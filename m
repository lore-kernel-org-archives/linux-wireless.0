Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F3BC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFB9C20693
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfCLPGn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfCLPGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:06:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 845B3307EA87;
        Tue, 12 Mar 2019 15:06:42 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24CDA1797C;
        Tue, 12 Mar 2019 15:06:41 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 06/12] mt76usb: move mt76u_buf->done to queue entry
Date:   Tue, 12 Mar 2019 16:06:00 +0100
Message-Id: <1552403166-3821-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 12 Mar 2019 15:06:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mt76_queue_entry has alreay one bool variable, adding new one will
not increase it's size. Removing ->done filed from mt76u_buf will
allow to use urb directly in mt76usb code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  2 +-
 drivers/net/wireless/mediatek/mt76/usb.c  | 12 +++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 476cb39c99b7..998505064dee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -85,7 +85,6 @@ struct mt76_queue_buf {
 
 struct mt76u_buf {
 	struct urb *urb;
-	bool done;
 };
 
 struct mt76_queue_entry {
@@ -99,6 +98,7 @@ struct mt76_queue_entry {
 	};
 	enum mt76_txq_id qid;
 	bool schedule;
+	bool done;
 };
 
 struct mt76_queue_regs {
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 86bf852c6e3d..a4ef9bb1603d 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -615,7 +615,6 @@ static void mt76u_tx_tasklet(unsigned long data)
 	struct mt76_dev *dev = (struct mt76_dev *)data;
 	struct mt76_queue_entry entry;
 	struct mt76_sw_queue *sq;
-	struct mt76u_buf *buf;
 	struct mt76_queue *q;
 	bool wake;
 	int i;
@@ -626,8 +625,7 @@ static void mt76u_tx_tasklet(unsigned long data)
 
 		spin_lock_bh(&q->lock);
 		while (true) {
-			buf = &q->entry[q->head].ubuf;
-			if (!buf->done || !q->queued)
+			if (!q->entry[q->head].done || !q->queued)
 				break;
 
 			if (q->entry[q->head].schedule) {
@@ -693,11 +691,11 @@ static void mt76u_tx_status_data(struct work_struct *work)
 static void mt76u_complete_tx(struct urb *urb)
 {
 	struct mt76_dev *dev = dev_get_drvdata(&urb->dev->dev);
-	struct mt76u_buf *buf = urb->context;
+	struct mt76_queue_entry *e = urb->context;
 
 	if (mt76u_urb_error(urb))
 		dev_err(dev->dev, "tx urb failed: %d\n", urb->status);
-	buf->done = true;
+	e->done = true;
 
 	tasklet_schedule(&dev->usb.tx_tasklet);
 }
@@ -732,6 +730,7 @@ static void mt76u_complete_tx(struct urb *urb)
 	if (err < 0)
 		return err;
 
+	q->entry[idx].done = false;
 	buf = &q->entry[idx].ubuf;
 	if (!dev->usb.sg_en) {
 		buf->urb->transfer_buffer = skb->data;
@@ -741,10 +740,9 @@ static void mt76u_complete_tx(struct urb *urb)
 			return err;
 	}
 	buf->urb->transfer_buffer_length = skb->len;
-	buf->done = false;
 
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
-			    buf, mt76u_complete_tx, buf);
+			    buf, mt76u_complete_tx, &q->entry[idx]);
 
 	q->tail = (q->tail + 1) % q->ndesc;
 	q->entry[idx].skb = skb;
-- 
1.9.3

