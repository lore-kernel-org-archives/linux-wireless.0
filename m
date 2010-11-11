Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56137 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932281Ab0KKCfP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 21:35:15 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 5/5] ath9k_hw: add a private op for configuring radar pulse detection
Date: Thu, 11 Nov 2010 03:18:38 +0100
Message-Id: <1289441918-94905-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289441918-94905-4-git-send-email-nbd@openwrt.org>
References: <1289441918-94905-1-git-send-email-nbd@openwrt.org>
 <1289441918-94905-2-git-send-email-nbd@openwrt.org>
 <1289441918-94905-3-git-send-email-nbd@openwrt.org>
 <1289441918-94905-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   32 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   32 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |   36 +++++++++++++++++++++++++++
 3 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index c83a22c..3686811 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1579,6 +1579,37 @@ static void ar5008_hw_set_nf_limits(struct ath_hw *ah)
 	ah->nf_5g.nominal = AR_PHY_CCA_NOM_VAL_5416_5GHZ;
 }
 
+static void ar5008_hw_set_radar_params(struct ath_hw *ah,
+				       struct ath_hw_radar_conf *conf)
+{
+	u32 radar_0 = 0, radar_1 = 0;
+
+	if (!conf) {
+		REG_CLR_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_ENA);
+		return;
+	}
+
+	radar_0 |= AR_PHY_RADAR_0_ENA | AR_PHY_RADAR_0_FFT_ENA;
+	radar_0 |= SM(conf->fir_power, AR_PHY_RADAR_0_FIRPWR);
+	radar_0 |= SM(conf->radar_rssi, AR_PHY_RADAR_0_RRSSI);
+	radar_0 |= SM(conf->pulse_height, AR_PHY_RADAR_0_HEIGHT);
+	radar_0 |= SM(conf->pulse_rssi, AR_PHY_RADAR_0_PRSSI);
+	radar_0 |= SM(conf->pulse_inband, AR_PHY_RADAR_0_INBAND);
+
+	radar_1 |= AR_PHY_RADAR_1_MAX_RRSSI;
+	radar_1 |= AR_PHY_RADAR_1_BLOCK_CHECK;
+	radar_1 |= SM(conf->pulse_maxlen, AR_PHY_RADAR_1_MAXLEN);
+	radar_1 |= SM(conf->pulse_inband_step, AR_PHY_RADAR_1_RELSTEP_THRESH);
+	radar_1 |= SM(conf->radar_inband, AR_PHY_RADAR_1_RELPWR_THRESH);
+
+	REG_WRITE(ah, AR_PHY_RADAR_0, radar_0);
+	REG_WRITE(ah, AR_PHY_RADAR_1, radar_1);
+	if (conf->ext_channel)
+		REG_SET_BIT(ah, AR_PHY_RADAR_EXT, AR_PHY_RADAR_EXT_ENA);
+	else
+		REG_CLR_BIT(ah, AR_PHY_RADAR_EXT, AR_PHY_RADAR_EXT_ENA);
+}
+
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1609,6 +1640,7 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->restore_chainmask = ar5008_restore_chainmask;
 	priv_ops->set_diversity = ar5008_set_diversity;
 	priv_ops->do_getnf = ar5008_hw_do_getnf;
+	priv_ops->set_radar_params = ar5008_hw_set_radar_params;
 
 	if (modparam_force_new_ani) {
 		priv_ops->ani_control = ar5008_hw_ani_control_new;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 44c5454..f676b21 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1113,6 +1113,37 @@ static void ar9003_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	aniState->mrcCCKOff = !ATH9K_ANI_ENABLE_MRC_CCK;
 }
 
