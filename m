Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53548 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaJADEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 23:04:35 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 4/5] ath9k: Fix pending frame check
Date: Wed,  1 Oct 2014 08:34:55 +0530
Message-Id: <1412132696-22836-5-git-send-email-sujith@msujith.org> (sfid-20141001_050439_931284_C8692983)
In-Reply-To: <1412132696-22836-1-git-send-email-sujith@msujith.org>
References: <1412132696-22836-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Checking for the queue depth outside of
the TX queue lock is incorrect and in this
case, is not required since it is done inside
ath9k_has_pending_frames().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 84c0cd4..73a4438 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1974,9 +1974,6 @@ static bool ath9k_has_tx_pending(struct ath_softc *sc)
 		if (!ATH_TXQ_SETUP(sc, i))
 			continue;
 
-		if (!sc->tx.txq[i].axq_depth)
-			continue;
-
 		npend = ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
 		if (npend)
 			break;
-- 
2.1.1

