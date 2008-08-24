Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33655 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYHXU1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2008 16:27:36 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54pci: rx tasklet refactoring
Date: Sun, 24 Aug 2008 22:30:38 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808242230.38447.chunkeey@web.de> (sfid-20080824_222741_892713_67027F08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the all of p54pci's receiver code out of the
bloated interrupt handler routine and into a less critical tasklet.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
linux-next material as well
---
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-08-24 02:13:44.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-08-24 22:05:06.000000000 +0200
@@ -3,6 +3,7 @@
  * Linux device driver for PCI based Prism54
  *
  * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2008, Christian Lamparter <chunkeey@web.de>
  *
  * Based on the islsm (softmac prism54) driver, which is:
  * Copyright 2004-2006 Jean-Baptiste Note <jean-baptiste.note@m4x.org>, et al.
@@ -237,20 +238,22 @@ static int p54p_read_eeprom(struct ieee8
 	return err;
 }
 
-static void p54p_refill_rx_ring(struct ieee80211_hw *dev)
+static void p54p_refill_rx_ring(struct ieee80211_hw *dev,
+	int ring_index, struct p54p_desc *ring, u32 ring_limit,
+	struct sk_buff **rx_buf)
 {
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
-	u32 limit, host_idx, idx;
+	u32 limit, idx, i;
 
-	host_idx = le32_to_cpu(ring_control->host_idx[0]);
-	limit = host_idx;
-	limit -= le32_to_cpu(ring_control->device_idx[0]);
-	limit = ARRAY_SIZE(ring_control->rx_data) - limit;
+	idx = le32_to_cpu(ring_control->host_idx[ring_index]);
+	limit = idx;
+	limit -= le32_to_cpu(ring_control->device_idx[ring_index]);
+	limit = ring_limit - limit;
 
-	idx = host_idx % ARRAY_SIZE(ring_control->rx_data);
+	i = idx % ring_limit;
 	while (limit-- > 1) {
-		struct p54p_desc *desc = &ring_control->rx_data[idx];
+		struct p54p_desc *desc = &ring[i];
 
 		if (!desc->host_addr) {
 			struct sk_buff *skb;
@@ -267,16 +270,106 @@ static void p54p_refill_rx_ring(struct i
 			desc->device_addr = 0;	// FIXME: necessary?
 			desc->len = cpu_to_le16(MAX_RX_SIZE);
 			desc->flags = 0;
-			priv->rx_buf[idx] = skb;
+			rx_buf[i] = skb;
 		}
 
+		i++;
 		idx++;
-		host_idx++;
-		idx %= ARRAY_SIZE(ring_control->rx_data);
+		i %= ring_limit;
 	}
 
 	wmb();
-	ring_control->host_idx[0] = cpu_to_le32(host_idx);
+	ring_control->host_idx[ring_index] = cpu_to_le32(idx);
+}
+
+static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
+	int ring_index, struct p54p_desc *ring, u32 ring_limit,
+	struct sk_buff **rx_buf)
+{
+	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
+	struct p54p_desc *desc;
+	u32 idx, i;
+
+	i = (*index) % ring_limit;
+	(*index) = idx = le32_to_cpu(ring_control->device_idx[ring_index]);
+	idx %= ring_limit;
+	while (i != idx) {
+		u16 len;
+		struct sk_buff *skb;
+		desc = &ring[i];
+		len = le16_to_cpu(desc->len);
+		skb = rx_buf[i];
+
+		if (!skb)
+			continue;
+
+		skb_put(skb, len);
+
+		if (p54_rx(dev, skb)) {
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
+					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+			rx_buf[i] = NULL;
+			desc->host_addr = 0;
+		} else {
+			skb_trim(skb, 0);
+			desc->len = cpu_to_le16(MAX_RX_SIZE);
+		}
+
+		i++;
+		i %= ring_limit;
+	}
+
+	p54p_refill_rx_ring(dev, ring_index, ring, ring_limit, rx_buf);
+}
+
+/* caller must hold priv->lock */
+static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
+	int ring_index, struct p54p_desc *ring, u32 ring_limit,
+	void **tx_buf)
+{
+	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
+	struct p54p_desc *desc;
+	u32 idx, i;
+
+	i = (*index) % ring_limit;
+	(*index) = idx = le32_to_cpu(ring_control->device_idx[1]);
+	idx %= ring_limit;
+
+	while (i != idx) {
+		desc = &ring[i];
+		kfree(tx_buf[i]);
+		tx_buf[i] = NULL;
+
+		pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
+				 le16_to_cpu(desc->len), PCI_DMA_TODEVICE);
+
+		desc->host_addr = 0;
+		desc->device_addr = 0;
+		desc->len = 0;
+		desc->flags = 0;
+
+		i++;
+		i %= ring_limit;
+	}
+}
+
+static void p54p_rx_tasklet(unsigned long dev_id)
+{
+	struct ieee80211_hw *dev = (struct ieee80211_hw *)dev_id;
+	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
+
+	p54p_check_rx_ring(dev, &priv->rx_idx_mgmt, 2, ring_control->rx_mgmt,
+		ARRAY_SIZE(ring_control->rx_mgmt), priv->rx_buf_mgmt);
+
+	p54p_check_rx_ring(dev, &priv->rx_idx_data, 0, ring_control->rx_data,
+		ARRAY_SIZE(ring_control->rx_data), priv->rx_buf_data);
+
+	wmb();
+	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
 }
 
 static irqreturn_t p54p_interrupt(int irq, void *dev_id)
