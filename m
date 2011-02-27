Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60649 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1B0WbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:31:05 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so3126865wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:31:05 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 6/7] wl12xx: Avoid redundant TX work
Date: Mon, 28 Feb 2011 00:30:44 +0200
Message-Id: <1298845845-12191-7-git-send-email-ido@wizery.com>
In-Reply-To: <1298845845-12191-1-git-send-email-ido@wizery.com>
References: <1298845845-12191-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX might be handled in the threaded IRQ handler, in which case, TX work
might be scheduled just to discover it has nothing to do.

Save a few context switches by cancelling redundant TX work in case TX
is about to be handled in the threaded IRQ handler. Also, avoid
scheduling TX work from wl1271_op_tx if not needed.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   33 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9ceba52..70995a1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -641,6 +641,12 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 	u32 intr;
 	struct wl1271 *wl = (struct wl1271 *)cookie;
 	bool done = false;
+	unsigned long flags;
+
+	/* TX might be handled here, avoid redundant work */
+	set_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
+
+	cancel_work_sync(&wl->tx_work);
 
 	mutex_lock(&wl->mutex);
 
@@ -685,13 +691,17 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 			wl1271_rx(wl, &wl->fw_status->common);
 
 			/* Check if any tx blocks were freed */
+			spin_lock_irqsave(&wl->wl_lock, flags);
 			if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
 			    wl->tx_queue_count) {
+				spin_unlock_irqrestore(&wl->wl_lock, flags);
 				/*
 				 * In order to avoid starvation of the TX path,
 				 * call the work function directly.
 				 */
 				wl1271_tx_work_locked(wl);
+			} else {
+				spin_unlock_irqrestore(&wl->wl_lock, flags);
 			}
 
 			/* check for tx results */
@@ -721,6 +731,14 @@ irqreturn_t wl1271_irq(int irq, void *cookie)
 	wl1271_ps_elp_sleep(wl);
 
 out:
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	/* In case TX was not handled here, queue TX work */
+	clear_bit(WL1271_FLAG_TX_PENDING, &wl->flags);
+	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
+	    wl->tx_queue_count)
+		ieee80211_queue_work(wl->hw, &wl->tx_work);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
 	mutex_unlock(&wl->mutex);
 
 	return IRQ_HANDLED;
@@ -1055,7 +1073,13 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	int q;
 	u8 hlid = 0;
 
+	q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
+
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
+		hlid = wl1271_tx_get_hlid(skb);
+
 	spin_lock_irqsave(&wl->wl_lock, flags);
+
 	wl->tx_queue_count++;
 
 	/*
@@ -1068,12 +1092,8 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
 	}
 
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
 	/* queue the packet */
-	q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
-		hlid = wl1271_tx_get_hlid(skb);
 		wl1271_debug(DEBUG_TX, "queue skb hlid %d q %d", hlid, q);
 		skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
 	} else {
@@ -1085,9 +1105,12 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * before that, the tx_work will not be initialized!
 	 */
 
-	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags))
+	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
+	    !test_bit(WL1271_FLAG_TX_PENDING, &wl->flags))
 		ieee80211_queue_work(wl->hw, &wl->tx_work);
 
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 45e6577..8fdea60 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -317,6 +317,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_JOINED,
 	WL1271_FLAG_GPIO_POWER,
 	WL1271_FLAG_TX_QUEUE_STOPPED,
+	WL1271_FLAG_TX_PENDING,
 	WL1271_FLAG_IN_ELP,
 	WL1271_FLAG_PSM,
 	WL1271_FLAG_PSM_REQUESTED,
-- 
1.7.1

