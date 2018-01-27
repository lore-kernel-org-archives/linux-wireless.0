Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34116 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751846AbeA0PCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 10:02:08 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4.16 2/4] mt76: implement processing of BlockAckReq frames
Date: Sat, 27 Jan 2018 16:02:04 +0100
Message-Id: <20180127150206.24690-2-nbd@nbd.name> (sfid-20180127_160213_227268_CBD39531)
In-Reply-To: <20180127150206.24690-1-nbd@nbd.name>
References: <20180127150206.24690-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids timeouts on reordered A-MPDU rx frames

Fixes: aee5b8cf2477 ("mt76: implement A-MPDU rx reordering in the driver code")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 34 ++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index 8027bb7c03c2..e9784b50e2af 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -113,6 +113,33 @@ mt76_rx_aggr_reorder_work(struct work_struct *work)
 	local_bh_enable();
 }
 
+static void
+mt76_rx_aggr_check_ctl(struct sk_buff *skb, struct sk_buff_head *frames)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
+	struct ieee80211_bar *bar = (struct ieee80211_bar *) skb->data;
+	struct mt76_wcid *wcid = status->wcid;
+	struct mt76_rx_tid *tid;
+	u16 seqno;
+
+	if (!ieee80211_is_ctl(bar->frame_control))
+		return;
+
+	if (!ieee80211_is_back_req(bar->frame_control))
+		return;
+
+	status->tid = le16_to_cpu(bar->control) >> 12;
+	seqno = le16_to_cpu(bar->start_seq_num) >> 4;
+	tid = rcu_dereference(wcid->aggr[status->tid]);
+	if (!tid)
+		return;
+
+	spin_lock_bh(&tid->lock);
+	mt76_rx_aggr_release_frames(tid, frames, seqno);
+	mt76_rx_aggr_release_head(tid, frames);
+	spin_unlock_bh(&tid->lock);
+}
+
 void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
@@ -126,9 +153,14 @@ void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames)
 	__skb_queue_tail(frames, skb);
 
 	sta = wcid_to_sta(wcid);
-	if (!sta || !status->aggr)
+	if (!sta)
 		return;
 
+	if (!status->aggr) {
+		mt76_rx_aggr_check_ctl(skb, frames);
+		return;
+	}
+
 	tid = rcu_dereference(wcid->aggr[status->tid]);
 	if (!tid)
 		return;
-- 
2.14.2
