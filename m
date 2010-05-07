Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0EGWXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 18:23:23 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Paul Shaw <paul.shaw@atheros.com>,
	Don Breslin <don.breslin@atheros.com>
Subject: [PATCH] ath9k_hw: enable PCIe low power mode for AR9003
Date: Fri,  7 May 2010 18:23:22 -0400
Message-Id: <1273271002-7377-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Paul Shaw <paul.shaw@atheros.com>
Cc: Don Breslin <don.breslin@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5590192..c33f17d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -574,6 +574,26 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_init_mode_regs(ah);
 
+	/*
+	 * Configire PCIE after Ini init. SERDES values now come from ini file
+	 * This enables PCIe low power mode.
+	 */
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		u32 regval;
+		unsigned int i;
+
+		/* Set Bits 16 and 17 in the AR_WA register. */
+		regval = REG_READ(ah, AR_WA);
+		regval |= 0x00030000;
+		REG_WRITE(ah, AR_WA, regval);
+
+		for (i = 0; i < ah->iniPcieSerdesLowPower.ia_rows; i++) {
+			REG_WRITE(ah,
+				  INI_RA(&ah->iniPcieSerdesLowPower, i, 0),
+				  INI_RA(&ah->iniPcieSerdesLowPower, i, 1));
+		}
+	}
+
 	if (ah->is_pciexpress)
 		ath9k_hw_configpcipowersave(ah, 0, 0);
 	else
-- 
1.6.3.3

