Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A8CC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 07:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCFC220643
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 07:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389379AbfBOHMd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 02:12:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbfBOHMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 02:12:32 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A0E7112AD79;
        Fri, 15 Feb 2019 07:12:31 +0000 (UTC)
Received: from localhost (ovpn-204-178.brq.redhat.com [10.40.204.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92FF719C65;
        Fri, 15 Feb 2019 07:12:28 +0000 (UTC)
Date:   Fri, 15 Feb 2019 08:12:27 +0100
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
Message-ID: <20190215071226.GA2372@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 15 Feb 2019 07:12:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2019 at 10:48:15AM +0100, Stefan Wahren wrote:
> Hi Stanislaw,
> 
> Am 14.02.19 um 10:25 schrieb Stanislaw Gruszka:
> > On Thu, Feb 14, 2019 at 07:49:57AM +0100, Stefan Wahren wrote:
> >> Hi Stanislaw,
> >>
> >>> Stanislaw Gruszka <sgruszka@redhat.com> hat am 12. Februar 2019 um 10:30 geschrieben:
> >>>
> >>>
> >>>
> >>> In usb_sg_init() urb->num_sgs is set 0 for sg_tablesize = 0 controllers.
> >>> In mt76 we set urb->num_sgs to 1. I thought it is fine, but now I think
> >>> this is bug. We can fix that without changing allocation method and
> >>> still use SG allocation. Attached patch do this, please check if it works
> >>> on rpi. Patch is on top of your error path fixes.
> >> your patch didn't apply cleanly to yesterdays next. After some minor manual fixup, i was able to build them and here are the results starting from boot (please ignore the invalid time in the kernel log):
> >> https://gist.github.com/lategoodbye/33bd5bc75b9fc935faa231bc472defa8
> > I think this is due to urb->transfer_length and sg[0]->length mismatch,
> > which should be addressed by my other patch. I'm attaching the patch
> > rebased on -next with this line integrated, please test. 
> >
> > But there could be other bug's in mt76-usb SG code.

I found another bug in mt76usb SG code. We set sg->offset bigger than
PAGE_SIZE that actually make sg point to memory in different page than
sg->page. Correcting this with another patch that avoid using sg
mapping with sg->length > PAGE_SIZE, fixed mt76x0u with AMD IOMMU:
https://bugzilla.kernel.org/show_bug.cgi?id=202241

I'm attaching 3 patches, they should also fix issue on rpi.
It's also possible that only 2 patches are sufficient:

0001-mt76usb-do-not-set-urb-num_sgs-to-1-for-non-SG-usb-h.patch
0003-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch

to fix the issue, if doing dma_map_{page,sg} is fine with
sg->offset == 0 and sg->length bigger than one page.

Please test, thanks.

Stanislaw

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mt76usb-do-not-set-urb-num_sgs-to-1-for-non-SG-usb-h.patch"

From 49654f00b5071602a9182f0cb488f346f01ec5ac Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 15 Feb 2019 07:39:00 +0100
Subject: [PATCH v5 1/3] mt76usb: do not set urb->num_sgs to 1 for non SG usb
 host drivers

Track number of segments in mt76u_buf structure and do not
submit urbs with urb->num_sgs = 1 if usb host driver
sg_tablesize is zero.

This suppose fix problem of mt76 not working with some usb
host controllers like dwc2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  1 +
 drivers/net/wireless/mediatek/mt76/usb.c  | 57 +++++++++++++++++++------------
 2 files changed, 37 insertions(+), 21 deletions(-)

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


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-mt76x02u-use-usb_bulk_msg-to-upload-firmware.patch"

From 3307dc2b47ea4442adebf09466e6bb9fdd6479db Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Mon, 11 Feb 2019 09:08:40 +0100
Subject: [PATCH v5 2/3] mt76x02u: use usb_bulk_msg to upload firmware

We don't need to send firmware data asynchronously, much simpler is just
use synchronous usb_bulk_msg().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          | 13 ++++++
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 52 +++++++---------------
 drivers/net/wireless/mediatek/mt76/usb.c           |  1 -
 3 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 97ad0270f8a6..364f3571c033 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -733,6 +733,19 @@ static inline bool mt76u_check_sg(struct mt76_dev *dev)
 		 udev->speed == USB_SPEED_WIRELESS));
 }
 
+static inline int
+mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int timeout)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct mt76_usb *usb = &dev->usb;
+	unsigned int pipe;
+	int sent;
+
+	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
+	return usb_bulk_msg(udev, pipe, data, len, &sent, timeout);
+}
+
 int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 			 u8 req_type, u16 val, u16 offset,
 			 void *buf, size_t len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 6db789f90269..2ca393e267af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -121,18 +121,14 @@ static int
 __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 			int cmd, bool wait_resp)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
 	struct mt76_usb *usb = &dev->usb;
