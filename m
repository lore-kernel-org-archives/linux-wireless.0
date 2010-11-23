Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39865 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab0KWTAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:00:43 -0500
Received: by eye27 with SMTP id 27so4874816eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:00:42 -0800 (PST)
Date: Tue, 23 Nov 2010 21:00:37 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 10/30] ath5k: Put core clock initialization on a new function
Message-ID: <20101123190037.GJ4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Handle all usec parameters in one function. It's much cleaner
 this way.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   26 +++++--
 drivers/net/wireless/ath/ath5k/phy.c   |    1 -
 drivers/net/wireless/ath/ath5k/qcu.c   |    4 -
 drivers/net/wireless/ath/ath5k/reset.c |  130 ++++++++++++++++++++++++++++----
 4 files changed, 134 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index b1429da..c953544 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -242,14 +242,6 @@
 #define AR5K_INIT_SLG_RETRY			AR5K_INIT_SSH_RETRY
 #define AR5K_INIT_TX_RETRY			10
 
-#define AR5K_INIT_TRANSMIT_LATENCY		(			\
-	(AR5K_INIT_TX_LATENCY << 14) | (AR5K_INIT_USEC_32 << 7) |	\
-	(AR5K_INIT_USEC)						\
-)
-#define AR5K_INIT_TRANSMIT_LATENCY_TURBO	(			\
-	(AR5K_INIT_TX_LATENCY << 14) | (AR5K_INIT_USEC_32 << 7) |	\
-	(AR5K_INIT_USEC_TURBO)						\
-)
 #define AR5K_INIT_PROTO_TIME_CNTRL		(			\
 	(AR5K_INIT_CARR_SENSE_EN << 26) | (AR5K_INIT_EIFS << 12) |	\
 	(AR5K_INIT_PROG_IFS)						\
@@ -259,6 +251,24 @@
 	(AR5K_INIT_PROG_IFS_TURBO)					\
 )
 
+/* Rx latency for 5 and 10MHz operation (max ?) */
+#define AR5K_INIT_RX_LAT_MAX			63
+/* Tx latencies from initvals (5212 only but no problem
+ * because we only tweak them on 5212) */
+#define	AR5K_INIT_TX_LAT_A			54
+#define	AR5K_INIT_TX_LAT_BG			384
+/* Tx latency for 40MHz (turbo) operation (min ?) */
+#define	AR5K_INIT_TX_LAT_MIN			32
+
+/* Tx frame to Tx data start delay */
+#define AR5K_INIT_TXF2TXD_START_DEFAULT		14
+#define AR5K_INIT_TXF2TXD_START_DELAY_10MHZ	12
+#define AR5K_INIT_TXF2TXD_START_DELAY_5MHZ	13
+
+/* Default Tx/Rx latencies (same for 5211)*/
+#define AR5K_INIT_TX_LATENCY_5210		54
+#define	AR5K_INIT_RX_LATENCY_5210		29
+
 
 /* GENERIC CHIPSET DEFINITIONS */
 
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 02869c7..706fc46 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1235,7 +1235,6 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
 	}
 
 	ah->ah_current_channel = channel;
-	ath5k_hw_set_clockrate(ah);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 778fb59..f89bc94 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -253,10 +253,6 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			AR5K_INIT_ACK_CTS_TIMEOUT_TURBO :
 			AR5K_INIT_ACK_CTS_TIMEOUT, AR5K_SLOT_TIME);
-		/* Set Transmit Latency */
-		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
-			AR5K_INIT_TRANSMIT_LATENCY_TURBO :
-			AR5K_INIT_TRANSMIT_LATENCY, AR5K_USEC_5210);
 
 		/* Set IFS0 */
 		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index e4900e1..a013bdf 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -86,16 +86,21 @@ unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock)
 }
 
 /**
- * ath5k_hw_set_clockrate - Set common->clockrate for the current channel
+ * ath5k_hw_init_core_clock - Initialize core clock
  *
- * @ah: The &struct ath5k_hw
+ * @ah The &struct ath5k_hw
+ *
+ * Initialize core clock parameters (usec, usec32, latencies etc).
  */
-void ath5k_hw_set_clockrate(struct ath5k_hw *ah)
+static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 	struct ath_common *common = ath5k_hw_common(ah);
-	int clock;
+	u32 usec_reg, txlat, rxlat, usec, clock, sclock, txf2txs;
 
+	/*
+	 * Set core clock frequency
+	 */
 	if (channel->hw_value & CHANNEL_5GHZ)
 		clock = 40; /* 802.11a */
 	else if (channel->hw_value & CHANNEL_CCK)
@@ -103,11 +108,109 @@ void ath5k_hw_set_clockrate(struct ath5k_hw *ah)
 	else
 		clock = 44; /* 802.11g */
 
-	/* Clock rate in turbo modes is twice the normal rate */
-	if (channel->hw_value & CHANNEL_TURBO)
+	/* Use clock multiplier for non-default
+	 * bwmode */
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_40MHZ:
 		clock *= 2;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		clock /= 2;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		clock /= 4;
+		break;
+	default:
+		break;
+	}
 
 	common->clockrate = clock;
