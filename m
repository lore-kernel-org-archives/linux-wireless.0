Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17470 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbGOHyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2015 03:54:14 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 1/2] ath9k: Fix register definitions for QCA956x
Date: Wed, 15 Jul 2015 15:54:06 +0800
Message-ID: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150715_095418_156327_5BDB5BF0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index fc595b9..c5f8bc4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -455,7 +455,7 @@
 #define AR_PHY_MODE              (AR_SM_BASE + 0x8)
 #define AR_PHY_ACTIVE            (AR_SM_BASE + 0xc)
 #define AR_PHY_SPUR_MASK_A       (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x18 : 0x20))
-#define AR_PHY_SPUR_MASK_B       (AR_SM_BASE + 0x24)
+#define AR_PHY_SPUR_MASK_B       (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x1c : 0x24))
 #define AR_PHY_SPECTRAL_SCAN     (AR_SM_BASE + 0x28)
 #define AR_PHY_RADAR_BW_FILTER   (AR_SM_BASE + 0x2c)
 #define AR_PHY_SEARCH_START_DELAY (AR_SM_BASE + 0x30)
@@ -495,7 +495,7 @@
 #define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A                       0x3FF
 #define AR_PHY_SPUR_MASK_A_CF_PUNC_MASK_A_S                     0
 
-#define AR_PHY_TEST              (AR_SM_BASE + 0x160)
+#define AR_PHY_TEST              (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x15c : 0x160))
 
 #define AR_PHY_TEST_BBB_OBS_SEL       0x780000
 #define AR_PHY_TEST_BBB_OBS_SEL_S     19
@@ -521,24 +521,29 @@
 #define AR_PHY_TEST_CTL_DEBUGPORT_SEL_S	  29
 
 
-#define AR_PHY_TSTDAC            (AR_SM_BASE + 0x168)
+#define AR_PHY_TSTDAC            (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x164 : 0x168))
 
-#define AR_PHY_CHAN_STATUS       (AR_SM_BASE + 0x16c)
+#define AR_PHY_CHAN_STATUS       (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x168 : 0x16c))
 
 #define AR_PHY_CHAN_INFO_MEMORY (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x16c : 0x170))
 #define AR_PHY_CHAN_INFO_MEMORY_CHANINFOMEM_S2_READ	0x00000008
 #define AR_PHY_CHAN_INFO_MEMORY_CHANINFOMEM_S2_READ_S	3
 
-#define AR_PHY_CHNINFO_NOISEPWR  (AR_SM_BASE + 0x174)
-#define AR_PHY_CHNINFO_GAINDIFF  (AR_SM_BASE + 0x178)
-#define AR_PHY_CHNINFO_FINETIM   (AR_SM_BASE + 0x17c)
-#define AR_PHY_CHAN_INFO_GAIN_0  (AR_SM_BASE + 0x180)
-#define AR_PHY_SCRAMBLER_SEED    (AR_SM_BASE + 0x190)
-#define AR_PHY_CCK_TX_CTRL       (AR_SM_BASE + 0x194)
+#define AR_PHY_CHNINFO_NOISEPWR  (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x170 : 0x174))
+#define AR_PHY_CHNINFO_GAINDIFF  (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x174 : 0x178))
+#define AR_PHY_CHNINFO_FINETIM   (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x178 : 0x17c))
+#define AR_PHY_CHAN_INFO_GAIN_0  (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x17c : 0x180))
+#define AR_PHY_SCRAMBLER_SEED    (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x184 : 0x190))
+#define AR_PHY_CCK_TX_CTRL       (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x188 : 0x194))
 
 #define AR_PHY_HEAVYCLIP_CTL     (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x198 : 0x1a4))
 #define AR_PHY_HEAVYCLIP_20      (AR_SM_BASE + 0x1a8)
 #define AR_PHY_HEAVYCLIP_40      (AR_SM_BASE + 0x1ac)
+#define AR_PHY_HEAVYCLIP_1	 (AR_SM_BASE + 0x19c)
+#define AR_PHY_HEAVYCLIP_2	 (AR_SM_BASE + 0x1a0)
+#define AR_PHY_HEAVYCLIP_3	 (AR_SM_BASE + 0x1a4)
+#define AR_PHY_HEAVYCLIP_4	 (AR_SM_BASE + 0x1a8)
+#define AR_PHY_HEAVYCLIP_5	 (AR_SM_BASE + 0x1ac)
 #define AR_PHY_ILLEGAL_TXRATE    (AR_SM_BASE + 0x1b0)
 
 #define AR_PHY_POWER_TX_RATE(_d) (AR_SM_BASE + 0x1c0 + ((_d) << 2))
-- 
1.9.1

