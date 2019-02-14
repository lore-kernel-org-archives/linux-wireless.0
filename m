Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94DAC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855312229F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437025AbfBNJZh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:25:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390125AbfBNJZh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 04:25:37 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABB5713A42;
        Thu, 14 Feb 2019 09:25:36 +0000 (UTC)
Received: from localhost (ovpn-204-123.brq.redhat.com [10.40.204.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFBE560C62;
        Thu, 14 Feb 2019 09:25:32 +0000 (UTC)
Date:   Thu, 14 Feb 2019 10:25:32 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190214092530.GA17273@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <404607590.373282.1550126997144@email.ionos.de>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 14 Feb 2019 09:25:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2019 at 07:49:57AM +0100, Stefan Wahren wrote:
> Hi Stanislaw,
> 
> > Stanislaw Gruszka <sgruszka@redhat.com> hat am 12. Februar 2019 um 10:30 geschrieben:
> > 
> > 
> > 
> > In usb_sg_init() urb->num_sgs is set 0 for sg_tablesize = 0 controllers.
> > In mt76 we set urb->num_sgs to 1. I thought it is fine, but now I think
> > this is bug. We can fix that without changing allocation method and
> > still use SG allocation. Attached patch do this, please check if it works
> > on rpi. Patch is on top of your error path fixes.
> 
> your patch didn't apply cleanly to yesterdays next. After some minor manual fixup, i was able to build them and here are the results starting from boot (please ignore the invalid time in the kernel log):
> https://gist.github.com/lategoodbye/33bd5bc75b9fc935faa231bc472defa8

I think this is due to urb->transfer_length and sg[0]->length mismatch,
which should be addressed by my other patch. I'm attaching the patch
rebased on -next with this line integrated, please test. 

But there could be other bug's in mt76-usb SG code.

> Using multi_v7_defconfig i'm getting a warning on the first connect and always this flood of rx urb failed on disconnect. The driver seems to probe but isn't functional even after 2 tries.
> 
> Using arm64_defconfig i don't get any warning. But except of this i'm getting similiar results to multi_v7_defconfig.
> 
> So in comparison, Lorenzo's workaround behaves better.

I'm pretty sure problem is mt76x0u 4.19 -> 4.20 regression intrduced by
integrating mt76x0u in mt76-usb (things do not work from day 0
for mt76x2u). We should find fix(es) that will be proper for -stable.

Stanislaw 

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mt76usb-do-not-set-urb-num_sgs-to-1-for-non-SG-usb-h.patch"

From 2b20054fc424e0bb33962bbb05509a7ca16d01bc Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 14 Feb 2019 10:01:06 +0100
Subject: [PATCH v5] mt76usb: do not set urb->num_sgs to 1 for non SG usb host
 drivers

Track number of segments in mt76u_buf structure and do not
submit urbs with urb->num_sgs = 1 if usb host driver
sg_tablesize is zero.

This suppose fix problem of mt76 not working with some usb
host controllers like dwc2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |  1 +
 drivers/net/wireless/mediatek/mt76/usb.c           | 57 ++++++++++++++--------
 3 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2bb9db4ed80a..97ad0270f8a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -86,6 +86,7 @@ struct mt76_queue_buf {
 struct mt76u_buf {
 	struct mt76_dev *dev;
 	struct urb *urb;
+	int num_sgs;
 	size_t len;
 	bool done;
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 6db789f90269..80a259e1e931 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -292,6 +292,7 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 			MT_FCE_DMA_LEN, len << 16);
 
 	buf->len = MT_CMD_HDR_LEN + len + sizeof(info);
+	buf->urb->sg[0].length = buf->len;
 	err = mt76u_submit_buf(&dev->mt76, USB_DIR_OUT,
 			       MT_EP_OUT_INBAND_CMD,
 			       buf, GFP_KERNEL,
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 6a2507524c6c..4f92732506cc 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -297,14 +297,14 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 	if (i < nsgs) {
 		int j;
 
-		for (j = nsgs; j < urb->num_sgs; j++)
+		for (j = nsgs; j < buf->num_sgs; j++)
 			skb_free_frag(sg_virt(&urb->sg[j]));
-		urb->num_sgs = i;
+		buf->num_sgs = i;
 	}
 
-	urb->num_sgs = max_t(int, i, urb->num_sgs);
-	buf->len = urb->num_sgs * sglen,
-	sg_init_marker(urb->sg, urb->num_sgs);
+	buf->num_sgs = max_t(int, i, buf->num_sgs);
+	buf->len = buf->num_sgs * sglen,
+	sg_init_marker(urb->sg, buf->num_sgs);
 
 	return i ? : -ENOMEM;
 }
@@ -323,6 +323,7 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
 
 	sg_init_table(buf->urb->sg, nsgs);
 	buf->dev = dev;
+	buf->num_sgs = nsgs;
 
 	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
 }
@@ -333,15 +334,16 @@ void mt76u_buf_free(struct mt76u_buf *buf)
 	struct urb *urb = buf->urb;
 	int i;
 
-	for (i = 0; i < urb->num_sgs; i++)
+	for (i = 0; i < buf->num_sgs; i++)
 		skb_free_frag(sg_virt(&urb->sg[i]));
 	usb_free_urb(buf->urb);
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
@@ -352,12 +354,28 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 	else
 		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
 
-	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len,
-			  complete_fn, context);
-	trace_submit_urb(dev, buf->urb);
+	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len, complete_fn,
+			  context);
+
+	if (udev->bus->sg_tablesize > 0) {
+		buf->urb->num_sgs = buf->num_sgs;
+	} else {
+		WARN_ON_ONCE(buf->num_sgs != 1);
+		/* See usb_sg_init() */
+		buf->urb->num_sgs = 0;
+		if (!PageHighMem(sg_page(buf->urb->sg)))
+			buf->urb->transfer_buffer = sg_virt(buf->urb->sg);
+	}
+}
 
+int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
+		     struct mt76u_buf *buf, gfp_t gfp,
+		     usb_complete_t complete_fn, void *context)
+{
+	mt76u_fill_bulk_urb(dev, dir, index, buf, complete_fn, context);
 	return usb_submit_urb(buf->urb, gfp);
 }
+
 EXPORT_SYMBOL_GPL(mt76u_submit_buf);
 
 static inline struct mt76u_buf
@@ -667,10 +685,11 @@ static void mt76u_complete_tx(struct urb *urb)
 }
 
 static int
-mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
+mt76u_tx_build_sg(struct sk_buff *skb, struct mt76u_buf *buf)
 {
 	int nsgs = 1 + skb_shinfo(skb)->nr_frags;
 	struct sk_buff *iter;
+	struct urb *urb = buf->urb;
 
 	skb_walk_frags(skb, iter)
 		nsgs += 1 + skb_shinfo(iter)->nr_frags;
@@ -679,7 +698,8 @@ mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
 
 	nsgs = min_t(int, MT_SG_MAX_SIZE, nsgs);
 	sg_init_marker(urb->sg, nsgs);
-	urb->num_sgs = nsgs;
+	buf->num_sgs = nsgs;
+	buf->len = skb->len;
 
 	return skb_to_sgvec_nomark(skb, urb->sg, 0, skb->len);
 }
@@ -689,12 +709,9 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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
@@ -708,13 +725,11 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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
-- 
2.7.5


--ZGiS0Q5IWpPtfppv--
