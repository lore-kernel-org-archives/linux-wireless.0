Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 08/15] ath9k_hw: rename ath9k_hw_rf_free() to ath9k_hw_rf_free_ext_banks()
Date: Mon, 19 Oct 2009 02:33:39 -0400
Message-Id: <1255934026-20686-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This clarifies this is only required for external radios.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.h  |    1 -
 drivers/net/wireless/ath/ath9k/phy.c |    9 ++++++---
 drivers/net/wireless/ath/ath9k/phy.h |    2 ++
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 694629b..5a08b97 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1282,7 +1282,8 @@ void ath9k_hw_detach(struct ath_hw *ah)
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 
 free_hw:
-	ath9k_hw_rf_free(ah);
+	if (!AR_SREV_9280_10_OR_LATER(ah))
+		ath9k_hw_rf_free_ext_banks(ah);
 	kfree(ah);
 	ah = NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8fe64cf..f9eb57b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -628,7 +628,6 @@ static inline struct ath_regulatory *ath9k_hw_regulatory(struct ath_hw *ah)
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
 int ath9k_hw_init(struct ath_hw *ah);
-void ath9k_hw_rf_free(struct ath_hw *ah);
 int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		   bool bChannelChange);
 void ath9k_hw_fill_cap_info(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 923ea0b..d50b5ff 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -384,18 +384,20 @@ ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
 }
 
 /**
- * ath9k_hw_rf_free - Free memory for analog bank scratch buffers
+ * ath9k_hw_rf_free_ext_banks - Free memory for analog bank scratch buffers
  * @ah: atheros hardware struture
- * For the external AR2133/AR5133 radios.
+ * For the external AR2133/AR5133 radios banks.
  */
 void
-ath9k_hw_rf_free(struct ath_hw *ah)
+ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
 {
 #define ATH_FREE_BANK(bank) do { \
 		kfree(bank); \
 		bank = NULL; \
 	} while (0);
 
+	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
+
 	ATH_FREE_BANK(ah->analogBank0Data);
 	ATH_FREE_BANK(ah->analogBank1Data);
 	ATH_FREE_BANK(ah->analogBank2Data);
@@ -405,6 +407,7 @@ ath9k_hw_rf_free(struct ath_hw *ah)
 	ATH_FREE_BANK(ah->analogBank7Data);
 	ATH_FREE_BANK(ah->addac5416_21);
 	ATH_FREE_BANK(ah->bank6Temp);
+
 #undef ATH_FREE_BANK
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index fa1dce4..c083bbf 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -29,6 +29,8 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah,
 			  u16 modesIndex);
 void ath9k_hw_decrease_chain_power(struct ath_hw *ah,
 				   struct ath9k_channel *chan);
+
+void ath9k_hw_rf_free_ext_banks(struct ath_hw *ah);
 int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah);
 
 #define AR_PHY_BASE     0x9800
-- 
1.6.0.4

