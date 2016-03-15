Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3906 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbcCOJ4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 05:56:38 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] ath10k: Advertise force AP scan feature
Date: Tue, 15 Mar 2016 15:25:53 +0530
Message-ID: <1458035753-20727-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160315_105642_192557_C6AA76C4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Results obtained from scan can be used for spectrum management by
doing something like building information of preferred channel
lists and sharing them with stations around. It is to be noted
that traffic to the connected stations would be affected during
the scan.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebff9c0..48b789c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7697,7 +7697,8 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
 
 	ar->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
-	ar->hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
+	ar->hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
+				   NL80211_FEATURE_AP_SCAN;
 
 	ar->hw->wiphy->max_ap_assoc_sta = ar->max_num_stations;
 
-- 
1.9.1

