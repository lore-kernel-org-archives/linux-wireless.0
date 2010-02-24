Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47662 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0BXDnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 22:43:12 -0500
Message-ID: <4B84A049.1040904@openwrt.org>
Date: Wed, 24 Feb 2010 04:43:05 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: disable RIFS search for AR91xx based chips
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While ath9k does not support RIFS yet, the ability to receive RIFS
frames is currently enabled for most chipsets in the initvals.
This is causing baseband related issues on AR9160 and AR9130 based
chipsets, which can lock up under certain conditions.

This patch fixes these issues by overriding the initvals, effectively
disabling RIFS for all affected chipsets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1326,6 +1326,16 @@ static void ath9k_hw_override_ini(struct
 	 * Necessary to avoid issues on AR5416 2.0
 	 */
 	REG_WRITE(ah, 0x9800 + (651 << 2), 0x11);
+
+	/*
+	 * Disable RIFS search on some chips to avoid baseband
+	 * hang issues.
+	 */
+	if (AR_SREV_9100(ah) || AR_SREV_9160(ah)) {
+		val = REG_READ(ah, AR_PHY_HEAVY_CLIP_FACTOR_RIFS);
+		val &= ~AR_PHY_RIFS_INIT_DELAY;
+		REG_WRITE(ah, AR_PHY_HEAVY_CLIP_FACTOR_RIFS, val);
+	}
 }
 
 static u32 ath9k_hw_def_ini_fixup(struct ath_hw *ah,
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -384,6 +384,9 @@ bool ath9k_hw_set_rf_regs(struct ath_hw 
 
 #define AR_PHY_HEAVY_CLIP_ENABLE         0x99E0
 
+#define AR_PHY_HEAVY_CLIP_FACTOR_RIFS    0x99EC
+#define AR_PHY_RIFS_INIT_DELAY         0x03ff0000
+
 #define AR_PHY_M_SLEEP      0x99f0
 #define AR_PHY_REFCLKDLY    0x99f4
 #define AR_PHY_REFCLKPD     0x99f8
