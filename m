Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46224 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab3FVKjb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 06:39:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.10] ath9k: fix an RCU issue in calling ieee80211_get_tx_rates
Date: Sat, 22 Jun 2013 12:39:26 +0200
Message-Id: <1371897566-47892-1-git-send-email-nbd@openwrt.org> (sfid-20130622_123944_463809_318A4F13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_txq_schedule is called outside of the drv_tx call, so it needs RCU
protection.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index bfb58a5..c59ae43 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1673,6 +1673,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 	    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
 		return;
 
+	rcu_read_lock();
+
 	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
 	last_ac = list_entry(txq->axq_acq.prev, struct ath_atx_ac, list);
 
@@ -1711,8 +1713,10 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 
 		if (ac == last_ac ||
 		    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
-			return;
+			break;
 	}
+
+	rcu_read_unlock();
 }
 
 /***********/
-- 
1.8.0.2

