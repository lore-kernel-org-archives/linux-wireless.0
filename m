Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38495 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab2DJLST (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 07:18:19 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: remove dead code
Date: Tue, 10 Apr 2012 13:18:04 +0200
Message-Id: <1334056684-10944-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120410_131822_784022_FFC982F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean up some orphaned code lines containing
* unused variables (not referenced / write-only)
* non-implemented function prototypes

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c    |    1 -
 drivers/net/wireless/ath/ath9k/ar9002_phy.c    |    1 -
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 --
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |    1 -
 drivers/net/wireless/ath/ath9k/hw.c            |    1 -
 drivers/net/wireless/ath/ath9k/hw.h            |   10 ----------
 6 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 52ff5ca..de30cb3 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -245,7 +245,6 @@ static int ar5008_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	REG_WRITE(ah, AR_PHY(0x37), reg32);
 
 	ah->curchan = chan;
-	ah->curchan_rad_index = -1;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 3cbbb03..846dd79 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -152,7 +152,6 @@ static int ar9002_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	REG_WRITE(ah, AR_PHY_SYNTH_CONTROL, reg32);
 
 	ah->curchan = chan;
-	ah->curchan_rad_index = -1;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6bb4db0..672b6c9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -5060,8 +5060,6 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 			i, targetPowerValT2[i]);
 	}
 
-	ah->txpower_limit = regulatory->max_power_level;
-
 	/* Write target power array to registers */
 	ar9003_hw_tx_power_regwrite(ah, targetPowerValT2);
 	ar9003_hw_calibration_apply(ah, chan->channel);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 79070bf..04d1225 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -152,7 +152,6 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	REG_WRITE(ah, AR_PHY_65NM_CH0_SYNTH7, reg32);
 
 	ah->curchan = chan;
-	ah->curchan_rad_index = -1;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d1345a8..6fa8128 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -445,7 +445,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 		AR_STA_ID1_MCAST_KSRCH;
 	if (AR_SREV_9100(ah))
 		ah->sta_id1_defaults |= AR_STA_ID1_AR9100_BA_FIX;
-	ah->enable_32kHz_clock = DONT_USE_32KHZ;
 	ah->slottime = ATH9K_SLOT_TIME_9;
 	ah->globaltxtimeout = (u32) -1;
 	ah->power_mode = ATH9K_PM_UNDEFINED;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index aa1680a..1d4b983 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -708,7 +708,6 @@ struct ath_hw {
 	struct ar5416Stats stats;
 	struct ath9k_tx_queue_info txq[ATH9K_NUM_TX_QUEUES];
 
-	int16_t curchan_rad_index;
 	enum ath9k_int imask;
 	u32 imrs2_reg;
 	u32 txok_interrupt_mask;
@@ -762,11 +761,6 @@ struct ath_hw {
 
 	u32 sta_id1_defaults;
 	u32 misc_mode;
-	enum {
-		AUTO_32KHZ,
-		USE_32KHZ,
-		DONT_USE_32KHZ,
-	} enable_32kHz_clock;
 
 	/* Private to hardware code */
 	struct ath_hw_private_ops private_ops;
@@ -783,7 +777,6 @@ struct ath_hw {
 	u32 *analogBank7Data;
 	u32 *bank6Temp;
 
-	u8 txpower_limit;
 	int coverage_class;
 	u32 slottime;
 	u32 globaltxtimeout;
@@ -848,7 +841,6 @@ struct ath_hw {
 	struct ath_gen_timer_table hw_gen_timers;
 
 	struct ar9003_txs *ts_ring;
-	void *ts_start;
 	u32 ts_paddr_start;
 	u32 ts_paddr_end;
 	u16 ts_tail;
@@ -915,7 +907,6 @@ static inline u8 get_streams(int mask)
 }
 
 /* Initialization, Detach, Reset */
-const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_deinit(struct ath_hw *ah);
 int ath9k_hw_init(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
@@ -1011,7 +1002,6 @@ int ar9003_paprd_create_curve(struct ath_hw *ah,
 int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain);
 int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
-void ar9003_hw_set_paprd_txdesc(struct ath_hw *ah, void *ds, u8 chains);
 
 /* Hardware family op attach helpers */
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah);
-- 
1.7.4.1

