Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64845 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760422Ab1D1OXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 10:23:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 07:23:03 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>, <lrodriguez@atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC/RFT 3/9] ath9k_hw: define registers/macros to support Antenna diversity
Date: Thu, 28 Apr 2011 19:52:53 +0530
Message-ID: <1304000579-5784-4-git-send-email-mshajakhan@atheros.com> (sfid-20110428_162333_134892_340A87D6)
In-Reply-To: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

define few registers and macros to configure/enable Antenna diversity
parameters in AR9485

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   31 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h         |    3 ++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 2a0d5cb..c4f409f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -245,6 +245,9 @@
  */
 #define AR_BBB_BASE	0x9d00
 
+#define AR_BBB_SIG_DETECT_ANT_FAST_DIV			0x00002000
+#define AR_BBB_SIG_DETECT_ANT_FAST_DIV_S		13
+
 /*
  * AGC Register Map
  */
@@ -261,12 +264,37 @@
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
 
+#define AR_PHY_CCK_DETECT       (AR_AGC_BASE + 0x1c0)
+#define AR_FAST_DIV_ENABLE	0x2000
+#define AR_FAST_DIV_ENABLE_S	13
+
+#define AR_PHY_9485_ANT_FAST_DIV_BIAS			0x00007e00
+#define AR_PHY_9485_ANT_DIV_LNADIV			0x01000000
+#define AR_PHY_9485_ANT_DIV_ALT_LNACONF			0x06000000
+#define AR_PHY_9485_ANT_DIV_MAIN_LNACONF		0x18000000
+#define AR_PHY_9485_ANT_DIV_ALT_GAINTB			0x20000000
+#define AR_PHY_9485_ANT_DIV_MAIN_GAINTB			0x40000000
+#define AR_PHY_9485_ANT_DIV_LNADIV_S			24
+#define AR_PHY_9485_ANT_DIV_ALT_LNACONF_S		25
+#define AR_PHY_9485_ANT_DIV_MAIN_LNACONF_S		27
+#define AR_PHY_9485_ANT_DIV_ALT_GAINTB_S		29
+#define AR_PHY_9485_ANT_DIV_MAIN_GAINTB_S		30
+#define AR_PHY_9485_ANT_FAST_DIV_BIAS_S                  9
+
+#define AR_PHY_9485_ANT_DIV_LNA1_MINUS_LNA2		0x0
+#define AR_PHY_9485_ANT_DIV_LNA2			0x1
+#define AR_PHY_9485_ANT_DIV_LNA1			0x2
+#define AR_PHY_9485_ANT_DIV_LNA1_PLUS_LNA2		0x3
+
 #define AR_PHY_EXTCHN_PWRTHR1   (AR_AGC_BASE + 0x2c)
 #define AR_PHY_EXT_CHN_WIN      (AR_AGC_BASE + 0x30)
 #define AR_PHY_20_40_DET_THR    (AR_AGC_BASE + 0x34)
@@ -278,9 +306,6 @@
 #define AR_PHY_RSSI_0           (AR_AGC_BASE + 0x180)
 #define AR_PHY_SPUR_CCK_REP0    (AR_AGC_BASE + 0x184)
 
-#define AR_PHY_CCK_DETECT       (AR_AGC_BASE + 0x1c0)
-#define AR_FAST_DIV_ENABLE	0x2000
-#define AR_FAST_DIV_ENABLE_S	13
 
 #define AR_PHY_DAG_CTRLCCK      (AR_AGC_BASE + 0x1c4)
 #define AR_PHY_IQCORR_CTRL_CCK  (AR_AGC_BASE + 0x1c8)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 48420df..096f75b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -476,6 +476,9 @@ struct ath_hw_antcomb_conf {
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

