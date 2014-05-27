Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:41594 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaE0Lqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 07:46:34 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 2/7] wil6210: limit fw error recovery attempts
Date: Tue, 27 May 2014 14:45:45 +0300
Message-ID: <1401191150-29037-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140527_134637_688284_5A52CB64)
In-Reply-To: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case there is something fundamentally wrong with the firmware
(example: RF cable disconnected), FW will always crash immediately
after reset. This leads to infinite fw error recovery loop.

Count consecutive unsuccessful error recovery attempts in a short period
of time, and stop doing recovery after some reasonable count.
It is still possible to manually reset fw doing
interface down/up sequence.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 22 +++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h |  4 ++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 670cc6d..f24cb92 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -161,12 +161,30 @@ static void wil_fw_error_worker(struct work_struct *work)
 	if (no_fw_recovery)
 		return;
 
+	/* increment @recovery_count if less then WIL6210_FW_RECOVERY_TO
+	 * passed since last recovery attempt
+	 */
+	if (time_is_after_jiffies(wil->last_fw_recovery +
+				  WIL6210_FW_RECOVERY_TO))
+		wil->recovery_count++;
+	else
+		wil->recovery_count = 1; /* fw was alive for a long time */
+
+	if (wil->recovery_count > WIL6210_FW_RECOVERY_RETRIES) {
+		wil_err(wil, "too many recovery attempts (%d), giving up\n",
+			wil->recovery_count);
+		return;
+	}
+
+	wil->last_fw_recovery = jiffies;
+
 	mutex_lock(&wil->mutex);
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_MONITOR:
-		wil_info(wil, "fw error recovery started...\n");
+		wil_info(wil, "fw error recovery started (try %d)...\n",
+			 wil->recovery_count);
 		wil_reset(wil);
 
 		/* need to re-allocate Rx ring after reset */
@@ -249,6 +267,8 @@ int wil_priv_init(struct wil6210_priv *wil)
 		return -EAGAIN;
 	}
 
+	wil->last_fw_recovery = jiffies;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 3427ac4..f8c598e 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -40,6 +40,8 @@ static inline u32 WIL_GET_BITS(u32 x, int b0, int b1)
 #define WIL6210_MAX_CID		(8) /* HW limit */
 #define WIL6210_NAPI_BUDGET	(16) /* arbitrary */
 #define WIL6210_ITR_TRSH	(10000) /* arbitrary - about 15 IRQs/msec */
+#define WIL6210_FW_RECOVERY_RETRIES	(5) /* try to recover this many times */
+#define WIL6210_FW_RECOVERY_TO	msecs_to_jiffies(5000)
 
 /* Hardware definitions begin */
 
@@ -361,6 +363,8 @@ struct wil6210_priv {
 	u32 fw_version;
 	u32 hw_version;
 	u8 n_mids; /* number of additional MIDs as reported by FW */
+	int recovery_count; /* num of FW recovery attempts in a short time */
+	unsigned long last_fw_recovery; /* jiffies of last fw recovery */
 	/* profile */
 	u32 monitor_flags;
 	u32 secure_pcp; /* create secure PCP? */
-- 
1.9.1

