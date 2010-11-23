Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49848 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab0KWTFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:05:06 -0500
Received: by eye27 with SMTP id 27so4877928eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:05:05 -0800 (PST)
Date: Tue, 23 Nov 2010 21:04:43 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 12/30] ath5k: Increase PHY settling parameters for turo mode
Message-ID: <20101123190359.GL4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * On turbo mode increase PHY settling times, note that
 we only increase switch settling time on AR5212 as indicated
 by initvals.

 * A few cleanups: Move frame control settings for AR5210 from
 reset_tx_queue to tweak_initvals and remove phy_scal settings
 from tweak_initvals (we tweak them alread on set_sleep_clock).

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   14 +++++++--
 drivers/net/wireless/ath/ath5k/qcu.c   |   13 --------
 drivers/net/wireless/ath/ath5k/reg.h   |    2 +
 drivers/net/wireless/ath/ath5k/reset.c |   52 ++++++++++++++++++++++++--------
 4 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index c953544..005cad0 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -259,15 +259,23 @@
 #define	AR5K_INIT_TX_LAT_BG			384
 /* Tx latency for 40MHz (turbo) operation (min ?) */
 #define	AR5K_INIT_TX_LAT_MIN			32
+/* Default Tx/Rx latencies (same for 5211)*/
+#define AR5K_INIT_TX_LATENCY_5210		54
+#define	AR5K_INIT_RX_LATENCY_5210		29
 
 /* Tx frame to Tx data start delay */
 #define AR5K_INIT_TXF2TXD_START_DEFAULT		14
 #define AR5K_INIT_TXF2TXD_START_DELAY_10MHZ	12
 #define AR5K_INIT_TXF2TXD_START_DELAY_5MHZ	13
 
-/* Default Tx/Rx latencies (same for 5211)*/
-#define AR5K_INIT_TX_LATENCY_5210		54
-#define	AR5K_INIT_RX_LATENCY_5210		29
+/* We need to increase PHY switch and agc settling time
+ * on turbo mode */
+#define	AR5K_SWITCH_SETTLING			5760
+#define	AR5K_SWITCH_SETTLING_TURBO		7168
+
+#define	AR5K_AGC_SETTLING			28
+/* 38 on 5210 but shouldn't matter */
+#define	AR5K_AGC_SETTLING_TURBO			37
 
 
 /* GENERIC CHIPSET DEFINITIONS */
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index f89bc94..00c4908 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -271,19 +271,6 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
 			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
-		/* Set AR5K_PHY_SETTLING */
-		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
-			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
-			| 0x38 :
-			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
-			| 0x1C,
-			AR5K_PHY_SETTLING);
-		/* Set Frame Control Register */
-		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
-			(AR5K_PHY_FRAME_CTL_INI | AR5K_PHY_TURBO_MODE |
-			AR5K_PHY_TURBO_SHORT | 0x2020) :
-			(AR5K_PHY_FRAME_CTL_INI | 0x1020),
-			AR5K_PHY_FRAME_CTL_5210);
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 4d61061..dc213bb 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -2245,6 +2245,8 @@
 #define	AR5K_PHY_FRAME_CTL		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_PHY_FRAME_CTL_5210 : AR5K_PHY_FRAME_CTL_5211)
 /*---[5111+]---*/
+#define	AR5K_PHY_FRAME_CTL_WIN_LEN	0x00000003	/* Force window length (?) */
+#define	AR5K_PHY_FRAME_CTL_WIN_LEN_S	0
 #define	AR5K_PHY_FRAME_CTL_TX_CLIP	0x00000038	/* Mask for tx clip (?) */
 #define	AR5K_PHY_FRAME_CTL_TX_CLIP_S	3
 #define	AR5K_PHY_FRAME_CTL_PREP_CHINFO	0x00010000	/* Prepend chan info */
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index f9457f4..ee605cd 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -688,19 +688,6 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 		AR5K_REG_DISABLE_BITS(ah, AR5K_TXCFG,
 				AR5K_TXCFG_DCU_DBL_BUF_DIS);
 
-	/* Set DAC/ADC delays */
-	if (ah->ah_version == AR5K_AR5212) {
-		u32 scal;
-		struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-		if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
-			scal = AR5K_PHY_SCAL_32MHZ_2417;
-		else if (ee->ee_is_hb63)
-			scal = AR5K_PHY_SCAL_32MHZ_HB63;
-		else
-			scal = AR5K_PHY_SCAL_32MHZ;
-		ath5k_hw_reg_write(ah, scal, AR5K_PHY_SCAL);
-	}
-
 	/* Set fast ADC */
 	if ((ah->ah_radio == AR5K_RF5413) ||
 	(ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))) {
@@ -740,6 +727,45 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 		AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW_5211,
 					AR5K_DIAG_SW_ECO_ENABLE);
 	}
+
+	if (ah->ah_bwmode) {
+		/* Increase PHY switch and AGC settling time
+		 * on turbo mode (ath5k_hw_commit_eeprom_settings
+		 * will override settling time if available) */
+		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
+
+			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SETTLING,
+						AR5K_PHY_SETTLING_AGC,
+						AR5K_AGC_SETTLING_TURBO);
+
+			/* XXX: Initvals indicate we only increase
+			 * switch time on AR5212, 5211 and 5210
+			 * only change agc time (bug?) */
+			if (ah->ah_version == AR5K_AR5212)
+				AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SETTLING,
+						AR5K_PHY_SETTLING_SWITCH,
+						AR5K_SWITCH_SETTLING_TURBO);
+
+			if (ah->ah_version == AR5K_AR5210) {
+				/* Set Frame Control Register */
+				ath5k_hw_reg_write(ah,
+					(AR5K_PHY_FRAME_CTL_INI |
+					AR5K_PHY_TURBO_MODE |
+					AR5K_PHY_TURBO_SHORT | 0x2020),
+					AR5K_PHY_FRAME_CTL_5210);
+			}
+		/* On 5413 PHY force window length for half/quarter rate*/
+		} else if ((ah->ah_mac_srev >= AR5K_SREV_AR5424) &&
+		(ah->ah_mac_srev <= AR5K_SREV_AR5414)) {
+			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_FRAME_CTL_5211,
+						AR5K_PHY_FRAME_CTL_WIN_LEN,
+						3);
+		}
+	} else if (ah->ah_version == AR5K_AR5210) {
+		/* Set Frame Control Register for normal operation */
+		ath5k_hw_reg_write(ah, (AR5K_PHY_FRAME_CTL_INI | 0x1020),
+						AR5K_PHY_FRAME_CTL_5210);
+	}
 }
 
 static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
