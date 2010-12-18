Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38577 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab0LRXcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 18:32:10 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 2/2] ath9k: do not limit the chainmask to 1 for legacy mode
Date: Sun, 19 Dec 2010 00:31:55 +0100
Message-Id: <1292715115-36506-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292715115-36506-1-git-send-email-nbd@openwrt.org>
References: <1292715115-36506-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Restricting the chainmask to 1 for legacy mode disables useful features
such as MRC, and it reduces the available transmit power.
I can't think of a good reason to do this in legacy mode, so let's just
get rid of that code.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    1 -
 drivers/net/wireless/ath/ath9k/main.c    |   32 ------------------------------
 drivers/net/wireless/ath/ath9k/virtual.c |    1 -
 3 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9fd9519..2c31f51 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -675,7 +675,6 @@ void ath9k_deinit_device(struct ath_softc *sc);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			   struct ath9k_channel *ichan);
-void ath_update_chainmask(struct ath_softc *sc, int is_ht);
 int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cb53fbb..8a1691d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -538,32 +538,6 @@ set_timer:
 	}
 }
 
-/*
- * Update tx/rx chainmask. For legacy association,
- * hard code chainmask to 1x1, for 11n association, use
- * the chainmask configuration, for bt coexistence, use
- * the chainmask configuration even in legacy mode.
- */
-void ath_update_chainmask(struct ath_softc *sc, int is_ht)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if ((sc->sc_flags & SC_OP_OFFCHANNEL) || is_ht ||
-	    (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE)) {
-		common->tx_chainmask = ah->caps.tx_chainmask;
-		common->rx_chainmask = ah->caps.rx_chainmask;
-	} else {
-		common->tx_chainmask = 1;
-		common->rx_chainmask = 1;
-	}
-
-	ath_dbg(common, ATH_DBG_CONFIG,
-		"tx chmask: %d, rx chmask: %d\n",
-		common->tx_chainmask,
-		common->rx_chainmask);
-}
-
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an;
@@ -1679,8 +1653,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		/* XXX: remove me eventualy */
 		ath9k_update_ichannel(sc, hw, &sc->sc_ah->channels[pos]);
 
-		ath_update_chainmask(sc, conf_is_ht(conf));
-
 		/* update survey stats for the old channel before switching */
 		spin_lock_irqsave(&common->cc_lock, flags);
 		ath_update_survey_stats(sc);
@@ -1912,10 +1884,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		/* Set aggregation protection mode parameters */
 		sc->config.ath_aggr_prot = 0;
 
-		/* Only legacy IBSS for now */
-		if (vif->type == NL80211_IFTYPE_ADHOC)
-			ath_update_chainmask(sc, 0);
-
 		ath_dbg(common, ATH_DBG_CONFIG, "BSSID: %pM aid: 0x%x\n",
 			common->curbssid, common->curaid);
 
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index fbfbc82..2dc7095 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -288,7 +288,6 @@ void ath9k_wiphy_chan_work(struct work_struct *work)
 	/* sync hw configuration for hw code */
 	common->hw = aphy->hw;
 
-	ath_update_chainmask(sc, sc->chan_is_ht);
 	if (ath_set_channel(sc, aphy->hw,
 			    &sc->sc_ah->channels[sc->chan_idx]) < 0) {
 		printk(KERN_DEBUG "ath9k: Failed to set channel for new "
-- 
1.7.3.2

