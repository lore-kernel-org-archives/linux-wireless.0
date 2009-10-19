Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54686 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZJSGdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 02:33:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 05/15] ath9k_hw: bail out early on ath9k_hw_init_rf()
Date: Mon, 19 Oct 2009 02:33:36 -0400
Message-Id: <1255934026-20686-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We a huge branch for old hardware and nothing for newer
hardware. Instead of doing this just bail out early for
newer hardware.

This patch has no functional changes.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/phy.c |  109 +++++++++++++++++-----------------
 1 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
index 9e51503..bd4fb07 100644
--- a/drivers/net/wireless/ath/ath9k/phy.c
+++ b/drivers/net/wireless/ath/ath9k/phy.c
@@ -419,62 +419,63 @@ bool ath9k_hw_init_rf(struct ath_hw *ah, int *status)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if (!AR_SREV_9280_10_OR_LATER(ah)) {
-		ah->analogBank0Data =
-		    kzalloc((sizeof(u32) *
-			     ah->iniBank0.ia_rows), GFP_KERNEL);
-		ah->analogBank1Data =
-		    kzalloc((sizeof(u32) *
-			     ah->iniBank1.ia_rows), GFP_KERNEL);
-		ah->analogBank2Data =
-		    kzalloc((sizeof(u32) *
-			     ah->iniBank2.ia_rows), GFP_KERNEL);
-		ah->analogBank3Data =
-		    kzalloc((sizeof(u32) *
-			     ah->iniBank3.ia_rows), GFP_KERNEL);
-		ah->analogBank6Data =
-		    kzalloc((sizeof(u32) *
-			     ah->iniBank6.ia_rows), GFP_KERNEL);
-		ah->analogBank6TPCData =
-		    kzalloc((sizeof(u32) *
-			     ah->iniBank6TPC.ia_rows), GFP_KERNEL);
-		ah->analogBank7Data =
-		    kzalloc((sizeof(u32) *
-			     ah->iniBank7.ia_rows), GFP_KERNEL);
-
-		if (ah->analogBank0Data == NULL
-		    || ah->analogBank1Data == NULL
-		    || ah->analogBank2Data == NULL
-		    || ah->analogBank3Data == NULL
-		    || ah->analogBank6Data == NULL
-		    || ah->analogBank6TPCData == NULL
-		    || ah->analogBank7Data == NULL) {
-			ath_print(common, ATH_DBG_FATAL,
-				  "Cannot allocate RF banks\n");
-			*status = -ENOMEM;
-			return false;
-		}
+	if (AR_SREV_9280_10_OR_LATER(ah))
+		return true;
 
-		ah->addac5416_21 =
-		    kzalloc((sizeof(u32) *
-			     ah->iniAddac.ia_rows *
-			     ah->iniAddac.ia_columns), GFP_KERNEL);
-		if (ah->addac5416_21 == NULL) {
-			ath_print(common, ATH_DBG_FATAL,
-				  "Cannot allocate addac5416_21\n");
-			*status = -ENOMEM;
-			return false;
-		}
+	ah->analogBank0Data =
+	    kzalloc((sizeof(u32) *
+		     ah->iniBank0.ia_rows), GFP_KERNEL);
+	ah->analogBank1Data =
+	    kzalloc((sizeof(u32) *
+		     ah->iniBank1.ia_rows), GFP_KERNEL);
+	ah->analogBank2Data =
+	    kzalloc((sizeof(u32) *
+		     ah->iniBank2.ia_rows), GFP_KERNEL);
+	ah->analogBank3Data =
+	    kzalloc((sizeof(u32) *
+		     ah->iniBank3.ia_rows), GFP_KERNEL);
+	ah->analogBank6Data =
+	    kzalloc((sizeof(u32) *
+		     ah->iniBank6.ia_rows), GFP_KERNEL);
+	ah->analogBank6TPCData =
+	    kzalloc((sizeof(u32) *
+		     ah->iniBank6TPC.ia_rows), GFP_KERNEL);
+	ah->analogBank7Data =
+	    kzalloc((sizeof(u32) *
+		     ah->iniBank7.ia_rows), GFP_KERNEL);
+
+	if (ah->analogBank0Data == NULL
+	    || ah->analogBank1Data == NULL
+	    || ah->analogBank2Data == NULL
+	    || ah->analogBank3Data == NULL
+	    || ah->analogBank6Data == NULL
+	    || ah->analogBank6TPCData == NULL
+	    || ah->analogBank7Data == NULL) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Cannot allocate RF banks\n");
+		*status = -ENOMEM;
+		return false;
+	}
 
-		ah->bank6Temp =
-		    kzalloc((sizeof(u32) *
-			     ah->iniBank6.ia_rows), GFP_KERNEL);
-		if (ah->bank6Temp == NULL) {
-			ath_print(common, ATH_DBG_FATAL,
-				  "Cannot allocate bank6Temp\n");
-			*status = -ENOMEM;
-			return false;
-		}
+	ah->addac5416_21 =
+	    kzalloc((sizeof(u32) *
+		     ah->iniAddac.ia_rows *
+		     ah->iniAddac.ia_columns), GFP_KERNEL);
+	if (ah->addac5416_21 == NULL) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Cannot allocate addac5416_21\n");
+		*status = -ENOMEM;
+		return false;
+	}
+
+	ah->bank6Temp =
+	    kzalloc((sizeof(u32) *
+		     ah->iniBank6.ia_rows), GFP_KERNEL);
+	if (ah->bank6Temp == NULL) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Cannot allocate bank6Temp\n");
+		*status = -ENOMEM;
+		return false;
 	}
 
 	return true;
-- 
1.6.0.4

