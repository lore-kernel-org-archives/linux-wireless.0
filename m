Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34630 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab0G2M5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 08:57:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 05:57:10 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k_hw: Add functions to get/set antenna diversity configuration
Date: Thu, 29 Jul 2010 05:56:58 -0700
Message-ID: <1280408219-5293-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1280408219-5293-1-git-send-email-vasanth@atheros.com>
References: <1280408219-5293-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   39 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.h |    2 +
 drivers/net/wireless/ath/ath9k/hw-ops.h     |   14 +++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |   10 +++++++
 4 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 4922b8d..f12aab2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -513,9 +513,43 @@ static void ar9002_hw_set_nf_limits(struct ath_hw *ah)
 	}
 }
 
+static void ar9002_hw_ant_div_comb_conf_get(struct ath_hw *ah,
+					    struct ath_hw_antcomb_conf *antconf)
+{
+	u32 regval;
+
+	regval = REG_READ(ah, AR_PHY_MULTICHAIN_GAIN_CTL);
+	antconf->main_lna_conf = (regval & AR_PHY_9285_ANT_DIV_MAIN_LNACONF) >>
+				  AR_PHY_9285_ANT_DIV_MAIN_LNACONF_S;
+	antconf->alt_lna_conf = (regval & AR_PHY_9285_ANT_DIV_ALT_LNACONF) >>
+				 AR_PHY_9285_ANT_DIV_ALT_LNACONF_S;
+	antconf->fast_div_bias = (regval & AR_PHY_9285_FAST_DIV_BIAS) >>
+				  AR_PHY_9285_FAST_DIV_BIAS_S;
+}
+
+static void ar9002_hw_ant_div_comb_conf_set(struct ath_hw *ah,
+					    struct ath_hw_antcomb_conf *antconf)
+{
+	u32 regval;
+
+	regval = REG_READ(ah, AR_PHY_MULTICHAIN_GAIN_CTL);
+	regval &= ~(AR_PHY_9285_ANT_DIV_MAIN_LNACONF |
+		    AR_PHY_9285_ANT_DIV_ALT_LNACONF |
+		    AR_PHY_9285_FAST_DIV_BIAS);
+	regval |= ((antconf->main_lna_conf << AR_PHY_9285_ANT_DIV_MAIN_LNACONF_S)
+		   & AR_PHY_9285_ANT_DIV_MAIN_LNACONF);
+	regval |= ((antconf->alt_lna_conf << AR_PHY_9285_ANT_DIV_ALT_LNACONF_S)
+		   & AR_PHY_9285_ANT_DIV_ALT_LNACONF);
+	regval |= ((antconf->fast_div_bias << AR_PHY_9285_FAST_DIV_BIAS_S)
+		   & AR_PHY_9285_FAST_DIV_BIAS);
+
+	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
+}
+
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
 	priv_ops->set_rf_regs = NULL;
 	priv_ops->rf_alloc_ext_banks = NULL;
@@ -526,5 +560,10 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->compute_pll_control = ar9002_hw_compute_pll_control;
 	priv_ops->do_getnf = ar9002_hw_do_getnf;
 
+	if (AR_SREV_9285(ah)) {
+		ops->ant_div_comb_conf_get = ar9002_hw_ant_div_comb_conf_get;
+		ops->ant_div_comb_conf_set = ar9002_hw_ant_div_comb_conf_set;
+	}
+
 	ar9002_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index c5151a4..37663db 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -302,6 +302,8 @@
 #define AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE 0x80000000
 
 #define AR_PHY_MULTICHAIN_GAIN_CTL          0x99ac
+#define AR_PHY_9285_FAST_DIV_BIAS	    0x00007E00
+#define AR_PHY_9285_FAST_DIV_BIAS_S	    9
 #define AR_PHY_9285_ANT_DIV_CTL_ALL         0x7f000000
 #define AR_PHY_9285_ANT_DIV_CTL             0x01000000
 #define AR_PHY_9285_ANT_DIV_CTL_S           24
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index ffecbad..7d84b7f 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -139,6 +139,20 @@ static inline void ath9k_hw_ani_monitor(struct ath_hw *ah,
 	ath9k_hw_ops(ah)->ani_monitor(ah, chan);
 }
 
+static inline void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+					struct ath_hw_antcomb_conf *antconf)
+{
+	if (ath9k_hw_ops(ah)->ant_div_comb_conf_get)
+		ath9k_hw_ops(ah)->ant_div_comb_conf_get(ah, antconf);
+}
+
+static inline void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+					struct ath_hw_antcomb_conf *antconf)
+{
+	if (ath9k_hw_ops(ah)->ant_div_comb_conf_set)
+		ath9k_hw_ops(ah)->ant_div_comb_conf_set(ah, antconf);
+}
+
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3f19148..4663557 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -489,6 +489,12 @@ struct ath_gen_timer_table {
 	} timer_mask;
 };
 
+struct ath_hw_antcomb_conf {
+	u8 main_lna_conf;
+	u8 alt_lna_conf;
+	u8 fast_div_bias;
+};
+
 /**
  * struct ath_hw_private_ops - callbacks used internally by hardware code
  *
@@ -627,6 +633,10 @@ struct ath_hw_ops {
 
 	void (*ani_proc_mib_event)(struct ath_hw *ah);
 	void (*ani_monitor)(struct ath_hw *ah, struct ath9k_channel *chan);
+	void (*ant_div_comb_conf_get)(struct ath_hw *ah,
+				      struct ath_hw_antcomb_conf *antconf);
+	void (*ant_div_comb_conf_set)(struct ath_hw *ah,
+				      struct ath_hw_antcomb_conf *antconf);
 };
 
 struct ath_nf_limits {
-- 
1.7.0.4