+
+	/*
+	 * Set USEC parameters
+	 */
+	/* Set USEC counter on PCU*/
+	usec = clock - 1;
+	usec = AR5K_REG_SM(usec, AR5K_USEC_1);
+
+	/* Set usec duration on DCU */
+	if (ah->ah_version != AR5K_AR5210)
+		AR5K_REG_WRITE_BITS(ah, AR5K_DCU_GBL_IFS_MISC,
+					AR5K_DCU_GBL_IFS_MISC_USEC_DUR,
+					clock);
+
+	/* Set 32MHz USEC counter */
+	if ((ah->ah_radio == AR5K_RF5112) ||
+	(ah->ah_radio == AR5K_RF5413))
+	/* Remain on 40MHz clock ? */
+		sclock = 40 - 1;
+	else
+		sclock = 32 - 1;
+	sclock = AR5K_REG_SM(sclock, AR5K_USEC_32);
+
+	/*
+	 * Set tx/rx latencies
+	 */
+	usec_reg = ath5k_hw_reg_read(ah, AR5K_USEC_5211);
+	txlat = AR5K_REG_MS(usec_reg, AR5K_USEC_TX_LATENCY_5211);
+	rxlat = AR5K_REG_MS(usec_reg, AR5K_USEC_RX_LATENCY_5211);
+
+	/*
+	 * 5210 initvals don't include usec settings
+	 * so we need to use magic values here for
+	 * tx/rx latencies
+	 */
+	if (ah->ah_version == AR5K_AR5210) {
+		/* same for turbo */
+		txlat = AR5K_INIT_TX_LATENCY_5210;
+		rxlat = AR5K_INIT_RX_LATENCY_5210;
+	}
+
+	if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
+		/* 5311 has different tx/rx latency masks
+		 * from 5211, since we deal 5311 the same
+		 * as 5211 when setting initvals, shift
+		 * values here to their proper locations
+		 *
+		 * Note: Initvals indicate tx/rx/ latencies
+		 * are the same for turbo mode */
+		txlat = AR5K_REG_SM(txlat, AR5K_USEC_TX_LATENCY_5210);
+		rxlat = AR5K_REG_SM(rxlat, AR5K_USEC_RX_LATENCY_5210);
+	} else
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_10MHZ:
+		txlat = AR5K_REG_SM(txlat * 2,
+				AR5K_USEC_TX_LATENCY_5211);
+		rxlat = AR5K_REG_SM(AR5K_INIT_RX_LAT_MAX,
+				AR5K_USEC_RX_LATENCY_5211);
+		txf2txs = AR5K_INIT_TXF2TXD_START_DELAY_10MHZ;
+		break;
+	case AR5K_BWMODE_5MHZ:
+		txlat = AR5K_REG_SM(txlat * 4,
+				AR5K_USEC_TX_LATENCY_5211);
+		rxlat = AR5K_REG_SM(AR5K_INIT_RX_LAT_MAX,
+				AR5K_USEC_RX_LATENCY_5211);
+		txf2txs = AR5K_INIT_TXF2TXD_START_DELAY_5MHZ;
+		break;
+	case AR5K_BWMODE_40MHZ:
+		txlat = AR5K_INIT_TX_LAT_MIN;
+		rxlat = AR5K_REG_SM(rxlat / 2,
+				AR5K_USEC_RX_LATENCY_5211);
+		txf2txs = AR5K_INIT_TXF2TXD_START_DEFAULT;
+		break;
+	default:
+		break;
+	}
+
+	usec_reg = (usec | sclock | txlat | rxlat);
+	ath5k_hw_reg_write(ah, usec_reg, AR5K_USEC);
+
+	/* On 5112 set tx frane to tx data start delay */
+	if (ah->ah_radio == AR5K_RF5112) {
+		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RF_CTL2,
+					AR5K_PHY_RF_CTL2_TXF2TXD_START,
+					txf2txs);
+	}
 }
 
 /*
@@ -122,7 +225,7 @@ void ath5k_hw_set_clockrate(struct ath5k_hw *ah)
 static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 scal, spending, usec32;
+	u32 scal, spending;
 
 	/* Only set 32KHz settings if we have an external
 	 * 32KHz crystal present */
@@ -179,6 +282,7 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 		AR5K_REG_WRITE_BITS(ah, AR5K_PCICFG,
 				AR5K_PCICFG_SLEEP_CLOCK_RATE, 0);
 
+		/* Set DAC/ADC delays */
 		ath5k_hw_reg_write(ah, 0x1f, AR5K_PHY_SCR);
 		ath5k_hw_reg_write(ah, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
 
@@ -201,13 +305,7 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 			spending = 0x18;
 		ath5k_hw_reg_write(ah, spending, AR5K_PHY_SPENDING);
 
-		if ((ah->ah_radio == AR5K_RF5112) ||
-		(ah->ah_radio == AR5K_RF5413))
-			usec32 = 39;
-		else
-			usec32 = 31;
-		AR5K_REG_WRITE_BITS(ah, AR5K_USEC_5211, AR5K_USEC_32, usec32);
-
+		/* Set up tsf increment on each cycle */
 		AR5K_REG_WRITE_BITS(ah, AR5K_TSF_PARM, AR5K_TSF_PARM_INC, 1);
 	}
 }
@@ -822,6 +920,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	freq = 0;
 	mode = 0;
 
+
 	/*
 	 * Stop PCU
 	 */
@@ -971,6 +1070,9 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	if (ret)
 		return ret;
 
+	/* Initialize core clock settings */
+	ath5k_hw_init_core_clock(ah);
+
 	/*
 	 * Tweak initval settings for revised
 	 * chipsets and add some more config
