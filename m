Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab0DODa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 72/97] ath9k_hw: move AR9280 PCI EEPROM fix to eeprom_def.c
Date: Wed, 14 Apr 2010 23:30:26 -0400
Message-Id: <1271302251-9075-73-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    6 ++++++
 drivers/net/wireless/ath/ath9k/hw.c         |   17 -----------------
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 3d1b86b..cf59799 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -223,6 +223,12 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		return -EINVAL;
 	}
 
+	/* Enable fixup for AR_AN_TOP2 if necessary */
+	if (AR_SREV_9280_10_OR_LATER(ah) &&
+	    (eep->baseEepHeader.version & 0xff) > 0x0a &&
+	    eep->baseEepHeader.pwdclkind == 0)
+		ah->need_an_top2_fixup = 1;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e8b88be..c224f21 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -526,21 +526,6 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 	return 0;
 }
 
-static void ath9k_hw_init_eeprom_fix(struct ath_hw *ah)
-{
-	struct base_eep_header *pBase = &(ah->eeprom.def.baseEepHeader);
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	ah->need_an_top2_fixup = (ah->hw_version.devid == AR9280_DEVID_PCI) &&
-				 !AR_SREV_9285(ah) && !AR_SREV_9271(ah) &&
-				 ((pBase->version & 0xff) > 0x0a) &&
-				 (pBase->pwdclkind == 0);
-
-	if (ah->need_an_top2_fixup)
-		ath_print(common, ATH_DBG_EEPROM,
-			  "needs fixup for AR_AN_TOP2 register\n");
-}
-
 static void ath9k_hw_attach_ops(struct ath_hw *ah)
 {
 	if (AR_SREV_9300_20_OR_LATER(ah))
@@ -630,8 +615,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (r)
 		return r;
 
-	ath9k_hw_init_eeprom_fix(ah);
-
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
-- 
1.6.3.3

