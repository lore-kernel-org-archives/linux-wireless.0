Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40099 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaJADEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 23:04:40 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 5/5] ath9k: Remove duplicate code
Date: Wed,  1 Oct 2014 08:34:56 +0530
Message-Id: <1412132696-22836-6-git-send-email-sujith@msujith.org> (sfid-20141001_050445_567246_481227E6)
In-Reply-To: <1412132696-22836-1-git-send-email-sujith@msujith.org>
References: <1412132696-22836-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k_has_tx_pending() can be used to
check if there are pending frames instead
of having duplicate code.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 73a4438..65ca7ac 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2039,16 +2039,8 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 static bool ath9k_tx_frames_pending(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
-	int i;
-
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (!ATH_TXQ_SETUP(sc, i))
-			continue;
 
-		if (ath9k_has_pending_frames(sc, &sc->tx.txq[i]))
-			return true;
-	}
-	return false;
+	return ath9k_has_tx_pending(sc);
 }
 
 static int ath9k_tx_last_beacon(struct ieee80211_hw *hw)
-- 
2.1.1

