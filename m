Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44044 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbYIAUpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2008 16:45:45 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] p54: move eeprom code into common library
Date: Mon, 1 Sep 2008 22:48:51 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809012248.51561.chunkeey@web.de> (sfid-20080901_224600_901821_F4B9DE9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both p54pci and p54usb uses a good chunk of device specific code to
get the data from the device's eeprom into the drivers memory.

So, this patch reduces the code size and will it make life easier if
someone wants to implement ethtool eeprom dumping features. 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-01 21:33:22.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-01 22:23:17.000000000 +0200
@@ -249,6 +249,9 @@ static int p54_convert_rev1(struct ieee8
 	return 0;
 }
 
+const char* p54_rf_chips[] = { "NULL", "Indigo?", "Duette",
+                              "Frisbee", "Xbow", "Longbow" };
+
 int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
@@ -258,6 +261,7 @@ int p54_parse_eeprom(struct ieee80211_hw
 	void *tmp;
 	int err;
 	u8 *end = (u8 *)eeprom + len;
+	DECLARE_MAC_BUF(mac);
 
 	wrap = (struct eeprom_pda_wrap *) eeprom;
 	entry = (void *)wrap->data + le16_to_cpu(wrap->len);
@@ -339,7 +343,7 @@ int p54_parse_eeprom(struct ieee80211_hw
 			while ((u8 *)tmp < entry->data + data_len) {
 				struct bootrec_exp_if *exp_if = tmp;
 				if (le16_to_cpu(exp_if->if_id) == 0xF)
-					priv->rxhw = exp_if->variant & cpu_to_le16(0x07);
+					priv->rxhw = le16_to_cpu(exp_if->variant) & 0x07;
 				tmp += sizeof(struct bootrec_exp_if);
 			}
 			break;
@@ -365,6 +369,37 @@ int p54_parse_eeprom(struct ieee80211_hw
 		goto err;
 	}
 
+	switch (priv->rxhw) {
+		case 4: /* XBow */	
+		case 1: /* Indigo? */
+		case 2: /* Duette */
+			/* TODO: 5GHz initialization goes here */
+
+		case 3: /* Frisbee */
+		case 5: /* Longbow */
+			dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
+			break;
+		default:
+			printk(KERN_ERR "%s: unsupported RF-Chip\n",
+				wiphy_name(dev->wiphy));
+			err = -EINVAL;
+			goto err;
+	}
+
+	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
+		u8 perm_addr[ETH_ALEN];
+
+		printk(KERN_WARNING "%s: Invalid hwaddr! Using randomly generated MAC addr\n",
+			wiphy_name(dev->wiphy));
+		random_ether_addr(perm_addr);
+		SET_IEEE80211_PERM_ADDR(dev, perm_addr);
+	}
+
+	printk(KERN_INFO "%s: hwaddr %s, MAC:isl38%02x RF:%s\n",
+		wiphy_name(dev->wiphy),
+		print_mac(mac, dev->wiphy->perm_addr),
+		priv->version, p54_rf_chips[priv->rxhw]);
+
 	return 0;
 
   err:
@@ -388,20 +423,6 @@ int p54_parse_eeprom(struct ieee80211_hw
 }
 EXPORT_SYMBOL_GPL(p54_parse_eeprom);
 
-void p54_fill_eeprom_readback(struct p54_control_hdr *hdr)
-{
-	struct p54_eeprom_lm86 *eeprom_hdr;
-
-	hdr->magic1 = cpu_to_le16(0x8000);
-	hdr->len = cpu_to_le16(sizeof(*eeprom_hdr) + 0x2000);
-	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_EEPROM_READBACK);
-	hdr->retry1 = hdr->retry2 = 0;
-	eeprom_hdr = (struct p54_eeprom_lm86 *) hdr->data;
-	eeprom_hdr->offset = 0x0;
-	eeprom_hdr->len = cpu_to_le16(0x2000);
-}
-EXPORT_SYMBOL_GPL(p54_fill_eeprom_readback);
-
 static void p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_rx_hdr *hdr = (struct p54_rx_hdr *) skb->data;
@@ -499,6 +520,21 @@ out:
 		p54_wake_free_queues(dev);
 }
 
