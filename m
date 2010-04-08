Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 063/102] ath9k_hw: abstract the AR_PHY_AGC_CONTROL register access
Date: Thu,  8 Apr 2010 15:26:59 -0400
Message-Id: <1270754858-26266-64-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is so we can share routines which access this register
on calib.c

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.h |    7 -------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   13 -------------
 drivers/net/wireless/ath/ath9k/reg.h        |   15 +++++++++++++++
 3 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index 9864f9e..65510ab 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -120,13 +120,6 @@
 #define AR_PHY_AGC_CTL1_COARSE_HIGH      0x003F8000
 #define AR_PHY_AGC_CTL1_COARSE_HIGH_S    15
 
-#define AR_PHY_AGC_CONTROL               0x9860
-#define AR_PHY_AGC_CONTROL_CAL           0x00000001
-#define AR_PHY_AGC_CONTROL_NF            0x00000002
-#define AR_PHY_AGC_CONTROL_ENABLE_NF     0x00008000
-#define AR_PHY_AGC_CONTROL_FLTR_CAL      0x00010000
-#define AR_PHY_AGC_CONTROL_NO_UPDATE_NF  0x00020000
-
 #define AR_PHY_CCA                  0x9864
 #define AR_PHY_MINCCA_PWR           0x0FF80000
 #define AR_PHY_MINCCA_PWR_S         19
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 420bd3b..b9a76d3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -359,7 +359,6 @@
 #define AR_PHY_SWITCH_COM_2      AR_SM_BASE + 0x8c
 #define AR_PHY_RX_CHAINMASK      AR_SM_BASE + 0xa0
 #define AR_PHY_CAL_CHAINMASK     AR_SM_BASE + 0xc0
-#define AR_PHY_AGC_CONTROL       AR_SM_BASE + 0xc4
 #define AR_PHY_CALMODE           AR_SM_BASE + 0xc8
 #define AR_PHY_FCAL_1            AR_SM_BASE + 0xcc
 #define AR_PHY_FCAL_2_0          AR_SM_BASE + 0xd0
@@ -509,18 +508,6 @@
 #define AR_PHY_GC_ENABLE_DAC_FIFO  0x00000800  /* fifo between bb and dac */
 #define AR_PHY_RX_DELAY_DELAY      0x00003FFF  /* delay from wakeup to rx ena */
 
-#define AR_PHY_AGC_CONTROL_CAL              0x00000001  /* do internal calibration */
-#define AR_PHY_AGC_CONTROL_NF               0x00000002  /* do noise-floor calibration */
-#define AR_PHY_AGC_CONTROL_OFFSET_CAL       0x00000800  /* allow offset calibration */
-#define AR_PHY_AGC_CONTROL_ENABLE_NF        0x00008000  /* enable noise floor calibration to happen */
-#define AR_PHY_AGC_CONTROL_FLTR_CAL         0x00010000  /* allow tx filter calibration */
-#define AR_PHY_AGC_CONTROL_NO_UPDATE_NF     0x00020000  /* don't update noise floor automatically */
-#define AR_PHY_AGC_CONTROL_EXT_NF_PWR_MEAS  0x00040000  /* extend noise floor power measurement */
-#define AR_PHY_AGC_CONTROL_CLC_SUCCESS      0x00080000  /* carrier leak calibration done */
-
-#define AR_PHY_AGC_CONTROL_YCOK_MAX         0x000003c0
-#define AR_PHY_AGC_CONTROL_YCOK_MAX_S                6
-
 #define AR_PHY_CALMODE_IQ           0x00000000
 #define AR_PHY_CALMODE_ADC_GAIN     0x00000001
 #define AR_PHY_CALMODE_ADC_DC_PER   0x00000002
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 7758d99..aacc29a 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1776,4 +1776,19 @@ enum {
 						     * pcu_txsm.
 						     */
 
+#define AR9300_SM_BASE				0xa200
+#define AR9002_PHY_AGC_CONTROL			0x9860
+#define AR9003_PHY_AGC_CONTROL			AR9300_SM_BASE + 0xc4
+#define AR_PHY_AGC_CONTROL			(AR_SREV_9300_20_OR_LATER(ah) ? AR9003_PHY_AGC_CONTROL : AR9002_PHY_AGC_CONTROL)
+#define AR_PHY_AGC_CONTROL_CAL			0x00000001  /* do internal calibration */
+#define AR_PHY_AGC_CONTROL_NF			0x00000002  /* do noise-floor calibration */
+#define AR_PHY_AGC_CONTROL_OFFSET_CAL		0x00000800  /* allow offset calibration */
+#define AR_PHY_AGC_CONTROL_ENABLE_NF		0x00008000  /* enable noise floor calibration to happen */
+#define AR_PHY_AGC_CONTROL_FLTR_CAL		0x00010000  /* allow tx filter calibration */
+#define AR_PHY_AGC_CONTROL_NO_UPDATE_NF		0x00020000  /* don't update noise floor automatically */
+#define AR_PHY_AGC_CONTROL_EXT_NF_PWR_MEAS	0x00040000  /* extend noise floor power measurement */
+#define AR_PHY_AGC_CONTROL_CLC_SUCCESS		0x00080000  /* carrier leak calibration done */
+#define AR_PHY_AGC_CONTROL_YCOK_MAX		0x000003c0
+#define AR_PHY_AGC_CONTROL_YCOK_MAX_S		6
+
 #endif
-- 
1.6.3.3

