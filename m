Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33163 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0KWS7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:59:16 -0500
Received: by eye27 with SMTP id 27so4873760eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:59:15 -0800 (PST)
Date: Tue, 23 Nov 2010 20:58:34 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 09/30] ath5k: Add new field on ath5k_hw to track bandwidth
 modes
Message-ID: <20101123185834.GI4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Prepare for half/quarter/turbo support, introduce a new
 ah_bwmode parameter and get rid of ah_turbo. Bwmode stands
 for "bandwidth mode" and can have 4 values, default (20MHz),
 turbo (40MHz), half rate (10MHz), and quarter rate (5MHz).

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    8 +++++++-
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/phy.c    |    1 -
 drivers/net/wireless/ath/ath5k/qcu.c    |   16 ++++++++--------
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 66359dc..b1429da 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -424,6 +424,12 @@ enum ath5k_ant_mode {
 	AR5K_ANTMODE_MAX,
 };
 
+enum ath5k_bw_mode {
+	AR5K_BWMODE_DEFAULT	= 0,	/* 20MHz, default operation */
+	AR5K_BWMODE_5MHZ	= 1,	/* Quarter rate */
+	AR5K_BWMODE_10MHZ	= 2,	/* Half rate */
+	AR5K_BWMODE_40MHZ	= 3	/* Turbo */
+};
 
 /****************\
   TX DEFINITIONS
@@ -1026,7 +1032,6 @@ struct ath5k_hw {
 	enum ath5k_int		ah_imr;
 
 	struct ieee80211_channel *ah_current_channel;
-	bool			ah_turbo;
 	bool			ah_calibration;
 	bool			ah_single_chip;
 
@@ -1044,6 +1049,7 @@ struct ath5k_hw {
 
 	u32			ah_limit_tx_retries;
 	u8			ah_coverage_class;
+	u8			ah_bwmode;
 
 	/* Antenna Control */
 	u32			ah_ant_ctl[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index fbe8aca..ed86b9d 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -115,7 +115,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	 * HW information
 	 */
 	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
-	ah->ah_turbo = false;
+	ah->ah_bwmode = AR5K_BWMODE_DEFAULT;
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
 	ah->ah_imr = 0;
 	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 1c41fa83..02869c7 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1235,7 +1235,6 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
 	}
 
 	ah->ah_current_channel = channel;
-	ah->ah_turbo = channel->hw_value == CHANNEL_T ? true : false;
 	ath5k_hw_set_clockrate(ah);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index ed62273..778fb59 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -246,21 +246,21 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 			return 0;
 
 		/* Set Slot time */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			AR5K_INIT_SLOT_TIME_TURBO : AR5K_INIT_SLOT_TIME,
 			AR5K_SLOT_TIME);
 		/* Set ACK_CTS timeout */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			AR5K_INIT_ACK_CTS_TIMEOUT_TURBO :
 			AR5K_INIT_ACK_CTS_TIMEOUT, AR5K_SLOT_TIME);
 		/* Set Transmit Latency */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			AR5K_INIT_TRANSMIT_LATENCY_TURBO :
 			AR5K_INIT_TRANSMIT_LATENCY, AR5K_USEC_5210);
 
 		/* Set IFS0 */
-		if (ah->ah_turbo) {
-			 ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
+		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
+			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
 				tq->tqi_aifs * AR5K_INIT_SLOT_TIME_TURBO) <<
 				AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
 				AR5K_IFS0);
@@ -272,18 +272,18 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		}
 
 		/* Set IFS1 */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
 			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
 		/* Set AR5K_PHY_SETTLING */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
 			| 0x38 :
 			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
 			| 0x1C,
 			AR5K_PHY_SETTLING);
 		/* Set Frame Control Register */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
+		ath5k_hw_reg_write(ah, (ah->ah_bwmode == AR5K_BWMODE_40MHZ) ?
 			(AR5K_PHY_FRAME_CTL_INI | AR5K_PHY_TURBO_MODE |
 			AR5K_PHY_TURBO_SHORT | 0x2020) :
 			(AR5K_PHY_FRAME_CTL_INI | 0x1020),
