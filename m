Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F395C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 14:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D58C2147A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550671549;
	bh=/+8agYbfxRr0us3+J6phVQRdQvPWGdGS1ksMn3KXPR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oyRfAmH8k6i1QcsT4YUTprB67SgmM0UOsLJcTwXteObfqXHlXeOcBcafkToC71v3S
	 9wQoir6x7X+uP/cVnT4E1H5/R7YYBG0frQo1+7rrKCPBpajrhIX3wtLkP8Hz0OiPQK
	 Qy2V3GKjNhg9L2dwR/Kdmd/tHw7LQrEDPS0C9P0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfBTOFs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 09:05:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbfBTOFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 09:05:48 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E2632147A;
        Wed, 20 Feb 2019 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550671547;
        bh=/+8agYbfxRr0us3+J6phVQRdQvPWGdGS1ksMn3KXPR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZpesDwTZUhBk4jvAg+EPww8mQDLcKFbAbR396A8by6JPQM0bbSKlTuOVwlnsplN0
         K00U+ty4hWj75L5ZbI2nLqbIoebJlXeGh+qp4FdFAR8PctZFeC0H1PGAavmDOPSQX/
         0Ut7JqNrWCvWSVDMN3/q5VonB/h1Ekv9qc32/dok=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [RFC 1/3] mt76: usb: introduce mt76u_fill_bulk_urb routine
Date:   Wed, 20 Feb 2019 15:05:33 +0100
Message-Id: <9e48ac02e4da1474351a713d4e02adf7811371a0.1550671183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550671183.git.lorenzo@kernel.org>
References: <cover.1550671183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add mt76u_fill_bulk_urb routine and remove duplicate code
use to initialize tx/rx urb

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 45 ++++++++++++++----------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 62dfd70232fe..c84415caaeaf 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -381,9 +381,10 @@ void mt76u_buf_free(struct mt76u_buf *buf)
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
@@ -397,6 +398,14 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 
 	usb_fill_bulk_urb(buf->urb, udev, pipe, data, buf->len,
 			  complete_fn, context);
+}
+
+int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
+		     struct mt76u_buf *buf, gfp_t gfp,
+		     usb_complete_t complete_fn, void *context)
+{
+	mt76u_fill_bulk_urb(dev, dir, index, buf, complete_fn,
+			    context);
 	trace_submit_urb(dev, buf->urb);
 
 	return usb_submit_urb(buf->urb, gfp);
@@ -732,11 +741,16 @@ static void mt76u_complete_tx(struct urb *urb)
 }
 
 static int
-mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
+mt76u_tx_build_sg(struct mt76_dev *dev, struct sk_buff *skb,
+		  struct urb *urb)
 {
-	int nsgs = 1 + skb_shinfo(skb)->nr_frags;
 	struct sk_buff *iter;
+	int nsgs;
+
+	if (!dev->usb.sg_en)
+		return 0;
 
+	nsgs = 1 + skb_shinfo(skb)->nr_frags;
 	skb_walk_frags(skb, iter)
 		nsgs += 1 + skb_shinfo(iter)->nr_frags;
 
@@ -754,12 +768,8 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		   struct sk_buff *skb, struct mt76_wcid *wcid,
 		   struct ieee80211_sta *sta)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
-	u8 *data = NULL, ep = q2ep(q->hw_idx);
 	struct mt76u_buf *buf;
 	u16 idx = q->tail;
-	unsigned int pipe;
 	int err;
 
 	if (q->queued == q->ndesc)
@@ -771,19 +781,16 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		return err;
 
 	buf = &q->entry[idx].ubuf;
+	buf->buf = skb->data;
+	buf->len = skb->len;
 	buf->done = false;
 
-	if (dev->usb.sg_en) {
-		err = mt76u_tx_build_sg(skb, buf->urb);
-		if (err < 0)
-			return err;
-	} else {
-		data = skb->data;
-	}
+	err = mt76u_tx_build_sg(dev, skb, buf->urb);
+	if (err < 0)
+		return err;
 
-	pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[ep]);
-	usb_fill_bulk_urb(buf->urb, udev, pipe, data, skb->len,
-			  mt76u_complete_tx, buf);
+	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
+			    buf, mt76u_complete_tx, buf);
 
 	q->tail = (q->tail + 1) % q->ndesc;
 	q->entry[idx].skb = skb;
-- 
2.20.1

