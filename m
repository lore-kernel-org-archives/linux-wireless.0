Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EBDC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 13:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1E9C2147A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 13:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbfBTNAw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 08:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbfBTNAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 08:00:51 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC91C74840;
        Wed, 20 Feb 2019 13:00:50 +0000 (UTC)
Received: from localhost (ovpn-204-58.brq.redhat.com [10.40.204.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8D5060139;
        Wed, 20 Feb 2019 13:00:12 +0000 (UTC)
Date:   Wed, 20 Feb 2019 14:00:11 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190220130009.GA2377@redhat.com>
References: <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
 <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
 <20190218150303.GD9602@redhat.com>
 <a035966b-99f8-1109-d96f-0c3862d26518@nbd.name>
 <20190219104208.GA22999@redhat.com>
 <58097bb1-d726-c48e-2a40-2e12098dfb15@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58097bb1-d726-c48e-2a40-2e12098dfb15@nbd.name>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 20 Feb 2019 13:00:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 19, 2019 at 01:19:26PM +0100, Felix Fietkau wrote:
> >> >> The way I see it, we have two choices.
> >> >> 1. Fix dwc2 to do its alignment quirk for the urb->sg != NULL case
> >> >> 2. Rely on urb->transfer_buffer and keep urb->sg NULL
> >> > 
> >> > I agree, if this is only needed for dwc2. Though I would investigate
> >> > if this is not a bug on other platforms as well.
> >> >From what I can see, using Lorenzo's patches seems to be the better
> >> solution, since they avoid these corner cases in dwc2 (and maybe other
> >> drivers as well). I will apply them and then we'll see if we need to do
> >> any further improvements later on.
> > 
> > They work on rpi dwc2, but they do not address root of the problem.
> > There is clearly something wrong how mt76usb handle SG, what is not
> > fixed. And adding disable_usb_sg module parameter for hcd's supporting
> > SG should be red flag.
> I think we're simply dealing with multiple issues here, only some of
> which are fixed by Lorenzo's patches.
> I'm pretty sure it's still wrong for mt76 to try to align its buffers,
> since the Linux USB API supports non-aligned transfer buffers and it
> should be up to the controller driver to deal with that.

Agree.

> dwc2 tries to do that, but that has limitations which I already pointed
> out and which are properly dealt with by Lorenzo's patches.

I planed to just accept current solution, but I started to work on patch
that remove len, sglen arguments from mt76u_buf_alloc() and use
q->buf_size and SKB_WITH_OVERHEAD(q->buf_size) directly and realized how
related code is now tangled.

Would be ok to send this patch with proper changelog as fix for RPI
against wireless-drivers and cc:stable (assuming it works and really
fix things on RPI) and revert Lorenzo's patches in -next ?

Stanislaw

From 4f8d7d3f4031b0a97b3bb147cb7e52533886e7cc Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 20 Feb 2019 13:29:42 +0100
Subject: [PATCH] mt76usb: use urb transfer_buffer for one segment

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 +
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  4 +-
 drivers/net/wireless/mediatek/mt76/usb.c      | 75 +++++++++++--------
 3 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2e5bcb3fdff7..7e0680daeee6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -86,6 +86,8 @@ struct mt76_queue_buf {
 struct mt76u_buf {
 	struct mt76_dev *dev;
 	struct urb *urb;
+	struct scatterlist *sg;
+	int num_sgs;
 	size_t len;
 	bool done;
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index da299b8a1334..75561910d630 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -90,7 +90,7 @@ static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 		if (urb->status)
 			return -EIO;
 
-		data = sg_virt(&urb->sg[0]);
+		data = sg_virt(&buf->sg[0]);
 		if (usb->mcu.rp)
 			mt76x02u_multiple_mcu_reads(dev, data + 4,
 						    urb->actual_length - 8);
@@ -266,7 +266,7 @@ static int
 __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 			    const void *fw_data, int len, u32 dst_addr)
 {
-	u8 *data = sg_virt(&buf->urb->sg[0]);
+	u8 *data = sg_virt(&buf->sg[0]);
 	DECLARE_COMPLETION_ONSTACK(cmpl);
 	__le32 info;
 	u32 val;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index a1811c39415e..57bb16eaff06 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -277,7 +277,6 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		 int nsgs, int len, int sglen)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	struct urb *urb = buf->urb;
 	int i;
 
 	spin_lock_bh(&q->rx_page_lock);
@@ -292,21 +291,21 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 
 		page = virt_to_head_page(data);
 		offset = data - page_address(page);
-		sg_set_page(&urb->sg[i], page, sglen, offset);
+		sg_set_page(&buf->sg[i], page, sglen, offset);
 	}
 	spin_unlock_bh(&q->rx_page_lock);
 
 	if (i < nsgs) {
 		int j;
 
-		for (j = nsgs; j < urb->num_sgs; j++)
-			skb_free_frag(sg_virt(&urb->sg[j]));
-		urb->num_sgs = i;
+		for (j = nsgs; j < buf->num_sgs; j++)
+			skb_free_frag(sg_virt(&buf->sg[j]));
+		buf->num_sgs = i;
 	}
 
-	urb->num_sgs = max_t(int, i, urb->num_sgs);
-	buf->len = urb->num_sgs * sglen,
-	sg_init_marker(urb->sg, urb->num_sgs);
+	buf->num_sgs = max_t(int, i, buf->num_sgs);
+	buf->len = buf->num_sgs * sglen,
+	sg_init_marker(buf->sg, buf->num_sgs);
 
 	return i ? : -ENOMEM;
 }
@@ -318,13 +317,14 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
 	if (!buf->urb)
 		return -ENOMEM;
 
-	buf->urb->sg = devm_kcalloc(dev->dev, nsgs, sizeof(*buf->urb->sg),
+	buf->sg = devm_kcalloc(dev->dev, nsgs, sizeof(*buf->sg),
 				    gfp);
-	if (!buf->urb->sg)
+	if (!buf->sg)
 		return -ENOMEM;
 
-	sg_init_table(buf->urb->sg, nsgs);
+	sg_init_table(buf->sg, nsgs);
 	buf->dev = dev;
+	buf->num_sgs = nsgs;
 
 	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
 }
@@ -332,12 +332,11 @@ EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
 
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
-	struct urb *urb = buf->urb;
 	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < urb->num_sgs; i++) {
-		sg = &urb->sg[i];
+	for (i = 0; i < buf->num_sgs; i++) {
+		sg = &buf->sg[i];
 		if (!sg)
 			continue;
 
@@ -347,9 +346,10 @@ void mt76u_buf_free(struct mt76u_buf *buf)
 }
 EXPORT_SYMBOL_GPL(mt76u_buf_free);
 
-int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
-		     struct mt76u_buf *buf, gfp_t gfp,
-		     usb_complete_t complete_fn, void *context)
+static void
+mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
+		    struct mt76u_buf *buf, usb_complete_t complete_fn,
+		    void *context)
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -360,9 +360,22 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 	else
 		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
 
