Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F60C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C710D21874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfCUPZx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:25:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728478AbfCUPZw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:25:52 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A49ECC4EBB;
        Thu, 21 Mar 2019 15:25:52 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05EBD1001E87;
        Thu, 21 Mar 2019 15:25:49 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 01/12] mt76usb: change mt76u_submit_buf
Date:   Thu, 21 Mar 2019 16:25:26 +0100
Message-Id: <20190321152537.19105-2-sgruszka@redhat.com>
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 21 Mar 2019 15:25:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove unnecessery arguments and change the function name since is
now used only for RX.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 30 ++++++++++--------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 7b62bd63d395..ac4608f1422d 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -394,18 +394,6 @@ mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
 			  complete_fn, context);
 }
 
-static int
-mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
-		 struct mt76u_buf *buf, gfp_t gfp,
-		 usb_complete_t complete_fn, void *context)
-{
-	mt76u_fill_bulk_urb(dev, dir, index, buf, complete_fn,
-			    context);
-	trace_submit_urb(dev, buf->urb);
-
-	return usb_submit_urb(buf->urb, gfp);
-}
-
 static inline struct mt76u_buf
 *mt76u_get_next_rx_entry(struct mt76_queue *q)
 {
@@ -513,6 +501,16 @@ static void mt76u_complete_rx(struct urb *urb)
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
+static int
+mt76u_submit_rx_buf(struct mt76_dev *dev, struct mt76u_buf *buf)
+{
+	mt76u_fill_bulk_urb(dev, USB_DIR_IN, MT_EP_IN_PKT_RX, buf,
+			    mt76u_complete_rx, dev);
+	trace_submit_urb(dev, buf->urb);
+
+	return usb_submit_urb(buf->urb, GFP_ATOMIC);
+}
+
 static void mt76u_rx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
@@ -534,9 +532,7 @@ static void mt76u_rx_tasklet(unsigned long data)
 			if (err < 0)
 				break;
 		}
-		mt76u_submit_buf(dev, USB_DIR_IN, MT_EP_IN_PKT_RX,
-				 buf, GFP_ATOMIC,
-				 mt76u_complete_rx, dev);
+		mt76u_submit_rx_buf(dev, buf);
 	}
 	mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
 
@@ -551,9 +547,7 @@ int mt76u_submit_rx_buffers(struct mt76_dev *dev)
 
 	spin_lock_irqsave(&q->lock, flags);
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_submit_buf(dev, USB_DIR_IN, MT_EP_IN_PKT_RX,
-				       &q->entry[i].ubuf, GFP_ATOMIC,
-				       mt76u_complete_rx, dev);
+		err = mt76u_submit_rx_buf(dev, &q->entry[i].ubuf);
 		if (err < 0)
 			break;
 	}
-- 
2.20.1

