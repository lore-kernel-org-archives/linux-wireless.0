Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52974 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbaBYNtd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:49:33 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MXUmw-1Wmcfg0gmk-00WUmU for
 <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 14:49:31 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 3/7] ath9k: move setup_ht_cap to common-init
Date: Tue, 25 Feb 2014 14:48:52 +0100
Message-Id: <1393336136-31069-4-git-send-email-linux@rempel-privat.de> (sfid-20140225_144936_106747_841B0E78)
In-Reply-To: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
References: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and rename it to ath9k_cmn_setup_ht_cap

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common-init.c | 58 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-init.h |  2 +
 drivers/net/wireless/ath/ath9k/init.c        | 62 +---------------------------
 3 files changed, 62 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index 1fa30c3..8e2fa03 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -168,3 +168,61 @@ int ath9k_cmn_init_channels_rates(struct ath_common *common)
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_cmn_init_channels_rates);
+
+void ath9k_cmn_setup_ht_cap(struct ath_hw *ah,
+			    struct ieee80211_sta_ht_cap *ht_info)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u8 tx_streams, rx_streams;
+	int i, max_streams;
+
+	ht_info->ht_supported = true;
+	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+		       IEEE80211_HT_CAP_SM_PS |
+		       IEEE80211_HT_CAP_SGI_40 |
+		       IEEE80211_HT_CAP_DSSSCCK40;
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_LDPC)
+		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
+		ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
+
+	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
+
+	if (AR_SREV_9330(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah))
+		max_streams = 1;
+	else if (AR_SREV_9462(ah))
+		max_streams = 2;
+	else if (AR_SREV_9300_20_OR_LATER(ah))
+		max_streams = 3;
+	else
+		max_streams = 2;
+
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		if (max_streams >= 2)
+			ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
+		ht_info->cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+	}
+
+	/* set up supported mcs set */
+	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
+	tx_streams = ath9k_cmn_count_streams(ah->txchainmask, max_streams);
+	rx_streams = ath9k_cmn_count_streams(ah->rxchainmask, max_streams);
+
+	ath_dbg(common, CONFIG, "TX streams %d, RX streams: %d\n",
+		tx_streams, rx_streams);
+
+	if (tx_streams != rx_streams) {
+		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
+		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
+				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
+	}
+
+	for (i = 0; i < rx_streams; i++)
+		ht_info->mcs.rx_mask[i] = 0xff;
+
+	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
+}
+EXPORT_SYMBOL(ath9k_cmn_setup_ht_cap);
diff --git a/drivers/net/wireless/ath/ath9k/common-init.h b/drivers/net/wireless/ath/ath9k/common-init.h
index 8fc9049..6e678ca 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.h
+++ b/drivers/net/wireless/ath/ath9k/common-init.h
@@ -15,3 +15,5 @@
  */
 
 int ath9k_cmn_init_channels_rates(struct ath_common *common);
+void ath9k_cmn_setup_ht_cap(struct ath_hw *ah,
+			    struct ieee80211_sta_ht_cap *ht_info);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 172b2f9..6b37145 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -153,64 +153,6 @@ static unsigned int ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 cl
 /*     Initialization     */
 /**************************/
 
-static void setup_ht_cap(struct ath_softc *sc,
-			 struct ieee80211_sta_ht_cap *ht_info)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u8 tx_streams, rx_streams;
-	int i, max_streams;
-
-	ht_info->ht_supported = true;
-	ht_info->cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-		       IEEE80211_HT_CAP_SM_PS |
-		       IEEE80211_HT_CAP_SGI_40 |
-		       IEEE80211_HT_CAP_DSSSCCK40;
-
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_LDPC)
-		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
-
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
-		ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
-
-	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
-	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
-
-	if (AR_SREV_9330(ah) || AR_SREV_9485(ah) || AR_SREV_9565(ah))
-		max_streams = 1;
-	else if (AR_SREV_9462(ah))
-		max_streams = 2;
-	else if (AR_SREV_9300_20_OR_LATER(ah))
-		max_streams = 3;
-	else
-		max_streams = 2;
-
-	if (AR_SREV_9280_20_OR_LATER(ah)) {
-		if (max_streams >= 2)
-			ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
-		ht_info->cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
-	}
-
-	/* set up supported mcs set */
-	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-	tx_streams = ath9k_cmn_count_streams(ah->txchainmask, max_streams);
-	rx_streams = ath9k_cmn_count_streams(ah->rxchainmask, max_streams);
-
-	ath_dbg(common, CONFIG, "TX streams %d, RX streams: %d\n",
-		tx_streams, rx_streams);
-
-	if (tx_streams != rx_streams) {
-		ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
-		ht_info->mcs.tx_params |= ((tx_streams - 1) <<
-				IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
-	}
-
-	for (i = 0; i < rx_streams; i++)
-		ht_info->mcs.rx_mask[i] = 0xff;
-
-	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
-}
-
 static void ath9k_reg_notifier(struct wiphy *wiphy,
 			       struct regulatory_request *request)
 {
@@ -709,9 +651,9 @@ void ath9k_reload_chainmask_settings(struct ath_softc *sc)
 		return;
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-		setup_ht_cap(sc, &common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+		ath9k_cmn_setup_ht_cap(ah, &common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
-		setup_ht_cap(sc, &common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+		ath9k_cmn_setup_ht_cap(ah, &common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 }
 
 static const struct ieee80211_iface_limit if_limits[] = {
-- 
1.9.0