+static void ar9003_hw_set_radar_params(struct ath_hw *ah,
+				       struct ath_hw_radar_conf *conf)
+{
+	u32 radar_0 = 0, radar_1 = 0;
+
+	if (!conf) {
+		REG_CLR_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_ENA);
+		return;
+	}
+
+	radar_0 |= AR_PHY_RADAR_0_ENA | AR_PHY_RADAR_0_FFT_ENA;
+	radar_0 |= SM(conf->fir_power, AR_PHY_RADAR_0_FIRPWR);
+	radar_0 |= SM(conf->radar_rssi, AR_PHY_RADAR_0_RRSSI);
+	radar_0 |= SM(conf->pulse_height, AR_PHY_RADAR_0_HEIGHT);
+	radar_0 |= SM(conf->pulse_rssi, AR_PHY_RADAR_0_PRSSI);
+	radar_0 |= SM(conf->pulse_inband, AR_PHY_RADAR_0_INBAND);
+
+	radar_1 |= AR_PHY_RADAR_1_MAX_RRSSI;
+	radar_1 |= AR_PHY_RADAR_1_BLOCK_CHECK;
+	radar_1 |= SM(conf->pulse_maxlen, AR_PHY_RADAR_1_MAXLEN);
+	radar_1 |= SM(conf->pulse_inband_step, AR_PHY_RADAR_1_RELSTEP_THRESH);
+	radar_1 |= SM(conf->radar_inband, AR_PHY_RADAR_1_RELPWR_THRESH);
+
+	REG_WRITE(ah, AR_PHY_RADAR_0, radar_0);
+	REG_WRITE(ah, AR_PHY_RADAR_1, radar_1);
+	if (conf->ext_channel)
+		REG_SET_BIT(ah, AR_PHY_RADAR_EXT, AR_PHY_RADAR_EXT_ENA);
+	else
+		REG_CLR_BIT(ah, AR_PHY_RADAR_EXT, AR_PHY_RADAR_EXT_ENA);
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1141,6 +1172,7 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->ani_control = ar9003_hw_ani_control;
 	priv_ops->do_getnf = ar9003_hw_do_getnf;
 	priv_ops->ani_cache_ini_regs = ar9003_hw_ani_cache_ini_regs;
+	priv_ops->set_radar_params = ar9003_hw_set_radar_params;
 
 	ar9003_hw_set_nf_limits(ah);
 	memcpy(ah->nf_regs, ar9300_cca_regs, sizeof(ah->nf_regs));
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e29c712..f5689cd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -485,6 +485,40 @@ struct ath_hw_antcomb_conf {
 };
 
 /**
+ * struct ath_hw_radar_conf - radar detection initialization parameters
+ *
+ * @pulse_inband: threshold for checking the ratio of in-band power
+ *	to total power for short radar pulses (half dB steps)
+ * @pulse_inband_step: threshold for checking an in-band power to total
+ *	power ratio increase for short radar pulses (half dB steps)
+ * @pulse_height: threshold for detecting the beginning of a short
+ *	radar pulse (dB step)
+ * @pulse_rssi: threshold for detecting if a short radar pulse is
+ *	gone (dB step)
+ * @pulse_maxlen: maximum pulse length (0.8 us steps)
+ *
+ * @radar_rssi: RSSI threshold for starting long radar detection (dB steps)
+ * @radar_inband: threshold for checking the ratio of in-band power
+ *	to total power for long radar pulses (half dB steps)
+ * @fir_power: threshold for detecting the end of a long radar pulse (dB)
+ *
+ * @ext_channel: enable extension channel radar detection
+ */
+struct ath_hw_radar_conf {
+	unsigned int pulse_inband;
+	unsigned int pulse_inband_step;
+	unsigned int pulse_height;
+	unsigned int pulse_rssi;
+	unsigned int pulse_maxlen;
+
+	unsigned int radar_rssi;
+	unsigned int radar_inband;
+	int fir_power;
+
+	bool ext_channel;
+};
+
+/**
  * struct ath_hw_private_ops - callbacks used internally by hardware code
  *
  * This structure contains private callbacks designed to only be used internally
@@ -549,6 +583,8 @@ struct ath_hw_private_ops {
 	bool (*ani_control)(struct ath_hw *ah, enum ath9k_ani_cmd cmd,
 			    int param);
 	void (*do_getnf)(struct ath_hw *ah, int16_t nfarray[NUM_NF_READINGS]);
+	void (*set_radar_params)(struct ath_hw *ah,
+				 struct ath_hw_radar_conf *conf);
 
 	/* ANI */
 	void (*ani_cache_ini_regs)(struct ath_hw *ah);
-- 
1.7.2.2

