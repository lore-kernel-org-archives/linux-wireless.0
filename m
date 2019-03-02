Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365C3C10F05
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E995A20863
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551534487;
	bh=s82Ajn8sVTPwcw+AdtP7/egcAWFrckE8dKY+4TwS318=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VUDNYhtBK904GC6wZ+6REGeyBQQKd9VJ6dv1YgDWu37fkYIo1diMUqvdIvNNdJUy0
	 9vz9/SWCpdCtBjYVCC02gQ+Mm6zQ9jB62ublowGQOCDRO1Vwcjercy3oWUF8ub2B48
	 n0Qp3R8IRN4m2N5WIqsjJ0+Pmj4CSqB1zDmNeBmY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfCBNsG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 08:48:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfCBNsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 08:48:05 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B9E320838;
        Sat,  2 Mar 2019 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551534484;
        bh=s82Ajn8sVTPwcw+AdtP7/egcAWFrckE8dKY+4TwS318=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5pXMt0QWHxWtQoDHTY1Vf6FkwCNfoKNbEMEzaqXO5DKdvUS+C6GoH8/Y/VqD3xz8
         Qx1fPP+ZP3Pt//gCQLJExhq+LiNgUdHdJC/D9XIZHCJvvEmjprmnyQMpAyHUdvQu1l
         9/OW+zYpyx2geJU0t477EK9ZIjxo7JT2MYVvjm8o=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, roychl666@gmail.com,
        ryder.lee@mediatek.com
Subject: [PATCH 5/5] mt76: introduce mt76_txq_id field in mt76_queue_entry
Date:   Sat,  2 Mar 2019 14:47:42 +0100
Message-Id: <4154a3ec914e43ab3802a083895b1035bc626229.1551533068.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551533068.git.lorenzo@kernel.org>
References: <cover.1551533068.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76_txq_id field to mt76_queue_entry in order to properly
track outstanding frames for mt7615 that relies on a single hw queue

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h | 1 +
 drivers/net/wireless/mediatek/mt76/tx.c   | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a37a1af74981..75ea381ff64a 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -164,7 +164,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 	while (q->queued && q->tail != last) {
 		mt76_dma_tx_cleanup_idx(dev, q, q->tail, &entry);
 		if (entry.schedule)
-			dev->q_tx[qid].swq_queued--;
+			dev->q_tx[entry.qid].swq_queued--;
 
 		q->tail = (q->tail + 1) % q->ndesc;
 		q->queued--;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index e3160dc7c515..51245623b427 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -100,6 +100,7 @@ struct mt76_queue_entry {
 		struct mt76_txwi_cache *txwi;
 		struct mt76u_buf ubuf;
 	};
+	enum mt76_txq_id qid;
 	bool schedule;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 240ef2cc5c79..b59cdf88a224 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -465,6 +465,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_sw_queue *sq,
 	} while (n_frames < limit);
 
 	if (!probe) {
+		hwq->entry[idx].qid = sq - dev->q_tx;
 		hwq->entry[idx].schedule = true;
 		sq->swq_queued++;
 	}
-- 
2.20.1

