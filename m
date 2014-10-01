Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44098 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJADEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 23:04:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/5] ath9k: Check pending frames properly
Date: Wed,  1 Oct 2014 08:34:54 +0530
Message-Id: <1412132696-22836-4-git-send-email-sujith@msujith.org> (sfid-20141001_050437_291285_DF5185C1)
In-Reply-To: <1412132696-22836-1-git-send-email-sujith@msujith.org>
References: <1412132696-22836-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is no need to check if the current
channel context has active ACs queued up
if the TX queue is not empty.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ae7c6ee..84c0cd4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -60,8 +60,10 @@ static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
 
 	spin_lock_bh(&txq->axq_lock);
 
-	if (txq->axq_depth)
+	if (txq->axq_depth) {
 		pending = true;
+		goto out;
+	}
 
 	if (txq->mac80211_qnum >= 0) {
 		struct list_head *list;
@@ -70,6 +72,7 @@ static bool ath9k_has_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
 		if (!list_empty(list))
 			pending = true;
 	}
+out:
 	spin_unlock_bh(&txq->axq_lock);
 	return pending;
 }
-- 
2.1.1

