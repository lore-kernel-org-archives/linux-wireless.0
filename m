Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCDAC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 974D021874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbfCUP0W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:26:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbfCUP0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:26:22 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68E70369CD;
        Thu, 21 Mar 2019 15:26:22 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A2385D9C5;
        Thu, 21 Mar 2019 15:26:17 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/12] mt76usb: move mt76u_buf->done to queue entry
Date:   Thu, 21 Mar 2019 16:25:31 +0100
Message-Id: <20190321152537.19105-7-sgruszka@redhat.com>
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 21 Mar 2019 15:26:22 +0000 (UTC)
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
 drivers/net/wireless/mediatek/mt76/usb.c  | 13 +++++--------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 4cb01502f5b1..508f21926025 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -91,7 +91,6 @@ struct mt76_tx_info {
 
 struct mt76u_buf {
 	struct urb *urb;
-	bool done;
 };
 
 struct mt76_queue_entry {
@@ -105,6 +104,7 @@ struct mt76_queue_entry {
 	};
 	enum mt76_txq_id qid;
 	bool schedule;
+	bool done;
 };
 
 struct mt76_queue_regs {
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 8bb660e0d65a..bea7379d572b 100644
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
@@ -738,15 +736,14 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	if (err < 0)
 		return err;
 
+	q->entry[idx].done = false;
 	buf = &q->entry[idx].ubuf;
 	err = mt76u_tx_setup_buffers(dev, skb, buf->urb);
 	if (err < 0)
 		return err;
 
-	buf->done = false;
-
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
-			    buf, mt76u_complete_tx, buf);
+			    buf, mt76u_complete_tx, &q->entry[idx]);
 
 	q->tail = (q->tail + 1) % q->ndesc;
 	q->entry[idx].skb = skb;
-- 
2.20.1

