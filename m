Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41291 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:55:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 5/5] ath9k: Fix primary station configuration
Date: Mon, 15 Sep 2014 11:25:54 +0530
Message-Id: <1410760554-11844-6-git-send-email-sujith@msujith.org> (sfid-20140915_075543_935665_C5218F3F)
In-Reply-To: <1410760554-11844-1-git-send-email-sujith@msujith.org>
References: <1410760554-11844-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Assign 'primary_sta' to the active primary station
interface after iterating over the list of interfaces.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3a91b30..7bc7d55 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1088,9 +1088,7 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 			iter_data.beacons = true;
 			ath9k_set_assoc_state(sc, iter_data.primary_sta,
 					      changed);
-			if (!ctx->primary_sta ||
-			    !ctx->primary_sta->bss_conf.assoc)
-				ctx->primary_sta = iter_data.primary_sta;
+			ctx->primary_sta = iter_data.primary_sta;
 		} else {
 			ctx->primary_sta = NULL;
 			memset(common->curbssid, 0, ETH_ALEN);
@@ -1119,8 +1117,6 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	else
 		clear_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
 
-	ctx->primary_sta = iter_data.primary_sta;
-
 	ath9k_ps_restore(sc);
 }
 
-- 
2.1.0

