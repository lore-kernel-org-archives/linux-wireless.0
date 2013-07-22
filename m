Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48547 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab3GVMNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:13:49 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/4] ath10k: fix memleak in mac setup
Date: Mon, 22 Jul 2013 14:13:30 +0200
Message-ID: <1374495211-20353-4-git-send-email-michal.kazior@tieto.com> (sfid-20130722_141356_024478_0877D3FE)
In-Reply-To: <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
 <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases channel arrays were never freed.

The patch also unifies error handling in the mac
setup function.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 07e5f7d..6144b3b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3225,8 +3225,10 @@ int ath10k_mac_register(struct ath10k *ar)
 		channels = kmemdup(ath10k_2ghz_channels,
 				   sizeof(ath10k_2ghz_channels),
 				   GFP_KERNEL);
-		if (!channels)
-			return -ENOMEM;
+		if (!channels) {
+			ret = -ENOMEM;
+			goto err_free;
+		}
 
 		band = &ar->mac.sbands[IEEE80211_BAND_2GHZ];
 		band->n_channels = ARRAY_SIZE(ath10k_2ghz_channels);
@@ -3245,11 +3247,8 @@ int ath10k_mac_register(struct ath10k *ar)
 				   sizeof(ath10k_5ghz_channels),
 				   GFP_KERNEL);
 		if (!channels) {
-			if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY) {
-				band = &ar->mac.sbands[IEEE80211_BAND_2GHZ];
-				kfree(band->channels);
-			}
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_free;
 		}
 
 		band = &ar->mac.sbands[IEEE80211_BAND_5GHZ];
@@ -3313,25 +3312,30 @@ int ath10k_mac_register(struct ath10k *ar)
 			    ath10k_reg_notifier);
 	if (ret) {
 		ath10k_err("Regulatory initialization failed\n");
-		return ret;
+		goto err_free;
 	}
 
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath10k_err("ieee80211 registration failed: %d\n", ret);
-		return ret;
+		goto err_free;
 	}
 
 	if (!ath_is_world_regd(&ar->ath_common.regulatory)) {
 		ret = regulatory_hint(ar->hw->wiphy,
 				      ar->ath_common.regulatory.alpha2);
 		if (ret)
-			goto exit;
+			goto err_unregister;
 	}
 
 	return 0;
-exit:
+
+err_unregister:
 	ieee80211_unregister_hw(ar->hw);
+err_free:
+	kfree(ar->mac.sbands[IEEE80211_BAND_2GHZ].channels);
+	kfree(ar->mac.sbands[IEEE80211_BAND_5GHZ].channels);
+
 	return ret;
 }
 
-- 
1.7.9.5

