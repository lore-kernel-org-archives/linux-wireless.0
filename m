Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55960 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbaBYNty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:49:54 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MDE6y-1WSCP42YiS-00GbpE for
 <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 14:49:52 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 6/7] ath9k: move ath9k_reload_chainmask_settings to common
Date: Tue, 25 Feb 2014 14:48:55 +0100
Message-Id: <1393336136-31069-7-git-send-email-linux@rempel-privat.de> (sfid-20140225_144956_752133_837BC659)
In-Reply-To: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
References: <1393336136-31069-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/common-init.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-init.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c        | 16 +---------------
 drivers/net/wireless/ath/ath9k/main.c        |  2 +-
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index 8775ab2..a006c14 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -226,3 +226,19 @@ void ath9k_cmn_setup_ht_cap(struct ath_hw *ah,
 	ht_info->mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
 }
 EXPORT_SYMBOL(ath9k_cmn_setup_ht_cap);
+
+void ath9k_cmn_reload_chainmask(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_HT))
+		return;
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
+		ath9k_cmn_setup_ht_cap(ah,
+			&common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
+		ath9k_cmn_setup_ht_cap(ah,
+			&common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
+}
+EXPORT_SYMBOL(ath9k_cmn_reload_chainmask);
diff --git a/drivers/net/wireless/ath/ath9k/common-init.h b/drivers/net/wireless/ath/ath9k/common-init.h
index 6e678ca..ac03fca 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.h
+++ b/drivers/net/wireless/ath/ath9k/common-init.h
@@ -17,3 +17,4 @@
 int ath9k_cmn_init_channels_rates(struct ath_common *common);
 void ath9k_cmn_setup_ht_cap(struct ath_hw *ah,
 			    struct ieee80211_sta_ht_cap *ht_info);
+void ath9k_cmn_reload_chainmask(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6b37145..66c268b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -642,20 +642,6 @@ static void ath9k_init_txpower_limits(struct ath_softc *sc)
 	ah->curchan = curchan;
 }
 
-void ath9k_reload_chainmask_settings(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_HT))
-		return;
-
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
-		ath9k_cmn_setup_ht_cap(ah, &common->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
-		ath9k_cmn_setup_ht_cap(ah, &common->sbands[IEEE80211_BAND_5GHZ].ht_cap);
-}
-
 static const struct ieee80211_iface_limit if_limits[] = {
 	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
@@ -771,7 +757,7 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			&common->sbands[IEEE80211_BAND_5GHZ];
 
 	ath9k_init_wow(hw);
-	ath9k_reload_chainmask_settings(sc);
+	ath9k_cmn_reload_chainmask(ah);
 
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index afce549..81f8328 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2053,7 +2053,7 @@ static int ath9k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 		ah->rxchainmask = fill_chainmask(ah->caps.rx_chainmask, rx_ant);
 
 	ah->txchainmask = fill_chainmask(ah->caps.tx_chainmask, tx_ant);
-	ath9k_reload_chainmask_settings(sc);
+	ath9k_cmn_reload_chainmask(ah);
 
 	return 0;
 }
-- 
1.9.0

