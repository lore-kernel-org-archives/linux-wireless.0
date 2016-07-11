Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56423 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030314AbcGKKCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 06:02:52 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 1/4] ath9k_hw: fix duplicate (and partially wrong) definition of AR_CH0_THERM
Date: Mon, 11 Jul 2016 12:02:45 +0200
Message-Id: <20160711100248.68678-1-nbd@nbd.name> (sfid-20160711_120450_900453_DE04181D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR_PHY_65NM_CH0_THERM and AR_CH0_THERM were supposed to refer to the
same register, however they had different SREV checks.

Remove the duplicate and use the checks. Since there were other SREV
checks present in the only place that uses this, this will probaby not
affect runtime behavior.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 566da78..a171dbb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -689,13 +689,6 @@
 #define AR_CH0_TOP_XPABIASLVL (AR_SREV_9550(ah) ? 0x3c0 : 0x300)
 #define AR_CH0_TOP_XPABIASLVL_S (AR_SREV_9550(ah) ? 6 : 8)
 
-#define AR_CH0_THERM	(AR_SREV_9300(ah) ? 0x16290 : \
-				((AR_SREV_9485(ah) ? 0x1628c : 0x16294)))
-#define AR_CH0_THERM_XPABIASLVL_MSB 0x3
-#define AR_CH0_THERM_XPABIASLVL_MSB_S 0
-#define AR_CH0_THERM_XPASHORT2GND 0x4
-#define AR_CH0_THERM_XPASHORT2GND_S 2
-
 #define AR_SWITCH_TABLE_COM_ALL (0xffff)
 #define AR_SWITCH_TABLE_COM_ALL_S (0)
 #define AR_SWITCH_TABLE_COM_AR9462_ALL (0xffffff)
@@ -712,15 +705,17 @@
 #define AR_SWITCH_TABLE_ALL (0xfff)
 #define AR_SWITCH_TABLE_ALL_S (0)
 
-#define AR_PHY_65NM_CH0_THERM       (AR_SREV_9300(ah) ? 0x16290 :\
-				     ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16294 : 0x1628c))
+#define AR_CH0_THERM       (AR_SREV_9300(ah) ? 0x16290 :\
+			    ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16294 : 0x1628c))
+#define AR_CH0_THERM_XPABIASLVL_MSB 0x3
+#define AR_CH0_THERM_XPABIASLVL_MSB_S 0
+#define AR_CH0_THERM_XPASHORT2GND 0x4
+#define AR_CH0_THERM_XPASHORT2GND_S 2
 
-#define AR_PHY_65NM_CH0_THERM_LOCAL   0x80000000
-#define AR_PHY_65NM_CH0_THERM_LOCAL_S 31
-#define AR_PHY_65NM_CH0_THERM_START   0x20000000
-#define AR_PHY_65NM_CH0_THERM_START_S 29
-#define AR_PHY_65NM_CH0_THERM_SAR_ADC_OUT   0x0000ff00
-#define AR_PHY_65NM_CH0_THERM_SAR_ADC_OUT_S 8
+#define AR_CH0_THERM_LOCAL   0x80000000
+#define AR_CH0_THERM_START   0x20000000
+#define AR_CH0_THERM_SAR_ADC_OUT   0x0000ff00
+#define AR_CH0_THERM_SAR_ADC_OUT_S 8
 
 #define AR_CH0_TOP2		(AR_SREV_9300(ah) ? 0x1628c : \
 					(AR_SREV_9462(ah) ? 0x16290 : 0x16284))
-- 
2.8.4

