Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56034 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754392AbcK2SF6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 13:05:58 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] mac80211:  put upper bound on txqi queue length.
Date: Tue, 29 Nov 2016 10:05:53 -0800
Message-Id: <1480442753-6830-2-git-send-email-greearb@candelatech.com> (sfid-20161129_190601_774406_10D2EEDF)
In-Reply-To: <1480442753-6830-1-git-send-email-greearb@candelatech.com>
References: <1480442753-6830-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This fixes OOM when using pktgen to drive a wifi station at more than
the station can transmit.  pktgen uses ndo_start_xmit instead of going
through the queue layer, so it will not back off when the queues are
stopped, and would thus cause packets to be added to the txqi->queue
until the system goes OOM and crashes.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is against 4.7.10+, not sure if it is actually needed in latest kernel.

 net/mac80211/tx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index fbcb5fc..0573ab9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1293,6 +1293,16 @@ static void ieee80211_drv_tx(struct ieee80211_local *local,
 		goto tx_normal;
 
 	ac = txq->ac;
+
+	if (atomic_read(&sdata->txqs_len[ac]) >=
+	    (local->hw.txq_ac_max_pending * 2)) {
+		/* Must be that something is not paying attention to
+		 * max-pending, like pktgen, so just drop this frame.
+		 */
+		ieee80211_free_txskb(&local->hw, skb);
+		return;
+	}
+
 	txqi = to_txq_info(txq);
 	atomic_inc(&sdata->txqs_len[ac]);
 	if (atomic_read(&sdata->txqs_len[ac]) >= local->hw.txq_ac_max_pending)
-- 
2.4.11
