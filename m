Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35633 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbcGKNEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 09:04:13 -0400
From: Felix Fietkau <nbd@nbd.name>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath9k-txq-work 2/2] ath9k: call ieee80211_sta_set_buffered if frames are pending
Date: Mon, 11 Jul 2016 15:04:05 +0200
Message-Id: <20160711130405.77451-2-nbd@nbd.name> (sfid-20160711_150416_870420_035D4C05)
In-Reply-To: <20160711130405.77451-1-nbd@nbd.name>
References: <20160711130405.77451-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 needs to know about driver queued frames

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b3521c3..18c7443 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1561,6 +1561,9 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 			continue;
 		}
 
+		if (!skb_queue_empty(&tid->retry_q))
+			ieee80211_sta_set_buffered(sta, tid->tidno, true);
+
 		list_del_init(&tid->list);
 
 		ath_txq_unlock(sc, txq);
-- 
2.8.4

