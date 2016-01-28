Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41656 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbcA1R5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 12:57:12 -0500
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 2/4] wil6210: wait for disconnect completion
Date: Thu, 28 Jan 2016 19:24:03 +0200
Message-Id: <1454001845-28414-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160128_185716_366326_EC11118F)
In-Reply-To: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1454001845-28414-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

cfg80211_ops.disconnect() should wait for disconnect flow to
complete. If it does not, internal state becomes out of sync with
one in cfg80211. If one does stress test connect/disconnect
sequence, cfg80211 will issue next connect before disconnect
completed internally.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 13 ++++++++++++-
 drivers/net/wireless/ath/wil6210/main.c     | 28 +++++++++-------------------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 774352f..97ad91e 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -535,7 +535,18 @@ static int wil_cfg80211_disconnect(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "%s(reason=%d)\n", __func__, reason_code);
 
-	rc = wmi_send(wil, WMI_DISCONNECT_CMDID, NULL, 0);
+	if (!(test_bit(wil_status_fwconnecting, wil->status) ||
+	      test_bit(wil_status_fwconnected, wil->status))) {
+		wil_err(wil, "%s: Disconnect was called while disconnected\n",
+			__func__);
+		return 0;
+	}
+
+	rc = wmi_call(wil, WMI_DISCONNECT_CMDID, NULL, 0,
+		      WMI_DISCONNECT_EVENTID, NULL, 0,
+		      WIL6210_DISCONNECT_TO_MS);
+	if (rc)
+		wil_err(wil, "%s: disconnect error %d\n", __func__, rc);
 
 	return rc;
 }
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 712ebbf..78ba6e0 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -23,9 +23,6 @@
 #include "wmi.h"
 #include "boot_loader.h"
 
-#define WAIT_FOR_DISCONNECT_TIMEOUT_MS 2000
-#define WAIT_FOR_DISCONNECT_INTERVAL_MS 10
-
 bool debug_fw; /* = false; */
 module_param(debug_fw, bool, S_IRUGO);
 MODULE_PARM_DESC(debug_fw, " do not perform card reset. For FW debug");
@@ -942,8 +939,7 @@ int wil_up(struct wil6210_priv *wil)
 
 int __wil_down(struct wil6210_priv *wil)
 {
-	int iter = WAIT_FOR_DISCONNECT_TIMEOUT_MS /
-			WAIT_FOR_DISCONNECT_INTERVAL_MS;
+	int rc;
 
 	WARN_ON(!mutex_is_locked(&wil->mutex));
 
@@ -967,22 +963,16 @@ int __wil_down(struct wil6210_priv *wil)
 	}
 
 	if (test_bit(wil_status_fwconnected, wil->status) ||
-	    test_bit(wil_status_fwconnecting, wil->status))
-		wmi_send(wil, WMI_DISCONNECT_CMDID, NULL, 0);
+	    test_bit(wil_status_fwconnecting, wil->status)) {
 
-	/* make sure wil is idle (not connected) */
-	mutex_unlock(&wil->mutex);
-	while (iter--) {
-		int idle = !test_bit(wil_status_fwconnected, wil->status) &&
-			   !test_bit(wil_status_fwconnecting, wil->status);
-		if (idle)
-			break;
-		msleep(WAIT_FOR_DISCONNECT_INTERVAL_MS);
+		mutex_unlock(&wil->mutex);
+		rc = wmi_call(wil, WMI_DISCONNECT_CMDID, NULL, 0,
+			      WMI_DISCONNECT_EVENTID, NULL, 0,
+			      WIL6210_DISCONNECT_TO_MS);
+		mutex_lock(&wil->mutex);
+		if (rc)
+			wil_err(wil, "timeout waiting for disconnect\n");
 	}
-	mutex_lock(&wil->mutex);
-
-	if (iter < 0)
-		wil_err(wil, "timeout waiting for idle FW/HW\n");
 
 	wil_reset(wil, false);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1b8fa1d..9502965 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -92,6 +92,7 @@ static inline u32 wil_mtu2macbuf(u32 mtu)
 #define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
 #define WIL6210_FW_RECOVERY_TO	msecs_to_jiffies(5000)
 #define WIL6210_SCAN_TO		msecs_to_jiffies(10000)
+#define WIL6210_DISCONNECT_TO_MS (2000)
 #define WIL6210_RX_HIGH_TRSH_INIT		(0)
 #define WIL6210_RX_HIGH_TRSH_DEFAULT \
 				(1 << (WIL_RX_RING_SIZE_ORDER_DEFAULT - 3))
-- 
1.8.5.2

