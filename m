Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55478 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3IPGB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 02:01:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Fix regression in LNA diversity
Date: Mon, 16 Sep 2013 11:27:59 +0530
Message-Id: <1379311079-8411-1-git-send-email-sujith@msujith.org> (sfid-20130916_080201_847820_CBD55B5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit "ath9k: Optimize LNA check" tried
to use the "rs_firstaggr" flag to optimize the LNA
combining algorithm when processing subframes in
an A-MPDU. This doesn't appear to work well in practice,
so revert it and use the old method of relying on
"rs_moreaggr".

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4ee472a..ab9e3a8 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1270,13 +1270,6 @@ static void ath9k_antenna_check(struct ath_softc *sc,
 		return;
 
 	/*
-	 * All MPDUs in an aggregate will use the same LNA
-	 * as the first MPDU.
-	 */
-	if (rs->rs_isaggr && !rs->rs_firstaggr)
-		return;
-
-	/*
 	 * Change the default rx antenna if rx diversity
 	 * chooses the other antenna 3 times in a row.
 	 */
-- 
1.8.4

