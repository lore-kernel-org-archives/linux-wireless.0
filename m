Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46799 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab3FABky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 21:40:54 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Disable PowerSave by default
Date: Sat,  1 Jun 2013 07:08:09 +0530
Message-Id: <1370050689-4941-1-git-send-email-sujith@msujith.org> (sfid-20130601_034058_485672_817A2A7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Almost all the DMA issues which have plagued ath9k (in station mode)
for years are related to PS. Disabling PS usually "fixes" the user's
connection stablility. Reports of DMA problems are still trickling in
and are sitting in the kernel bugzilla. Until the PS code in ath9k is
given a thorough review, disbale it by default. The slight increase
in chip power consumption is a small price to pay for improved link
stability.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f908dc1..9fc4d67 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -790,8 +790,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->iface_combinations = if_comb;
 	hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 
-	if (AR_SREV_5416(sc->sc_ah))
-		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
+	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
-- 
1.8.3

