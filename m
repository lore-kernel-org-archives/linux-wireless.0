Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32933 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab0DOVjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 70/97] ath9k_hw: add OFDM spur mitigation for AR9003
Date: Thu, 15 Apr 2010 17:39:15 -0400
Message-Id: <1271367582-992-71-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add this now as OFDM spur mitigation required accessing
the EEPROM for the AR9003 devices.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.h |    2 -
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  210 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   54 +++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    2 +
 drivers/net/wireless/ath/ath9k/phy.h        |    3 +
 5 files changed, 267 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index afe4808..81bf6e5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -289,8 +289,6 @@
 #define	AR_PHY_TIMING11			        0x99a0
 #define	AR_PHY_TIMING11_SPUR_DELTA_PHASE	0x000FFFFF
 #define	AR_PHY_TIMING11_SPUR_DELTA_PHASE_S	0
-#define	AR_PHY_TIMING11_SPUR_FREQ_SD		0x3FF00000
-#define	AR_PHY_TIMING11_SPUR_FREQ_SD_S		20
 #define AR_PHY_TIMING11_USE_SPUR_IN_AGC		0x40000000
 #define AR_PHY_TIMING11_USE_SPUR_IN_SELFCOR	0x80000000
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index fee07fd..137543b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -103,8 +103,8 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
  *
  * Spur mitigation for MRC CCK
  */
-static void ar9003_hw_spur_mitigate(struct ath_hw *ah,
-				    struct ath9k_channel *chan)
+static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
+					    struct ath9k_channel *chan)
 {
 	u32 spur_freq[4] = { 2420, 2440, 2464, 2480 };
 	int cur_bb_spur, negative = 0, cck_spur_freq;
@@ -157,6 +157,212 @@ static void ar9003_hw_spur_mitigate(struct ath_hw *ah,
 		      AR_PHY_CCK_SPUR_MIT_CCK_SPUR_FREQ, 0x0);
 }
 
