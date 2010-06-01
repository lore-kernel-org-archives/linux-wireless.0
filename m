Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42262 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0FAKNs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 06:13:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 03:13:48 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19460.56738.25970.883414@gargle.gargle.HOWL>
Date: Tue, 1 Jun 2010 15:44:58 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/13] ath9k_hw: Update the PCI WAR register
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates the PCI power save handling
code, fixing ASPM hangs and handling device state D3
properly.

The WAR register is programmed with the correct
values now.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |   85 +++++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/reg.h       |    3 +
 2 files changed, 60 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index a8a8cdc..748449c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -436,55 +436,84 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 		}
 
 		udelay(1000);
+	}
 
-		/* set bit 19 to allow forcing of pcie core into L1 state */
-		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
+	if (power_off) {
+		/* clear bit 19 to disable L1 */
+		REG_CLR_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
+
+		val = REG_READ(ah, AR_WA);
 
-		/* Several PCIe massages to ensure proper behaviour */
+		/*
+		 * Set PCIe workaround bits
+		 * In AR9280 and AR9285, bit 14 in WA register (disable L1)
+		 * should only  be set when device enters D3 and be
+		 * cleared when device comes back to D0.
+		 */
+		if (ah->config.pcie_waen) {
+			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
+				val |= AR_WA_D3_L1_DISABLE;
+		} else {
+			if (((AR_SREV_9285(ah) ||
+			      AR_SREV_9271(ah) ||
+			      AR_SREV_9287(ah)) &&
+			     (AR9285_WA_DEFAULT & AR_WA_D3_L1_DISABLE)) ||
+			    (AR_SREV_9280(ah) &&
+			     (AR9280_WA_DEFAULT & AR_WA_D3_L1_DISABLE))) {
+				val |= AR_WA_D3_L1_DISABLE;
+			}
+		}
+
+		if (AR_SREV_9280(ah) || AR_SREV_9285(ah) || AR_SREV_9287(ah)) {
+			/*
+			 * Disable bit 6 and 7 before entering D3 to
+			 * prevent system hang.
+			 */
+			val &= ~(AR_WA_BIT6 | AR_WA_BIT7);
+		}
+
+		if (AR_SREV_9285E_20(ah))
+			val |= AR_WA_BIT23;
+
+		REG_WRITE(ah, AR_WA, val);
+	} else {
 		if (ah->config.pcie_waen) {
 			val = ah->config.pcie_waen;
 			if (!power_off)
 				val &= (~AR_WA_D3_L1_DISABLE);
 		} else {
-			if (AR_SREV_9285(ah) || AR_SREV_9271(ah) ||
+			if (AR_SREV_9285(ah) ||
+			    AR_SREV_9271(ah) ||
 			    AR_SREV_9287(ah)) {
 				val = AR9285_WA_DEFAULT;
 				if (!power_off)
 					val &= (~AR_WA_D3_L1_DISABLE);
-			} else if (AR_SREV_9280(ah)) {
+			}
+			else if (AR_SREV_9280(ah)) {
 				/*
-				 * On AR9280 chips bit 22 of 0x4004 needs to be
-				 * set otherwise card may disappear.
+				 * For AR9280 chips, bit 22 of 0x4004
+				 * needs to be set.
 				 */
 				val = AR9280_WA_DEFAULT;
 				if (!power_off)
 					val &= (~AR_WA_D3_L1_DISABLE);
-			} else
+			} else {
 				val = AR_WA_DEFAULT;
+			}
+		}
+
+		/* WAR for ASPM system hang */
+		if (AR_SREV_9280(ah) || AR_SREV_9285(ah) || AR_SREV_9287(ah)) {
+			val |= (AR_WA_BIT6 | AR_WA_BIT7);
 		}
 
+		if (AR_SREV_9285E_20(ah))
+			val |= AR_WA_BIT23;
+
 		REG_WRITE(ah, AR_WA, val);
-	}
 
-	if (power_off) {
-		/*
-		 * Set PCIe workaround bits
-		 * bit 14 in WA register (disable L1) should only
-		 * be set when device enters D3 and be cleared
-		 * when device comes back to D0.
-		 */
-		if (ah->config.pcie_waen) {
-			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
-				REG_SET_BIT(ah, AR_WA, AR_WA_D3_L1_DISABLE);
-		} else {
-			if (((AR_SREV_9285(ah) || AR_SREV_9271(ah) ||
-			      AR_SREV_9287(ah)) &&
-			     (AR9285_WA_DEFAULT & AR_WA_D3_L1_DISABLE)) ||
-			    (AR_SREV_9280(ah) &&
-			     (AR9280_WA_DEFAULT & AR_WA_D3_L1_DISABLE))) {
-				REG_SET_BIT(ah, AR_WA, AR_WA_D3_L1_DISABLE);
-			}
-		}
+		/* set bit 19 to allow forcing of pcie core into L1 state */
+		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index d4371a4..854e681 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -699,6 +699,9 @@
 #define AR_RC_HOSTIF         0x00000100
 
 #define AR_WA                		0x4004
+#define AR_WA_BIT6			(1 << 6)
+#define AR_WA_BIT7			(1 << 7)
+#define AR_WA_BIT23			(1 << 23)
 #define AR_WA_D3_L1_DISABLE		(1 << 14)
 #define AR9285_WA_DEFAULT		0x004a050b
 #define AR9280_WA_DEFAULT           	0x0040073b
-- 
1.7.1

