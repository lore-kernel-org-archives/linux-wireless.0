Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxsf08.insightbb.com ([74.128.0.78]:57246 "EHLO
	mxsf08.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbXKBFzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 01:55:40 -0400
From: Dmitry Torokhov <dtor@insightbb.com>
To: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] P54: use temporary variables to reduce size of generated code
Date: Fri, 2 Nov 2007 01:55:36 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711020155.36919.dtor@insightbb.com> (sfid-20071102_055546_806701_D90BC6F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

Please consider applying the patch below. It is done against tonight pull
from Linus and seems to be working fine here on a FullMAC card.

Thanks.

-- 
Dmitry

Subject: P54: use temporary variables to reduce size of generated code
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

When there are 2 linked structures, using a temporary variable to hold a pointer
to the often used structure usually produces better code (smaller and faster)
since compiler does not have to constantly re-fetch data from the first structure.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/net/wireless/p54pci.c |   77 ++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 36 deletions(-)

Index: work/drivers/net/wireless/p54pci.c
===================================================================
--- work.orig/drivers/net/wireless/p54pci.c
+++ work/drivers/net/wireless/p54pci.c
@@ -141,6 +141,7 @@ static irqreturn_t p54p_simple_interrupt
 static int p54p_read_eeprom(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
 	int err;
 	struct p54_control_hdr *hdr;
 	void *eeprom;
@@ -164,7 +165,7 @@ static int p54p_read_eeprom(struct ieee8
 		goto out;
 	}
 
-	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
+	memset(ring_control, 0, sizeof(*ring_control));
 	P54P_WRITE(ring_control_base, priv->ring_control_dma);
 	P54P_READ(ring_control_base);
 	udelay(10);
@@ -194,14 +195,14 @@ static int p54p_read_eeprom(struct ieee8
 	tx_mapping = pci_map_single(priv->pdev, (void *)hdr,
 				    EEPROM_READBACK_LEN, PCI_DMA_TODEVICE);
 
-	priv->ring_control->rx_mgmt[0].host_addr = cpu_to_le32(rx_mapping);
-	priv->ring_control->rx_mgmt[0].len = cpu_to_le16(0x2010);
-	priv->ring_control->tx_data[0].host_addr = cpu_to_le32(tx_mapping);
-	priv->ring_control->tx_data[0].device_addr = hdr->req_id;
-	priv->ring_control->tx_data[0].len = cpu_to_le16(EEPROM_READBACK_LEN);
+	ring_control->rx_mgmt[0].host_addr = cpu_to_le32(rx_mapping);
+	ring_control->rx_mgmt[0].len = cpu_to_le16(0x2010);
+	ring_control->tx_data[0].host_addr = cpu_to_le32(tx_mapping);
+	ring_control->tx_data[0].device_addr = hdr->req_id;
+	ring_control->tx_data[0].len = cpu_to_le16(EEPROM_READBACK_LEN);
 
-	priv->ring_control->host_idx[2] = cpu_to_le32(1);
-	priv->ring_control->host_idx[1] = cpu_to_le32(1);
+	ring_control->host_idx[2] = cpu_to_le32(1);
+	ring_control->host_idx[1] = cpu_to_le32(1);
 
 	wmb();
 	mdelay(100);
@@ -215,8 +216,8 @@ static int p54p_read_eeprom(struct ieee8
 	pci_unmap_single(priv->pdev, rx_mapping,
 			 0x2010, PCI_DMA_FROMDEVICE);
 
-	alen = le16_to_cpu(priv->ring_control->rx_mgmt[0].len);
-	if (le32_to_cpu(priv->ring_control->device_idx[2]) != 1 ||
+	alen = le16_to_cpu(ring_control->rx_mgmt[0].len);
+	if (le32_to_cpu(ring_control->device_idx[2]) != 1 ||
 	    alen < 0x10) {
 		printk(KERN_ERR "%s (prism54pci): Cannot read eeprom!\n",
 		       pci_name(priv->pdev));
@@ -239,16 +240,17 @@ static int p54p_read_eeprom(struct ieee8
 static void p54p_refill_rx_ring(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
 	u32 limit, host_idx, idx;
 
-	host_idx = le32_to_cpu(priv->ring_control->host_idx[0]);
+	host_idx = le32_to_cpu(ring_control->host_idx[0]);
 	limit = host_idx;
-	limit -= le32_to_cpu(priv->ring_control->device_idx[0]);
-	limit = ARRAY_SIZE(priv->ring_control->rx_data) - limit;
+	limit -= le32_to_cpu(ring_control->device_idx[0]);
+	limit = ARRAY_SIZE(ring_control->rx_data) - limit;
 
-	idx = host_idx % ARRAY_SIZE(priv->ring_control->rx_data);
+	idx = host_idx % ARRAY_SIZE(ring_control->rx_data);
 	while (limit-- > 1) {
-		struct p54p_desc *desc = &priv->ring_control->rx_data[idx];
+		struct p54p_desc *desc = &ring_control->rx_data[idx];
 
 		if (!desc->host_addr) {
 			struct sk_buff *skb;
@@ -270,17 +272,18 @@ static void p54p_refill_rx_ring(struct i
 
 		idx++;
 		host_idx++;
-		idx %= ARRAY_SIZE(priv->ring_control->rx_data);
+		idx %= ARRAY_SIZE(ring_control->rx_data);
 	}
 
 	wmb();
-	priv->ring_control->host_idx[0] = cpu_to_le32(host_idx);
+	ring_control->host_idx[0] = cpu_to_le32(host_idx);
 }
 
 static irqreturn_t p54p_interrupt(int irq, void *dev_id)
 {
 	struct ieee80211_hw *dev = dev_id;
 	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
 	__le32 reg;
 
 	spin_lock(&priv->lock);
@@ -298,12 +301,12 @@ static irqreturn_t p54p_interrupt(int ir
 		struct p54p_desc *desc;
 		u32 idx, i;
 		i = priv->tx_idx;
-		i %= ARRAY_SIZE(priv->ring_control->tx_data);
-		priv->tx_idx = idx = le32_to_cpu(priv->ring_control->device_idx[1]);
-		idx %= ARRAY_SIZE(priv->ring_control->tx_data);
+		i %= ARRAY_SIZE(ring_control->tx_data);
+		priv->tx_idx = idx = le32_to_cpu(ring_control->device_idx[1]);
+		idx %= ARRAY_SIZE(ring_control->tx_data);
 
 		while (i != idx) {
-			desc = &priv->ring_control->tx_data[i];
+			desc = &ring_control->tx_data[i];
 			if (priv->tx_buf[i]) {
 				kfree(priv->tx_buf[i]);
 				priv->tx_buf[i] = NULL;
@@ -318,17 +321,17 @@ static irqreturn_t p54p_interrupt(int ir
 			desc->flags = 0;
 
 			i++;
-			i %= ARRAY_SIZE(priv->ring_control->tx_data);
+			i %= ARRAY_SIZE(ring_control->tx_data);
 		}
 
 		i = priv->rx_idx;
-		i %= ARRAY_SIZE(priv->ring_control->rx_data);
-		priv->rx_idx = idx = le32_to_cpu(priv->ring_control->device_idx[0]);
-		idx %= ARRAY_SIZE(priv->ring_control->rx_data);
+		i %= ARRAY_SIZE(ring_control->rx_data);
+		priv->rx_idx = idx = le32_to_cpu(ring_control->device_idx[0]);
+		idx %= ARRAY_SIZE(ring_control->rx_data);
 		while (i != idx) {
 			u16 len;
 			struct sk_buff *skb;
-			desc = &priv->ring_control->rx_data[i];
+			desc = &ring_control->rx_data[i];
 			len = le16_to_cpu(desc->len);
 			skb = priv->rx_buf[i];
 
@@ -347,7 +350,7 @@ static irqreturn_t p54p_interrupt(int ir
 			}
 
 			i++;
-			i %= ARRAY_SIZE(priv->ring_control->rx_data);
+			i %= ARRAY_SIZE(ring_control->rx_data);
 		}
 
 		p54p_refill_rx_ring(dev);
@@ -366,6 +369,7 @@ static void p54p_tx(struct ieee80211_hw 
 		    size_t len, int free_on_tx)
 {
 	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
 	unsigned long flags;
 	struct p54p_desc *desc;
 	dma_addr_t mapping;
@@ -373,19 +377,19 @@ static void p54p_tx(struct ieee80211_hw 
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	device_idx = le32_to_cpu(priv->ring_control->device_idx[1]);
-	idx = le32_to_cpu(priv->ring_control->host_idx[1]);
-	i = idx % ARRAY_SIZE(priv->ring_control->tx_data);
+	device_idx = le32_to_cpu(ring_control->device_idx[1]);
+	idx = le32_to_cpu(ring_control->host_idx[1]);
+	i = idx % ARRAY_SIZE(ring_control->tx_data);
 
 	mapping = pci_map_single(priv->pdev, data, len, PCI_DMA_TODEVICE);
-	desc = &priv->ring_control->tx_data[i];
+	desc = &ring_control->tx_data[i];
 	desc->host_addr = cpu_to_le32(mapping);
 	desc->device_addr = data->req_id;
 	desc->len = cpu_to_le16(len);
 	desc->flags = 0;
 
 	wmb();
-	priv->ring_control->host_idx[1] = cpu_to_le32(idx + 1);
+	ring_control->host_idx[1] = cpu_to_le32(idx + 1);
 
 	if (free_on_tx)
 		priv->tx_buf[i] = data;
@@ -397,7 +401,7 @@ static void p54p_tx(struct ieee80211_hw 
 
 	/* FIXME: unlikely to happen because the device usually runs out of
 	   memory before we fill the ring up, but we can make it impossible */
-	if (idx - device_idx > ARRAY_SIZE(priv->ring_control->tx_data) - 2)
+	if (idx - device_idx > ARRAY_SIZE(ring_control->tx_data) - 2)
 		printk(KERN_INFO "%s: tx overflow.\n", wiphy_name(dev->wiphy));
 }
 
@@ -457,6 +461,7 @@ static int p54p_open(struct ieee80211_hw
 static void p54p_stop(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
+	struct p54p_ring_control *ring_control = priv->ring_control;
 	unsigned int i;
 	struct p54p_desc *desc;
 
@@ -469,7 +474,7 @@ static void p54p_stop(struct ieee80211_h
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
 
 	for (i = 0; i < ARRAY_SIZE(priv->rx_buf); i++) {
-		desc = &priv->ring_control->rx_data[i];
+		desc = &ring_control->rx_data[i];
 		if (desc->host_addr)
 			pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
 					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
@@ -478,7 +483,7 @@ static void p54p_stop(struct ieee80211_h
 	}
 
 	for (i = 0; i < ARRAY_SIZE(priv->tx_buf); i++) {
-		desc = &priv->ring_control->tx_data[i];
+		desc = &ring_control->tx_data[i];
 		if (desc->host_addr)
 			pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
 					 le16_to_cpu(desc->len), PCI_DMA_TODEVICE);
@@ -487,7 +492,7 @@ static void p54p_stop(struct ieee80211_h
 		priv->tx_buf[i] = NULL;
 	}
 
-	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
+	memset(ring_control, 0, sizeof(ring_control));
 }
 
 static int __devinit p54p_probe(struct pci_dev *pdev,
