Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61280 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2BUKAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 05:00:49 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Make foreground scan a deterministic one
Date: Tue, 21 Feb 2012 15:30:42 +0530
Message-ID: <1329818442-5095-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120221_110053_033311_573F6EC6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the device get into scan state as soon as a
scan request is received, instead of blocking the scan
request till the traffic comes down. It is  necessary
for the deterministic foreground scan particularly when
having multiple vif operating where, if the scan is non-
deterministic, scan on one interface will not start
as long as there are traffic on the other interface. This
change passes 50 msec as foreground scan interval to fix this.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   11 +++++++----
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 313787e..0bfa087 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -927,14 +927,17 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		 */
 		ret = ath6kl_wmi_beginscan_cmd(ar->wmi, vif->fw_vif_idx,
 						WMI_LONG_SCAN, force_fg_scan,
-						false, 0, 0, n_channels,
-						channels, request->no_cck,
+						false, 0,
+						ATH6KL_FG_SCAN_INTERVAL,
+						n_channels, channels,
+						request->no_cck,
 						request->rates);
 	} else {
 		ret = ath6kl_wmi_startscan_cmd(ar->wmi, vif->fw_vif_idx,
 						WMI_LONG_SCAN, force_fg_scan,
-						false, 0, 0, n_channels,
-						channels);
+						false, 0,
+						ATH6KL_FG_SCAN_INTERVAL,
+						n_channels, channels);
 	}
 	if (ret)
 		ath6kl_err("wmi_startscan_cmd failed\n");
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ec7d6b6..8d8677d 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -63,6 +63,9 @@
 #define A_DEFAULT_LISTEN_INTERVAL         1      /* beacon intervals */
 #define A_MAX_WOW_LISTEN_INTERVAL         1000
 
+/* Channel dwell time in fg scan */
+#define ATH6KL_FG_SCAN_INTERVAL		50 /* in ms */
+
 /* includes also the null byte */
 #define ATH6KL_FIRMWARE_MAGIC               "QCA-ATH6KL"
 
-- 
1.7.0.4

