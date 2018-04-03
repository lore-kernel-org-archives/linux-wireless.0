Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49828 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752600AbeDCTw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:52:58 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 7/7] mt76: check qos ack policy before reordering packets
Date: Tue,  3 Apr 2018 21:52:54 +0200
Message-Id: <20180403195254.87700-7-nbd@nbd.name> (sfid-20180403_215312_596139_0F48150C)
In-Reply-To: <20180403195254.87700-1-nbd@nbd.name>
References: <20180403195254.87700-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not attempt to reorder packets not part of a BA session

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index 6657ec8928de..dbf4057d2d3e 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -147,12 +147,13 @@ mt76_rx_aggr_check_ctl(struct sk_buff *skb, struct sk_buff_head *frames)
 void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct mt76_wcid *wcid = status->wcid;
 	struct ieee80211_sta *sta;
 	struct mt76_rx_tid *tid;
 	bool sn_less;
 	u16 seqno, head, size;
-	u8 idx;
+	u8 ackp, idx;
 
 	__skb_queue_tail(frames, skb);
 
@@ -165,6 +166,12 @@ void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames)
 		return;
 	}
 
+	/* not part of a BA session */
+	ackp = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_ACK_POLICY_MASK;
+	if (ackp != IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK &&
+	    ackp != IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)
+		return;
+
 	tid = rcu_dereference(wcid->aggr[status->tid]);
 	if (!tid)
 		return;
-- 
2.14.2
