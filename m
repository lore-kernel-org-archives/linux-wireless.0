Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30975 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab1EMPAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:00:51 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:00:22 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 5/9] ath9k_hw: define modules to get/set Antenna diversity paramaters
Date: Fri, 13 May 2011 20:30:41 +0530
Message-ID: <1305298841-3465-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_170055_299569_B90F036B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

these are the two important modules that will be called by the antenna
diversity algorithm module in the rx. this will continuosly configure
the hardware based on the current diversity status obtained
from the algorithm

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   44 +++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index c83be2d..d2a5d27 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1184,9 +1184,50 @@ static void ar9003_hw_set_radar_conf(struct ath_hw *ah)
 	conf->radar_inband = 8;
 }
 
+static void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+				   struct ath_hw_antcomb_conf *antconf)
+{
+	u32 regval;
+
+	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+	antconf->main_lna_conf = (regval & AR_PHY_9485_ANT_DIV_MAIN_LNACONF) >>
+				  AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S;
+	antconf->alt_lna_conf = (regval & AR_PHY_9485_ANT_DIV_ALT_LNACONF) >>
+				 AR_PHY_9485_ANT_DIV_ALT_LNACONF_S;
+	antconf->fast_div_bias = (regval & AR_PHY_9485_ANT_FAST_DIV_BIAS) >>
+				  AR_PHY_9485_ANT_FAST_DIV_BIAS_S;
+}
+
+static void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+				   struct ath_hw_antcomb_conf *antconf)
+{
+	u32 regval;
+
+	regval = REG_READ(ah, AR_PHY_MC_GAIN_CTRL);
+	regval &= ~(AR_PHY_9485_ANT_DIV_MAIN_LNACONF |
+		    AR_PHY_9485_ANT_DIV_ALT_LNACONF |
+		    AR_PHY_9485_ANT_FAST_DIV_BIAS |
+		    AR_PHY_9485_ANT_DIV_MAIN_GAINTB |
+		    AR_PHY_9485_ANT_DIV_ALT_GAINTB);
+	regval |= ((antconf->main_lna_conf <<
+					AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S)
+		   & AR_PHY_9485_ANT_DIV_MAIN_LNACONF);
+	regval |= ((antconf->alt_lna_conf << AR_PHY_9485_ANT_DIV_ALT_LNACONF_S)
+		   & AR_PHY_9485_ANT_DIV_ALT_LNACONF);
+	regval |= ((antconf->fast_div_bias << AR_PHY_9485_ANT_FAST_DIV_BIAS_S)
+		   & AR_PHY_9485_ANT_FAST_DIV_BIAS);
+	regval |= ((antconf->main_gaintb << AR_PHY_9485_ANT_DIV_MAIN_GAINTB_S)
+		   & AR_PHY_9485_ANT_DIV_MAIN_GAINTB);
+	regval |= ((antconf->alt_gaintb << AR_PHY_9485_ANT_DIV_ALT_GAINTB_S)
+		   & AR_PHY_9485_ANT_DIV_ALT_GAINTB);
+
+	REG_WRITE(ah, AR_PHY_MC_GAIN_CTRL, regval);
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 	static const u32 ar9300_cca_regs[6] = {
 		AR_PHY_CCA_0,
 		AR_PHY_CCA_1,
@@ -1213,6 +1254,9 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->ani_cache_ini_regs = ar9003_hw_ani_cache_ini_regs;
 	priv_ops->set_radar_params = ar9003_hw_set_radar_params;
 
+	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
+	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
+
 	ar9003_hw_set_nf_limits(ah);
 	ar9003_hw_set_radar_conf(ah);
 	memcpy(ah->nf_regs, ar9300_cca_regs, sizeof(ah->nf_regs));
-- 
1.7.0.4

