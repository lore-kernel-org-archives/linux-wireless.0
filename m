Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:38862 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753999Ab1A1Hw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 02:52:27 -0500
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0842721143
	for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 16:52:25 +0900 (JST)
Subject: [PATCH] ath5k: Fix short and long retry configuration
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 28 Jan 2011 16:52:11 +0900
Message-ID: <20110128075211.26919.39228.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The register definition for retry configuration on AR5212 was wrong, and simply
copied over from AR5210. Update the register definitions from the documentation.

Let the short and long retries be configured from mac80211 and use the standard
values of 7 and 4 by default. Also we need to make sure we don't export more
retries than we are configured for to mac80211 (and the rate module) in
hw->max_rate_tries.

Also clean up the code by removing unused defines and variables and drop the
different values for "station retries" - if these need to be different it can
be handled tru ah_retry_long/short.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h        |   18 ++++------
 drivers/net/wireless/ath/ath5k/attach.c       |    4 +-
 drivers/net/wireless/ath/ath5k/base.c         |    3 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    9 +++++
 drivers/net/wireless/ath/ath5k/qcu.c          |   46 +++++++++----------------
 drivers/net/wireless/ath/ath5k/reg.h          |   15 ++++----
 6 files changed, 44 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 407e39c..e43175a 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -210,14 +210,9 @@
 /* Initial values */
 #define	AR5K_INIT_CYCRSSI_THR1			2
 
-/* Tx retry limits */
-#define AR5K_INIT_SH_RETRY			10
-#define AR5K_INIT_LG_RETRY			AR5K_INIT_SH_RETRY
-/* For station mode */
-#define AR5K_INIT_SSH_RETRY			32
-#define AR5K_INIT_SLG_RETRY			AR5K_INIT_SSH_RETRY
-#define AR5K_INIT_TX_RETRY			10
-
+/* Tx retry limit defaults from standard */
+#define AR5K_INIT_RETRY_SHORT			7
+#define AR5K_INIT_RETRY_LONG			4
 
 /* Slot time */
 #define AR5K_INIT_SLOT_TIME_TURBO		6
@@ -1057,7 +1052,9 @@ struct ath5k_hw {
 #define ah_modes		ah_capabilities.cap_mode
 #define ah_ee_version		ah_capabilities.cap_eeprom.ee_version
 
-	u32			ah_limit_tx_retries;
+	u8			ah_retry_long;
+	u8			ah_retry_short;
+
 	u8			ah_coverage_class;
 	bool			ah_ack_bitrate_high;
 	u8			ah_bwmode;
@@ -1067,7 +1064,6 @@ struct ath5k_hw {
 	u8			ah_ant_mode;
 	u8			ah_tx_ant;
 	u8			ah_def_ant;
-	bool			ah_software_retry;
 
 	struct ath5k_capabilities ah_capabilities;
 
@@ -1250,6 +1246,8 @@ int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
 int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah,
 			    enum ath5k_tx_queue queue_type,
 			    struct ath5k_txq_info *queue_info);
+void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
+				  unsigned int queue);
 u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
 void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
 int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index cdac5cf..c71fdbb 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -118,8 +118,8 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 	ah->ah_bwmode = AR5K_BWMODE_DEFAULT;
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
 	ah->ah_imr = 0;
-	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
-	ah->ah_software_retry = false;
+	ah->ah_retry_short = AR5K_INIT_RETRY_SHORT;
+	ah->ah_retry_long = AR5K_INIT_RETRY_LONG;
 	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
 	ah->ah_noise_floor = -95;	/* until first NF calibration is run */
 	sc->ani_state.ani_mode = ATH5K_ANI_MODE_AUTO;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index dae0bdc..e6e68fd 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2399,7 +2399,8 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
 	/* set up multi-rate retry capabilities */
 	if (sc->ah->ah_version == AR5K_AR5212) {
 		hw->max_rates = 4;
-		hw->max_rate_tries = 11;
+		hw->max_rate_tries = max(AR5K_INIT_RETRY_SHORT,
+					 AR5K_INIT_RETRY_LONG);
 	}
 
 	hw->vif_data_size = sizeof(struct ath5k_vif);
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index d76d68c..36a5199 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -226,6 +226,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath5k_hw *ah = sc->ah;
 	struct ieee80211_conf *conf = &hw->conf;
 	int ret = 0;
+	int i;
 
 	mutex_lock(&sc->lock);
 
@@ -243,6 +244,14 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 		ath5k_hw_set_txpower_limit(ah, (conf->power_level * 2));
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
+		ah->ah_retry_long = conf->long_frame_max_tx_count;
+		ah->ah_retry_short = conf->short_frame_max_tx_count;
+
+		for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++)
+			ath5k_hw_set_tx_retry_limits(ah, i);
+	}
+
 	/* TODO:
 	 * 1) Move this on config_interface and handle each case
 	 * separately eg. when we have only one STA vif, use
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 2c9c9e7..3343fb9 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -228,24 +228,9 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 /*
  * Set tx retry limits on DCU
  */