@@ -298,65 +391,18 @@ static irqreturn_t p54p_interrupt(int ir
 	reg &= P54P_READ(int_enable);
 
 	if (reg & cpu_to_le32(ISL38XX_INT_IDENT_UPDATE)) {
-		struct p54p_desc *desc;
-		u32 idx, i;
-		i = priv->tx_idx;
-		i %= ARRAY_SIZE(ring_control->tx_data);
-		priv->tx_idx = idx = le32_to_cpu(ring_control->device_idx[1]);
-		idx %= ARRAY_SIZE(ring_control->tx_data);
-
-		while (i != idx) {
-			desc = &ring_control->tx_data[i];
-			if (priv->tx_buf[i]) {
-				kfree(priv->tx_buf[i]);
-				priv->tx_buf[i] = NULL;
-			}
+		p54p_check_tx_ring(dev, &priv->tx_idx_mgmt,
+				   3, ring_control->tx_mgmt,
+				   ARRAY_SIZE(ring_control->tx_mgmt),
+				   priv->tx_buf_mgmt);
+
+		p54p_check_tx_ring(dev, &priv->tx_idx_data,
+				   1, ring_control->tx_data,
+				   ARRAY_SIZE(ring_control->tx_data),
+				   priv->tx_buf_data);
 
-			pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
-					 le16_to_cpu(desc->len), PCI_DMA_TODEVICE);
+		tasklet_schedule(&priv->rx_tasklet);
 
-			desc->host_addr = 0;
-			desc->device_addr = 0;
-			desc->len = 0;
-			desc->flags = 0;
-
-			i++;
-			i %= ARRAY_SIZE(ring_control->tx_data);
-		}
-
-		i = priv->rx_idx;
-		i %= ARRAY_SIZE(ring_control->rx_data);
-		priv->rx_idx = idx = le32_to_cpu(ring_control->device_idx[0]);
-		idx %= ARRAY_SIZE(ring_control->rx_data);
-		while (i != idx) {
-			u16 len;
-			struct sk_buff *skb;
-			desc = &ring_control->rx_data[i];
-			len = le16_to_cpu(desc->len);
-			skb = priv->rx_buf[i];
-
-			skb_put(skb, len);
-
-			if (p54_rx(dev, skb)) {
-				pci_unmap_single(priv->pdev,
-						 le32_to_cpu(desc->host_addr),
-						 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
-
-				priv->rx_buf[i] = NULL;
-				desc->host_addr = 0;
-			} else {
-				skb_trim(skb, 0);
-				desc->len = cpu_to_le16(MAX_RX_SIZE);
-			}
-
-			i++;
-			i %= ARRAY_SIZE(ring_control->rx_data);
-		}
-
-		p54p_refill_rx_ring(dev);
-
-		wmb();
-		P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
 	} else if (reg & cpu_to_le32(ISL38XX_INT_IDENT_INIT))
 		complete(&priv->boot_comp);
 
@@ -392,7 +438,7 @@ static void p54p_tx(struct ieee80211_hw 
 	ring_control->host_idx[1] = cpu_to_le32(idx + 1);
 
 	if (free_on_tx)
-		priv->tx_buf[i] = data;
+		priv->tx_buf_data[i] = data;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -420,8 +466,14 @@ static int p54p_open(struct ieee80211_hw
 	}
 
 	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
-	priv->rx_idx = priv->tx_idx = 0;
-	p54p_refill_rx_ring(dev);
+	priv->rx_idx_data = priv->tx_idx_data = 0;
+	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
+
+	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
+		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
+
+	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
+		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
 
 	p54p_upload_firmware(dev);
 
@@ -465,6 +517,8 @@ static void p54p_stop(struct ieee80211_h
 	unsigned int i;
 	struct p54p_desc *desc;
 
+	tasklet_kill(&priv->rx_tasklet);
+
 	P54P_WRITE(int_enable, cpu_to_le32(0));
 	P54P_READ(int_enable);
 	udelay(10);
@@ -473,26 +527,51 @@ static void p54p_stop(struct ieee80211_h
 
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
 
-	for (i = 0; i < ARRAY_SIZE(priv->rx_buf); i++) {
+	for (i = 0; i < ARRAY_SIZE(priv->rx_buf_data); i++) {
 		desc = &ring_control->rx_data[i];
 		if (desc->host_addr)
-			pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
+					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+		kfree_skb(priv->rx_buf_data[i]);
+		priv->rx_buf_data[i] = NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(priv->rx_buf_mgmt); i++) {
+		desc = &ring_control->rx_mgmt[i];
+		if (desc->host_addr)
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
 					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
-		kfree_skb(priv->rx_buf[i]);
-		priv->rx_buf[i] = NULL;
+		kfree_skb(priv->rx_buf_mgmt[i]);
+		priv->rx_buf_mgmt[i] = NULL;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(priv->tx_buf); i++) {
+	for (i = 0; i < ARRAY_SIZE(priv->tx_buf_data); i++) {
 		desc = &ring_control->tx_data[i];
 		if (desc->host_addr)
-			pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
-					 le16_to_cpu(desc->len), PCI_DMA_TODEVICE);
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
+					 le16_to_cpu(desc->len),
+					 PCI_DMA_TODEVICE);
 
-		kfree(priv->tx_buf[i]);
-		priv->tx_buf[i] = NULL;
+		kfree(priv->tx_buf_data[i]);
+		priv->tx_buf_data[i] = NULL;
 	}
 
-	memset(ring_control, 0, sizeof(ring_control));
+	for (i = 0; i < ARRAY_SIZE(priv->tx_buf_mgmt); i++) {
+		desc = &ring_control->tx_mgmt[i];
+		if (desc->host_addr)
+			pci_unmap_single(priv->pdev,
+					 le32_to_cpu(desc->host_addr),
+					 le16_to_cpu(desc->len),
+					 PCI_DMA_TODEVICE);
+
+		kfree(priv->tx_buf_mgmt[i]);
+		priv->tx_buf_mgmt[i] = NULL;
+	}
+
+	memset(ring_control, 0, sizeof(*ring_control));
 }
 
 static int __devinit p54p_probe(struct pci_dev *pdev,
@@ -585,6 +664,7 @@ static int __devinit p54p_probe(struct p
 	priv->common.tx = p54p_tx;
 
 	spin_lock_init(&priv->lock);
+	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
diff -Nurp a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
--- a/drivers/net/wireless/p54/p54pci.h	2008-08-24 02:13:44.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.h	2008-08-24 21:52:29.000000000 +0200
@@ -92,13 +92,17 @@ struct p54p_priv {
 	struct p54_common common;
 	struct pci_dev *pdev;
 	struct p54p_csr __iomem *map;
+	struct tasklet_struct rx_tasklet;
 
 	spinlock_t lock;
 	struct p54p_ring_control *ring_control;
 	dma_addr_t ring_control_dma;
-	u32 rx_idx, tx_idx;
-	struct sk_buff *rx_buf[8];
-	void *tx_buf[32];
+	u32 rx_idx_data, tx_idx_data;
+	u32 rx_idx_mgmt, tx_idx_mgmt;
+	struct sk_buff *rx_buf_data[8];
+	struct sk_buff *rx_buf_mgmt[4];
+	void *tx_buf_data[32];
+	void *tx_buf_mgmt[4];
 	struct completion boot_comp;
 };
 

