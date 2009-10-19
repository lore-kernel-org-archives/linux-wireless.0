Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 06/15] ath9k_hw: simplify rf attach and rename to ath9k_hw_rf_alloc_ext_banks()
Date: Mon, 19 Oct 2009 02:33:37 -0400
Message-Id: <1255934026-20686-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_rfattach() was just calling a helper and this helper was
doing nothing for single-chip devices, and for non single-chip devices
it is just allocating memory for banks to program the RF registers
at a later time. Simplify this by having the hw initialization call
the rf bank allocation directly for external radios.

Also, propagate an -ENOMEM properly now upon failure.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   27 +++++++++------------------
 drivers/net/wireless/ath/ath9k/phy.c |   19 +++++++------------
 drivers/net/wireless/ath/ath9k/phy.h |    3 +--
 3 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f67d3a4..694629b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -454,21 +454,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 }
 
-static int ath9k_hw_rfattach(struct ath_hw *ah)
-{
-	bool rfStatus = false;
-	int ecode = 0;
-
-	rfStatus = ath9k_hw_init_rf(ah, &ecode);
-	if (!rfStatus) {
-		ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
-			  "RF setup failed, status: %u\n", ecode);
-		return ecode;
-	}
-
-	return 0;
-}
-
 static int ath9k_hw_rf_claim(struct ath_hw *ah)
 {
 	u32 val;
@@ -585,9 +570,15 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		  ah->eep_ops->get_eeprom_ver(ah),
 		  ah->eep_ops->get_eeprom_rev(ah));
 
-	ecode = ath9k_hw_rfattach(ah);
-	if (ecode != 0)
-		return ecode;
+        if (!AR_SREV_9280_10_OR_LATER(ah)) {
+		ecode = ath9k_hw_rf_alloc_ext_banks(ah);
+		if (ecode) {
+			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
+				  "Failed allocating banks for "
+				  "external radio\n");
+			return ecode;
+		}
+	}
 
 	if (!AR_SREV_9100(ah)) {
 		ath9k_hw_ani_setup(ah);
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index bd4fb07..f3136b2 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -409,18 +409,16 @@ ath9k_hw_rf_free(struct ath_hw *ah)
 }
 
 /**
- * ath9k_hw_init_rf - initialize external radio structures
+ * ath9k_hw_rf_alloc_ext_banks - allocates banks for external radio programming
  * @ah: atheros hardware structure
- * @status:
  *
  * Only required for older devices with external AR2133/AR5133 radios.
  */
-bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
+int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (AR_SREV_9280_10_OR_LATER(ah))
-		return true;
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
 
 	ah->analogBank0Data =
 	    kzalloc((sizeof(u32) *
@@ -453,8 +451,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 	    || ah->analogBank7Data == NULL) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Cannot allocate RF banks\n");
-		*status = -ENOMEM;
-		return false;
+		return -ENOMEM;
 	}
 
 	ah->addac5416_21 =
@@ -464,8 +461,7 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 	if (ah->addac5416_21 == NULL) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Cannot allocate addac5416_21\n");
-		*status = -ENOMEM;
-		return false;
+		return -ENOMEM;
 	}
 
 	ah->bank6Temp =
@@ -474,11 +470,10 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 	if (ah->bank6Temp == NULL) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Cannot allocate bank6Temp\n");
-		*status = -ENOMEM;
-		return false;
+		return -ENOMEM;
 	}
 
-	return true;
+	return 0;
 }
 
 /**
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 140fef7..fa1dce4 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -29,8 +29,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 			  u16 modesIndex);
 void ath9k_hw_decrease_chain_power(struct ath_hw *ah,
 				   struct ath9k_channel *chan);
-bool ath9k_hw_init_rf(struct ath_hw *ah,
-		      int *status);
+int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah);
 
 #define AR_PHY_BASE     0x9800
 #define AR_PHY(_n)      (AR_PHY_BASE + ((_n)<<2))
-- 
1.6.0.4

