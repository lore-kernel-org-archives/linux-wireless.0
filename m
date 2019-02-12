Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645D6C282CA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C4D21773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549978993;
	bh=5TWnouN5jcc7lj6OmVKnadkK62v3BQHglbPNkbU+4oc=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WSG88uyJL046umxbJXOQlNaevf6flBhT4bu4Br5giQu42+rq4xFIJS6u42n8OXqQf
	 0qZKfs1v2+cKYamXfyLl5ByBaWZsF6KeSLbm1+ABOWQGqQr1EFMryc5DCPmbhmxEpE
	 ZrXtejutL2xUt3xvG8AYuuwIgRKubKJUYi4qTz7M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbfBLNnM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfBLNnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 08:43:12 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A82E21773
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549978990;
        bh=5TWnouN5jcc7lj6OmVKnadkK62v3BQHglbPNkbU+4oc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mBgOefeXyRtMbrPf85TtANTXWjyvSj8EU2BbAwSkxJrvcfBxFtJI4AJWLxv0mShn6
         CAd/8XnFVBBcd04oC/ohrpPX0ohrWysmMoTDVj45CdHkxDPACZwqH2LUpu4uxKFBVN
         39sRzSrlDMaAZTgPM03tc7WCcBdn2owKGSIR07JA=
From:   lorenzo@kernel.org
To:     linux-wireless@vger.kernel.org
Subject: [PATCH RESEND 2/4] mt76: usb: do not use sg buffers for mcu messages
Date:   Tue, 12 Feb 2019 14:42:40 +0100
Message-Id: <4d90a37e0f56c71d489b0a29f3439c9b9594d3f8.1549977282.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549977282.git.lorenzo@kernel.org>
References: <cover.1549977282.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Do not use scatter-gather buffers for mcu commands.
Introduce mt76u_buf_alloc and mt76u_buf_alloc_sg routines.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  3 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  3 +-
 drivers/net/wireless/mediatek/mt76/usb.c      | 38 +++++++++++++++----
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  |  5 +--
 4 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 0eb9152c5d18..f55dc621e060 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -87,6 +87,7 @@ struct mt76u_buf {
 	struct mt76_dev *dev;
 	struct urb *urb;
 	size_t len;
+	void *buf;
 	bool done;
 };
 
@@ -748,7 +749,7 @@ void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
 void mt76u_deinit(struct mt76_dev *dev);
 int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int nsgs, int len, int sglen, gfp_t gfp);
+		    int len, int data_len, gfp_t gfp);
 void mt76u_buf_free(struct mt76u_buf *buf);
 int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 		     struct mt76u_buf *buf, gfp_t gfp,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 64c777298cee..e469e383cb88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -63,9 +63,9 @@ static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 	struct mt76_usb *usb = &dev->usb;
 	struct mt76u_buf *buf = &usb->mcu.res;
 	struct urb *urb = buf->urb;
+	u8 *data = buf->buf;
 	int i, ret;
 	u32 rxfce;
-	u8 *data;
 
 	for (i = 0; i < 5; i++) {
 		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
@@ -75,7 +75,6 @@ static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 		if (urb->status)
 			return -EIO;
 
-		data = sg_virt(&urb->sg[0]);
 		if (usb->mcu.rp)
 			mt76x02u_multiple_mcu_reads(dev, data + 4,
 						    urb->actual_length - 8);
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 829128a07701..66c9451cb6f3 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -319,8 +319,9 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 	return i ? : -ENOMEM;
 }
 
-int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int nsgs, int len, int sglen, gfp_t gfp)
+static int
+mt76u_buf_alloc_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
+		   int nsgs, int len, int sglen, gfp_t gfp)
 {
 	buf->urb = usb_alloc_urb(0, gfp);
 	if (!buf->urb)
@@ -337,6 +338,25 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
 	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
 }
 
+int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
+		    int len, int data_len, gfp_t gfp)
+{
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+
+	buf->urb = usb_alloc_urb(0, gfp);
+	if (!buf->urb)
+		return -ENOMEM;
+
+	buf->buf = page_frag_alloc(&q->rx_page, len, gfp);
+	if (!buf->buf)
+		return -ENOMEM;
+
+	buf->len = data_len;
+	buf->dev = dev;
+
+	return 0;
+}
+
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
 	struct urb *urb = buf->urb;
@@ -350,6 +370,9 @@ void mt76u_buf_free(struct mt76u_buf *buf)
 
 		skb_free_frag(sg_virt(sg));
 	}
+	if (buf->buf)
+		skb_free_frag(buf->buf);
+
 	usb_free_urb(buf->urb);
 }
 EXPORT_SYMBOL_GPL(mt76u_buf_free);
@@ -360,6 +383,7 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
+	u8 *data = buf->urb->num_sgs ? NULL : buf->buf;
 	unsigned int pipe;
 
 	if (dir == USB_DIR_IN)
@@ -367,7 +391,7 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 	else
 		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
 
-	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len,
+	usb_fill_bulk_urb(buf->urb, udev, pipe, data, buf->len,
 			  complete_fn, context);
 	trace_submit_urb(dev, buf->urb);
 
@@ -556,10 +580,10 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 
 	q->ndesc = MT_NUM_RX_ENTRIES;
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
-				      nsgs, q->buf_size,
-				      SKB_WITH_OVERHEAD(q->buf_size),
-				      GFP_KERNEL);
+		err = mt76u_buf_alloc_sg(dev, &q->entry[i].ubuf,
+					 nsgs, q->buf_size,
+					 SKB_WITH_OVERHEAD(q->buf_size),
+					 GFP_KERNEL);
 		if (err < 0)
 			return err;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 9527e1216f3d..72c8607da4b4 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -29,9 +29,8 @@ int mt76u_mcu_init_rx(struct mt76_dev *dev)
 	struct mt76_usb *usb = &dev->usb;
 	int err;
 
-	err = mt76u_buf_alloc(dev, &usb->mcu.res, 1,
-			      MCU_RESP_URB_SIZE, MCU_RESP_URB_SIZE,
-			      GFP_KERNEL);
+	err = mt76u_buf_alloc(dev, &usb->mcu.res, MCU_RESP_URB_SIZE,
+			      MCU_RESP_URB_SIZE, GFP_KERNEL);
 	if (err < 0)
 		return err;
 
-- 
2.20.1

