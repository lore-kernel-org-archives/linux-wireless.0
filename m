Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57256 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab1BDGYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 01:24:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 22:23:47 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
Date: Fri, 4 Feb 2011 11:53:59 +0530
Message-ID: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a highly noisy environment, a data frame which is queued before
a nullfunc frame on a different hw queue may be sent over the air
after the tx completion of nullfunc frame. This causes the station
to enter power save and the AP to see the station as awake and
continues to send the data traffic. Fix this by draining all tx
queues before we send the null function frame with PM bit set.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 68a1c76..0cb6017 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1710,7 +1710,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 			    bf->bf_buf_addr,
 			    txq->axq_qnum);
 
-
 	return bf;
 }
 
@@ -1813,6 +1812,15 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(!bf))
 		return -ENOMEM;
 
+	if (ieee80211_is_nullfunc(hdr->frame_control) &&
+	    ieee80211_has_pm(hdr->frame_control)) {
+		/* Drain all the pending frames before we send a nullfunc frame
+		 * to avoid any power save state mismatch between the station
+		 * and the AP.
+		 */
+		ath_drain_all_txq(sc, false);
+	}
+
 	q = skb_get_queue_mapping(skb);
 	spin_lock_bh(&txq->axq_lock);
 	if (txq == sc->tx.txq_map[q] &&
-- 
1.6.3.3

