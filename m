Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61746 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaKXOLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:11:10 -0500
Received: by mail-wg0-f54.google.com with SMTP id l2so1837267wgh.13
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:11:09 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: make hw roc more reliable
Date: Mon, 24 Nov 2014 14:58:32 +0100
Message-Id: <1416837513-13386-2-git-send-email-michal.kazior@tieto.com> (sfid-20141124_151116_150754_1EBD9AE2)
In-Reply-To: <1416837513-13386-1-git-send-email-michal.kazior@tieto.com>
References: <1416837513-13386-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With P2P concurrency requested hw roc duration
time can be very small. Some firmware revisions
refuse scan requests with too small channel dwell
time.

This prevents messages like, e.g. with connected
STA vif and performing P2P Find:

 ath10k_pci 0000:00:05.0: failed to switch to channel for roc scan
 ieee80211 phy3: failed to start next HW ROC (-110)

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 drivers/net/wireless/ath/ath10k/wmi.h | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8deae4d..272a9d9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3807,6 +3807,8 @@ static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 	if (ret)
 		goto exit;
 
+	duration = max(duration, WMI_SCAN_CHAN_MIN_TIME_MSEC);
+
 	memset(&arg, 0, sizeof(arg));
 	ath10k_wmi_start_scan_init(ar, &arg);
 	arg.vdev_id = arvif->vdev_id;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index a38d788..1b7141a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1952,6 +1952,11 @@ struct wmi_ssid_list {
 #define WLAN_SCAN_PARAMS_MAX_BSSID   4
 #define WLAN_SCAN_PARAMS_MAX_IE_LEN  256
 
+/* Values lower than this may be refused by some firmware revisions with a scan
+ * completion with a timedout reason.
+ */
+#define WMI_SCAN_CHAN_MIN_TIME_MSEC 40
+
 /* Scan priority numbers must be sequential, starting with 0 */
 enum wmi_scan_priority {
 	WMI_SCAN_PRIORITY_VERY_LOW = 0,
-- 
1.8.5.3

