Return-Path: <SRS0=74Mc=2M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0305EC2D0D4
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Dec 2019 10:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDDE62070A
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Dec 2019 10:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577010827;
	bh=k41+vOgCILVOCYm2V5pTYuGdyxla4cOzk5lENxGVNRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ylemKNhl87RIGh7rl1K3MrfD57HAapE+4BQR7neCqXMydMZgHiTMBm7MKFDw24yXv
	 SqQ0VTk4g/UrPDc8e1Rz0T1ct89gHoxzvCoN4cxQl5DF3URaTPIYSwlBya3evGwJxK
	 pTGIIbyz3CneWYajv5RolMrfswb4MKMNi3x58ijE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLVKdq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 22 Dec 2019 05:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfLVKdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Dec 2019 05:33:46 -0500
Received: from lore-desk-wlan.lan (unknown [151.66.53.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EFB220733;
        Sun, 22 Dec 2019 10:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577010826;
        bh=k41+vOgCILVOCYm2V5pTYuGdyxla4cOzk5lENxGVNRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4oKFNQZfclpo6Cc1z26qXp4HGvY7gj7amcLMjgCt6PwOCSdeXuXEuWRMmwAfN2Q6
         TnHKVwrkdP0aoy8zLjHl/zaj7KQsmeUHq4DPQLwzUmCzeeVnPo18sVjByw5B3QDOvo
         GX8Sv81NmQ47FPD4BkFj0lZenDgH16sjEFbs24mU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH 05/18] mt76: mt76u: use mt76_queue as mt76u_complete_rx context
Date:   Sun, 22 Dec 2019 11:33:07 +0100
Message-Id: <73736fcc88ffaf16598bdba777c30f79b88c5c85.1577010183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1577010183.git.lorenzo@kernel.org>
References: <cover.1577010183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to reuse mt76u_complete_rx for both data and mcu rx queue, rely
on mt76_queue as urb context in mt76u_complete_rx. Moreover set usb rx
endoint according to rx queue in mt76u_submit_rx_buf. This is a
preliminary patch to add mt7663u support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index ab99d498b8f8..03b9ffaa0e8b 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -506,8 +506,8 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb,
 
 static void mt76u_complete_rx(struct urb *urb)
 {
-	struct mt76_dev *dev = urb->context;
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_dev *dev = dev_get_drvdata(&urb->dev->dev);
+	struct mt76_queue *q = urb->context;
 	unsigned long flags;
 
 	trace_rx_urb(dev, urb);
@@ -537,10 +537,13 @@ static void mt76u_complete_rx(struct urb *urb)
 }
 
 static int
-mt76u_submit_rx_buf(struct mt76_dev *dev, struct urb *urb)
+mt76u_submit_rx_buf(struct mt76_dev *dev, enum mt76_rxq_id qid,
+		    struct urb *urb)
 {
-	mt76u_fill_bulk_urb(dev, USB_DIR_IN, MT_EP_IN_PKT_RX, urb,
-			    mt76u_complete_rx, dev);
+	int ep = qid == MT_RXQ_MAIN ? MT_EP_IN_PKT_RX : MT_EP_IN_CMD_RESP;
+
+	mt76u_fill_bulk_urb(dev, USB_DIR_IN, ep, urb,
+			    mt76u_complete_rx, &dev->q_rx[qid]);
 	trace_submit_urb(dev, urb);
 
 	return usb_submit_urb(urb, GFP_ATOMIC);
@@ -564,7 +567,7 @@ mt76u_process_rx_queue(struct mt76_dev *dev, struct mt76_queue *q)
 			if (err < 0)
 				break;
 		}
-		mt76u_submit_rx_buf(dev, urb);
+		mt76u_submit_rx_buf(dev, qid, urb);
 	}
 	if (qid == MT_RXQ_MAIN)
 		mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
@@ -588,7 +591,7 @@ static int mt76u_submit_rx_buffers(struct mt76_dev *dev)
 
 	spin_lock_irqsave(&q->lock, flags);
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_submit_rx_buf(dev, q->entry[i].urb);
+		err = mt76u_submit_rx_buf(dev, MT_RXQ_MAIN, q->entry[i].urb);
 		if (err < 0)
 			break;
 	}
-- 
2.24.1