+/* Clean all spur register fields */
+static void ar9003_hw_spur_ofdm_clear(struct ath_hw *ah)
+{
+	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+		      AR_PHY_TIMING4_ENABLE_SPUR_FILTER, 0);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+		      AR_PHY_TIMING11_SPUR_FREQ_SD, 0);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+		      AR_PHY_TIMING11_SPUR_DELTA_PHASE, 0);
+	REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+		      AR_PHY_SFCORR_EXT_SPUR_SUBCHANNEL_SD, 0);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+		      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_AGC, 0);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+		      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_SELFCOR, 0);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+		      AR_PHY_TIMING4_ENABLE_SPUR_RSSI, 0);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+		      AR_PHY_SPUR_REG_EN_VIT_SPUR_RSSI, 0);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+		      AR_PHY_SPUR_REG_ENABLE_NF_RSSI_SPUR_MIT, 0);
+
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+		      AR_PHY_SPUR_REG_ENABLE_MASK_PPM, 0);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+		      AR_PHY_TIMING4_ENABLE_PILOT_MASK, 0);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+		      AR_PHY_TIMING4_ENABLE_CHAN_MASK, 0);
+	REG_RMW_FIELD(ah, AR_PHY_PILOT_SPUR_MASK,
+		      AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A, 0);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_MASK_A,
+		      AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_IDX_A, 0);
+	REG_RMW_FIELD(ah, AR_PHY_CHAN_SPUR_MASK,
+		      AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_A, 0);
+	REG_RMW_FIELD(ah, AR_PHY_PILOT_SPUR_MASK,
+		      AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A, 0);
+	REG_RMW_FIELD(ah, AR_PHY_CHAN_SPUR_MASK,
+		      AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_A, 0);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_MASK_A,
+		      AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A, 0);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+		      AR_PHY_SPUR_REG_MASK_RATE_CNTL, 0);
+}
+
+static void ar9003_hw_spur_ofdm(struct ath_hw *ah,
+				int freq_offset,
+				int spur_freq_sd,
+				int spur_delta_phase,
+				int spur_subchannel_sd)
+{
+	int mask_index = 0;
+
+	/* OFDM Spur mitigation */
+	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+		 AR_PHY_TIMING4_ENABLE_SPUR_FILTER, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+		      AR_PHY_TIMING11_SPUR_FREQ_SD, spur_freq_sd);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+		      AR_PHY_TIMING11_SPUR_DELTA_PHASE, spur_delta_phase);
+	REG_RMW_FIELD(ah, AR_PHY_SFCORR_EXT,
+		      AR_PHY_SFCORR_EXT_SPUR_SUBCHANNEL_SD, spur_subchannel_sd);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+		      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_AGC, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING11,
+		      AR_PHY_TIMING11_USE_SPUR_FILTER_IN_SELFCOR, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+		      AR_PHY_TIMING4_ENABLE_SPUR_RSSI, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+		      AR_PHY_SPUR_REG_SPUR_RSSI_THRESH, 34);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+		      AR_PHY_SPUR_REG_EN_VIT_SPUR_RSSI, 1);
+
+	if (REG_READ_FIELD(ah, AR_PHY_MODE,
+			   AR_PHY_MODE_DYNAMIC) == 0x1)
+		REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+			      AR_PHY_SPUR_REG_ENABLE_NF_RSSI_SPUR_MIT, 1);
+
+	mask_index = (freq_offset << 4) / 5;
+	if (mask_index < 0)
+		mask_index = mask_index - 1;
+
+	mask_index = mask_index & 0x7f;
+
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+		      AR_PHY_SPUR_REG_ENABLE_MASK_PPM, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+		      AR_PHY_TIMING4_ENABLE_PILOT_MASK, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_TIMING4,
+		      AR_PHY_TIMING4_ENABLE_CHAN_MASK, 0x1);
+	REG_RMW_FIELD(ah, AR_PHY_PILOT_SPUR_MASK,
+		      AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A, mask_index);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_MASK_A,
+		      AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_IDX_A, mask_index);
+	REG_RMW_FIELD(ah, AR_PHY_CHAN_SPUR_MASK,
+		      AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_A, mask_index);
+	REG_RMW_FIELD(ah, AR_PHY_PILOT_SPUR_MASK,
+		      AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A, 0xc);
+	REG_RMW_FIELD(ah, AR_PHY_CHAN_SPUR_MASK,
+		      AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_A, 0xc);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_MASK_A,
+		      AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A, 0xa0);
+	REG_RMW_FIELD(ah, AR_PHY_SPUR_REG,
+		      AR_PHY_SPUR_REG_MASK_RATE_CNTL, 0xff);
+}
+
+static void ar9003_hw_spur_ofdm_work(struct ath_hw *ah,
+				     struct ath9k_channel *chan,
+				     int freq_offset)
+{
+	int spur_freq_sd = 0;
+	int spur_subchannel_sd = 0;
+	int spur_delta_phase = 0;
+
+	if (IS_CHAN_HT40(chan)) {
+		if (freq_offset < 0) {
+			if (REG_READ_FIELD(ah, AR_PHY_GEN_CTRL,
+					   AR_PHY_GC_DYN2040_PRI_CH) == 0x0)
+				spur_subchannel_sd = 1;
+			else
+				spur_subchannel_sd = 0;
+
+			spur_freq_sd = ((freq_offset + 10) << 9) / 11;
+
+		} else {
+			if (REG_READ_FIELD(ah, AR_PHY_GEN_CTRL,
+			    AR_PHY_GC_DYN2040_PRI_CH) == 0x0)
+				spur_subchannel_sd = 0;
+			else
+				spur_subchannel_sd = 1;
+
+			spur_freq_sd = ((freq_offset - 10) << 9) / 11;
+
+		}
+
+		spur_delta_phase = (freq_offset << 17) / 5;
+
+	} else {
+		spur_subchannel_sd = 0;
+		spur_freq_sd = (freq_offset << 9) /11;
+		spur_delta_phase = (freq_offset << 18) / 5;
+	}
+
+	spur_freq_sd = spur_freq_sd & 0x3ff;
+	spur_delta_phase = spur_delta_phase & 0xfffff;
+
+	ar9003_hw_spur_ofdm(ah,
+			    freq_offset,
+			    spur_freq_sd,
+			    spur_delta_phase,
+			    spur_subchannel_sd);
+}
+
+/* Spur mitigation for OFDM */
+static void ar9003_hw_spur_mitigate_ofdm(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	int synth_freq;
+	int range = 10;
+	int freq_offset = 0;
+	int mode;
+	u8* spurChansPtr;
+	unsigned int i;
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (IS_CHAN_5GHZ(chan)) {
+		spurChansPtr = &(eep->modalHeader5G.spurChans[0]);
+		mode = 0;
+	}
+	else {
+		spurChansPtr = &(eep->modalHeader2G.spurChans[0]);
+		mode = 1;
+	}
+
+	if (spurChansPtr[0] == 0)
+		return; /* No spur in the mode */
+
+	if (IS_CHAN_HT40(chan)) {
+		range = 19;
+		if (REG_READ_FIELD(ah, AR_PHY_GEN_CTRL,
+				   AR_PHY_GC_DYN2040_PRI_CH) == 0x0)
+			synth_freq = chan->channel - 10;
+		else
+			synth_freq = chan->channel + 10;
+	} else {
+		range = 10;
+		synth_freq = chan->channel;
+	}
+
+	ar9003_hw_spur_ofdm_clear(ah);
+
+	for (i = 0; spurChansPtr[i] && i < 5; i++) {
+		freq_offset = FBIN2FREQ(spurChansPtr[i], mode) - synth_freq;
+		if (abs(freq_offset) < range) {
+			ar9003_hw_spur_ofdm_work(ah, chan, freq_offset);
+			break;
+		}
+	}
+}
+
+static void ar9003_hw_spur_mitigate(struct ath_hw *ah,
+				    struct ath9k_channel *chan)
+{
+	ar9003_hw_spur_mitigate_mrc_cck(ah, chan);
+	ar9003_hw_spur_mitigate_ofdm(ah, chan);
+}
+
 static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 4e1177d..f08cc8b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -33,6 +33,30 @@
 #define AR_PHY_RX_IQCAL_CORR_B0    (AR_CHAN_BASE + 0xdc)
 #define AR_PHY_TX_IQCAL_CONTROL_3  (AR_CHAN_BASE + 0xb0)
 
