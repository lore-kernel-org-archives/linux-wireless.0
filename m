Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0FUWix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:38:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Aeolus Yang <aeolus.yang@atheros.com>,
	Madhan Jaganathan <madhan.jaganathan@atheros.com>
Subject: [PATCH 2/5] ath9k_hw: move LowPower array writes to ar9003_hw_configpcipowersave()
Date: Mon, 21 Jun 2010 18:38:48 -0400
Message-Id: <1277159931-7797-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
References: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LowPower array writes disables the PLL when ASPM is enabled.
The host driver makes quite a few calls to ath9k_hw_configpcipowersave()
and these same calls also need to ensure the PLL is off when they issue
it.

Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: Madhan Jaganathan <madhan.jaganathan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   14 ++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c        |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index b4a9441..efabab8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -298,6 +298,20 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 		else
 			REG_WRITE(ah, AR_WA, ah->WARegVal);
 	}
+
+	/*
+	 * Configire PCIE after Ini init. SERDES values now come from ini file
+	 * This enables PCIe low power mode.
+	 */
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		unsigned int i;
+
+		for (i = 0; i < ah->iniPcieSerdesLowPower.ia_rows; i++) {
+			REG_WRITE(ah,
+				  INI_RA(&ah->iniPcieSerdesLowPower, i, 0),
+				  INI_RA(&ah->iniPcieSerdesLowPower, i, 1));
+		}
+	}
 }
 
 /* Sets up the AR9003 hardware familiy callbacks */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fb09042..3ee7d4e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -571,20 +571,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	ath9k_hw_init_mode_regs(ah);
 
 	/*
-	 * Configire PCIE after Ini init. SERDES values now come from ini file
-	 * This enables PCIe low power mode.
-	 */
-	if (AR_SREV_9300_20_OR_LATER(ah)) {
-		unsigned int i;
-
-		for (i = 0; i < ah->iniPcieSerdesLowPower.ia_rows; i++) {
-			REG_WRITE(ah,
-				  INI_RA(&ah->iniPcieSerdesLowPower, i, 0),
-				  INI_RA(&ah->iniPcieSerdesLowPower, i, 1));
-		}
-	}
-
-	/*
 	 * Read back AR_WA into a permanent copy and set bits 14 and 17.
 	 * We need to do this to avoid RMW of this register. We cannot
 	 * read the reg when chip is asleep.
-- 
1.6.3.3

