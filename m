Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01896C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5DAB2070B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 09:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732994AbfC0J6o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 05:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731668AbfC0J6n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 05:58:43 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2713988ABB;
        Wed, 27 Mar 2019 09:58:43 +0000 (UTC)
Received: from localhost (unknown [10.40.205.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF87B6085B;
        Wed, 27 Mar 2019 09:58:42 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH 4/8] rt2800mmio: fetch tx status changes
Date:   Wed, 27 Mar 2019 10:58:27 +0100
Message-Id: <1553680711-15730-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
References: <1553680711-15730-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 27 Mar 2019 09:58:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Prepare to use rt2800mmio_fetch_txstatus() in concurrent manner and drop
return value since is not longer needed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index f7635a47dbcd..3d4e37a9854e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -255,12 +255,12 @@ void rt2800mmio_autowake_tasklet(unsigned long data)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_autowake_tasklet);
 
-static bool rt2800mmio_fetch_txstatus(struct rt2x00_dev *rt2x00dev)
+static void rt2800mmio_fetch_txstatus(struct rt2x00_dev *rt2x00dev)
 {
 	u32 status;
-	bool more = false;
+	unsigned long flags;
 
-	/* FIXEME: rewrite this comment
+	/*
 	 * The TX_FIFO_STATUS interrupt needs special care. We should
 	 * read TX_STA_FIFO but we should do it immediately as otherwise
 	 * the register can overflow and we would lose status reports.
@@ -271,20 +271,21 @@ static bool rt2800mmio_fetch_txstatus(struct rt2x00_dev *rt2x00dev)
 	 * because we can schedule the tasklet multiple times (when the
 	 * interrupt fires again during tx status processing).
 	 *
-	 * txstatus tasklet is called with INT_SOURCE_CSR_TX_FIFO_STATUS
-	 * disabled so have only one producer and one consumer - we don't
-	 * need to lock the kfifo.
+	 * We also read statuses from tx status timeout timer, use
+	 * lock to prevent concurent writes to fifo.
 	 */
+
+	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
+
 	while (!kfifo_is_full(&rt2x00dev->txstatus_fifo)) {
 		status = rt2x00mmio_register_read(rt2x00dev, TX_STA_FIFO);
 		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
 			break;
 
 		kfifo_put(&rt2x00dev->txstatus_fifo, status);
-		more = true;
 	}
 
-	return more;
+	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);
 }
 
 void rt2800mmio_txstatus_tasklet(unsigned long data)
-- 
2.7.5

