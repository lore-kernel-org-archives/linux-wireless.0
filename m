Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30991 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab1EMPBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:01:04 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:00:35 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 6/9] ath9k_hw: define antenna diversity group
Date: Fri, 13 May 2011 20:30:56 +0530
Message-ID: <1305298856-3504-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_170109_546824_6C54F32D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

AR9285 belongs to diversity group 0 and AR9485 belongs to diversity
group 2. Based on the diversity group we configure certain antenna
diversity paramaters such as lna1_lna2_delta and fast diversity
bias values. For AR9485 we have some gain table parameter which
selects the gain table 0/1 for main and alternate antenna

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    2 ++
 drivers/net/wireless/ath/ath9k/ath9k.h      |    1 -
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 drivers/net/wireless/ath/ath9k/recv.c       |    2 +-
 5 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index b4a0c1d..a57e963 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -529,6 +529,8 @@ static void ar9002_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				 AR_PHY_9285_ANT_DIV_ALT_LNACONF_S;
 	antconf->fast_div_bias = (regval & AR_PHY_9285_FAST_DIV_BIAS) >>
 				  AR_PHY_9285_FAST_DIV_BIAS_S;
+	antconf->lna1_lna2_delta = -3;
+	antconf->div_group = 0;
 }
 
 static void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index d2a5d27..25f3c2f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1196,6 +1196,8 @@ static void ar9003_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				 AR_PHY_9485_ANT_DIV_ALT_LNACONF_S;
 	antconf->fast_div_bias = (regval & AR_PHY_9485_ANT_FAST_DIV_BIAS) >>
 				  AR_PHY_9485_ANT_FAST_DIV_BIAS_S;
+	antconf->lna1_lna2_delta = -9;
+	antconf->div_group = 2;
 }
 
 static void ar9003_hw_antdiv_comb_conf_set(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f2f672b..03b37d7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -483,7 +483,6 @@ static inline void ath_deinit_leds(struct ath_softc *sc)
 #define ATH_ANT_DIV_COMB_ALT_ANT_RATIO 30
 #define ATH_ANT_DIV_COMB_ALT_ANT_RATIO2 20
 
-#define ATH_ANT_DIV_COMB_LNA1_LNA2_DELTA -3
 #define ATH_ANT_DIV_COMB_LNA1_LNA2_SWITCH_DELTA -1
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_HI -4
 #define ATH_ANT_DIV_COMB_LNA1_DELTA_MID -2
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 80f512d..7af2773 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -482,6 +482,7 @@ struct ath_hw_antcomb_conf {
 	u8 main_gaintb;
 	u8 alt_gaintb;
 	int lna1_lna2_delta;
+	u8 div_group;
 };
 
 /**
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 9fcd1e4..85e0532 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1442,7 +1442,7 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 		}
 
 		if ((alt_rssi_avg < (main_rssi_avg +
-		    ATH_ANT_DIV_COMB_LNA1_LNA2_DELTA)))
+						div_ant_conf.lna1_lna2_delta)))
 			goto div_comb_done;
 	}
 
-- 
1.7.0.4

