Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53275 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751559AbcKDJ17 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 05:27:59 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: toke@toke.dk, johannes@sipsolutions.net
Subject: [PATCH 3/3] mac80211: fix A-MSDU aggregation with fast-xmit + txq
Date: Fri,  4 Nov 2016 10:27:54 +0100
Message-Id: <20161104092754.91649-3-nbd@nbd.name> (sfid-20161104_102808_742348_9C27E631)
In-Reply-To: <20161104092754.91649-1-nbd@nbd.name>
References: <20161104092754.91649-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A-MSDU aggregation alters the QoS header after a frame has been
enqueued, so it needs to be ready before enqueue and not overwritten
again afterwards

Fixes: bb42f2d13ffc ("mac80211: Move reorder-sensitive TX handlers to after TXQ dequeue")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 390b425..2c21b70 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3235,7 +3235,6 @@ static void ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
 
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
-		*ieee80211_get_qos_ctl(hdr) = tid;
 		hdr->seq_ctrl = ieee80211_tx_next_seq(sta, tid);
 	} else {
 		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
@@ -3360,6 +3359,11 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 		      (tid_tx ? IEEE80211_TX_CTL_AMPDU : 0);
 	info->control.flags = IEEE80211_TX_CTRL_FAST_XMIT;
 
+	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
+		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+		*ieee80211_get_qos_ctl(hdr) = tid;
+	}
+
 	__skb_queue_head_init(&tx.skbs);
 
 	tx.flags = IEEE80211_TX_UNICAST;
-- 
2.10.1
