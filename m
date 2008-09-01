Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50366 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbYIAUpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2008 16:45:36 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54: enhance firmware parser to reduce memory waste
Date: Mon, 1 Sep 2008 22:48:41 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809012248.42259.chunkeey@web.de> (sfid-20080901_224559_015979_C3D40FC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch greatly reduces one of biggest memory waste in the driver.
 
The firmware headers provides the right values for extra head-/tailroom
and mtu size which are usually much lower than the old hardcoded ones.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

this is another batch of patches for wireless-next ;-)
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-08-31 21:15:41.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-01 21:33:22.000000000 +0200
@@ -66,8 +66,7 @@ static struct ieee80211_supported_band b
 	.n_bitrates = ARRAY_SIZE(p54_rates),
 };
 
-
-void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
+int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 {
 	struct p54_common *priv = dev->priv;
 	struct bootrec_exp_if *exp_if;
@@ -79,7 +78,7 @@ void p54_parse_firmware(struct ieee80211
 	int i;
 
 	if (priv->rx_start)
-		return;
+		return 0;
 
 	while (data < end_data && *data)
 		data++;
@@ -117,11 +116,22 @@ void p54_parse_firmware(struct ieee80211
 			if (strnlen((unsigned char*)bootrec->data, 24) < 24)
 				fw_version = (unsigned char*)bootrec->data;
 			break;
-		case BR_CODE_DESCR:
-			priv->rx_start = le32_to_cpu(((__le32 *)bootrec->data)[1]);
+		case BR_CODE_DESCR: {
+			struct bootrec_desc *desc =
+				(struct bootrec_desc *)bootrec->data;
+			priv->rx_start = le32_to_cpu(desc->rx_start);
 			/* FIXME add sanity checking */
-			priv->rx_end = le32_to_cpu(((__le32 *)bootrec->data)[2]) - 0x3500;
+			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
+			priv->headroom = desc->headroom;
+			priv->tailroom = desc->tailroom;
+			if (bootrec->len == 11)
+				priv->rx_mtu = (size_t) le16_to_cpu(
+					(__le16)bootrec->data[10]);
+			else
+				priv->rx_mtu = (size_t) 
+					0x620 - priv->tx_hdr_len;
 			break;
+			}
 		case BR_CODE_EXPOSED_IF:
 			exp_if = (struct bootrec_exp_if *) bootrec->data;
 			for (i = 0; i < (len * sizeof(*exp_if) / 4); i++)
@@ -152,6 +162,8 @@ void p54_parse_firmware(struct ieee80211
 		priv->tx_stats[7].limit = 1;
 		dev->queues = 4;
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
 
@@ -428,7 +440,7 @@ static void p54_rx_frame_sent(struct iee
 	struct p54_control_hdr *hdr = (struct p54_control_hdr *) skb->data;
 	struct p54_frame_sent_hdr *payload = (struct p54_frame_sent_hdr *) hdr->data;
 	struct sk_buff *entry = (struct sk_buff *) priv->tx_queue.next;
-	u32 addr = le32_to_cpu(hdr->req_id) - 0x70;
+	u32 addr = le32_to_cpu(hdr->req_id) - priv->headroom;
 	struct memrecord *range = NULL;
 	u32 freed = 0;
 	u32 last_addr = priv->rx_start;
@@ -550,7 +562,7 @@ static void p54_assign_address(struct ie
 	u32 target_addr = priv->rx_start;
 	unsigned long flags;
 	unsigned int left;
-	len = (len + 0x170 + 3) & ~0x3; /* 0x70 headroom, 0x100 tailroom */
+	len = (len + priv->headroom + priv->tailroom + 3) & ~0x3;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	left = skb_queue_len(&priv->tx_queue);
@@ -585,13 +597,14 @@ static void p54_assign_address(struct ie
 		range->start_addr = target_addr;
 		range->end_addr = target_addr + len;
 		__skb_queue_after(&priv->tx_queue, target_skb, skb);
-		if (largest_hole < IEEE80211_MAX_RTS_THRESHOLD + 0x170 +
+		if (largest_hole < priv->rx_mtu + priv->headroom +
+				   priv->tailroom + 
 				   sizeof(struct p54_control_hdr))
 			ieee80211_stop_queues(dev);
 	}
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
-	data->req_id = cpu_to_le32(target_addr + 0x70);
+	data->req_id = cpu_to_le32(target_addr + priv->headroom);
 }
 
 static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
@@ -704,7 +717,7 @@ static int p54_set_filter(struct ieee802
 	filter->antenna = antenna;
 	filter->magic3 = cpu_to_le32(magic3);
 	filter->rx_addr = cpu_to_le32(priv->rx_end);
-	filter->max_rx = cpu_to_le16(0x0620);	/* FIXME: for usb ver 1.. maybe */
+	filter->max_rx = cpu_to_le16(priv->rx_mtu);
 	filter->rxhw = priv->rxhw;
 	filter->magic8 = cpu_to_le16(magic8);
 	filter->magic9 = cpu_to_le16(magic9);
@@ -1081,7 +1094,6 @@ struct ieee80211_hw *p54_init_common(siz
 	priv->tx_stats[3].limit = 1;
 	priv->tx_stats[4].limit = 5;
 	dev->queues = 1;
-
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-08-31 21:15:41.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-08-31 22:35:47.000000000 +0200
@@ -29,6 +29,17 @@ struct bootrec_exp_if {
 	__le16 top_compat;
 } __attribute__((packed));
 
+struct bootrec_desc {
+	__le16 modes;
+	__le16 flags;
+	__le32 rx_start;
+	__le32 rx_end;
+	u8 headroom;
+	u8 tailroom;
+	u8 unimportant[6];
+	u8 rates[16];
+} __attribute__((packed));
+
 #define BR_CODE_MIN			0x80000000
 #define BR_CODE_COMPONENT_ID		0x80000001
 #define BR_CODE_COMPONENT_VERSION	0x80000002
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-08-31 21:15:41.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-08-31 22:57:53.000000000 +0200
@@ -39,7 +39,6 @@ struct p54_control_hdr {
 } __attribute__ ((packed));
 
 #define EEPROM_READBACK_LEN (sizeof(struct p54_control_hdr) + 4 /* p54_eeprom_lm86 */)
-#define MAX_RX_SIZE (IEEE80211_MAX_RTS_THRESHOLD + sizeof(struct p54_control_hdr) + 20 /* length of struct p54_rx_hdr */ + 16 )
 
 #define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
 
@@ -53,6 +52,9 @@ struct p54_common {
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
 	u16 seqno;
+	u16 rx_mtu;
+	u8 headroom;
+	u8 tailroom;
 	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
@@ -70,7 +72,7 @@ struct p54_common {
 };
 
 int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
-void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw);
+int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw);
 int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len);
 void p54_fill_eeprom_readback(struct p54_control_hdr *hdr);
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-08-31 21:47:02.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-09-01 02:29:58.000000000 +0200
@@ -81,7 +81,11 @@ static int p54p_upload_firmware(struct i
 		return err;
 	}
 
-	p54_parse_firmware(dev, fw_entry);
+	err = p54_parse_firmware(dev, fw_entry);
+	if (err) {                                                           
+		release_firmware(fw_entry);                                                                        
+		return err;                                                                                        
+	}
 
 	data = (__le32 *) fw_entry->data;
 	remains = fw_entry->size;
@@ -258,17 +262,17 @@ static void p54p_refill_rx_ring(struct i
 		if (!desc->host_addr) {
 			struct sk_buff *skb;
 			dma_addr_t mapping;
-			skb = dev_alloc_skb(MAX_RX_SIZE);
+			skb = dev_alloc_skb(priv->common.rx_mtu + 32);
 			if (!skb)
 				break;
 
 			mapping = pci_map_single(priv->pdev,
 						 skb_tail_pointer(skb),
-						 MAX_RX_SIZE,
+						 priv->common.rx_mtu + 32,
 						 PCI_DMA_FROMDEVICE);
 			desc->host_addr = cpu_to_le32(mapping);
 			desc->device_addr = 0;	// FIXME: necessary?
-			desc->len = cpu_to_le16(MAX_RX_SIZE);
+			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
 			desc->flags = 0;
 			rx_buf[i] = skb;
 		}
@@ -311,12 +315,13 @@ static void p54p_check_rx_ring(struct ie
 		if (p54_rx(dev, skb)) {
 			pci_unmap_single(priv->pdev,
 					 le32_to_cpu(desc->host_addr),
-					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+					 priv->common.rx_mtu + 32,
+					 PCI_DMA_FROMDEVICE);
 			rx_buf[i] = NULL;
 			desc->host_addr = 0;
 		} else {
 			skb_trim(skb, 0);
-			desc->len = cpu_to_le16(MAX_RX_SIZE);
+			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
 		}
 
 		i++;
@@ -534,7 +539,8 @@ static void p54p_stop(struct ieee80211_h
 		if (desc->host_addr)
 			pci_unmap_single(priv->pdev,
 					 le32_to_cpu(desc->host_addr),
-					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+					 priv->common.rx_mtu + 32,
+					 PCI_DMA_FROMDEVICE);
 		kfree_skb(priv->rx_buf_data[i]);
 		priv->rx_buf_data[i] = NULL;
 	}
@@ -544,7 +550,8 @@ static void p54p_stop(struct ieee80211_h
 		if (desc->host_addr)
 			pci_unmap_single(priv->pdev,
 					 le32_to_cpu(desc->host_addr),
-					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+					 priv->common.rx_mtu + 32,
+					 PCI_DMA_FROMDEVICE);
 		kfree_skb(priv->rx_buf_mgmt[i]);
 		priv->rx_buf_mgmt[i] = NULL;
 	}
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-08-31 21:15:41.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-09-01 02:33:46.000000000 +0200
@@ -95,7 +95,7 @@ static void p54u_rx_cb(struct urb *urb)
 		skb_pull(skb, sizeof(struct net2280_tx_hdr));
 
 	if (p54_rx(dev, skb)) {
-		skb = dev_alloc_skb(MAX_RX_SIZE);
+		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
 		if (unlikely(!skb)) {
 			usb_free_urb(urb);
 			/* TODO check rx queue length and refill *somewhere* */
@@ -145,7 +145,7 @@ static int p54u_init_urbs(struct ieee802
 	struct p54u_rx_info *info;
 
 	while (skb_queue_len(&priv->rx_queue) < 32) {
-		skb = __dev_alloc_skb(MAX_RX_SIZE, GFP_KERNEL);
+		skb = __dev_alloc_skb(priv->common.rx_mtu + 32, GFP_KERNEL);
 		if (!skb)
 			break;
 		entry = usb_alloc_urb(0, GFP_KERNEL);
@@ -153,7 +153,10 @@ static int p54u_init_urbs(struct ieee802
 			kfree_skb(skb);
 			break;
 		}
-		usb_fill_bulk_urb(entry, priv->udev, usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA), skb_tail_pointer(skb), MAX_RX_SIZE, p54u_rx_cb, skb);
+		usb_fill_bulk_urb(entry, priv->udev,
+				  usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA),
+				  skb_tail_pointer(skb),
+				  priv->common.rx_mtu + 32, p54u_rx_cb, skb);
 		info = (struct p54u_rx_info *) skb->cb;
 		info->urb = entry;
 		info->dev = dev;
@@ -412,7 +415,9 @@ static int p54u_upload_firmware_3887(str
 		goto err_req_fw_failed;
 	}
 
-	p54_parse_firmware(dev, fw_entry);
+	err = p54_parse_firmware(dev, fw_entry);
+	if (err)
+		goto err_upload_failed;
 
 	left = block_size = min((size_t)P54U_FW_BLOCK, fw_entry->size);
 	strcpy(buf, start_string);
@@ -549,7 +554,12 @@ static int p54u_upload_firmware_net2280(
 		return err;
 	}
 
-	p54_parse_firmware(dev, fw_entry);
+	err = p54_parse_firmware(dev, fw_entry);
+	if (err) {
+		kfree(buf);
+		release_firmware(fw_entry);
+		return err;
+	}
 
 #define P54U_WRITE(type, addr, data) \
 	do {\

