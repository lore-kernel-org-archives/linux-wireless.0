Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46678 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab1H3TEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:04:45 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 21/22] ath6kl: Return error from wmi.c instead of -EIO in ath6kl_cfg80211_scan
Date: Tue, 30 Aug 2011 21:58:10 +0300
Message-ID: <1314730691-12089-22-git-send-email-jouni@qca.qualcomm.com> (sfid-20110830_210448_699223_7E615370)
In-Reply-To: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314730691-12089-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2136899..e867a7a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -759,12 +759,13 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	if (!ar->usr_bss_filter) {
-		if (ath6kl_wmi_bssfilter_cmd(ar->wmi,
-					     (test_bit(CONNECTED, &ar->flag) ?
-					     ALL_BUT_BSS_FILTER :
-					     ALL_BSS_FILTER), 0) != 0) {
+		ret = ath6kl_wmi_bssfilter_cmd(
+			ar->wmi,
+			(test_bit(CONNECTED, &ar->flag) ?
+			 ALL_BUT_BSS_FILTER : ALL_BSS_FILTER), 0);
+		if (ret) {
 			ath6kl_err("couldn't set bss filtering\n");
-			return -EIO;
+			return ret;
 		}
 	}
 
@@ -807,11 +808,10 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 			channels[i] = request->channels[i]->center_freq;
 	}
 
-	if (ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
-				     false, 0, 0, n_channels, channels) != 0) {
+	ret = ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
+				       false, 0, 0, n_channels, channels);
+	if (ret)
 		ath6kl_err("wmi_startscan_cmd failed\n");
-		ret = -EIO;
-	}
 
 	ar->scan_req = request;
 
-- 
1.7.4.1

