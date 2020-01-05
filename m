Return-Path: <SRS0=kXDB=22=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6C9C33C8C
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 12:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB39217F4
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 12:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578226977;
	bh=2PCHf3GasOMCjW0hCfPmnvxJV0nTnK0fKSwHHlLaP8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xnZEs210ZHxQSY5vduFbw+e/D2J+hxI/Q1xUdJcZMA+1Uk2MZftT+NPCGF1UvMDd5
	 9l0iz8sw/qiCTQjo1JLfa729ValQFtY+Q3SDvTaIMOi9SZWNX/kgUtFOJF5n+7z2Hj
	 vA9W/CTuRQwNk+JYEJSwE9+/cXGCzURiFY5sE2kY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgAEMW4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 5 Jan 2020 07:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAEMW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Jan 2020 07:22:56 -0500
Received: from new-host-5.station (net-2-42-61-77.cust.vodafonedsl.it [2.42.61.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A43332465E;
        Sun,  5 Jan 2020 12:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578226974;
        bh=2PCHf3GasOMCjW0hCfPmnvxJV0nTnK0fKSwHHlLaP8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iB7kzM9nXJ9y9Yw0CerKc6gLlD1YRcHtjFfdJGfguKeQZG0RtUwRhiLfGhb68lFVN
         LReozawQimaBN2VIW3CWzgLUfCL0g7hSxHIU/CLeR0AnSh/9iJz00sfU38lcNw36wj
         eJiFiwzYhKH5D28r9vupgqPoJ6eXDRHh8NNwHF8E=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH v2 11/18] mt76: mt76u: add queue parameter to mt76u_rx_urb_alloc
Date:   Sun,  5 Jan 2020 13:21:49 +0100
Message-Id: <ccf397c953e7fc4098ee4ff676eba56b2c056738.1578226544.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1578226544.git.lorenzo@kernel.org>
References: <cover.1578226544.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76_queue parameter to mt76u_rx_urb_alloc signature since this
routine will be used to allocate urbs for mcu hw queue used by new
chipset generation (e.g. mt7663u). Check sg_max_size in in
mt76u_urb_alloc in order to use linear urb for mcu queue

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index e1112899a207..f80380c674a1 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -347,24 +347,25 @@ mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e,
 
 	usb_init_urb(e->urb);
 
-	if (dev->usb.sg_en)
+	if (dev->usb.sg_en && sg_max_size > 0)
 		e->urb->sg = (struct scatterlist *)(e->urb + 1);
 
 	return 0;
 }
 
 static int
-mt76u_rx_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
+mt76u_rx_urb_alloc(struct mt76_dev *dev, struct mt76_queue *q,
+		   struct mt76_queue_entry *e)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	int err;
+	enum mt76_rxq_id qid = q - &dev->q_rx[MT_RXQ_MAIN];
+	int err, sg_size;
 
-	err = mt76u_urb_alloc(dev, e, MT_RX_SG_MAX_SIZE);
+	sg_size = qid == MT_RXQ_MAIN ? MT_RX_SG_MAX_SIZE : 0;
+	err = mt76u_urb_alloc(dev, e, sg_size);
 	if (err)
 		return err;
 
-	return mt76u_refill_rx(dev, q, e->urb, MT_RX_SG_MAX_SIZE,
-			       GFP_KERNEL);
+	return mt76u_refill_rx(dev, q, e->urb, sg_size, GFP_KERNEL);
 }
 
 static void mt76u_urb_free(struct urb *urb)
@@ -620,7 +621,7 @@ mt76u_alloc_rx_queue(struct mt76_dev *dev, enum mt76_rxq_id qid)
 	q->buf_size = PAGE_SIZE;
 
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_rx_urb_alloc(dev, &q->entry[i]);
+		err = mt76u_rx_urb_alloc(dev, q, &q->entry[i]);
 		if (err < 0)
 			return err;
 	}
-- 
2.21.1

