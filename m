Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99972C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 14:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52537222E6
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 14:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfBPOH5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 09:07:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbfBPOH5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 09:07:57 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1E8193D952;
        Sat, 16 Feb 2019 14:07:56 +0000 (UTC)
Received: from localhost (ovpn-204-67.brq.redhat.com [10.40.204.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 018401024910;
        Sat, 16 Feb 2019 14:07:45 +0000 (UTC)
Date:   Sat, 16 Feb 2019 15:07:40 +0100
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
Message-ID: <20190216140739.GA2236@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <1411983628.668277.1550315118443@email.ionos.de>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Sat, 16 Feb 2019 14:07:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2019 at 12:05:18PM +0100, Stefan Wahren wrote:
> sorry for the delay, but i do this all in my spare time.

Stefan, thanks for sacrifing your spare time for testing this!

> The results for your recent patch series are better (no firmware timeout), but still no working wifi and still a warning:
> https://gist.github.com/lategoodbye/c4864e446821717419cbe65df07f8d8d
> 
> I've identified the reason for the warning in dwc2:
> 
> /*
>  * We assume that DMA is always aligned in non-split
>  * case or split out case. Warn if not.
>  */
> WARN_ON_ONCE(hsotg->params.host_dma && (chan->xfer_dma & 0x3));

I think I understand why that happen, we first allocate 1024 mcu 
buffer then standard 4096 rx buffers, that couse 4096 buffers are
not contained in single page and need split by dwc2 driver.

Attached patch should fix this, plese test, thanks in advance.

> Btw i can confirm a regression was introduced after 4.19, because in 4.19 there was no firmware timeout but even no working wifi:

You ment 'no working wifi' or 'working wifi'?

Stanislaw

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0004-mt76usb-allocate-page-contained-rx-buffers.patch"

From 35dadd09bd3193b33b10f56e0210da680c6d915f Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Sat, 16 Feb 2019 14:53:19 +0100
Subject: [PATCH] mt76usb: allocate page contained rx buffers

If we first allocate 1024 bytes buffer and then 4096 bytes
buffer via page_frag_alloc() the second buffer will be crossing
page boundaries what is most likely not appropriate for
dma_map_{sg/page} and make buffer split misalign issues on
dwc2 usb host driver.

Since patch changed arguments of mt76u_buf_alloc() function I also
changed name to indicate it is only used for RX allocation.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h    |  5 ++---
 drivers/net/wireless/mediatek/mt76/usb.c     | 24 ++++++++++--------------
 drivers/net/wireless/mediatek/mt76/usb_mcu.c |  4 +---
 3 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 364f3571c033..9e24f603664a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -364,7 +364,6 @@ enum mt76u_out_ep {
 #define MT_SG_MAX_SIZE		8
 #define MT_NUM_TX_ENTRIES	256
 #define MT_NUM_RX_ENTRIES	128
-#define MCU_RESP_URB_SIZE	1024
 struct mt76_usb {
 	struct mutex usb_ctrl_mtx;
 	u8 data[32];
@@ -753,8 +752,8 @@ void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 		     const u16 offset, const u32 val);
 int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
 void mt76u_deinit(struct mt76_dev *dev);
-int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int nsgs, int len, int sglen, gfp_t gfp);
+int mt76u_rx_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf, int nsgs,
+		       gfp_t gfp);
 void mt76u_buf_free(struct mt76u_buf *buf);
 int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 		     struct mt76u_buf *buf, gfp_t gfp,
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index de906f07e85a..472642ef25a4 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -271,11 +271,11 @@ mt76u_set_endpoints(struct usb_interface *intf,
 }
 
 static int
-mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
-		 int nsgs, int len, int sglen)
+mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf, int nsgs)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct urb *urb = buf->urb;
+	int sglen = SKB_WITH_OVERHEAD(q->buf_size);
 	int i;
 
 	spin_lock_bh(&q->rx_page_lock);
@@ -284,7 +284,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		void *data;
 		int offset;
 
-		data = page_frag_alloc(&q->rx_page, len, GFP_ATOMIC);
+		data = page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
 		if (!data)
 			break;
 
@@ -309,8 +309,8 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 	return i ? : -ENOMEM;
 }
 
-int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int nsgs, int len, int sglen, gfp_t gfp)
+int mt76u_rx_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
+		       int nsgs, gfp_t gfp)
 {
 	buf->urb = usb_alloc_urb(0, gfp);
 	if (!buf->urb)
@@ -325,7 +325,7 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
 	buf->dev = dev;
 	buf->num_sgs = nsgs;
 
-	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
+	return mt76u_fill_rx_sg(dev, buf, nsgs);
 }
 
 void mt76u_buf_free(struct mt76u_buf *buf)
@@ -485,7 +485,7 @@ static void mt76u_rx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	int err, nsgs, buf_len = q->buf_size;
+	int err, nsgs;
 	struct mt76u_buf *buf;
 
 	rcu_read_lock();
@@ -497,9 +497,7 @@ static void mt76u_rx_tasklet(unsigned long data)
 
 		nsgs = mt76u_process_rx_entry(dev, buf->urb);
 		if (nsgs > 0) {
-			err = mt76u_fill_rx_sg(dev, buf, nsgs,
-					       buf_len,
-					       SKB_WITH_OVERHEAD(buf_len));
+			err = mt76u_fill_rx_sg(dev, buf, nsgs);
 			if (err < 0)
 				break;
 		}
@@ -556,10 +554,8 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	}
 
 	for (i = 0; i < MT_NUM_RX_ENTRIES; i++) {
-		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
-				      nsgs, q->buf_size,
-				      SKB_WITH_OVERHEAD(q->buf_size),
-				      GFP_KERNEL);
+		err = mt76u_rx_buf_alloc(dev, &q->entry[i].ubuf, nsgs,
+					 GFP_KERNEL);
 		if (err < 0)
 			return err;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 036be4163e69..7c43738f5a6e 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -29,9 +29,7 @@ int mt76u_mcu_init_rx(struct mt76_dev *dev)
 	struct mt76_usb *usb = &dev->usb;
 	int err;
 
-	err = mt76u_buf_alloc(dev, &usb->mcu.res, 1,
-			      MCU_RESP_URB_SIZE, MCU_RESP_URB_SIZE,
-			      GFP_KERNEL);
+	err = mt76u_rx_buf_alloc(dev, &usb->mcu.res, 1, GFP_KERNEL);
 	if (err < 0)
 		return err;
 
-- 
2.7.5


--KsGdsel6WgEHnImy--
