Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31443 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbcCARSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 12:18:38 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH v2 08/15] wil6210: add support for platform specific notification events
Date: Tue,  1 Mar 2016 19:18:11 +0200
Message-Id: <1456852698-26808-9-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160301_181916_465223_36EF60AF)
In-Reply-To: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the ability to notify the platform driver on different
events, such as FW crash, pre reset and FW ready.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c    |  5 ++--
 drivers/net/wireless/ath/wil6210/main.c         | 32 +++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/wil_platform.h |  8 ++++++-
 3 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 4f2ffa5..ae90295 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -394,9 +394,10 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 		wil_fw_core_dump(wil);
 		wil_notify_fw_error(wil);
 		isr &= ~ISR_MISC_FW_ERROR;
-		if (wil->platform_ops.notify_crash) {
+		if (wil->platform_ops.notify) {
 			wil_err(wil, "notify platform driver about FW crash");
-			wil->platform_ops.notify_crash(wil->platform_handle);
+			wil->platform_ops.notify(wil->platform_handle,
+						 WIL_PLATFORM_EVT_FW_CRASH);
 		} else {
 			wil_fw_error_recovery(wil);
 		}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 1fa215d..1472978 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -764,6 +764,15 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	if (wil->hw_version == HW_VER_UNKNOWN)
 		return -ENODEV;
 
+	if (wil->platform_ops.notify) {
+		rc = wil->platform_ops.notify(wil->platform_handle,
+					      WIL_PLATFORM_EVT_PRE_RESET);
+		if (rc)
+			wil_err(wil,
+				"%s: PRE_RESET platform notify failed, rc %d\n",
+				__func__, rc);
+	}
+
 	set_bit(wil_status_resetting, wil->status);
 
 	cancel_work_sync(&wil->disconnect_worker);
@@ -843,8 +852,27 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 
 		/* we just started MAC, wait for FW ready */
 		rc = wil_wait_for_fw_ready(wil);
-		if (rc == 0) /* check FW is responsive */
-			rc = wmi_echo(wil);
+		if (rc)
+			return rc;
+
+		/* check FW is responsive */
+		rc = wmi_echo(wil);
+		if (rc) {
+			wil_err(wil, "%s: wmi_echo failed, rc %d\n",
+				__func__, rc);
+			return rc;
+		}
+
+		if (wil->platform_ops.notify) {
+			rc = wil->platform_ops.notify(wil->platform_handle,
+						      WIL_PLATFORM_EVT_FW_RDY);
+			if (rc) {
+				wil_err(wil,
+					"%s: FW_RDY notify failed, rc %d\n",
+					__func__, rc);
+				rc = 0;
+			}
+		}
 	}
 
 	return rc;
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index 9a949d9..33d4a34 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -19,6 +19,12 @@
 
 struct device;
 
+enum wil_platform_event {
+	WIL_PLATFORM_EVT_FW_CRASH = 0,
+	WIL_PLATFORM_EVT_PRE_RESET = 1,
+	WIL_PLATFORM_EVT_FW_RDY = 2,
+};
+
 /**
  * struct wil_platform_ops - wil platform module calls from this
  * driver to platform driver
@@ -28,7 +34,7 @@ struct wil_platform_ops {
 	int (*suspend)(void *handle);
 	int (*resume)(void *handle);
 	void (*uninit)(void *handle);
-	int (*notify_crash)(void *handle);
+	int (*notify)(void *handle, enum wil_platform_event evt);
 };
 
 /**
-- 
1.8.5.2

