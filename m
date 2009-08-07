Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32403 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZHGEPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:15:08 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:15:10 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43609.458948.110109@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:45:21 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/12] ath9k: Add macros for Antenna Diversity
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A subsequent patch would use these for configuring
antennae on AR9285.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/phy.h |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 27bd93c..5317e05 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -312,7 +312,25 @@ bool ath9k_hw_init_rf(struct ath_hw *ah,
 #define AR_PHY_NEW_ADC_DC_GAIN_CORR(_i) (0x99b4 + ((_i) << 12))
 #define AR_PHY_NEW_ADC_GAIN_CORR_ENABLE 0x40000000
 #define AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE 0x80000000
-#define AR_PHY_MULTICHAIN_GAIN_CTL  0x99ac
+
+#define AR_PHY_MULTICHAIN_GAIN_CTL          0x99ac
+#define AR_PHY_9285_ANT_DIV_CTL_ALL         0x7f000000
+#define AR_PHY_9285_ANT_DIV_CTL             0x01000000
+#define AR_PHY_9285_ANT_DIV_CTL_S           24
+#define AR_PHY_9285_ANT_DIV_ALT_LNACONF     0x06000000
+#define AR_PHY_9285_ANT_DIV_ALT_LNACONF_S   25
+#define AR_PHY_9285_ANT_DIV_MAIN_LNACONF    0x18000000
+#define AR_PHY_9285_ANT_DIV_MAIN_LNACONF_S  27
+#define AR_PHY_9285_ANT_DIV_ALT_GAINTB      0x20000000
+#define AR_PHY_9285_ANT_DIV_ALT_GAINTB_S    29
+#define AR_PHY_9285_ANT_DIV_MAIN_GAINTB     0x40000000
+#define AR_PHY_9285_ANT_DIV_MAIN_GAINTB_S   30
+#define AR_PHY_9285_ANT_DIV_LNA1            2
+#define AR_PHY_9285_ANT_DIV_LNA2            1
+#define AR_PHY_9285_ANT_DIV_LNA1_PLUS_LNA2  3
+#define AR_PHY_9285_ANT_DIV_LNA1_MINUS_LNA2 0
+#define AR_PHY_9285_ANT_DIV_GAINTB_0        0
+#define AR_PHY_9285_ANT_DIV_GAINTB_1        1
 
 #define AR_PHY_EXT_CCA0             0x99b8
 #define AR_PHY_EXT_CCA0_THRESH62    0x000000FF
-- 
1.6.4