+#define AR_PHY_TIMING11_SPUR_FREQ_SD    0x3FF00000
+#define AR_PHY_TIMING11_SPUR_FREQ_SD_S  20
+
+#define AR_PHY_TIMING11_SPUR_DELTA_PHASE 0x000FFFFF
+#define AR_PHY_TIMING11_SPUR_DELTA_PHASE_S 0
+
+#define AR_PHY_TIMING11_USE_SPUR_FILTER_IN_AGC 0x40000000
+#define AR_PHY_TIMING11_USE_SPUR_FILTER_IN_AGC_S 30
+
+#define AR_PHY_TIMING11_USE_SPUR_FILTER_IN_SELFCOR 0x80000000
+#define AR_PHY_TIMING11_USE_SPUR_FILTER_IN_SELFCOR_S 31
+
+#define AR_PHY_SPUR_REG_ENABLE_NF_RSSI_SPUR_MIT         0x4000000
+#define AR_PHY_SPUR_REG_ENABLE_NF_RSSI_SPUR_MIT_S       26
+
+#define AR_PHY_SPUR_REG_ENABLE_MASK_PPM                         0x20000     /* bins move with freq offset */
+#define AR_PHY_SPUR_REG_ENABLE_MASK_PPM_S                       17
+#define AR_PHY_SPUR_REG_SPUR_RSSI_THRESH            0x000000FF
+#define AR_PHY_SPUR_REG_SPUR_RSSI_THRESH_S          0
+#define AR_PHY_SPUR_REG_EN_VIT_SPUR_RSSI                        0x00000100
+#define AR_PHY_SPUR_REG_EN_VIT_SPUR_RSSI_S                      8
+#define AR_PHY_SPUR_REG_MASK_RATE_CNTL                          0x03FC0000
+#define AR_PHY_SPUR_REG_MASK_RATE_CNTL_S			18
+
 #define AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN   0x20000000
 #define AR_PHY_RX_IQCAL_CORR_B0_LOOPBACK_IQCORR_EN_S         29
 
@@ -84,6 +108,17 @@
 #define AR_PHY_TIMING4_IQCAL_LOG_COUNT_MAX 0xF000
 #define AR_PHY_TIMING4_IQCAL_LOG_COUNT_MAX_S   12
 #define AR_PHY_TIMING4_DO_CAL    0x10000
+
+#define AR_PHY_TIMING4_ENABLE_PILOT_MASK        0x10000000
+#define AR_PHY_TIMING4_ENABLE_PILOT_MASK_S      28
+#define AR_PHY_TIMING4_ENABLE_CHAN_MASK         0x20000000
+#define AR_PHY_TIMING4_ENABLE_CHAN_MASK_S       29
+
+#define AR_PHY_TIMING4_ENABLE_SPUR_FILTER 0x40000000
+#define AR_PHY_TIMING4_ENABLE_SPUR_FILTER_S 30
+#define AR_PHY_TIMING4_ENABLE_SPUR_RSSI 0x80000000
+#define AR_PHY_TIMING4_ENABLE_SPUR_RSSI_S 31
+
 #define AR_PHY_NEW_ADC_GAIN_CORR_ENABLE 0x40000000
 #define AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE 0x80000000
 #define AR_PHY_SFCORR_LOW_USE_SELF_CORR_LOW  0x00000001
