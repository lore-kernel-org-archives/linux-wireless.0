Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:39216 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbYLIUWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 15:22:07 -0500
Received: from smtp08.web.de (fmsmtp08.dlan.cinetic.de [172.20.5.216])
	by fmmailgate02.web.de (Postfix) with ESMTP id 2D27AF782F9F
	for <linux-wireless@vger.kernel.org>; Tue,  9 Dec 2008 21:22:06 +0100 (CET)
Received: from [129.13.72.197] (helo=blech.mobile)
	by smtp08.web.de with esmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226)
	id 1LA95p-0000Iq-00
	for linux-wireless@vger.kernel.org; Tue, 09 Dec 2008 21:22:05 +0100
Received: from localhost (localhost [127.0.0.1])
	by blech.mobile (Postfix) with ESMTP id 9A8E8114123
	for <linux-wireless@vger.kernel.org>; Tue,  9 Dec 2008 21:22:10 +0100 (CET)
Received: from blech.mobile ([127.0.0.1])
	by localhost (blech.mobile [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lC5WLSOPYDwd for <linux-wireless@vger.kernel.org>;
	Tue,  9 Dec 2008 21:22:08 +0100 (CET)
Received: from blech.mobile (blech.mobile [127.0.1.1])
	by blech.mobile (Postfix) with ESMTPS id 87865114125
	for <linux-wireless@vger.kernel.org>; Tue,  9 Dec 2008 21:22:08 +0100 (CET)
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC/RFT][PATCH] p54: remove free_on_tx parameter
Date: Tue, 9 Dec 2008 21:22:07 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812092122.07925.chunkeey@web.de> (sfid-20081209_212212_748334_E850977F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch simplifies the tx code a bit and will be necessary for
the upcoming stlc45xx<->p54 port.

roughly speaking: we no longer have to tell all backend drivers twice, if we
want to free a frame right after it was send to the firmware, or not.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-09 20:49:21.235888230 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-09 20:49:26.756375468 +0100
@@ -645,7 +645,7 @@ void p54_free_skb(struct ieee80211_hw *d
 		freed = priv->rx_end - last_addr;
 	__skb_unlink(skb, &priv->tx_queue);
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
-	kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 
 	if (freed >= priv->headroom + sizeof(struct p54_hdr) + 48 +
 		     IEEE80211_MAX_RTS_THRESHOLD + priv->tailroom)
@@ -1023,7 +1023,7 @@ int p54_read_eeprom(struct ieee80211_hw 
 			eeprom_hdr->v2.magic2 = 0xf;
 			memcpy(eeprom_hdr->v2.magic, (const char *)"LOCK", 4);
 		}
-		priv->tx(dev, skb, 0);
+		priv->tx(dev, skb);
 
 		if (!wait_for_completion_interruptible_timeout(&priv->eeprom_comp, HZ)) {
 			printk(KERN_ERR "%s: device does not respond!\n",
@@ -1064,7 +1064,7 @@ static int p54_set_tim(struct ieee80211_
 	tim = (struct p54_tim *) skb_put(skb, sizeof(*tim));
 	tim->count = 1;
 	tim->entry[0] = cpu_to_le16(set ? (sta->aid | 0x8000) : sta->aid);
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	return 0;
 }
 
@@ -1082,7 +1082,7 @@ static int p54_sta_unlock(struct ieee802
 
 	sta = (struct p54_sta_unlock *)skb_put(skb, sizeof(*sta));
 	memcpy(sta->addr, addr, ETH_ALEN);
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	return 0;
 }
 
@@ -1125,7 +1125,7 @@ static int p54_tx_cancel(struct ieee8021
 	hdr = (void *)entry->data;
 	cancel = (struct p54_txcancel *)skb_put(skb, sizeof(*cancel));
 	cancel->req_id = hdr->req_id;
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	return 0;
 }
 
@@ -1354,7 +1354,7 @@ static int p54_tx(struct ieee80211_hw *d
 	/* modifies skb->cb and with it info, so must be last! */
 	if (unlikely(p54_assign_address(dev, skb, hdr, skb->len + tim_len)))
 		goto err;
-	priv->tx(dev, skb, 0);
+	priv->tx(dev, skb);
 	return 0;
 
  err:
@@ -1429,7 +1429,7 @@ static int p54_setup_mac(struct ieee8021
 		setup->v2.lpf_bandwidth = cpu_to_le16(65535);
 		setup->v2.osc_start_delay = cpu_to_le16(65535);
 	}
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	return 0;
 }
 
@@ -1510,7 +1510,7 @@ static int p54_scan(struct ieee80211_hw 
 		chan->v2.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
 		memset(chan->v2.rts_rates, 0, 8);
 	}
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	return 0;
 
  err:
@@ -1536,7 +1536,7 @@ static int p54_set_leds(struct ieee80211
 	led->led_permanent = cpu_to_le16(link);
 	led->led_temporary = cpu_to_le16(act);
 	led->duration = cpu_to_le16(1000);
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	return 0;
 }
 
@@ -1576,7 +1576,7 @@ static int p54_set_edcf(struct ieee80211
 	edcf->flags = 0;
 	memset(edcf->mapping, 0, sizeof(edcf->mapping));
 	memcpy(edcf->queue, priv->qos_params, sizeof(edcf->queue));
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	return 0;
 }
 
@@ -1886,7 +1886,7 @@ static int p54_init_xbow_synth(struct ie
 	xbow->magic2 = cpu_to_le16(0x2);
 	xbow->freq = cpu_to_le16(5390);
 	memset(xbow->padding, 0, sizeof(xbow->padding));
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	return 0;
 }
 
@@ -1897,7 +1897,7 @@ static void p54_statistics_timer(unsigne
 
 	BUG_ON(!priv->cached_stats);
 
-	priv->tx(dev, priv->cached_stats, 0);
+	priv->tx(dev, priv->cached_stats);
 }
 
 static int p54_get_stats(struct ieee80211_hw *dev,
@@ -2040,7 +2040,7 @@ static int p54_set_key(struct ieee80211_
 			[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY]), 8);
 	}
 
-	priv->tx(dev, skb, 1);
+	priv->tx(dev, skb);
 	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-07 22:04:45.956897502 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-07 22:04:45.944898560 +0100
@@ -84,9 +84,6 @@ struct bootrec_desc {
 #define BR_CODE_END_OF_BRA		0xFF0000FF
 #define LEGACY_BR_CODE_END_OF_BRA	0xFFFFFFFF
 
-#define P54_HDR_FLAG_CONTROL		BIT(15)
-#define P54_HDR_FLAG_CONTROL_OPSET	(BIT(15) + BIT(0))
-
 #define P54_HDR_FLAG_DATA_ALIGN		BIT(14)
 #define P54_HDR_FLAG_DATA_OUT_PROMISC	BIT(0)
 #define P54_HDR_FLAG_DATA_OUT_TIMESTAMP BIT(1)
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-12-07 22:04:45.952897552 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-12-09 17:46:17.988174098 +0100
@@ -44,6 +44,9 @@ enum p54_control_frame_types {
 	P54_CONTROL_TYPE_BT_OPTIONS = 35
 };
 
+#define P54_HDR_FLAG_CONTROL		BIT(15)
+#define P54_HDR_FLAG_CONTROL_OPSET	(BIT(15) + BIT(0))
+
 struct p54_hdr {
 	__le16 flags;
 	__le16 len;
@@ -54,6 +57,10 @@ struct p54_hdr {
 	u8 data[0];
 } __attribute__ ((packed));
 
+#define FREE_AFTER_TX(skb)						\
+	((((struct p54_hdr *) ((struct sk_buff *) skb)->data)->		\
+	flags) == cpu_to_le16(P54_HDR_FLAG_CONTROL_OPSET))
+
 struct p54_edcf_queue_param {
 	__le16 aifs;
 	__le16 cwmin;
@@ -74,8 +81,7 @@ struct p54_common {
 	u32 rx_start;
 	u32 rx_end;
 	struct sk_buff_head tx_queue;
-	void (*tx)(struct ieee80211_hw *dev, struct sk_buff *skb,
-		   int free_on_tx);
+	void (*tx)(struct ieee80211_hw *dev, struct sk_buff *skb);
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-12-07 22:04:45.952897552 +0100
+++ b/drivers/net/wireless/p54/p54pci.c	2008-12-07 22:04:45.936898241 +0100
@@ -227,7 +227,9 @@ static void p54p_check_tx_ring(struct ie
 
 	while (i != idx) {
 		desc = &ring[i];
-		p54_free_skb(dev, tx_buf[i]);
+		if (tx_buf[i])
+			if (FREE_AFTER_TX((struct sk_buff *) tx_buf[i]))
+				p54_free_skb(dev, tx_buf[i]);
 		tx_buf[i] = NULL;
 
 		pci_unmap_single(priv->pdev, le32_to_cpu(desc->host_addr),
@@ -298,8 +300,7 @@ static irqreturn_t p54p_interrupt(int ir
 	return reg ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
-		    int free_on_tx)
+static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
@@ -314,6 +315,7 @@ static void p54p_tx(struct ieee80211_hw 
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
 
+	priv->tx_buf_data[i] = skb;
 	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
 				 PCI_DMA_TODEVICE);
 	desc = &ring_control->tx_data[i];
@@ -324,10 +326,6 @@ static void p54p_tx(struct ieee80211_hw 
 
 	wmb();
 	ring_control->host_idx[1] = cpu_to_le32(idx + 1);
-
-	if (free_on_tx)
-		priv->tx_buf_data[i] = skb;
-
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_UPDATE));
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-12-09 17:07:37.814752970 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-12-09 17:50:05.828203629 +0100
@@ -138,22 +138,16 @@ static void p54u_rx_cb(struct urb *urb)
 	}
 }
 
-static void p54u_tx_reuse_skb_cb(struct urb *urb)
-{
-	struct sk_buff *skb = urb->context;
-	struct p54u_priv *priv = (struct p54u_priv *)((struct ieee80211_hw *)
-		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0)))->priv;
-
-	skb_pull(skb, priv->common.tx_hdr_len);
-}
-
-static void p54u_tx_free_skb_cb(struct urb *urb)
+static void p54u_tx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = urb->context;
 	struct ieee80211_hw *dev = (struct ieee80211_hw *)
 		usb_get_intfdata(usb_ifnum_to_if(urb->dev, 0));
+	struct p54u_priv *priv = dev->priv;
 
-	p54_free_skb(dev, skb);
+	skb_pull(skb, priv->common.tx_hdr_len);
+	if (FREE_AFTER_TX(skb))
+		p54_free_skb(dev, skb);
 }
 
 static void p54u_tx_dummy_cb(struct urb *urb) { }
@@ -213,8 +207,7 @@ static int p54u_init_urbs(struct ieee802
 	return ret;
 }
 
-static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb,
-			 int free_on_tx)
+static void p54u_tx_3887(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *addr_urb, *data_urb;
@@ -236,9 +229,7 @@ static void p54u_tx_3887(struct ieee8021
 			  p54u_tx_dummy_cb, dev);
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  skb->data, skb->len,
-			  free_on_tx ? p54u_tx_free_skb_cb :
-				       p54u_tx_reuse_skb_cb, skb);
+			  skb->data, skb->len, p54u_tx_cb, skb);
 
 	usb_anchor_urb(addr_urb, &priv->submitted);
 	err = usb_submit_urb(addr_urb, GFP_ATOMIC);
@@ -273,8 +264,7 @@ static __le32 p54u_lm87_chksum(const __l
 	return cpu_to_le32(chk);
 }
 
-static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb,
-			 int free_on_tx)
+static void p54u_tx_lm87(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *data_urb;
@@ -293,9 +283,7 @@ static void p54u_tx_lm87(struct ieee8021
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  skb->data, skb->len,
-			  free_on_tx ? p54u_tx_free_skb_cb :
-				       p54u_tx_reuse_skb_cb, skb);
+			  skb->data, skb->len, p54u_tx_cb, skb);
 
 	usb_anchor_urb(data_urb, &priv->submitted);
 	if (usb_submit_urb(data_urb, GFP_ATOMIC)) {
@@ -306,8 +294,7 @@ static void p54u_tx_lm87(struct ieee8021
 	usb_free_urb(data_urb);
 }
 
-static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
-			    int free_on_tx)
+static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct p54u_priv *priv = dev->priv;
 	struct urb *int_urb, *data_urb;
@@ -354,9 +341,7 @@ static void p54u_tx_net2280(struct ieee8
 
 	usb_fill_bulk_urb(data_urb, priv->udev,
 			  usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA),
-			  skb->data, skb->len,
-			  free_on_tx ? p54u_tx_free_skb_cb :
-				       p54u_tx_reuse_skb_cb, skb);
+			  skb->data, skb->len, p54u_tx_cb, skb);
 
 	usb_anchor_urb(int_urb, &priv->submitted);
 	err = usb_submit_urb(int_urb, GFP_ATOMIC);
