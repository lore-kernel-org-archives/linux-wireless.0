Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49241 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaBYNtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:49:39 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MTO3f-1WiVwE09cF-00SO2h for
 <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 14:49:37 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 4/7] ath9k_htc: use ath9k_cmn_setup_ht_cap
Date: Tue, 25 Feb 2014 14:48:53 +0100
Message-Id: <1393336136-31069-5-git-send-email-linux@rempel-privat.de> (sfid-20140225_144942_034990_AC778982)
In-Reply-To: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
References: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 50 ++-------------------------
 1 file changed, 3 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 752586d..5220f46 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -404,51 +404,6 @@ static const struct ath_bus_ops ath9k_usb_bus_ops = {
 	.eeprom_read = ath_usb_eeprom_read,
 };
 
-static void setup_ht_cap(struct ath9k_htc_priv *priv,
-			 struct ieee80211_sta_ht_cap *ht_info)
-{
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	u8 tx_streams, rx_streams;
-	int i;
-
-	ht_info->ht_supported = true;
-	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-		       IEEE80211_HT_CAP_SM_PS |
-		       IEEE80211_HT_CAP_SGI_40 |
-		       IEEE80211_HT_CAP_DSSSCCK40;
-
-	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
-		ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
-
-	ht_info->cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
-
-	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
-	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
-
-	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-
-	/* ath9k_htc supports only 1 or 2 stream devices */
-	tx_streams = ath9k_cmn_count_streams(priv->ah->txchainmask, 2);
-	rx_streams = ath9k_cmn_count_streams(priv->ah->rxchainmask, 2);
-
-	ath_dbg(common, CONFIG, "TX streams %d, RX streams: %d\n",
-		tx_streams, rx_streams);
-
-	if (tx_streams >= 2)
-		ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
-
-	if (tx_streams != rx_streams) {
-		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
-		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
-					   IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
-	}
-
-	for (i = 0; i < rx_streams; i++)
-		ht_info->mcs.rx_mask[i] = 0xff;
-
-	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
-}
-
 static int ath9k_init_queues(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
@@ -611,6 +566,7 @@ static const struct ieee80211_iface_combination if_comb = {
 static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 			       struct ieee80211_hw *hw)
 {
+	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct base_eep_header *pBase;
 
@@ -662,10 +618,10 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-			setup_ht_cap(priv,
+			ath9k_cmn_setup_ht_cap(ah,
 				     &common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
 		if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
-			setup_ht_cap(priv,
+			ath9k_cmn_setup_ht_cap(ah,
 				     &common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
-- 
1.9.0

