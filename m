Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55021 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755352Ab0KMTWu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 14:22:50 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	simon.wunderlich@saxnet.de, bernhard.schmidt@saxnet.de,
	zefir.kurtisi@neratec.com
Subject: [PATCH] ath9k_hw: set default values for radar pulse detection
Date: Sat, 13 Nov 2010 20:22:41 +0100
Message-Id: <1289676161-11530-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    2 ++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 3686811..7303d98 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1610,6 +1610,20 @@ static void ar5008_hw_set_radar_params(struct ath_hw *ah,
 		REG_CLR_BIT(ah, AR_PHY_RADAR_EXT, AR_PHY_RADAR_EXT_ENA);
 }
 
+static void ar5008_hw_set_radar_conf(struct ath_hw *ah)
+{
+	struct ath_hw_radar_conf *conf = &ah->radar_conf;
+
+	conf->fir_power = -33;
+	conf->radar_rssi = 20;
+	conf->pulse_height = 10;
+	conf->pulse_rssi = 24;
+	conf->pulse_inband = 15;
+	conf->pulse_maxlen = 255;
+	conf->pulse_inband_step = 12;
+	conf->radar_inband = 8;
+}
+
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1656,5 +1670,6 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 		priv_ops->compute_pll_control = ar5008_hw_compute_pll_control;
 
 	ar5008_hw_set_nf_limits(ah);
+	ar5008_hw_set_radar_conf(ah);
 	memcpy(ah->nf_regs, ar5416_cca_regs, sizeof(ah->nf_regs));
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index f676b21..e8d6455 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1144,6 +1144,20 @@ static void ar9003_hw_set_radar_params(struct ath_hw *ah,
 		REG_CLR_BIT(ah, AR_PHY_RADAR_EXT, AR_PHY_RADAR_EXT_ENA);
 }
 
+static void ar9003_hw_set_radar_conf(struct ath_hw *ah)
+{
+	struct ath_hw_radar_conf *conf = &ah->radar_conf;
+
+	conf->fir_power = -28;
+	conf->radar_rssi = 0;
+	conf->pulse_height = 10;
+	conf->pulse_rssi = 24;
+	conf->pulse_inband = 8;
+	conf->pulse_maxlen = 255;
+	conf->pulse_inband_step = 12;
+	conf->radar_inband = 8;
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1175,6 +1189,7 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->set_radar_params = ar9003_hw_set_radar_params;
 
 	ar9003_hw_set_nf_limits(ah);
+	ar9003_hw_set_radar_conf(ah);
 	memcpy(ah->nf_regs, ar9300_cca_regs, sizeof(ah->nf_regs));
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f5689cd..597c25a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -783,6 +783,8 @@ struct ath_hw {
 	u8 txchainmask;
 	u8 rxchainmask;
 
+	struct ath_hw_radar_conf radar_conf;
+
 	u32 originalGain[22];
 	int initPDADC;
 	int PDADCdelta;
-- 
1.7.3.2

