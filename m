Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36799 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab2IJDvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Sep 2012 23:51:14 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20557.25468.469353.339303@gargle.gargle.HOWL> (sfid-20120910_055150_020701_79E1D6E8)
Date: Mon, 10 Sep 2012 09:20:20 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] ath9k_hw: Fix spur mitigation for AR9565
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Exclude CCK spur mitigation, freq 2437 for OFDM and
add AR9565-specific logic.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 67 ++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 15 +++++--
 2 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 78665b2..05d0ac0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -206,6 +206,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 	for (i = 0; i < max_spur_cnts; i++) {
 		if (AR_SREV_9462(ah) && (i == 0 || i == 3))
 			continue;
+
 		negative = 0;
 		if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
 		    AR_SREV_9550(ah))
@@ -301,7 +302,9 @@ static void ar9003_hw_spur_ofdm(struct ath_hw *ah,
 				int freq_offset,
 				int spur_freq_sd,
 				int spur_delta_phase,
-				int spur_subchannel_sd)
+				int spur_subchannel_sd,
+				int range,
+				int synth_freq)
 {
 	int mask_index = 0;
 
@@ -316,8 +319,11 @@ static void ar9003_hw_spur_ofdm(struct ath_hw *ah,
 		      AR_PHY_SFCORR_EXT_SPUR_SUBCHANNEL_SD, spur_subchannel_sd);
 	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
 		      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_AGC, 0x1);
-	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
-		      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_SELFCOR, 0x1);
+
+	if (!(AR_SREV_9565(ah) && range == 10 && synth_freq == 2437))
+		REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+			      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_SELFCOR, 0x1);
+
 	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
 		      AR_PHY_TIMING4_ENABLE_SPUR_RSSI, 0x1);
 	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
@@ -358,9 +364,44 @@ static void ar9003_hw_spur_ofdm(struct ath_hw *ah,
 		      AR_PHY_SPUR_REG_MASK_RATE_CNTL, 0xff);
 }
 
+static void ar9003_hw_spur_ofdm_9565(struct ath_hw *ah,
+				     int freq_offset)
+{
+	int mask_index = 0;
+
+	mask_index = (freq_offset << 4) / 5;
+	if (mask_index < 0)
+		mask_index = mask_index - 1;
+
+	mask_index = mask_index & 0x7f;
+
+	REG_RMW_FIELD(ah, AR_PHY_PILOT_SPUR_MASK,
+		      AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_B,
+		      mask_index);
+
+	/* A == B */
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_MASK_B,
+		      AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_IDX_A,
+		      mask_index);
+
+	REG_RMW_FIELD(ah, AR_PHY_CHAN_SPUR_MASK,
+		      AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_B,
+		      mask_index);
+	REG_RMW_FIELD(ah, AR_PHY_PILOT_SPUR_MASK,
+		      AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_B, 0xe);
+	REG_RMW_FIELD(ah, AR_PHY_CHAN_SPUR_MASK,
+		      AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_B, 0xe);
+
+	/* A == B */
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_MASK_B,
+		      AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A, 0xa0);
+}
+
 static void ar9003_hw_spur_ofdm_work(struct ath_hw *ah,
 				     struct ath9k_channel *chan,
-				     int freq_offset)
+				     int freq_offset,
+				     int range,
+				     int synth_freq)
 {
 	int spur_freq_sd = 0;
 	int spur_subchannel_sd = 0;
@@ -402,7 +443,8 @@ static void ar9003_hw_spur_ofdm_work(struct ath_hw *ah,
 			    freq_offset,
 			    spur_freq_sd,
 			    spur_delta_phase,
-			    spur_subchannel_sd);
+			    spur_subchannel_sd,
+			    range, synth_freq);
 }
 
 /* Spur mitigation for OFDM */
@@ -447,7 +489,17 @@ static void ar9003_hw_spur_mitigate_ofdm(struct ath_hw *ah,
 		freq_offset = ath9k_hw_fbin2freq(spurChansPtr[i], mode);
 		freq_offset -= synth_freq;
 		if (abs(freq_offset) < range) {
-			ar9003_hw_spur_ofdm_work(ah, chan, freq_offset);
+			ar9003_hw_spur_ofdm_work(ah, chan, freq_offset,
+						 range, synth_freq);
+
+			if (AR_SREV_9565(ah) && (i < 4)) {
+				freq_offset = ath9k_hw_fbin2freq(spurChansPtr[i + 1],
+								 mode);
+				freq_offset -= synth_freq;
+				if (abs(freq_offset) < range)
+					ar9003_hw_spur_ofdm_9565(ah, freq_offset);
+			}
+
 			break;
 		}
 	}
@@ -456,7 +508,8 @@ static void ar9003_hw_spur_mitigate_ofdm(struct ath_hw *ah,
 static void ar9003_hw_spur_mitigate(struct ath_hw *ah,
 				    struct ath9k_channel *chan)
 {
-	ar9003_hw_spur_mitigate_mrc_cck(ah, chan);
+	if (!AR_SREV_9565(ah))
+		ar9003_hw_spur_mitigate_mrc_cck(ah, chan);
 	ar9003_hw_spur_mitigate_ofdm(ah, chan);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 20bf3ae..ff5899e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -223,15 +223,24 @@
 #define AR_PHY_ML_CNTL_2       (AR_MRC_BASE + 0x1c)
 #define AR_PHY_TST_ADC         (AR_MRC_BASE + 0x20)
 
-#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A              0x00000FE0
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A      0x00000FE0
 #define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A_S    5
-#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A                  0x1F
-#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A_S                0
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A          0x1F
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A_S        0
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_B      0x00FE0000
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_B_S    17
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_B          0x0001F000
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_B_S        12
 
 #define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_A        0x00000FE0
 #define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_A_S      5
 #define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_A            0x1F
 #define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_A_S		0
+#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_B	0x00FE0000
+#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_B_S	17
+#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_B		0x0001F000
+#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_B_S		12
+
 
 /*
  * MRC Feild Definitions
-- 
1.7.12

