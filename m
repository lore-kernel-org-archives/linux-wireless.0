Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33639 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaI3Iot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 04:44:49 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Check early for HW reset
Date: Tue, 30 Sep 2014 14:15:23 +0530
Message-Id: <1412066723-6628-1-git-send-email-sujith@msujith.org> (sfid-20140930_104501_562291_6CEDED8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

chan_lock is not required for checking if
we are in the middle of a HW reset, so do it
early. This also removes the small window
where the lock is dropped and reacquired.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index aae70a1..7193a00 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1839,15 +1839,17 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	if (txq->mac80211_qnum < 0)
 		return;
 
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
+		return;
+
 	spin_lock_bh(&sc->chan_lock);
 	ac_list = &sc->cur_chan->acq[txq->mac80211_qnum];
-	spin_unlock_bh(&sc->chan_lock);
 
-	if (test_bit(ATH_OP_HW_RESET, &common->op_flags) ||
-	    list_empty(ac_list))
+	if (list_empty(ac_list)) {
+		spin_unlock_bh(&sc->chan_lock);
 		return;
+	}
 
-	spin_lock_bh(&sc->chan_lock);
 	rcu_read_lock();
 
 	last_ac = list_entry(ac_list->prev, struct ath_atx_ac, list);
-- 
2.1.1

