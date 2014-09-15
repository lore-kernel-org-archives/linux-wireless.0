Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44831 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaIOFzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:55:33 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 4/5] ath9k: Remove useless opmode check
Date: Mon, 15 Sep 2014 11:25:53 +0530
Message-Id: <1410760554-11844-5-git-send-email-sujith@msujith.org> (sfid-20140915_075536_452306_08BC6451)
In-Reply-To: <1410760554-11844-1-git-send-email-sujith@msujith.org>
References: <1410760554-11844-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The opmode is verified to be NL80211_IFTYPE_STATION
before calling ath9k_set_assoc_state().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index aa541fd..3a91b30 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -963,13 +963,6 @@ static void ath9k_set_assoc_state(struct ath_softc *sc,
 	unsigned long flags;
 
 	set_bit(ATH_OP_PRIM_STA_VIF, &common->op_flags);
-	/* Set the AID, BSSID and do beacon-sync only when
-	 * the HW opmode is STATION.
-	 *
-	 * But the primary bit is set above in any case.
-	 */
-	if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
-		return;
 
 	ether_addr_copy(common->curbssid, bss_conf->bssid);
 	common->curaid = bss_conf->aid;
-- 
2.1.0

