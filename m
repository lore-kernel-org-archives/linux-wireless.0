Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21539 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0IBIey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 04:34:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Sep 2010 01:34:49 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k_hw: Add functions to get/set antenna diversity configuration
Date: Thu, 2 Sep 2010 01:34:42 -0700
Message-ID: <1283416483-5674-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1283416483-5674-1-git-send-email-vasanth@atheros.com>
References: <1283416483-5674-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   35 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.h |    2 +
 drivers/net/wireless/ath/ath9k/hw.h         |   10 +++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index adbf031..cd56c86 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -530,3 +530,38 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 
 	ar9002_hw_set_nf_limits(ah);
 }
+
+void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+				   struct ath_hw_antcomb_conf *antconf)
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
+EXPORT_SYMBOL(ath9k_hw_antdiv_comb_conf_get);
+
+void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+				   struct ath_hw_antcomb_conf *antconf)
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
+EXPORT_SYMBOL(ath9k_hw_antdiv_comb_conf_set);
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
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1a0efbd..197c717 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -496,6 +496,12 @@ struct ath_gen_timer_table {
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
@@ -889,6 +895,10 @@ void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
 u32 ath9k_hw_getdefantenna(struct ath_hw *ah);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
+void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+				   struct ath_hw_antcomb_conf *antconf);
+void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+				   struct ath_hw_antcomb_conf *antconf);
 
 /* General Operation */
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
-- 
1.7.0.4

