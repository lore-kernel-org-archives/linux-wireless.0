Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 07/15] ath9k_hw: simplify ath9k_hw_rf_alloc_ext_banks()
Date: Mon, 19 Oct 2009 02:33:38 -0400
Message-Id: <1255934026-20686-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is calling an allocation and checking for it, simplify
this process in a macro.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/phy.c |   72 +++++++++------------------------
 1 files changed, 20 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index f3136b2..923ea0b 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -416,64 +416,32 @@ ath9k_hw_rf_free(struct ath_hw *ah)
  */
 int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
 {
+#define ATH_ALLOC_BANK(bank, size) do { \
+		bank = kzalloc((sizeof(u32) * size), GFP_KERNEL); \
+		if (!bank) { \
+			ath_print(common, ATH_DBG_FATAL, \
+				  "Cannot allocate RF banks\n"); \
+			return -ENOMEM; \
+		} \
+	} while (0);
+
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
 
-	ah->analogBank0Data =
-	    kzalloc((sizeof(u32) *
-		     ah->iniBank0.ia_rows), GFP_KERNEL);
-	ah->analogBank1Data =
-	    kzalloc((sizeof(u32) *
-		     ah->iniBank1.ia_rows), GFP_KERNEL);
-	ah->analogBank2Data =
-	    kzalloc((sizeof(u32) *
-		     ah->iniBank2.ia_rows), GFP_KERNEL);
-	ah->analogBank3Data =
-	    kzalloc((sizeof(u32) *
-		     ah->iniBank3.ia_rows), GFP_KERNEL);
-	ah->analogBank6Data =
-	    kzalloc((sizeof(u32) *
-		     ah->iniBank6.ia_rows), GFP_KERNEL);
-	ah->analogBank6TPCData =
-	    kzalloc((sizeof(u32) *
-		     ah->iniBank6TPC.ia_rows), GFP_KERNEL);
-	ah->analogBank7Data =
-	    kzalloc((sizeof(u32) *
-		     ah->iniBank7.ia_rows), GFP_KERNEL);
-
-	if (ah->analogBank0Data == NULL
-	    || ah->analogBank1Data == NULL
-	    || ah->analogBank2Data == NULL
-	    || ah->analogBank3Data == NULL
-	    || ah->analogBank6Data == NULL
-	    || ah->analogBank6TPCData == NULL
-	    || ah->analogBank7Data == NULL) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Cannot allocate RF banks\n");
-		return -ENOMEM;
-	}
-
-	ah->addac5416_21 =
-	    kzalloc((sizeof(u32) *
-		     ah->iniAddac.ia_rows *
-		     ah->iniAddac.ia_columns), GFP_KERNEL);
-	if (ah->addac5416_21 == NULL) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Cannot allocate addac5416_21\n");
-		return -ENOMEM;
-	}
-
-	ah->bank6Temp =
-	    kzalloc((sizeof(u32) *
-		     ah->iniBank6.ia_rows), GFP_KERNEL);
-	if (ah->bank6Temp == NULL) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Cannot allocate bank6Temp\n");
-		return -ENOMEM;
-	}
+	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank2Data, ah->iniBank2.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank3Data, ah->iniBank3.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank6Data, ah->iniBank6.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank6TPCData, ah->iniBank6TPC.ia_rows);
+	ATH_ALLOC_BANK(ah->analogBank7Data, ah->iniBank7.ia_rows);
+	ATH_ALLOC_BANK(ah->addac5416_21,
+		       ah->iniAddac.ia_rows * ah->iniAddac.ia_columns);
+	ATH_ALLOC_BANK(ah->bank6Temp, ah->iniBank6.ia_rows);
 
 	return 0;
+#undef ATH_ALLOC_BANK
 }
 
 /**
-- 
1.6.0.4

