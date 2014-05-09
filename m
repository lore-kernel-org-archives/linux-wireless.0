Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40537 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaEIMm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:42:58 -0400
Received: by mail-ee0-f54.google.com with SMTP id b57so2664340eek.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:42:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/7] ath10k: reduce timeout values
Date: Fri,  9 May 2014 14:35:55 +0200
Message-Id: <1399638957-20449-6-git-send-email-michal.kazior@tieto.com> (sfid-20140509_144303_999728_711610A8)
In-Reply-To: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
References: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to wait more than 1
second in most cases.

This speeds up teardown in some failcases.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 2 +-
 drivers/net/wireless/ath/ath10k/htt.c  | 2 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 6 +++---
 drivers/net/wireless/ath/ath10k/txrx.c | 2 +-
 drivers/net/wireless/ath/ath10k/wmi.h  | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 074cb41..01f1830 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -221,7 +221,7 @@ struct ath10k_sta {
 	struct work_struct update_wk;
 };
 
-#define ATH10K_VDEV_SETUP_TIMEOUT_HZ (5*HZ)
+#define ATH10K_VDEV_SETUP_TIMEOUT_HZ (1*HZ)
 
 struct ath10k_vif {
 	struct list_head list;
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 69697af5..60ea5f1 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -100,7 +100,7 @@ err_htc_attach:
 	return ret;
 }
 
-#define HTT_TARGET_VERSION_TIMEOUT_HZ (3*HZ)
+#define HTT_TARGET_VERSION_TIMEOUT_HZ (1*HZ)
 
 static int ath10k_htt_verify_version(struct ath10k_htt *htt)
 {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9b14ec8..9e3b16f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -98,7 +98,7 @@ static int ath10k_install_key(struct ath10k_vif *arvif,
 	if (ret)
 		return ret;
 
-	ret = wait_for_completion_timeout(&ar->install_key_done, 3*HZ);
+	ret = wait_for_completion_timeout(&ar->install_key_done, 1*HZ);
 	if (ret == 0)
 		return -ETIMEDOUT;
 
@@ -2190,7 +2190,7 @@ static int ath10k_abort_scan(struct ath10k *ar)
 		return -EIO;
 	}
 
-	ret = wait_for_completion_timeout(&ar->scan.completed, 3*HZ);
+	ret = wait_for_completion_timeout(&ar->scan.completed, 1*HZ);
 	if (ret == 0)
 		ath10k_warn("timed out while waiting for scan to stop\n");
 
@@ -3604,7 +3604,7 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
-	ret = wait_for_completion_timeout(&ar->scan.on_channel, 3*HZ);
+	ret = wait_for_completion_timeout(&ar->scan.on_channel, 1*HZ);
 	if (ret == 0) {
 		ath10k_warn("failed to switch to channel for roc scan\n");
 		ath10k_abort_scan(ar);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 82669a7..9007f2e 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -146,7 +146,7 @@ static int ath10k_wait_for_peer_common(struct ath10k *ar, int vdev_id,
 			spin_unlock_bh(&ar->data_lock);
 
 			mapped == expect_mapped;
-		}), 3*HZ);
+		}), 1*HZ);
 
 	if (ret <= 0)
 		return -ETIMEDOUT;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ae83822..772dbb6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1162,8 +1162,8 @@ struct wmi_service_ready_event_10x {
 } __packed;
 
 
-#define WMI_SERVICE_READY_TIMEOUT_HZ (5*HZ)
-#define WMI_UNIFIED_READY_TIMEOUT_HZ (5*HZ)
+#define WMI_SERVICE_READY_TIMEOUT_HZ (1*HZ)
+#define WMI_UNIFIED_READY_TIMEOUT_HZ (1*HZ)
 
 struct wmi_ready_event {
 	__le32 sw_version;
-- 
1.8.5.3

