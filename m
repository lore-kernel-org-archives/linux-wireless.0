Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35122 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbbJXRnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 13:43:05 -0400
Received: by qkbl190 with SMTP id l190so94328872qkb.2
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2015 10:43:04 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] wcn36xx: introduce per-channel ring buffer locks
Date: Sat, 24 Oct 2015 13:42:15 -0400
Message-Id: <1445708535-20169-1-git-send-email-me@bobcopeland.com> (sfid-20151024_194310_906584_B775C6E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wcn36xx implements a ring buffer for transmitted frames for each
(high and low priority) DMA channel.  The ring buffers are lockless:
new frames are inserted at the head of the queue, while finished
packets are reaped from the tail.

Unfortunately, the list manipulations are missing any kind of barriers
so are susceptible to various races: for example, a TX completion
handler might read an updated desc->ctrl before the head has actually
advanced, and then null out the ctl->skb pointer while it is still
being used in the TX path.

Simplify things here by adding a spin lock when traversing the ring.
This change increased stability for me without adding any noticeable
overhead on my platform (xperia z).

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 27 +++++++++++++++++++--------
 drivers/net/wireless/ath/wcn36xx/dxe.h |  1 +
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 086549b..26085f7 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -79,6 +79,7 @@ static int wcn36xx_dxe_allocate_ctl_block(struct wcn36xx_dxe_ch *ch)
 	struct wcn36xx_dxe_ctl *cur_ctl = NULL;
 	int i;
 
+	spin_lock_init(&ch->lock);
 	for (i = 0; i < ch->desc_num; i++) {
 		cur_ctl = kzalloc(sizeof(*cur_ctl), GFP_KERNEL);
 		if (!cur_ctl)
@@ -345,7 +346,7 @@ void wcn36xx_dxe_tx_ack_ind(struct wcn36xx *wcn, u32 status)
 
 static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 {
-	struct wcn36xx_dxe_ctl *ctl = ch->tail_blk_ctl;
+	struct wcn36xx_dxe_ctl *ctl;
 	struct ieee80211_tx_info *info;
 	unsigned long flags;
 
@@ -354,6 +355,8 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 	 * completely full head and tail are pointing to the same element
 	 * and while-do will not make any cycles.
 	 */
+	spin_lock_irqsave(&ch->lock, flags);
+	ctl = ch->tail_blk_ctl;
 	do {
 		if (ctl->desc->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)
 			break;
@@ -365,12 +368,12 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 				/* Keep frame until TX status comes */
 				ieee80211_free_txskb(wcn->hw, ctl->skb);
 			}
-			spin_lock_irqsave(&ctl->skb_lock, flags);
+			spin_lock(&ctl->skb_lock);
 			if (wcn->queues_stopped) {
 				wcn->queues_stopped = false;
 				ieee80211_wake_queues(wcn->hw);
 			}
-			spin_unlock_irqrestore(&ctl->skb_lock, flags);
+			spin_unlock(&ctl->skb_lock);
 
 			ctl->skb = NULL;
 		}
@@ -379,6 +382,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 	       !(ctl->desc->ctrl & WCN36XX_DXE_CTRL_VALID_MASK));
 
 	ch->tail_blk_ctl = ctl;
+	spin_unlock_irqrestore(&ch->lock, flags);
 }
 
 static irqreturn_t wcn36xx_irq_tx_complete(int irq, void *dev)
@@ -596,12 +600,14 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 	struct wcn36xx_dxe_desc *desc = NULL;
 	struct wcn36xx_dxe_ch *ch = NULL;
 	unsigned long flags;
+	int ret;
 
 	ch = is_low ? &wcn->dxe_tx_l_ch : &wcn->dxe_tx_h_ch;
 
+	spin_lock_irqsave(&ch->lock, flags);
 	ctl = ch->head_blk_ctl;
 
-	spin_lock_irqsave(&ctl->next->skb_lock, flags);
+	spin_lock(&ctl->next->skb_lock);
 
 	/*
 	 * If skb is not null that means that we reached the tail of the ring
@@ -611,10 +617,11 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 	if (NULL != ctl->next->skb) {
 		ieee80211_stop_queues(wcn->hw);
 		wcn->queues_stopped = true;
-		spin_unlock_irqrestore(&ctl->next->skb_lock, flags);
+		spin_unlock(&ctl->next->skb_lock);
+		spin_unlock_irqrestore(&ch->lock, flags);
 		return -EBUSY;
 	}
-	spin_unlock_irqrestore(&ctl->next->skb_lock, flags);
+	spin_unlock(&ctl->next->skb_lock);
 
 	ctl->skb = NULL;
 	desc = ctl->desc;
@@ -640,7 +647,8 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 	desc = ctl->desc;
 	if (ctl->bd_cpu_addr) {
 		wcn36xx_err("bd_cpu_addr cannot be NULL for skb DXE\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto unlock;
 	}
 
 	desc->src_addr_l = dma_map_single(NULL,
@@ -679,7 +687,10 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 			ch->reg_ctrl, ch->def_ctrl);
 	}
 
-	return 0;
+	ret = 0;
+unlock:
+	spin_unlock_irqrestore(&ch->lock, flags);
+	return ret;
 }
 
 int wcn36xx_dxe_init(struct wcn36xx *wcn)
diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.h b/drivers/net/wireless/ath/wcn36xx/dxe.h
index 35ee7e9..3eca4f9 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.h
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.h
@@ -243,6 +243,7 @@ struct wcn36xx_dxe_ctl {
 };
 
 struct wcn36xx_dxe_ch {
+	spinlock_t			lock;	/* protects head/tail ptrs */
 	enum wcn36xx_dxe_ch_type	ch_type;
 	void				*cpu_addr;
 	dma_addr_t			dma_addr;
-- 
2.1.4

