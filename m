Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A90C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 09:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C10218A3
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 09:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfBLJam (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 04:30:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfBLJam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 04:30:42 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 37243C05D419;
        Tue, 12 Feb 2019 09:30:41 +0000 (UTC)
Received: from localhost (ovpn-204-125.brq.redhat.com [10.40.204.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71B3C62943;
        Tue, 12 Feb 2019 09:30:37 +0000 (UTC)
Date:   Tue, 12 Feb 2019 10:30:36 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190212093035.GB12906@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 12 Feb 2019 09:30:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 12, 2019 at 01:06:00AM +0100, Lorenzo Bianconi wrote:
> >
> > On Mon, 11 Feb 2019, Stanislaw Gruszka wrote:
> >
> > > On Mon, Feb 11, 2019 at 10:12:57AM -0500, Alan Stern wrote:
> > > > On Mon, 11 Feb 2019, Lorenzo Bianconi wrote:
> > > >
> > > > > Here it is a different issue respect to the AMD IOMMU one, dwc2 host driver
> > > > > does not implement SG I/O so probing fails. I guess it is still useful to
> > > > > implement a 'legacy' mode that enable mt76 on host controllers that do not implement
> > > > > SG I/O (rpi is a very common device so it will be cool to have mt76 working on
> > > > > it). Moreover we are not removing functionalities, user experience will remain
> > > > > the same
> > > >
> > > > Has anyone considered adding SG support to dwc2?  It shouldn't be very
> > > > difficult.  The corresponding change for ehci-hcd required adding no
> > > > more than about 30 lines of code.
> > >
> > > That would be cool. Perhaps somebody with dwc2 hardware could do this.
> > >
> > > However in mt76x02u we possibly would like to support other usb host
> > > drivers with sg_tablesize = 0 . I would like to clarify what is correct
> > > to do with such drivers.
> > >
> > > Is ok to pass buffer via urb->sg with urb->num_sgs = 1 ? Or maybe
> > > urb->num_sgs should be 0 to pass buffer via urb->sg on such drivers ?
> > > Or maybe non of above is correct and the only option that will work
> > > in 100% is pass buffer via urb->transfer_buffer ?
> >
> > See the kerneldoc for usb_sg_init(), usb_sg_wait(), and usb_sg_cancel()
> > in drivers/usb/core/message.c.  These routines will always do the right
> > thing -- however usb_sg_wait() must be called in process context.
> >
> > Alan Stern
> >
> 
> Hi Alan,
> 
> I actually used usb_sg_init()/usb_sg_wait() as reference to implement
> mt76u {tx/rx} datapath, but I will double-check.
> I guess we should even consider if there are other usb host drivers
> that do not implement SG I/O and it is worth to support.
> I am wondering if the right approach is to add SG to the controller
> one by one or have legacy I/O in mt76 (not sure what is the 'best'
> approach)

In usb_sg_init() urb->num_sgs is set 0 for sg_tablesize = 0 controllers.
In mt76 we set urb->num_sgs to 1. I thought it is fine, but now I think
this is bug. We can fix that without changing allocation method and
still use SG allocation. Attached patch do this, please check if it works
on rpi. Patch is on top of your error path fixes.

Stanislaw

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mt76usb-do-not-set-urb-num_sgs-to-1-for-non-SG-usb-h.patch"

From f79ac0df967d406523d0a1c03a138d1394e7665a Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Tue, 12 Feb 2019 10:02:53 +0100
Subject: [PATCH] mt76usb: do not set urb->num_sgs to 1 for non SG usb host
 drivers

Track number of segments in mt76u_buf structure and do not
submit urbs with urb->num_sgs = 1 if usb host driver
sg_tablesize is zero.

This suppose fix problem of mt76 not working with some usb
host controllers like dwc2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  1 +
 drivers/net/wireless/mediatek/mt76/usb.c  | 55 ++++++++++++++---------
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2e5bcb3fdff7..eadc913c37b6 100644
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
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index a1811c39415e..d82de59ec6dc 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -299,14 +299,14 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
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
@@ -325,6 +325,7 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
 
 	sg_init_table(buf->urb->sg, nsgs);
 	buf->dev = dev;
+	buf->num_sgs = nsgs;
 
 	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
 }
@@ -336,7 +337,7 @@ void mt76u_buf_free(struct mt76u_buf *buf)
 	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < urb->num_sgs; i++) {
+	for (i = 0; i < buf->num_sgs; i++) {
 		sg = &urb->sg[i];
 		if (!sg)
 			continue;
@@ -347,9 +348,10 @@ void mt76u_buf_free(struct mt76u_buf *buf)
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
@@ -360,9 +362,25 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 	else
 		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
 
-	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len,
-			  complete_fn, context);
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
 EXPORT_SYMBOL_GPL(mt76u_submit_buf);
@@ -672,10 +690,11 @@ static void mt76u_complete_tx(struct urb *urb)
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
@@ -684,7 +703,8 @@ mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
 
 	nsgs = min_t(int, MT_SG_MAX_SIZE, nsgs);
 	sg_init_marker(urb->sg, nsgs);
-	urb->num_sgs = nsgs;
+	buf->num_sgs = nsgs;
+	buf->len = skb->len;
 
 	return skb_to_sgvec_nomark(skb, urb->sg, 0, skb->len);
 }
@@ -694,12 +714,9 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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
@@ -712,13 +729,11 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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
2.19.2


--FL5UXtIhxfXey3p5--
