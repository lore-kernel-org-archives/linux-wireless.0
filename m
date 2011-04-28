Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64853 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760514Ab1D1OXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 10:23:48 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 07:23:21 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>, <lrodriguez@atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC/RFT 6/9] ath9k_hw: define antenna diversity group
Date: Thu, 28 Apr 2011 19:52:56 +0530
Message-ID: <1304000579-5784-7-git-send-email-mshajakhan@atheros.com> (sfid-20110428_162350_936033_5D95C383)
In-Reply-To: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

AR9285 belongs to diversity group 0 and AR9485 belongs to diversity
group 2. Based on the diversity group we configure certain antenna
diversity paramaters such as lna1_lna2_delta and fast diversity
bias values. For AR9485 we have some gain table paramter which
selects the gain table 0/1 for main and alternate antenna

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    2 ++
 drivers/net/wireless/ath/ath9k/ath9k.h      |    1 -
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 drivers/net/wireless/ath/ath9k/recv.c       |    2 +-
 5 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index aa2d08a..ff32864 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -545,6 +545,8 @@ void ar9002_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				 AR_PHY_9285_ANT_DIV_ALT_LNACONF_S;
 	antconf->fast_div_bias = (regval & AR_PHY_9285_FAST_DIV_BIAS) >>
 				  AR_PHY_9285_FAST_DIV_BIAS_S;
+	antconf->lna1_lna2_delta = -3;
+	antconf->div_group = 0;
 }
 EXPORT_SYMBOL(ar9002_hw_antdiv_comb_conf_get);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 8f580cd..1c6c9ac 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1348,6 +1348,8 @@ void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				 AR_PHY_9485_ANT_DIV_ALT_LNACONF_S;
 	antconf->fast_div_bias = (regval & AR_PHY_9485_ANT_FAST_DIV_BIAS) >>
 				  AR_PHY_9485_ANT_FAST_DIV_BIAS_S;
+	antconf->lna1_lna2_delta = -9;
+	antconf->div_group = 2;
 }
 EXPORT_SYMBOL(ar9003_hw_antdiv_comb_conf_get);
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0312aa0..3e7f4a4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -484,7 +484,6 @@ static inline void ath_deinit_leds(struct ath_softc *sc)
 #define ATH_ANT_DIV_COMB_ALT_ANT_RATIO 30
 #define ATH_ANT_DIV_COMB_ALT_ANT_RATIO2 20
 
-#define ATH_ANT_DIV_COMB_LNA1_LNA2_DELTA -3
 #define ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA -1
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_HI -4
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_MID -2
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7035f2d..8603b9f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -479,6 +479,7 @@ struct ath_hw_antcomb_conf {
 	u8 main_gaintb;
 	u8 alt_gaintb;
 	int lna1_lna2_delta;
+	u8 div_group;
 };
 
 /**
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c5b7cbe..53ff570 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1440,7 +1440,7 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 		}
 
 		if ((alt_rssi_avg < (main_rssi_avg +
-		    ATH_ANT_DIV_COMB_LNA1_LNA2_DELTA)))
+						div_ant_conf.lna1_lna2_delta)))
 			goto div_comb_done;
 	}
 
-- 
1.7.0.4

