Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/11] ath9k: remove ath9k_ht_macmode
Date: Mon, 14 Sep 2009 04:37:23 -0400
Message-Id: <1252917448-10744-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is used just to determine how to program the MAC,
either for 20 MHz operation of 40 MHz so just use conf_is_ht40()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/hw.c    |   29 ++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/hw.h    |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h   |    5 -----
 drivers/net/wireless/ath/ath9k/main.c  |   13 ++++---------
 5 files changed, 17 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e93ab63..73c2ac5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -592,7 +592,6 @@ struct ath_softc {
 	bool ps_enabled;
 	unsigned long ps_usecount;
 	enum ath9k_int imask;
-	enum ath9k_ht_macmode tx_chan_width;
 
 	struct ath_config config;
 	struct ath_rx rx;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e430be0..75831a1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -26,8 +26,7 @@
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
-static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
-			      enum ath9k_ht_macmode macmode);
+static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan);
 static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 			      struct ar5416_eeprom_def *pEepData,
 			      u32 reg, u32 value);
@@ -1343,8 +1342,7 @@ static u32 ath9k_regd_get_ctl(struct ath_regulatory *reg,
 }
 
 static int ath9k_hw_process_ini(struct ath_hw *ah,
-				struct ath9k_channel *chan,
-				enum ath9k_ht_macmode macmode)
+				struct ath9k_channel *chan)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	int i, regWrites = 0;
@@ -1446,7 +1444,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	}
 
 	ath9k_hw_override_ini(ah, chan);
-	ath9k_hw_set_regs(ah, chan, macmode);
+	ath9k_hw_set_regs(ah, chan);
 	ath9k_hw_init_chain_masks(ah);
 
 	if (OLC_FOR_AR9280_20_LATER)
@@ -1729,8 +1727,7 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 	}
 }
 
-static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
-			      enum ath9k_ht_macmode macmode)
+static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	u32 phymode;
 	u32 enableDacFifo = 0;
@@ -1752,7 +1749,7 @@ static void ath9k_hw_set_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 	REG_WRITE(ah, AR_PHY_TURBO, phymode);
 
-	ath9k_hw_set11nmac2040(ah, macmode);
+	ath9k_hw_set11nmac2040(ah);
 
 	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
 	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
@@ -1778,8 +1775,7 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 }
 
 static bool ath9k_hw_channel_change(struct ath_hw *ah,
-				    struct ath9k_channel *chan,
-				    enum ath9k_ht_macmode macmode)
+				    struct ath9k_channel *chan)
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1803,7 +1799,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		return false;
 	}
 
-	ath9k_hw_set_regs(ah, chan, macmode);
+	ath9k_hw_set_regs(ah, chan);
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		ath9k_hw_ar9280_set_channel(ah, chan);
@@ -2314,7 +2310,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 saveLedState;
-	struct ath_softc *sc = ah->ah_sc;
 	struct ath9k_channel *curchan = ah->curchan;
 	u32 saveDefAntenna;
 	u32 macStaId1;
@@ -2338,7 +2333,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	    (!AR_SREV_9280(ah) || (!IS_CHAN_A_5MHZ_SPACED(chan) &&
 				   !IS_CHAN_A_5MHZ_SPACED(ah->curchan)))) {
 
-		if (ath9k_hw_channel_change(ah, chan, sc->tx_chan_width)) {
+		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
 			ath9k_hw_start_nfcal(ah);
 			return 0;
@@ -2390,7 +2385,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		REG_SET_BIT(ah, AR_MAC_PCU_ASYNC_FIFO_REG3,
 				AR_MAC_PCU_ASYNC_FIFO_REG3_SOFT_RESET);
 	}
-	r = ath9k_hw_process_ini(ah, chan, sc->tx_chan_width);
+	r = ath9k_hw_process_ini(ah, chan);
 	if (r)
 		return r;
 
@@ -4023,12 +4018,12 @@ bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 	}
 }
 
-void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode)
+void ath9k_hw_set11nmac2040(struct ath_hw *ah)
 {
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 	u32 macmode;
 
-	if (mode == ATH9K_HT_MACMODE_2040 &&
-	    !ah->config.cwm_ignore_extcca)
+	if (conf_is_ht40(conf) && !ah->config.cwm_ignore_extcca)
 		macmode = AR_2040_JOINED_RX_CLEAR;
 	else
 		macmode = 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3b1cfda..e2b6bce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -662,7 +662,7 @@ void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64);
 void ath9k_hw_reset_tsf(struct ath_hw *ah);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting);
 bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us);
-void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode);
+void ath9k_hw_set11nmac2040(struct ath_hw *ah);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 767256d..9ab3431 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -614,11 +614,6 @@ enum ath9k_cipher {
 	ATH9K_CIPHER_MIC = 127
 };
 
-enum ath9k_ht_macmode {
-	ATH9K_HT_MACMODE_20 = 0,
-	ATH9K_HT_MACMODE_2040 = 1,
-};
-
 struct ath_hw;
 struct ath9k_channel;
 struct ath_rate_table;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6404157..8b9ce67 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -299,6 +299,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &common->hw->conf;
 	bool fastcc = true, stopped;
 	struct ieee80211_channel *channel = hw->conf.channel;
 	int r;
@@ -329,9 +330,9 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		fastcc = false;
 
 	ath_print(common, ATH_DBG_CONFIG,
-		  "(%u MHz) -> (%u MHz), chanwidth: %d\n",
+		  "(%u MHz) -> (%u MHz), conf_is_ht40: %d\n",
 		  sc->sc_ah->curchan->channel,
-		  channel->center_freq, sc->tx_chan_width);
+		  channel->center_freq, conf_is_ht40(conf));
 
 	spin_lock_bh(&sc->sc_resetlock);
 
@@ -2195,15 +2196,9 @@ void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
 	}
 
-	sc->tx_chan_width = ATH9K_HT_MACMODE_20;
-
-	if (conf_is_ht(conf)) {
-		if (conf_is_ht40(conf))
-			sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
-
+	if (conf_is_ht(conf))
 		ichan->chanmode = ath_get_extchanmode(sc, chan,
 					    conf->channel_type);
-	}
 }
 
 /**********************/
-- 
1.6.3.3

