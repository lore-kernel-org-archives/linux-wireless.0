Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41820 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab0AWTE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 14:04:29 -0500
Message-ID: <4B5B4832.2020800@openwrt.org>
Date: Sat, 23 Jan 2010 20:04:18 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, jorge@dti2.net,
	Pavel Roskin <proski@gnu.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: fix eeprom INI values override for 2GHz-only cards
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Among other changes, this commit:

   commit 06d0f0663e11cab4ec5f2c143a118d71a12fbbe9
   Author: Sujith <Sujith.Manoharan@atheros.com>
   Date:   Thu Feb 12 10:06:45 2009 +0530

   ath9k: Enable Fractional N mode

changed the hw attach code to fix up initialization values only for
dual band devices, however the commit message did not give a reason as
to why this would be useful or necessary.

According to tests by Jorge Boncompte, this breaks at least some 
2GHz-only cards, so the code should be changed back to the
unconditional INI fixup.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Jorge Boncompte <jorge@dti2.net>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -823,12 +823,11 @@ static void ath9k_hw_init_mode_gain_regs
 	}
 }
 
-static void ath9k_hw_init_11a_eeprom_fix(struct ath_hw *ah)
+static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
 {
 	u32 i, j;
 
-	if ((ah->hw_version.devid == AR9280_DEVID_PCI) &&
-	    test_bit(ATH9K_MODE_11A, ah->caps.wireless_modes)) {
+	if (ah->hw_version.devid == AR9280_DEVID_PCI) {
 
 		/* EEPROM Fixup */
 		for (i = 0; i < ah->iniModes.ia_rows; i++) {
@@ -948,7 +947,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	if (r)
 		return r;
 
-	ath9k_hw_init_11a_eeprom_fix(ah);
+	ath9k_hw_init_eeprom_fix(ah);
 
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
