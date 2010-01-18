Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44505 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0ARQoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 11:44:08 -0500
Received: by bwz19 with SMTP id 19so1853874bwz.28
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2010 08:44:02 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id DBF28340CAD
	for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2010 17:43:59 +0100 (CET)
Received: from blech.mobile ([127.0.0.1])
	by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xO4C78MIpd+7 for <linux-wireless@vger.kernel.org>;
	Mon, 18 Jan 2010 17:43:56 +0100 (CET)
Received: from blech.mobile (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id DC4CB340A21
	for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2010 17:43:54 +0100 (CET)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFT][RFC] p54pci: revise tx locking
Date: Mon, 18 Jan 2010 17:43:54 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201001181743.54392.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch continues the effort which began with:
"[PATCH] p54pci: move tx cleanup into tasklet".

Thanks to these changes, p54pci's interrupt & tx
cleanup routines can be made lock-less.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
If no one finds a bug till Friday, this will become a [PATCH]. 
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index acc78e7..abf104e 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -238,7 +238,6 @@ static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
 	int ring_index, struct p54p_desc *ring, u32 ring_limit,
 	struct sk_buff **tx_buf)
 {
-	unsigned long flags;
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
 	struct p54p_desc *desc;
@@ -249,7 +248,6 @@ static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
 	(*index) = idx = le32_to_cpu(ring_control->device_idx[1]);
 	idx %= ring_limit;
 
-	spin_lock_irqsave(&priv->lock, flags);
 	while (i != idx) {
 		desc = &ring[i];
 
@@ -264,16 +262,12 @@ static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
 		desc->len = 0;
 		desc->flags = 0;
 
-		if (skb && FREE_AFTER_TX(skb)) {
-			spin_unlock_irqrestore(&priv->lock, flags);
+		if (skb && FREE_AFTER_TX(skb))
 			p54_free_skb(dev, skb);
-			spin_lock_irqsave(&priv->lock, flags);
-		}
 
 		i++;
 		i %= ring_limit;
 	}
-	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 static void p54p_tasklet(unsigned long dev_id)
@@ -306,7 +300,6 @@ static irqreturn_t p54p_interrupt(int irq, void *dev_id)
 	struct p54p_priv *priv = dev->priv;
 	__le32 reg;
 
-	spin_lock(&priv->lock);
 	reg = P54P_READ(int_ident);
 	if (unlikely(reg == cpu_to_le32(0xFFFFFFFF))) {
 		goto out;
@@ -321,15 +314,14 @@ static irqreturn_t p54p_interrupt(int irq, void *dev_id)
 		complete(&priv->boot_comp);
 
 out:
-	spin_unlock(&priv->lock);
 	return reg ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
+	unsigned long flags;
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
-	unsigned long flags;
 	struct p54p_desc *desc;
 	dma_addr_t mapping;
 	u32 device_idx, idx, i;
@@ -370,14 +362,14 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	unsigned int i;
 	struct p54p_desc *desc;
 
-	tasklet_kill(&priv->tasklet);
-
 	P54P_WRITE(int_enable, cpu_to_le32(0));
 	P54P_READ(int_enable);
 	udelay(10);
 
 	free_irq(priv->pdev->irq, dev);
 
+	tasklet_kill(&priv->tasklet);
+
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
 
 	for (i = 0; i < ARRAY_SIZE(priv->rx_buf_data); i++) {
