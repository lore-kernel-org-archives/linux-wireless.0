Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42842 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaLKBvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 20:51:48 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/4] ath9k: Fix register definitions for QCA956x
Date: Thu, 11 Dec 2014 07:23:39 +0530
Message-Id: <1418262820-24856-4-git-send-email-sujith@msujith.org> (sfid-20141211_025150_767067_6C4E0227)
In-Reply-To: <1418262820-24856-1-git-send-email-sujith@msujith.org>
References: <1418262820-24856-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index fd090b1..c311b2b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -454,7 +454,7 @@
 #define AR_PHY_GEN_CTRL          (AR_SM_BASE + 0x4)
 #define AR_PHY_MODE              (AR_SM_BASE + 0x8)
 #define AR_PHY_ACTIVE            (AR_SM_BASE + 0xc)
-#define AR_PHY_SPUR_MASK_A       (AR_SM_BASE + 0x20)
+#define AR_PHY_SPUR_MASK_A       (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x18 : 0x20))
 #define AR_PHY_SPUR_MASK_B       (AR_SM_BASE + 0x24)
 #define AR_PHY_SPECTRAL_SCAN     (AR_SM_BASE + 0x28)
 #define AR_PHY_RADAR_BW_FILTER   (AR_SM_BASE + 0x2c)
@@ -506,7 +506,7 @@
 #define AR_PHY_TEST_CHAIN_SEL      0xC0000000
 #define AR_PHY_TEST_CHAIN_SEL_S    30
 
-#define AR_PHY_TEST_CTL_STATUS   (AR_SM_BASE + 0x164)
+#define AR_PHY_TEST_CTL_STATUS   (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x160 : 0x164))
 #define AR_PHY_TEST_CTL_TSTDAC_EN         0x1
 #define AR_PHY_TEST_CTL_TSTDAC_EN_S       0
 #define AR_PHY_TEST_CTL_TX_OBS_SEL        0x1C
@@ -525,7 +525,7 @@
 
 #define AR_PHY_CHAN_STATUS       (AR_SM_BASE + 0x16c)
 
-#define AR_PHY_CHAN_INFO_MEMORY				(AR_SM_BASE + 0x170)
+#define AR_PHY_CHAN_INFO_MEMORY (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x16c : 0x170))
 #define AR_PHY_CHAN_INFO_MEMORY_CHANINFOMEM_S2_READ	0x00000008
 #define AR_PHY_CHAN_INFO_MEMORY_CHANINFOMEM_S2_READ_S	3
 
@@ -536,7 +536,7 @@
 #define AR_PHY_SCRAMBLER_SEED    (AR_SM_BASE + 0x190)
 #define AR_PHY_CCK_TX_CTRL       (AR_SM_BASE + 0x194)
 
-#define AR_PHY_HEAVYCLIP_CTL     (AR_SM_BASE + 0x1a4)
+#define AR_PHY_HEAVYCLIP_CTL     (AR_SM_BASE + (AR_SREV_9561(ah) ? 0x198 : 0x1a4))
 #define AR_PHY_HEAVYCLIP_20      (AR_SM_BASE + 0x1a8)
 #define AR_PHY_HEAVYCLIP_40      (AR_SM_BASE + 0x1ac)
 #define AR_PHY_ILLEGAL_TXRATE    (AR_SM_BASE + 0x1b0)
@@ -726,21 +726,24 @@
 
 #define AR_CH0_TOP2		(AR_SREV_9300(ah) ? 0x1628c : \
 					(AR_SREV_9462(ah) ? 0x16290 : 0x16284))
-#define AR_CH0_TOP2_XPABIASLVL		0xf000
+#define AR_CH0_TOP2_XPABIASLVL		(AR_SREV_9561(ah) ? 0x1e00 : 0xf000)
 #define AR_CH0_TOP2_XPABIASLVL_S	12
 
 #define AR_CH0_XTAL		(AR_SREV_9300(ah) ? 0x16294 : \
-				 ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16298 : 0x16290))
+				 ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16298 : \
+				  (AR_SREV_9561(ah) ? 0x162c0 : 0x16290)))
 #define AR_CH0_XTAL_CAPINDAC	0x7f000000
 #define AR_CH0_XTAL_CAPINDAC_S	24
 #define AR_CH0_XTAL_CAPOUTDAC	0x00fe0000
 #define AR_CH0_XTAL_CAPOUTDAC_S	17
 
-#define AR_PHY_PMU1		((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16340 : 0x16c40)
+#define AR_PHY_PMU1		((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16340 : \
+				 (AR_SREV_9561(ah) ? 0x16cc0 : 0x16c40))
 #define AR_PHY_PMU1_PWD		0x1
 #define AR_PHY_PMU1_PWD_S	0
 
-#define AR_PHY_PMU2		((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16344 : 0x16c44)
+#define AR_PHY_PMU2		((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x16344 : \
+				 (AR_SREV_9561(ah) ? 0x16cc4 : 0x16c44))
 #define AR_PHY_PMU2_PGM		0x00200000
 #define AR_PHY_PMU2_PGM_S	21
 
-- 
2.1.3