+static void p54_rx_eeprom_readback(struct ieee80211_hw *dev,
+				   struct sk_buff *skb)
+{
+	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
+	struct p54_eeprom_lm86 *eeprom = (struct p54_eeprom_lm86 *) hdr->data;
+	struct p54_common *priv = dev->priv;
+
+	if (!priv->eeprom)
+		return ;
+
+	memcpy(priv->eeprom, eeprom->data, eeprom->len);
+
+	complete(&priv->eeprom_comp);
+}
+
 static void p54_rx_control(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
@@ -509,6 +545,9 @@ static void p54_rx_control(struct ieee80
 		break;
 	case P54_CONTROL_TYPE_BBP:
 		break;
+	case P54_CONTROL_TYPE_EEPROM_READBACK:
+		p54_rx_eeprom_readback(dev, skb);
+		break;
 	default:
 		printk(KERN_DEBUG "%s: not handling 0x%02x type control frame\n",
 		       wiphy_name(dev->wiphy), le16_to_cpu(hdr->type));
@@ -607,6 +646,64 @@ static void p54_assign_address(struct ie
 	data->req_id = cpu_to_le32(target_addr + priv->headroom);
 }
 
+int p54_read_eeprom(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_control_hdr *hdr = NULL;
+	struct p54_eeprom_lm86 *eeprom_hdr;
+	size_t eeprom_size = 0x2020, offset = 0, blocksize;
+	int ret = -ENOMEM;
+	void *eeprom = NULL;
+
+	hdr = (struct p54_control_hdr *)kzalloc(sizeof(*hdr) +
+		sizeof(*eeprom_hdr) + EEPROM_READBACK_LEN, GFP_KERNEL);
+	if (!hdr)
+		goto free;
+
+	priv->eeprom = kzalloc(EEPROM_READBACK_LEN, GFP_KERNEL);
+	if (!priv->eeprom)
+		goto free;
+
+	eeprom = kzalloc(eeprom_size, GFP_KERNEL);
+	if (!eeprom)
+		goto free;
+
+	hdr->magic1 = cpu_to_le16(0x8000);
+	hdr->type = cpu_to_le16(P54_CONTROL_TYPE_EEPROM_READBACK);
+	hdr->retry1 = hdr->retry2 = 0;
+	eeprom_hdr = (struct p54_eeprom_lm86 *) hdr->data;
+
+	while (eeprom_size) {
+		blocksize = min(eeprom_size, (size_t)EEPROM_READBACK_LEN);
+		hdr->len = cpu_to_le16(blocksize + sizeof(*eeprom_hdr));
+		eeprom_hdr->offset = cpu_to_le16(offset);
+		eeprom_hdr->len = cpu_to_le16(blocksize);
+		p54_assign_address(dev, NULL, hdr, hdr->len + sizeof(*hdr));
+	        priv->tx(dev, hdr, hdr->len + sizeof(*hdr), 0);
+
+		if (!wait_for_completion_interruptible_timeout(&priv->eeprom_comp, HZ)) {
+			printk(KERN_ERR "%s: device does not respond!\n",
+				wiphy_name(dev->wiphy));
+			ret = -EBUSY;
+			goto free;
+	        }
+
+		memcpy(eeprom + offset, priv->eeprom, blocksize);
+		offset += blocksize;
+		eeprom_size -= blocksize;
+	}
+
+	ret = p54_parse_eeprom(dev, eeprom, offset);
+free:
+	kfree(priv->eeprom);
+	priv->eeprom = NULL;
+	kfree(hdr);
+	kfree(eeprom);
+
+	return ret;	
+}
+EXPORT_SYMBOL_GPL(p54_read_eeprom);
+
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -718,7 +815,7 @@ static int p54_set_filter(struct ieee802
 	filter->magic3 = cpu_to_le32(magic3);
 	filter->rx_addr = cpu_to_le32(priv->rx_end);
 	filter->max_rx = cpu_to_le16(priv->rx_mtu);
-	filter->rxhw = priv->rxhw;
+	filter->rxhw = cpu_to_le16(priv->rxhw);
 	filter->magic8 = cpu_to_le16(magic8);
 	filter->magic9 = cpu_to_le16(magic9);
 
@@ -1081,7 +1178,6 @@ struct ieee80211_hw *p54_init_common(siz
 	priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_INVALID;
 	skb_queue_head_init(&priv->tx_queue);
-	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
 		     IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_SIGNAL_UNSPEC;
@@ -1098,6 +1194,7 @@ struct ieee80211_hw *p54_init_common(siz
 				 sizeof(struct p54_tx_control_allocdata);
 
 	mutex_init(&priv->conf_mutex);
+	init_completion(&priv->eeprom_comp);
 
 	return dev;
 }
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-08-31 22:57:53.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-09-01 02:20:25.000000000 +0200
@@ -38,7 +38,7 @@ struct p54_control_hdr {
 	u8 data[0];
 } __attribute__ ((packed));
 
-#define EEPROM_READBACK_LEN (sizeof(struct p54_control_hdr) + 4 /* p54_eeprom_lm86 */)
+#define EEPROM_READBACK_LEN 0x3fc
 
 #define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
 
@@ -63,18 +63,19 @@ struct p54_common {
 	struct pda_channel_output_limit *output_limit;
 	unsigned int output_limit_len;
 	struct pda_pa_curve_data *curve_data;
-	__le16 rxhw;
+	u16 rxhw;
 	u8 version;
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;
 	struct ieee80211_tx_queue_stats tx_stats[8];
+	void *eeprom;
+	struct completion eeprom_comp;
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
 int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw);
-int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len);
-void p54_fill_eeprom_readback(struct p54_control_hdr *hdr);
+int p54_read_eeprom(struct ieee80211_hw *dev);
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
 void p54_free_common(struct ieee80211_hw *dev);
 
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-09-01 02:29:58.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-09-01 22:23:34.000000000 +0200
@@ -72,8 +72,6 @@ static int p54p_upload_firmware(struct i
 	P54P_WRITE(ctrl_stat, reg);
 	wmb();
 
-	mdelay(50);
-
 	err = request_firmware(&fw_entry, "isl3886", &priv->pdev->dev);
 	if (err) {
 		printk(KERN_ERR "%s (p54pci): cannot find firmware "
@@ -126,120 +124,10 @@ static int p54p_upload_firmware(struct i
 	wmb();
 	udelay(10);
 
-	return 0;
-}
-
-static irqreturn_t p54p_simple_interrupt(int irq, void *dev_id)
-{
-	struct p54p_priv *priv = (struct p54p_priv *) dev_id;
-	__le32 reg;
-
-	reg = P54P_READ(int_ident);
-	P54P_WRITE(int_ack, reg);
-
-	if (reg & P54P_READ(int_enable))
-		complete(&priv->boot_comp);
-
-	return IRQ_HANDLED;
-}
-
-static int p54p_read_eeprom(struct ieee80211_hw *dev)
-{
-	struct p54p_priv *priv = dev->priv;
-	struct p54p_ring_control *ring_control = priv->ring_control;
-	int err;
-	struct p54_control_hdr *hdr;
-	void *eeprom;
-	dma_addr_t rx_mapping, tx_mapping;
-	u16 alen;
-
-	init_completion(&priv->boot_comp);
-	err = request_irq(priv->pdev->irq, &p54p_simple_interrupt,
-			  IRQF_SHARED, "p54pci", priv);
-	if (err) {
-		printk(KERN_ERR "%s (p54pci): failed to register IRQ handler\n",
-		       pci_name(priv->pdev));
-		return err;
-	}
-
-	eeprom = kmalloc(0x2010 + EEPROM_READBACK_LEN, GFP_KERNEL);
-	if (!eeprom) {
-		printk(KERN_ERR "%s (p54pci): no memory for eeprom!\n",
-		       pci_name(priv->pdev));
-		err = -ENOMEM;
-		goto out;
-	}
-
-	memset(ring_control, 0, sizeof(*ring_control));
-	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
-	P54P_READ(ring_control_base);
-	udelay(10);
-
-	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_INIT));
-	P54P_READ(int_enable);
-	udelay(10);
-
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
-
-	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
-		printk(KERN_ERR "%s (p54pci): Cannot boot firmware!\n",
-		       pci_name(priv->pdev));
-		err = -EINVAL;
-		goto out;
-	}
-
-	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
-	P54P_READ(int_enable);
-
-	hdr = eeprom + 0x2010;
-	p54_fill_eeprom_readback(hdr);
-	hdr->req_id = cpu_to_le32(priv->common.rx_start);
-
-	rx_mapping = pci_map_single(priv->pdev, eeprom,
-				    0x2010, PCI_DMA_FROMDEVICE);
-	tx_mapping = pci_map_single(priv->pdev, (void *)hdr,
-				    EEPROM_READBACK_LEN, PCI_DMA_TODEVICE);
-
-	ring_control->rx_mgmt[0].host_addr = cpu_to_le32(rx_mapping);
-	ring_control->rx_mgmt[0].len = cpu_to_le16(0x2010);
-	ring_control->tx_data[0].host_addr = cpu_to_le32(tx_mapping);
-	ring_control->tx_data[0].device_addr = hdr->req_id;
-	ring_control->tx_data[0].len = cpu_to_le16(EEPROM_READBACK_LEN);
-
-	ring_control->host_idx[2] = cpu_to_le32(1);
-	ring_control->host_idx[1] = cpu_to_le32(1);
-
-	wmb();
+	/* wait for the firmware to boot properly */
 	mdelay(100);
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
-
-	wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ);
-	wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ);
 
-	pci_unmap_single(priv->pdev, tx_mapping,
-			 EEPROM_READBACK_LEN, PCI_DMA_TODEVICE);
-	pci_unmap_single(priv->pdev, rx_mapping,
-			 0x2010, PCI_DMA_FROMDEVICE);
-
-	alen = le16_to_cpu(ring_control->rx_mgmt[0].len);
-	if (le32_to_cpu(ring_control->device_idx[2]) != 1 ||
-	    alen < 0x10) {
-		printk(KERN_ERR "%s (p54pci): Cannot read eeprom!\n",
-		       pci_name(priv->pdev));
-		err = -EINVAL;
-		goto out;
-	}
-
-	p54_parse_eeprom(dev, (u8 *)eeprom + 0x10, alen - 0x10);
-
- out:
-	kfree(eeprom);
-	P54P_WRITE(int_enable, cpu_to_le32(0));
-	P54P_READ(int_enable);
-	udelay(10);
-	free_irq(priv->pdev->irq, priv);
-	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
-	return err;
+	return 0;
 }
 
 static void p54p_refill_rx_ring(struct ieee80211_hw *dev,
@@ -473,6 +361,11 @@ static int p54p_open(struct ieee80211_hw
 	}
 
 	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
+	err = p54p_upload_firmware(dev);
+	if (err) {
+		free_irq(priv->pdev->irq, dev);
+		return err;
+	}
 	priv->rx_idx_data = priv->tx_idx_data = 0;
 	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
 
@@ -482,8 +375,6 @@ static int p54p_open(struct ieee80211_hw
 	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
 		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
 
-	p54p_upload_firmware(dev);
-
 	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
 	P54P_READ(ring_control_base);
 	wmb();
@@ -658,16 +549,6 @@ static int __devinit p54p_probe(struct p
 		err = -ENOMEM;
 		goto err_iounmap;
 	}
-	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
-
-	err = p54p_upload_firmware(dev);
-	if (err)
-		goto err_free_desc;
-
-	err = p54p_read_eeprom(dev);
-	if (err)
-		goto err_free_desc;
-
 	priv->common.open = p54p_open;
 	priv->common.stop = p54p_stop;
 	priv->common.tx = p54p_tx;
@@ -675,6 +556,12 @@ static int __devinit p54p_probe(struct p
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
 
+	p54p_open(dev);
+	err = p54_read_eeprom(dev);
+	p54p_stop(dev);
+	if (err)
+		goto err_free_desc;
+
 	err = ieee80211_register_hw(dev);
 	if (err) {
 		printk(KERN_ERR "%s (p54pci): Cannot register netdevice\n",
@@ -682,11 +569,6 @@ static int __devinit p54p_probe(struct p
 		goto err_free_common;
 	}
 
-	printk(KERN_INFO "%s: hwaddr %s, isl38%02x\n",
-	       wiphy_name(dev->wiphy),
-	       print_mac(mac, dev->wiphy->perm_addr),
-	       priv->common.version);
-
 	return 0;
 
  err_free_common:
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-09-01 02:33:46.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-09-01 22:23:46.000000000 +0200
@@ -315,73 +315,6 @@ static int p54u_bulk_msg(struct p54u_pri
 			    data, len, &alen, 2000);
 }
 
-static int p54u_read_eeprom(struct ieee80211_hw *dev)
-{
-	struct p54u_priv *priv = dev->priv;
-	void *buf;
-	struct p54_control_hdr *hdr;
-	int err, alen;
-	size_t offset = priv->hw_type ? 0x10 : 0x20;
-
-	buf = kmalloc(0x2020, GFP_KERNEL);
-	if (!buf) {
-		printk(KERN_ERR "p54usb: cannot allocate memory for "
-		       "eeprom readback!\n");
-		return -ENOMEM;
-	}
-
-	if (priv->hw_type) {
-		*((u32 *) buf) = priv->common.rx_start;
-		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, sizeof(u32));
-		if (err) {
-			printk(KERN_ERR "p54usb: addr send failed\n");
-			goto fail;
-		}
-	} else {
-		struct net2280_reg_write *reg = buf;
-		reg->port = cpu_to_le16(NET2280_DEV_U32);
-		reg->addr = cpu_to_le32(P54U_DEV_BASE);
-		reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
-		err = p54u_bulk_msg(priv, P54U_PIPE_DEV, buf, sizeof(*reg));
-		if (err) {
-			printk(KERN_ERR "p54usb: dev_int send failed\n");
-			goto fail;
-		}
-	}
-
-	hdr = buf + priv->common.tx_hdr_len;
-	p54_fill_eeprom_readback(hdr);
-	hdr->req_id = cpu_to_le32(priv->common.rx_start);
-	if (priv->common.tx_hdr_len) {
-		struct net2280_tx_hdr *tx_hdr = buf;
-		tx_hdr->device_addr = hdr->req_id;
-		tx_hdr->len = cpu_to_le16(EEPROM_READBACK_LEN);
-	}
-
-	/* we can just pretend to send 0x2000 bytes of nothing in the headers */
-	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf,
-			    EEPROM_READBACK_LEN + priv->common.tx_hdr_len);
-	if (err) {
-		printk(KERN_ERR "p54usb: eeprom req send failed\n");
-		goto fail;
-	}
-
-	err = usb_bulk_msg(priv->udev,
-			   usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
-			   buf, 0x2020, &alen, 1000);
-	if (!err && alen > offset) {
-		p54_parse_eeprom(dev, (u8 *)buf + offset, alen - offset);
-	} else {
-		printk(KERN_ERR "p54usb: eeprom read failed!\n");
-		err = -EINVAL;
-		goto fail;
-	}
-
- fail:
-	kfree(buf);
-	return err;
-}
-
 static int p54u_upload_firmware_3887(struct ieee80211_hw *dev)
 {
 	static char start_string[] = "~~~~<\r";
@@ -861,31 +794,20 @@ static int __devinit p54u_probe(struct u
 	if (err)
 		goto err_free_dev;
 
-	err = p54u_read_eeprom(dev);
+	skb_queue_head_init(&priv->rx_queue);
+
+	p54u_open(dev);
+	err = p54_read_eeprom(dev);
+	p54u_stop(dev);
 	if (err)
 		goto err_free_dev;
 
-	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
-		u8 perm_addr[ETH_ALEN];
-
-		printk(KERN_WARNING "p54usb: Invalid hwaddr! Using randomly generated MAC addr\n");
-		random_ether_addr(perm_addr);
-		SET_IEEE80211_PERM_ADDR(dev, perm_addr);
-	}
-
-	skb_queue_head_init(&priv->rx_queue);
-
 	err = ieee80211_register_hw(dev);
 	if (err) {
 		printk(KERN_ERR "p54usb: Cannot register netdevice\n");
 		goto err_free_dev;
 	}
 
-	printk(KERN_INFO "%s: hwaddr %s, isl38%02x\n",
-	       wiphy_name(dev->wiphy),
-	       print_mac(mac, dev->wiphy->perm_addr),
-	       priv->common.version);
-
 	return 0;
 
  err_free_dev:

