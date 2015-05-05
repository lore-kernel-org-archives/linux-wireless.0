Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:14559 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbbEEAty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 20:49:54 -0400
Date: Tue, 5 May 2015 02:49:49 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [PATCH 1/2] add mt7601u driver
Message-ID: <20150505024949.0a672dd1@north> (sfid-20150505_024959_006806_130957AE)
In-Reply-To: <1430734511.2013.18.camel@sipsolutions.net>
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
	<1430571690-9054-2-git-send-email-moorray3@wp.pl>
	<1430732248.2013.16.camel@sipsolutions.net>
	<20150504120401.30835e07@north>
	<1430734511.2013.18.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 04 May 2015 12:15:11 +0200, Johannes Berg wrote:
> On Mon, 2015-05-04 at 12:04 +0200, Jakub Kiciński wrote:
> 
> > > Don't know how your buffers are set up, but if the DMA engine consumes
> > > pages you could consider using paged RX instead of the memcpy().
> > 
> > DMA engine can concatenate multiple frames into a single USB bulk
> > transfer to a large continuous buffer.  There is no way to request 
> > any alignment of the frames within that large buffer so I think paged 
> > RX is not an option.
> 
> You could probably still do it because the networking stack only
> requires the *headers* to be aligned. But if they headers aren't in the
> skb->data (skb->head) then they'll be pulled into that by the network
> stack, where they'll be aligned.

I *think* I got it.  Would you care to take a look?  I basically
allocate a compound page with dev_alloc_pages() and run get_page() for
every fragment.

------>8-----------------------------------

diff --git a/dma.c b/dma.c
index e865cf8384a5..a92993a64aeb 100644
--- a/dma.c
+++ b/dma.c
@@ -16,6 +16,9 @@
 #include "usb.h"
 #include "trace.h"
 
+static int mt7601u_submit_rx_buf(struct mt7601u_dev *dev,
+				 struct mt7601u_dma_buf_rx *e, gfp_t gfp);
+
 static unsigned int ieee80211_get_hdrlen_from_buf(const u8 *data, unsigned len)
 {
 	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *)data;
@@ -60,7 +63,7 @@ mt7601u_rx_process_seg(struct mt7601u_dev *dev, u8 *data, u32 seg_len)
 {
 	struct sk_buff *skb;
 	struct mt7601u_rxwi *rxwi;
-	u32 fce_info;
+	u32 true_len, fce_info;
 
 	/* DMA_INFO field at the beginning of the segment contains only some of
 	 * the information, we need to read the FCE descriptor from the end.
@@ -86,11 +89,81 @@ mt7601u_rx_process_seg(struct mt7601u_dev *dev, u8 *data, u32 seg_len)
 	if (!skb)
 		return;
 
-	if (mt76_mac_process_rx(dev, skb, rxwi)) {
-		dev_kfree_skb(skb);
-		return;
+	true_len = mt76_mac_process_rx(dev, skb, skb->data, rxwi);
+	skb_trim(skb, true_len);
+
+	ieee80211_rx_ni(dev->hw, skb);
+}
+
+static void mt7601u_rx_add_frags(struct mt7601u_dev *dev, struct sk_buff *skb,
+				 void *data, u32 true_len, u32 truesize,
+				 struct page *p)
+{
+	unsigned long addr = (unsigned long) data;
+	u32 overpage = 0;
+	u32 p_off = (data - page_address(p)) >> PAGE_SHIFT;
+
+	if ((addr & ~PAGE_MASK) + true_len > PAGE_SIZE)
+		overpage = (addr & ~PAGE_MASK) + true_len - PAGE_SIZE;
+
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, p + p_off,
+			addr & ~PAGE_MASK, true_len - overpage, truesize);
+	get_page(p + p_off);
+
+	/* Do we really need to split the buffer if it crosses a page boundary?
+	 * Does networking code care?
+	 */
+	if (overpage) {
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, p + p_off + 1,
+				0, overpage, 0);
+		get_page(p + p_off + 1);
+	}
+}
+
+static void mt7601u_rx_process_seg_paged(struct mt7601u_dev *dev, u8 *data,
+					 u32 seg_len, struct page *p)
+{
+	struct sk_buff *skb;
+	struct mt7601u_rxwi *rxwi;
+	u32 true_len, fce_info, truesize = seg_len;
+
+	/* DMA_INFO field at the beginning of the segment contains only some of
+	 * the information, we need to read the FCE descriptor from the end.
+	 */
+	fce_info = get_unaligned_le32(data + seg_len - MT_FCE_INFO_LEN);
+	seg_len -= MT_FCE_INFO_LEN;
+
+	data += MT_DMA_HDR_LEN;
+	seg_len -= MT_DMA_HDR_LEN;
+
+	rxwi = (struct mt7601u_rxwi *) data;
+	data += sizeof(struct mt7601u_rxwi);
+	seg_len -= sizeof(struct mt7601u_rxwi);
+
+	if (unlikely(rxwi->zero[0] || rxwi->zero[1] || rxwi->zero[2]))
+		dev_err_once(dev->dev, "Error: RXWI zero fields are set\n");
+	if (unlikely(MT76_GET(MT_RXD_INFO_TYPE, fce_info)))
+		dev_err_once(dev->dev, "Error: RX path seen a non-pkt urb\n");
+
+	trace_mt_rx(dev, rxwi, fce_info);
+
+	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD)) {
+		int hdr_len = ieee80211_get_hdrlen_from_buf(data, seg_len);
+
+		memmove(data + 2, data, hdr_len);
+		seg_len -= 2;
+		data += 2;
 	}
 
+	skb = __netdev_alloc_skb(NULL, 256, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	true_len = mt76_mac_process_rx(dev, skb, data, rxwi);
+	WARN_ON(true_len > seg_len || true_len < seg_len - 3);
+
+	mt7601u_rx_add_frags(dev, skb, data, true_len, truesize, p);
+
 	ieee80211_rx_ni(dev->hw, skb);
 }
 
@@ -110,17 +183,31 @@ static u16 mt7601u_rx_next_seg_len(u8 *data, u32 data_len)
 }
 
 static void
-mt7601u_rx_process_entry(struct mt7601u_dev *dev, struct mt7601u_dma_buf *e)
+mt7601u_rx_process_entry(struct mt7601u_dev *dev, struct mt7601u_dma_buf_rx *e)
 {
 	u32 seg_len, data_len = e->urb->actual_length;
-	u8 *data = e->buf;
+	u8 *data = page_address(e->p);
+	struct page *new_p = NULL;
+	bool paged = true;
 	int cnt = 0;
 
 	if (!test_bit(MT7601U_STATE_INITIALIZED, &dev->state))
 		return;
 
+	/* Copy if there is very little data in the buffer. */
+	if (data_len < 512) {
+		paged = false;
+	} else {
+		new_p = dev_alloc_pages(MT_RX_ORDER);
+		if (!new_p)
+			paged = false;
+	}
+
 	while ((seg_len = mt7601u_rx_next_seg_len(data, data_len))) {
-		mt7601u_rx_process_seg(dev, data, seg_len);
+		if (paged)
+			mt7601u_rx_process_seg_paged(dev, data, seg_len, e->p);
+		else
+			mt7601u_rx_process_seg(dev, data, seg_len);
 
 		data_len -= seg_len;
 		data += seg_len;
@@ -128,14 +215,21 @@ mt7601u_rx_process_entry(struct mt7601u_dev *dev, struct mt7601u_dma_buf *e)
 	}
 
 	if (cnt > 1)
-		trace_mt_rx_dma_aggr(dev, cnt);
+		trace_mt_rx_dma_aggr(dev, cnt, paged);
+
+	if (paged) {
+		/* we have one extra ref from the allcator */
+		put_page(e->p);
+
+		e->p = new_p;
+	}
 }
 
-static struct mt7601u_dma_buf *
+static struct mt7601u_dma_buf_rx *
 mt7601u_rx_get_pending_entry(struct mt7601u_dev *dev)
 {
 	struct mt7601u_rx_queue *q = &dev->rx_q;
-	struct mt7601u_dma_buf *buf = NULL;
+	struct mt7601u_dma_buf_rx *buf = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->rx_lock, flags);
@@ -175,15 +269,14 @@ out:
 static void mt7601u_rx_tasklet(unsigned long data)
 {
 	struct mt7601u_dev *dev = (struct mt7601u_dev *) data;
-	struct mt7601u_dma_buf *e;
+	struct mt7601u_dma_buf_rx *e;
 
 	while ((e = mt7601u_rx_get_pending_entry(dev))) {
 		if (e->urb->status)
 			continue;
 
 		mt7601u_rx_process_entry(dev, e);
-		mt7601u_usb_submit_buf(dev, USB_DIR_IN, MT_EP_IN_PKT_RX, e,
-				       GFP_ATOMIC, mt7601u_complete_rx, dev);
+		mt7601u_submit_rx_buf(dev, e, GFP_ATOMIC);
 	}
 }
 
@@ -325,14 +418,33 @@ static void mt7601u_kill_rx(struct mt7601u_dev *dev)
 	spin_unlock_irqrestore(&dev->rx_lock, flags);
 }
 
+static int mt7601u_submit_rx_buf(struct mt7601u_dev *dev,
+				 struct mt7601u_dma_buf_rx *e, gfp_t gfp)
+{
+	struct usb_device *usb_dev = mt7601u_to_usb_dev(dev);
+	u8 *buf = page_address(e->p);
+	unsigned pipe;
+	int ret;
+
+	pipe = usb_rcvbulkpipe(usb_dev, dev->in_eps[MT_EP_IN_PKT_RX]);
+
+	usb_fill_bulk_urb(e->urb, usb_dev, pipe, buf, MT_RX_URB_SIZE,
+			  mt7601u_complete_rx, dev);
+
+	trace_mt_submit_urb(dev, e->urb);
+	ret = usb_submit_urb(e->urb, gfp);
+	if (ret)
+		dev_err(dev->dev, "Error: submit RX URB failed:%d\n", ret);
+
+	return ret;
+}
+
 static int mt7601u_submit_rx(struct mt7601u_dev *dev)
 {
 	int i, ret;
 
 	for (i = 0; i < dev->rx_q.entries; i++) {
-		ret = mt7601u_usb_submit_buf(dev, USB_DIR_IN, MT_EP_IN_PKT_RX,
-					     &dev->rx_q.e[i], GFP_KERNEL,
-					     mt7601u_complete_rx, dev);
+		ret = mt7601u_submit_rx_buf(dev, &dev->rx_q.e[i], GFP_KERNEL);
 		if (ret)
 			return ret;
 	}
@@ -344,8 +456,10 @@ static void mt7601u_free_rx(struct mt7601u_dev *dev)
 {
 	int i;
 
-	for (i = 0; i < dev->rx_q.entries; i++)
-		mt7601u_usb_free_buf(dev, &dev->rx_q.e[i]);
+	for (i = 0; i < dev->rx_q.entries; i++) {
+		__free_pages(dev->rx_q.e[i].p, MT_RX_ORDER);
+		usb_free_urb(dev->rx_q.e[i].urb);
+	}
 }
 
 static int mt7601u_alloc_rx(struct mt7601u_dev *dev)
@@ -356,9 +470,13 @@ static int mt7601u_alloc_rx(struct mt7601u_dev *dev)
 	dev->rx_q.dev = dev;
 	dev->rx_q.entries = N_RX_ENTRIES;
 
-	for (i = 0; i < N_RX_ENTRIES; i++)
-		if (mt7601u_usb_alloc_buf(dev, MT_RX_URB_SIZE, &dev->rx_q.e[i]))
+	for (i = 0; i < N_RX_ENTRIES; i++) {
+		dev->rx_q.e[i].urb = usb_alloc_urb(0, GFP_KERNEL);
+		dev->rx_q.e[i].p = dev_alloc_pages(MT_RX_ORDER);
+
+		if (!dev->rx_q.e[i].urb || !dev->rx_q.e[i].p)
 			return -ENOMEM;
+	}
 
 	return 0;
 }
diff --git a/mac.c b/mac.c
index 539751362b41..8802366f7181 100644
--- a/mac.c
+++ b/mac.c
@@ -441,30 +441,28 @@ mt7601u_rx_monitor_beacon(struct mt7601u_dev *dev, struct mt7601u_rxwi *rxwi,
 }
 
 static int
-mt7601u_rx_is_our_beacon(struct mt7601u_dev *dev, struct sk_buff *skb)
+mt7601u_rx_is_our_beacon(struct mt7601u_dev *dev, u8 *data)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)data;
 
 	return ieee80211_is_beacon(hdr->frame_control) &&
 		ether_addr_equal(hdr->addr2, dev->ap_bssid);
 }
 
-int mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb, void *rxi)
+u32 mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb,
+			u8 *data, void *rxi)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct mt7601u_rxwi *rxwi = rxi;
 	u32 ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
-	int len, rssi;
+	int rssi;
 
 	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_DECRYPT)) {
 		status->flag |= RX_FLAG_DECRYPTED;
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
 	}
 
-	len = MT76_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
-	skb_trim(skb, len);
-
 	status->chains = BIT(0);
 	rssi = mt7601u_phy_get_rssi(dev, rxwi, rate);
 	status->chain_signal[0] = status->signal = rssi;
@@ -474,13 +472,13 @@ int mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb, void *rxi)
 	mt76_mac_process_rate(status, rate);
 
 	spin_lock_bh(&dev->con_mon_lock);
-	if (mt7601u_rx_is_our_beacon(dev, skb))
+	if (mt7601u_rx_is_our_beacon(dev, data))
 		mt7601u_rx_monitor_beacon(dev, rxwi, rate, rssi);
 	else if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_U2M))
 		dev->avg_rssi = (dev->avg_rssi * 15) / 16 + (rssi << 8);
 	spin_unlock_bh(&dev->con_mon_lock);
 
-	return 0;
+	return MT76_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 }
 
 static enum mt76_cipher_type
diff --git a/mac.h b/mac.h
index 90cf147f37e7..2c22d63c63a2 100644
--- a/mac.h
+++ b/mac.h
@@ -160,8 +160,8 @@ struct mt76_txwi {
 #define MT_TXWI_CTL_CHAN_CHECK_PKT	BIT(4)
 #define MT_TXWI_CTL_PIFS_REV		BIT(6)
 
-int
-mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb, void *rxwi);
+u32 mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb,
+			u8 *data, void *rxi);
 int mt76_mac_wcid_set_key(struct mt7601u_dev *dev, u8 idx,
 			  struct ieee80211_key_conf *key);
 void mt76_mac_wcid_set_rate(struct mt7601u_dev *dev, struct mt76_wcid *wcid,
diff --git a/mt7601u.h b/mt7601u.h
index f9957350a187..d6f83e03cb58 100644
--- a/mt7601u.h
+++ b/mt7601u.h
@@ -37,6 +37,7 @@
 #define MT_USB_AGGR_SIZE_LIMIT		21 /* * 1024B */
 #define MT_USB_AGGR_TIMEOUT		0x80 /* * 33ns */
 #define MT_RX_URB_SIZE			(24 * 1024)
+#define MT_RX_ORDER			3
 
 struct mt7601u_dma_buf {
 	struct urb *urb;
@@ -73,7 +74,10 @@ struct mac_stats {
 struct mt7601u_rx_queue {
 	struct mt7601u_dev *dev;
 
-	struct mt7601u_dma_buf e[N_RX_ENTRIES];
+	struct mt7601u_dma_buf_rx {
+		struct urb *urb;
+		struct page *p;
+	} e[N_RX_ENTRIES];
 
 	unsigned int start;
 	unsigned int end;
diff --git a/trace.h b/trace.h
index db86272401ff..289897300ef0 100644
--- a/trace.h
+++ b/trace.h
@@ -352,17 +352,20 @@ TRACE_EVENT(mt_tx_status,
 );
 
 TRACE_EVENT(mt_rx_dma_aggr,
-	TP_PROTO(struct mt7601u_dev *dev, int cnt),
-	TP_ARGS(dev, cnt),
+	TP_PROTO(struct mt7601u_dev *dev, int cnt, bool paged),
+	TP_ARGS(dev, cnt, paged),
 	TP_STRUCT__entry(
 		DEV_ENTRY
 		__field(u8, cnt)
+		__field(bool, paged)
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
 		__entry->cnt = cnt;
+		__entry->paged = paged;
 	),
-	TP_printk(DEV_PR_FMT "%d", DEV_PR_ARG, __entry->cnt)
+	TP_printk(DEV_PR_FMT "cnt:%d paged:%d",
+		  DEV_PR_ARG, __entry->cnt, __entry->paged)
 );
 
 DEFINE_EVENT(dev_simple_evt, set_key,

