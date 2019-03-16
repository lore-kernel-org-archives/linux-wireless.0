Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F389C10F0C
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5BCD218D4
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="gZKshQls"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfCPUmq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:42:46 -0400
Received: from nbd.name ([46.4.11.11]:39534 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfCPUmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rcpUey5/Xb3I1pt3c9DyfcUYzPu3iCDSpeuN9zRScKs=; b=gZKshQlsqN0N/BJ2MEBwCwiSTm
        u5vUXXvHJ5fXUDwFD596ff99vdrLSBxdCs8alAjB1PPiU/zjh842a2F2u5CT2GoneEsX8ZCTUyDSI
        t96Wb8aqrMKir4Km4qKzHRlfXcSUvKYM1j23tS0tW7fVwMcKZ9F3L18RS2anXM9N2V1w=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5G8h-0005Rz-Ny
        for linux-wireless@vger.kernel.org; Sat, 16 Mar 2019 21:42:43 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id CAAEF530F04E; Sat, 16 Mar 2019 21:42:42 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] mt76: reduce locking in mt76_dma_tx_cleanup
Date:   Sat, 16 Mar 2019 21:42:38 +0100
Message-Id: <20190316204242.73560-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190316204242.73560-1-nbd@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

q->tail can be safely updated without locking, because there is no
concurrent access. If called from outside of the tasklet (for flushing),
the tasklet is always disabled.
q->queued can be safely read without locking, as long as the decrement
happens within the locked section.
This patch allows cleaning up tx packets outside of the section that holds
the queue lock for improved performance

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 26 ++++++++++++++++--------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 09978757e7d1..7d8f9b8a81b5 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -149,31 +149,29 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 	struct mt76_sw_queue *sq = &dev->q_tx[qid];
 	struct mt76_queue *q = sq->q;
 	struct mt76_queue_entry entry;
+	unsigned int n_swq_queued[4] = {};
+	unsigned int n_queued = 0;
 	bool wake = false;
-	int last;
+	int i, last;
 
 	if (!q)
 		return;
 
-	spin_lock_bh(&q->lock);
 	if (flush)
 		last = -1;
 	else
 		last = ioread32(&q->regs->dma_idx);
 
-	while (q->queued && q->tail != last) {
+	while ((q->queued > n_queued) && q->tail != last) {
 		mt76_dma_tx_cleanup_idx(dev, q, q->tail, &entry);
 		if (entry.schedule)
-			dev->q_tx[entry.qid].swq_queued--;
+			n_swq_queued[entry.qid]++;
 
 		q->tail = (q->tail + 1) % q->ndesc;
-		q->queued--;
+		n_queued++;
 
-		if (entry.skb) {
-			spin_unlock_bh(&q->lock);
+		if (entry.skb)
 			dev->drv->tx_complete_skb(dev, qid, &entry);
-			spin_lock_bh(&q->lock);
-		}
 
 		if (entry.txwi) {
 			mt76_put_txwi(dev, entry.txwi);
@@ -184,6 +182,16 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 			last = ioread32(&q->regs->dma_idx);
 	}
 
+	spin_lock_bh(&q->lock);
+
+	q->queued -= n_queued;
+	for (i = 0; i < ARRAY_SIZE(n_swq_queued); i++) {
+		if (!n_swq_queued[i])
+			continue;
+
+		dev->q_tx[i].swq_queued -= n_swq_queued[i];
+	}
+
 	if (flush)
 		mt76_dma_sync_idx(dev, q);
 
-- 
2.17.0

