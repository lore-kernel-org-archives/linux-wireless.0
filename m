Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51171 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab2DORm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 13:42:29 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] ath9k: add an extra boolean parameter to ath9k_hw_apply_txpower
Date: Sun, 15 Apr 2012 20:38:05 +0200
Message-Id: <1334515086-16150-1-git-send-email-juhosg@openwrt.org> (sfid-20120415_194304_975712_D5D2C9E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to unifying regulatory limit handling
commit ca2c68cc7bc80fc4504fb420df04cce99c9ee6ec
(ath9k_hw: clean up tx power handling) introduced
a new helper function 'ath9k_hw_apply_txpower',
and the direct calls of 'ah->eep_ops->set_txpower'
has been replaced by a call of the helper function.

This caused a change in the behaviour of the
'ath9k_hw_set_txpowerlimit' function. The purpose
of that function is to calculate and store the
rate txpower table and the regulatory limit without
touching the hardware registers. Before the commit,
the 'test' parameter of the function was passed to
the 'ah->eep_ops->set_txpower'. Now the calling of
the 'set_txpower' function happens indirectly through
'ath9k_hw_apply_txpower', so the 'test' argument of
the 'set_txpower' is always 'false'.

This patch restores the original behaviour of
'ath9k_hw_set_txpowerlimit' by adding a new
argument to 'ath9k_hw_apply_txpower.'

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    9 +++++----
 drivers/net/wireless/ath/ath9k/hw.h           |    3 ++-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index de30cb3..8753e38 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -868,7 +868,7 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 	ar5008_hw_set_channel_regs(ah, chan);
 	ar5008_hw_init_chain_masks(ah);
 	ath9k_olc_init(ah);
-	ath9k_hw_apply_txpower(ah, chan);
+	ath9k_hw_apply_txpower(ah, chan, false);
 
 	/* Write analog registers */
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 59647a3..3d400e8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -54,7 +54,7 @@ void ar9003_paprd_enable(struct ath_hw *ah, bool val)
 
 	if (val) {
 		ah->paprd_table_write_done = true;
-		ath9k_hw_apply_txpower(ah, chan);
+		ath9k_hw_apply_txpower(ah, chan, false);
 	}
 
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL0_B0,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 4c9bc9f..5d2b584 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -690,7 +690,7 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
-	ath9k_hw_apply_txpower(ah, chan);
+	ath9k_hw_apply_txpower(ah, chan, false);
 
 	if (AR_SREV_9462(ah)) {
 		if (REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_0,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6fa8128..480e8f8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1453,7 +1453,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 		return false;
 	}
 	ath9k_hw_set_clockrate(ah);
-	ath9k_hw_apply_txpower(ah, chan);
+	ath9k_hw_apply_txpower(ah, chan, false);
 	ath9k_hw_rfbus_done(ah);
 
 	if (IS_CHAN_OFDM(chan) || IS_CHAN_HT(chan))
@@ -2724,7 +2724,8 @@ static int get_antenna_gain(struct ath_hw *ah, struct ath9k_channel *chan)
 	return ah->eep_ops->get_eeprom(ah, gain_param);
 }
 
-void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan)
+void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
+			    bool test)
 {
 	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
 	struct ieee80211_channel *channel;
@@ -2745,7 +2746,7 @@ void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	ah->eep_ops->set_txpower(ah, chan,
 				 ath9k_regd_get_ctl(reg, chan),
-				 ant_reduction, new_pwr, false);
+				 ant_reduction, new_pwr, test);
 }
 
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
@@ -2758,7 +2759,7 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test)
 	if (test)
 		channel->max_power = MAX_RATE_POWER / 2;
 
-	ath9k_hw_apply_txpower(ah, chan);
+	ath9k_hw_apply_txpower(ah, chan, test);
 
 	if (test)
 		channel->max_power = DIV_ROUND_UP(reg->max_power_level, 2);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1d4b983..99b57bd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -976,7 +976,8 @@ void ath9k_hw_name(struct ath_hw *ah, char *hw_name, size_t len);
 /* PHY */
 void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 				   u32 *coef_mantissa, u32 *coef_exponent);
-void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan);
+void ath9k_hw_apply_txpower(struct ath_hw *ah, struct ath9k_channel *chan,
+			    bool test);
 
 /*
  * Code Specific to AR5008, AR9001 or AR9002,
-- 
1.7.2.1