@@ -107,6 +142,8 @@
 #define AR_PHY_SFCORR_EXT_M1_THRESH_LOW_S 14
 #define AR_PHY_SFCORR_EXT_M2_THRESH_LOW   0x0FE00000
 #define AR_PHY_SFCORR_EXT_M2_THRESH_LOW_S 21
+#define AR_PHY_SFCORR_EXT_SPUR_SUBCHANNEL_SD 0x10000000
+#define AR_PHY_SFCORR_EXT_SPUR_SUBCHANNEL_SD_S 28
 #define AR_PHY_SFCORR_SPUR_SUBCHNL_SD_S   28
 #define AR_PHY_EXT_CCA_THRESH62 0x007F0000
 #define AR_PHY_EXT_CCA_THRESH62_S       16
@@ -184,6 +221,16 @@
 #define AR_PHY_ML_CNTL_2       (AR_MRC_BASE + 0x1c)
 #define AR_PHY_TST_ADC         (AR_MRC_BASE + 0x20)
 
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A              0x00000FE0
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_IDX_A_S    5
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A                  0x1F
+#define AR_PHY_PILOT_SPUR_MASK_CF_PILOT_MASK_A_S                0
+
+#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_A        0x00000FE0
+#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_IDX_A_S      5
+#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_A            0x1F
+#define AR_PHY_CHAN_SPUR_MASK_CF_CHAN_MASK_A_S		0
+
 /*
  * MRC Feild Definitions
  */
@@ -372,6 +419,11 @@
 #define AR_PHY_ADDAC_PARA_CTL    (AR_SM_BASE + 0x150)
 #define AR_PHY_XPA_CFG           (AR_SM_BASE + 0x158)
 
+#define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_IDX_A           0x0001FC00
+#define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_IDX_A_S         10
+#define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A                       0x3FF
+#define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A_S                     0
+
 #define AR_PHY_TEST              (AR_SM_BASE + 0x160)
 
 #define AR_PHY_TEST_BBB_OBS_SEL       0x780000
@@ -499,6 +551,7 @@
 #define AR_PHY_GC_DYN2040_EN       0x00000004  /* enable dyn 20/40 mode */
 #define AR_PHY_GC_DYN2040_PRI_ONLY 0x00000008  /* dyn 20/40 - primary only */
 #define AR_PHY_GC_DYN2040_PRI_CH   0x00000010  /* dyn 20/40 - primary ch offset (0=+10MHz, 1=-10MHz)*/
+#define AR_PHY_GC_DYN2040_PRI_CH_S 4
 #define AR_PHY_GC_DYN2040_EXT_CH   0x00000020  /* dyn 20/40 - ext ch spacing (0=20MHz/ 1=25MHz) */
 #define AR_PHY_GC_HT_EN            0x00000040  /* ht enable */
 #define AR_PHY_GC_SHORT_GI_40      0x00000080  /* allow short GI for HT 40 */
@@ -516,6 +569,7 @@
 #define AR_PHY_MODE_OFDM            0x00000000
 #define AR_PHY_MODE_CCK             0x00000001
 #define AR_PHY_MODE_DYNAMIC         0x00000004
+#define AR_PHY_MODE_DYNAMIC_S       2
 #define AR_PHY_MODE_HALF            0x00000020
 #define AR_PHY_MODE_QUARTER         0x00000040
 #define AR_PHY_MAC_CLK_MODE         0x00000080
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d1b9940..25713be 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -76,6 +76,8 @@
 #define REG_RMW_FIELD(_a, _r, _f, _v) \
 	REG_WRITE(_a, _r, \
 	(REG_READ(_a, _r) & ~_f) | (((_v) << _f##_S) & _f))
+#define REG_READ_FIELD(_a, _r, _f) \
+	(((REG_READ(_a, _r) & _f) >> _f##_S))
 #define REG_SET_BIT(_a, _r, _f) \
 	REG_WRITE(_a, _r, REG_READ(_a, _r) | _f)
 #define REG_CLR_BIT(_a, _r, _f) \
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 7d397fd..e724c2c 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -59,4 +59,7 @@
 			(_bank)[i] = INI_RA((_iniarray), i, _col);;	\
 	} while (0)
 
+#define	AR_PHY_TIMING11_SPUR_FREQ_SD		0x3FF00000
+#define	AR_PHY_TIMING11_SPUR_FREQ_SD_S		20
+
 #endif
-- 
1.6.3.3

