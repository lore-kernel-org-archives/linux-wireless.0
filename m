Return-Path: <SRS0=LItA=3E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DF6C33CB2
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 10:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22C092467D
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579085979;
	bh=oooxU1fSQCC+7+2/qjJfnCNptp5lyJmf5WZL48F0nFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gOXKRs9pfIGjP6jOO0xnMZK2SG+7O4L6f91KsOqADxgoksRiuy5Jg6iKIfLVpJwxS
	 7PKiL9e6l8qF656hWbvIgmStyOAYkV4+1/hB0Eh4rxgpZX07oQSwVeJNoPCo57fSNg
	 JtkBMk59CFKJ8Jl2hWsfIV23ImVzhRwB62PUaLrU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgAOK7i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Jan 2020 05:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729856AbgAOK7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Jan 2020 05:59:38 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE2FE2467C;
        Wed, 15 Jan 2020 10:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579085977;
        bh=oooxU1fSQCC+7+2/qjJfnCNptp5lyJmf5WZL48F0nFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESzNGXricb4pvjOilz10Bhes+DsRRk3BwH8plV0s4e5VMx8QluVdCSsMloHnMtXIo
         hrciJprMGEFDFOAQ9mdTjSwTqgo+Ok1uhySz1bBu7wZLBNUMTUTx2hNkebEAl3T3et
         Sr+DtJJU3JrWapStwShv/fsujXwu8fOdeHvup8D8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH v3 04/18] mt76: mt76u: add mt76_queue to mt76u_refill_rx signature
Date:   Wed, 15 Jan 2020 11:58:44 +0100
Message-Id: <35cd2d7a1e1042e0cd3fb8b83d2945aa5ee79a76.1579085367.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1579085367.git.lorenzo@kernel.org>
References: <cover.1579085367.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76_queue parameter to mt76u_refill_rx signature in order to
reuse it for mcu hw rx queue

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 23973ec6c92c..65b819f0d18a 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -318,11 +318,12 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76_queue *q, struct urb *urb,
 }
 
 static int
-mt76u_refill_rx(struct mt76_dev *dev, struct urb *urb, int nsgs, gfp_t gfp)
+mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
+		struct urb *urb, int nsgs, gfp_t gfp)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	enum mt76_rxq_id qid = q - &dev->q_rx[MT_RXQ_MAIN];
 
-	if (dev->usb.sg_en)
+	if (qid == MT_RXQ_MAIN && dev->usb.sg_en)
 		return mt76u_fill_rx_sg(dev, q, urb, nsgs, gfp);
 
 	urb->transfer_buffer_length = q->buf_size;
@@ -355,13 +356,14 @@ mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e,
 static int
 mt76u_rx_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
 {
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	int err;
 
 	err = mt76u_urb_alloc(dev, e, MT_RX_SG_MAX_SIZE);
 	if (err)
 		return err;
 
-	return mt76u_refill_rx(dev, e->urb, MT_RX_SG_MAX_SIZE,
+	return mt76u_refill_rx(dev, q, e->urb, MT_RX_SG_MAX_SIZE,
 			       GFP_KERNEL);
 }
 
@@ -558,7 +560,7 @@ mt76u_process_rx_queue(struct mt76_dev *dev, struct mt76_queue *q)
 
 		count = mt76u_process_rx_entry(dev, urb, q->buf_size);
 		if (count > 0) {
-			err = mt76u_refill_rx(dev, urb, count, GFP_ATOMIC);
+			err = mt76u_refill_rx(dev, q, urb, count, GFP_ATOMIC);
 			if (err < 0)
 				break;
 		}
-- 
2.21.1

