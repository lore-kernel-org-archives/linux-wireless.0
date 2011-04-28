Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64851 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760509Ab1D1OXl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 10:23:41 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 07:23:14 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>, <lrodriguez@atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC/RFT 5/9] ath9k_hw: define modules to get/set Antenna diversity paramaters
Date: Thu, 28 Apr 2011 19:52:55 +0530
Message-ID: <1304000579-5784-6-git-send-email-mshajakhan@atheros.com> (sfid-20110428_162344_023805_8D1BA5D4)
In-Reply-To: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

these are the two important modules that will be called by the antenna
diversity algorithm module in the rx. this will continuosly configure
the hardware based on the current diversity status obtained
from the algorithm

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   42 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    4 ++
 3 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index c1264d6..e2ed2a1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -520,6 +520,8 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 	ops->clr11n_aggr = ar9003_hw_clr11n_aggr;
 	ops->set11n_burstduration = ar9003_hw_set11n_burstduration;
 	ops->set_clrdmask = ar9003_hw_set_clrdmask;
+	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
+	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
 }
 
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index c83be2d..8f580cd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1335,3 +1335,45 @@ void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah)
 		"==== BB update: done ====\n\n");
 }
 EXPORT_SYMBOL(ar9003_hw_bb_watchdog_dbg_info);
+
+void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
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
+EXPORT_SYMBOL(ar9003_hw_antdiv_comb_conf_get);
+
+void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
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
+EXPORT_SYMBOL(ar9003_hw_antdiv_comb_conf_set);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 096f75b..7035f2d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -984,6 +984,10 @@ void ar9002_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				struct ath_hw_antcomb_conf *antconf);
 void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 				struct ath_hw_antcomb_conf *antconf);
+void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+				struct ath_hw_antcomb_conf *antconf);
+void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+				struct ath_hw_antcomb_conf *antconf);
 
 /*
  * Code specific to AR9003, we stuff these here to avoid callbacks
-- 
1.7.0.4