-	unsigned int pipe;
-	int ret, sent;
+	int ret;
 	u8 seq = 0;
 	u32 info;
 
 	if (test_bit(MT76_REMOVED, &dev->state))
 		return 0;
 
-	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
 	if (wait_resp) {
 		seq = ++usb->mcu.msg_seq & 0xf;
 		if (!seq)
@@ -146,7 +142,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	if (ret)
 		return ret;
 
-	ret = usb_bulk_msg(udev, pipe, skb->data, skb->len, &sent, 500);
+	ret = mt76u_bulk_msg(dev, skb->data, skb->len, 500);
 	if (ret)
 		return ret;
 
@@ -268,14 +264,12 @@ void mt76x02u_mcu_fw_reset(struct mt76x02_dev *dev)
 EXPORT_SYMBOL_GPL(mt76x02u_mcu_fw_reset);
 
 static int
-__mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
+__mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, u8 *data,
 			    const void *fw_data, int len, u32 dst_addr)
 {
-	u8 *data = sg_virt(&buf->urb->sg[0]);
-	DECLARE_COMPLETION_ONSTACK(cmpl);
 	__le32 info;
 	u32 val;
-	int err;
+	int err, data_len;
 
 	info = cpu_to_le32(FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
 			   FIELD_PREP(MT_MCU_MSG_LEN, len) |
@@ -291,25 +285,12 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 	mt76u_single_wr(&dev->mt76, MT_VEND_WRITE_FCE,
 			MT_FCE_DMA_LEN, len << 16);
 
-	buf->len = MT_CMD_HDR_LEN + len + sizeof(info);
-	err = mt76u_submit_buf(&dev->mt76, USB_DIR_OUT,
-			       MT_EP_OUT_INBAND_CMD,
-			       buf, GFP_KERNEL,
-			       mt76u_mcu_complete_urb, &cmpl);
-	if (err < 0)
-		return err;
-
-	if (!wait_for_completion_timeout(&cmpl,
-					 msecs_to_jiffies(1000))) {
-		dev_err(dev->mt76.dev, "firmware upload timed out\n");
-		usb_kill_urb(buf->urb);
-		return -ETIMEDOUT;
-	}
+	data_len = MT_CMD_HDR_LEN + len + sizeof(info);
 
-	if (mt76u_urb_error(buf->urb)) {
-		dev_err(dev->mt76.dev, "firmware upload failed: %d\n",
-			buf->urb->status);
-		return buf->urb->status;
+	err = mt76u_bulk_msg(&dev->mt76, data, data_len, 1000);
+	if (err) {
+		dev_err(dev->mt76.dev, "firmware upload failed: %d\n", err);
+		return err;
 	}
 
 	val = mt76_rr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX);
@@ -322,17 +303,16 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 			      int data_len, u32 max_payload, u32 offset)
 {
-	int err, len, pos = 0, max_len = max_payload - 8;
-	struct mt76u_buf buf;
+	int len, err = 0, pos = 0, max_len = max_payload - 8;
+	u8 *buf;
 
-	err = mt76u_buf_alloc(&dev->mt76, &buf, 1, max_payload, max_payload,
-			      GFP_KERNEL);
-	if (err < 0)
-		return err;
+	buf = kmalloc(max_payload, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	while (data_len > 0) {
 		len = min_t(int, data_len, max_len);
-		err = __mt76x02u_mcu_fw_send_data(dev, &buf, data + pos,
+		err = __mt76x02u_mcu_fw_send_data(dev, buf, data + pos,
 						  len, offset + pos);
 		if (err < 0)
 			break;
@@ -341,7 +321,7 @@ int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 		pos += len;
 		usleep_range(5000, 10000);
 	}
-	mt76u_buf_free(&buf);
+	kfree(buf);
 
 	return err;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 4f92732506cc..db31cae11911 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -327,7 +327,6 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
 
 	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
 }
-EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
 
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
-- 
2.7.5


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch"

From 675fdc945c2d1fce01c72f520e82289ba5877ba2 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 14 Feb 2019 19:48:05 +0100
Subject: [PATCH v5 3/3] mt76usb: do not use compound head page for SG I/O

We use head of compound page as base for SG, that results in sg->offset
bigger than PAGE_SIZE pointing to another page. Some DMA controllers
work ok with that, but for dma_map_sg() and dma_map_page() we should
provide buffer contained in single page (eventually with sg->offset = 0
and sg->length of more pages, but not with sg->offset pointed to
different page than sg->page).

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index db31cae11911..de906f07e85a 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -288,7 +288,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		if (!data)
 			break;
 
-		page = virt_to_head_page(data);
+		page = virt_to_page(data);
 		offset = data - page_address(page);
 		sg_set_page(&urb->sg[i], page, sglen, offset);
 	}
-- 
2.7.5


--bp/iNruPH9dso1Pn--
