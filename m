Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbZCJCJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:09:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH 1/2] ath9k: downgrade xmit queue full message to xmit debug
Date: Mon,  9 Mar 2009 22:09:41 -0400
Message-Id: <1236650982-11520-2-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032927_169893_760D4FAF)
In-Reply-To: <1236650982-11520-1-git-send-email-lrodriguez@atheros.com>
References: <1236650982-11520-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not a fatal message, hitting it simply means we're
going to tell the upper layers to slow their horses down but
as we make more descriptors available we let the show continue
by waking up the queues in ath_wake_mac80211_queue().

We downgrade this as otherwise we fill up your kernel log with
messages which can be common under heavy traffic.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Greg, the second patch in this series is not relevant for stable,
just this patch.

 drivers/net/wireless/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index a82d2ab..465e5bb 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -891,7 +891,7 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 	spin_lock_bh(&txq->axq_lock);
 
 	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc, ATH_DBG_XMIT,
 			"TX queue: %d is full, depth: %d\n",
 			qnum, txq->axq_depth);
 		ieee80211_stop_queue(sc->hw, skb_get_queue_mapping(skb));
-- 
1.6.0.6