-static void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
-					unsigned int queue)
+void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
+				  unsigned int queue)
 {
-	u32 retry_lg, retry_sh;
-
-	/*
-	 * Calculate and set retry limits
-	 */
-	if (ah->ah_software_retry) {
-		/* XXX Need to test this */
-		retry_lg = ah->ah_limit_tx_retries;
-		retry_sh = retry_lg = retry_lg > AR5K_DCU_RETRY_LMT_SH_RETRY ?
-			AR5K_DCU_RETRY_LMT_SH_RETRY : retry_lg;
-	} else {
-		retry_lg = AR5K_INIT_LG_RETRY;
-		retry_sh = AR5K_INIT_SH_RETRY;
-	}
-
 	/* Single data queue on AR5210 */
 	if (ah->ah_version == AR5K_AR5210) {
 		struct ath5k_txq_info *tq = &ah->ah_txq[queue];
@@ -255,25 +240,26 @@ static void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
 
 		ath5k_hw_reg_write(ah,
 			(tq->tqi_cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
-			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
-				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
-			| AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
-				AR5K_NODCU_RETRY_LMT_SSH_RETRY)
-			| AR5K_REG_SM(retry_lg, AR5K_NODCU_RETRY_LMT_LG_RETRY)
-			| AR5K_REG_SM(retry_sh, AR5K_NODCU_RETRY_LMT_SH_RETRY),
+			| AR5K_REG_SM(ah->ah_retry_long,
+				      AR5K_NODCU_RETRY_LMT_SLG_RETRY)
+			| AR5K_REG_SM(ah->ah_retry_short,
+				      AR5K_NODCU_RETRY_LMT_SSH_RETRY)
+			| AR5K_REG_SM(ah->ah_retry_long,
+				      AR5K_NODCU_RETRY_LMT_LG_RETRY)
+			| AR5K_REG_SM(ah->ah_retry_short,
+				      AR5K_NODCU_RETRY_LMT_SH_RETRY),
 			AR5K_NODCU_RETRY_LMT);
 	/* DCU on AR5211+ */
 	} else {
 		ath5k_hw_reg_write(ah,
-			AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
-				AR5K_DCU_RETRY_LMT_SLG_RETRY) |
-			AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
-				AR5K_DCU_RETRY_LMT_SSH_RETRY) |
-			AR5K_REG_SM(retry_lg, AR5K_DCU_RETRY_LMT_LG_RETRY) |
-			AR5K_REG_SM(retry_sh, AR5K_DCU_RETRY_LMT_SH_RETRY),
+			AR5K_REG_SM(ah->ah_retry_long,
+				    AR5K_DCU_RETRY_LMT_RTS)
+			| AR5K_REG_SM(ah->ah_retry_long,
+				      AR5K_DCU_RETRY_LMT_STA_RTS)
+			| AR5K_REG_SM(max(ah->ah_retry_long, ah->ah_retry_short),
+				      AR5K_DCU_RETRY_LMT_STA_DATA),
 			AR5K_QUEUE_DFS_RETRY_LIMIT(queue));
 	}
-	return;
 }
 
 /**
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index fd14b91..e1c9abd 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -686,16 +686,15 @@
 
 /*
  * DCU retry limit registers
+ * all these fields don't allow zero values
  */
 #define AR5K_DCU_RETRY_LMT_BASE		0x1080			/* Register Address -Queue0 DCU_RETRY_LMT */
-#define AR5K_DCU_RETRY_LMT_SH_RETRY	0x0000000f	/* Short retry limit mask */
-#define AR5K_DCU_RETRY_LMT_SH_RETRY_S	0
-#define AR5K_DCU_RETRY_LMT_LG_RETRY	0x000000f0	/* Long retry limit mask */
-#define AR5K_DCU_RETRY_LMT_LG_RETRY_S	4
-#define AR5K_DCU_RETRY_LMT_SSH_RETRY	0x00003f00	/* Station short retry limit mask (?) */
-#define AR5K_DCU_RETRY_LMT_SSH_RETRY_S	8
-#define AR5K_DCU_RETRY_LMT_SLG_RETRY	0x000fc000	/* Station long retry limit mask (?) */
-#define AR5K_DCU_RETRY_LMT_SLG_RETRY_S	14
+#define AR5K_DCU_RETRY_LMT_RTS		0x0000000f	/* RTS failure limit. Transmission fails if no CTS is received for this number of times */
+#define AR5K_DCU_RETRY_LMT_RTS_S	0
+#define AR5K_DCU_RETRY_LMT_STA_RTS	0x00003f00	/* STA RTS failure limit. If exceeded CW reset */
+#define AR5K_DCU_RETRY_LMT_STA_RTS_S	8
+#define AR5K_DCU_RETRY_LMT_STA_DATA	0x000fc000	/* STA data failure limit. If exceeded CW reset. */
+#define AR5K_DCU_RETRY_LMT_STA_DATA_S	14
 #define	AR5K_QUEUE_DFS_RETRY_LIMIT(_q)	AR5K_QUEUE_REG(AR5K_DCU_RETRY_LMT_BASE, _q)
 
 /*