-	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len,
-			  complete_fn, context);
+	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len, complete_fn,
+			  context);
+
+	if (buf->num_sgs > 1) {
+		buf->urb->num_sgs = buf->num_sgs;
+		buf->urb->sg = buf->sg;
+	} else {
+		buf->urb->transfer_buffer = sg_virt(buf->sg);
+	}
+}
 
+int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
+		     struct mt76u_buf *buf, gfp_t gfp,
+		     usb_complete_t complete_fn, void *context)
+{
+	mt76u_fill_bulk_urb(dev, dir, index, buf, complete_fn, context);
 	return usb_submit_urb(buf->urb, gfp);
 }
 EXPORT_SYMBOL_GPL(mt76u_submit_buf);
@@ -672,7 +685,7 @@ static void mt76u_complete_tx(struct urb *urb)
 }
 
 static int
-mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
+mt76u_tx_build_sg(struct sk_buff *skb, struct mt76u_buf *buf)
 {
 	int nsgs = 1 + skb_shinfo(skb)->nr_frags;
 	struct sk_buff *iter;
@@ -680,13 +693,14 @@ mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
 	skb_walk_frags(skb, iter)
 		nsgs += 1 + skb_shinfo(iter)->nr_frags;
 
-	memset(urb->sg, 0, sizeof(*urb->sg) * MT_SG_MAX_SIZE);
+	memset(buf->sg, 0, sizeof(*buf->sg) * MT_SG_MAX_SIZE);
 
 	nsgs = min_t(int, MT_SG_MAX_SIZE, nsgs);
-	sg_init_marker(urb->sg, nsgs);
-	urb->num_sgs = nsgs;
+	sg_init_marker(buf->sg, nsgs);
+	buf->num_sgs = nsgs;
+	buf->len = skb->len;
 
-	return skb_to_sgvec_nomark(skb, urb->sg, 0, skb->len);
+	return skb_to_sgvec_nomark(skb, buf->sg, 0, skb->len);
 }
 
 static int
@@ -694,12 +708,9 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		   struct sk_buff *skb, struct mt76_wcid *wcid,
 		   struct ieee80211_sta *sta)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
 	u8 ep = q2ep(q->hw_idx);
 	struct mt76u_buf *buf;
 	u16 idx = q->tail;
-	unsigned int pipe;
 	int err;
 
 	if (q->queued == q->ndesc)
@@ -712,13 +723,11 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	buf = &q->entry[idx].ubuf;
 	buf->done = false;
 
-	err = mt76u_tx_build_sg(skb, buf->urb);
+	err = mt76u_tx_build_sg(skb, buf);
 	if (err < 0)
 		return err;
 
-	pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[ep]);
-	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, skb->len,
-			  mt76u_complete_tx, buf);
+	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, ep, buf, mt76u_complete_tx, buf);
 
 	q->tail = (q->tail + 1) % q->ndesc;
 	q->entry[idx].skb = skb;
@@ -776,8 +785,8 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 			if (!buf->urb)
 				return -ENOMEM;
 
-			buf->urb->sg = devm_kzalloc(dev->dev, size, GFP_KERNEL);
-			if (!buf->urb->sg)
+			buf->sg = devm_kzalloc(dev->dev, size, GFP_KERNEL);
+			if (!buf->sg)
 				return -ENOMEM;
 		}
 	}
-- 
2.20.1

