Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39822 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751525AbeDFKLc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 06:11:32 -0400
Received: by mail-wm0-f67.google.com with SMTP id f125so2240284wme.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2018 03:11:32 -0700 (PDT)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: Remove useless skb spinlock
Date: Fri,  6 Apr 2018 12:11:28 +0200
Message-Id: <1523009488-15772-1-git-send-email-loic.poulain@linaro.org> (sfid-20180406_121136_238898_AC28DFB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each DXE control block is associated to a specific channel.
The channel lock is always taken before accessing a control block.
There is no need to have an extra (useless) spinlock for the control
block skb.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 8 +-------
 drivers/net/wireless/ath/wcn36xx/dxe.h | 1 -
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 2c3b899..4bb9630 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -78,7 +78,6 @@ static int wcn36xx_dxe_allocate_ctl_block(struct wcn36xx_dxe_ch *ch)
 		if (!cur_ctl)
 			goto out_fail;
 
-		spin_lock_init(&cur_ctl->skb_lock);
 		cur_ctl->ctl_blk_order = i;
 		if (i == 0) {
 			ch->head_blk_ctl = cur_ctl;
@@ -377,12 +376,11 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 				/* Keep frame until TX status comes */
 				ieee80211_free_txskb(wcn->hw, ctl->skb);
 			}
-			spin_lock(&ctl->skb_lock);
+
 			if (wcn->queues_stopped) {
 				wcn->queues_stopped = false;
 				ieee80211_wake_queues(wcn->hw);
 			}
-			spin_unlock(&ctl->skb_lock);
 
 			ctl->skb = NULL;
 		}
@@ -654,8 +652,6 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 	spin_lock_irqsave(&ch->lock, flags);
 	ctl = ch->head_blk_ctl;
 
-	spin_lock(&ctl->next->skb_lock);
-
 	/*
 	 * If skb is not null that means that we reached the tail of the ring
 	 * hence ring is full. Stop queues to let mac80211 back off until ring
@@ -664,11 +660,9 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 	if (NULL != ctl->next->skb) {
 		ieee80211_stop_queues(wcn->hw);
 		wcn->queues_stopped = true;
-		spin_unlock(&ctl->next->skb_lock);
 		spin_unlock_irqrestore(&ch->lock, flags);
 		return -EBUSY;
 	}
-	spin_unlock(&ctl->next->skb_lock);
 
 	ctl->skb = NULL;
 	desc = ctl->desc;
diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.h b/drivers/net/wireless/ath/wcn36xx/dxe.h
index ce58096..31b81b7 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.h
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.h
@@ -422,7 +422,6 @@ struct wcn36xx_dxe_ctl {
 	unsigned int		desc_phy_addr;
 	int			ctl_blk_order;
 	struct sk_buff		*skb;
-	spinlock_t              skb_lock;
 	void			*bd_cpu_addr;
 	dma_addr_t		bd_phy_addr;
 };
-- 
2.7.4
