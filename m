Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30949 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759068Ab1EMPAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:00:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 07:59:46 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 3/9] ath9k_hw: define registers/macros to support Antenna diversity
Date: Fri, 13 May 2011 20:29:53 +0530
Message-ID: <1305298793-3383-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_170019_239226_816D9343)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

define few registers and macros to configure/enable Antenna diversity
parameters in AR9485

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    3 +++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 2a0d5cb..c7505b4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -261,12 +261,34 @@
 #define AR_PHY_EXT_CCA0         (AR_AGC_BASE + 0x20)
 #define AR_PHY_RESTART          (AR_AGC_BASE + 0x24)
 
+/*
+ * Antenna Diversity  settings
+ */
 #define AR_PHY_MC_GAIN_CTRL     (AR_AGC_BASE + 0x28)
 #define AR_ANT_DIV_CTRL_ALL	0x7e000000
 #define AR_ANT_DIV_CTRL_ALL_S	25
 #define AR_ANT_DIV_ENABLE	0x1000000
 #define AR_ANT_DIV_ENABLE_S	24
 
+
+#define AR_PHY_9485_ANT_FAST_DIV_BIAS			0x00007e00
+#define AR_PHY_9485_ANT_FAST_DIV_BIAS_S                  9
+#define AR_PHY_9485_ANT_DIV_LNADIV			0x01000000
+#define AR_PHY_9485_ANT_DIV_LNADIV_S			24
+#define AR_PHY_9485_ANT_DIV_ALT_LNACONF			0x06000000
+#define AR_PHY_9485_ANT_DIV_ALT_LNACONF_S		25
+#define AR_PHY_9485_ANT_DIV_MAIN_LNACONF		0x18000000
+#define AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S		27
+#define AR_PHY_9485_ANT_DIV_ALT_GAINTB			0x20000000
+#define AR_PHY_9485_ANT_DIV_ALT_GAINTB_S		29
+#define AR_PHY_9485_ANT_DIV_MAIN_GAINTB			0x40000000
+#define AR_PHY_9485_ANT_DIV_MAIN_GAINTB_S		30
+
+#define AR_PHY_9485_ANT_DIV_LNA1_MINUS_LNA2		0x0
+#define AR_PHY_9485_ANT_DIV_LNA2			0x1
+#define AR_PHY_9485_ANT_DIV_LNA1			0x2
+#define AR_PHY_9485_ANT_DIV_LNA1_PLUS_LNA2		0x3
+
 #define AR_PHY_EXTCHN_PWRTHR1   (AR_AGC_BASE + 0x2c)
 #define AR_PHY_EXT_CHN_WIN      (AR_AGC_BASE + 0x30)
 #define AR_PHY_20_40_DET_THR    (AR_AGC_BASE + 0x34)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 67cca10..80f512d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -479,6 +479,9 @@ struct ath_hw_antcomb_conf {
 	u8 main_lna_conf;
 	u8 alt_lna_conf;
 	u8 fast_div_bias;
+	u8 main_gaintb;
+	u8 alt_gaintb;
+	int lna1_lna2_delta;
 };
 
 /**
-- 
1.7.0.4

