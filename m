Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3291 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1JTIwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 04:52:12 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k_hw: Fix regression of register offset for AR9003 chips
Date: Thu, 20 Oct 2011 14:22:43 +0530
Message-ID: <1319100763-9081-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111020_105216_964996_FBABC6DC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My recent commits (3782c69d, 324c74a) introduced regression
for register offset selection that based on the macversion.
Not using parentheses in proper manner for ternary operator
leads to select wrong offset for the registers.

This issue was observed with AR9462 chip that immediate disconnect
after the association with the following message

ieee80211 phy3: wlan0: Failed to send nullfunc to AP 00:23:69:12:ea:47
after 500ms, disconnecting.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 2f4023e..70e0103 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -572,14 +572,14 @@
 
 #define AR_PHY_TXGAIN_TABLE      (AR_SM_BASE + 0x300)
 
-#define AR_PHY_TX_IQCAL_CONTROL_0   (AR_SM_BASE + AR_SREV_9485(ah) ? \
-						 0x3c4 : 0x444)
-#define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + AR_SREV_9485(ah) ? \
-						 0x3c8 : 0x448)
-#define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + AR_SREV_9485(ah) ? \
-						 0x3c4 : 0x440)
-#define AR_PHY_TX_IQCAL_STATUS_B0   (AR_SM_BASE + AR_SREV_9485(ah) ? \
-						 0x3f0 : 0x48c)
+#define AR_PHY_TX_IQCAL_CONTROL_0   (AR_SM_BASE + (AR_SREV_9485(ah) ? \
+						 0x3c4 : 0x444))
+#define AR_PHY_TX_IQCAL_CONTROL_1   (AR_SM_BASE + (AR_SREV_9485(ah) ? \
+						 0x3c8 : 0x448))
+#define AR_PHY_TX_IQCAL_START       (AR_SM_BASE + (AR_SREV_9485(ah) ? \
+						 0x3c4 : 0x440))
+#define AR_PHY_TX_IQCAL_STATUS_B0   (AR_SM_BASE + (AR_SREV_9485(ah) ? \
+						 0x3f0 : 0x48c))
 #define AR_PHY_TX_IQCAL_CORR_COEFF_B0(_i)    (AR_SM_BASE + \
 					     (AR_SREV_9485(ah) ? \
 					      0x3d0 : 0x450) + ((_i) << 2))
@@ -931,10 +931,10 @@
 #define AR_PHY_AIC_SRAM_ADDR_B1	(AR_SM1_BASE + 0x5f0)
 #define AR_PHY_AIC_SRAM_DATA_B1	(AR_SM1_BASE + 0x5f4)
 
-#define AR_PHY_RTT_TABLE_SW_INTF_B(i)	(0x384 + (i) ? \
-					AR_SM1_BASE : AR_SM_BASE)
-#define AR_PHY_RTT_TABLE_SW_INTF_1_B(i)	(0x388 + (i) ? \
-					AR_SM1_BASE : AR_SM_BASE)
+#define AR_PHY_RTT_TABLE_SW_INTF_B(i)	(0x384 + ((i) ? \
+					AR_SM1_BASE : AR_SM_BASE))
+#define AR_PHY_RTT_TABLE_SW_INTF_1_B(i)	(0x388 + ((i) ? \
+					AR_SM1_BASE : AR_SM_BASE))
 /*
  * Channel 2 Register Map
  */
-- 
1.7.7

