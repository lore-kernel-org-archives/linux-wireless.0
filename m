Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0C0C07E85
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80FD120878
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="aJ4qRJ6B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80FD120878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbeLCMZH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 07:25:07 -0500
Received: from nbd.name ([46.4.11.11]:51622 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbeLCMZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 07:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2qxjmdyFSCgf5+okDYpKrVFSvJViasxIw58Aa2d5UWs=; b=aJ4qRJ6BP6ZqcYZpSWhfSzki2+
        g0XObtWVuz1pxoWTXbTSEwizMoCGxZc+3tRHuh5W+RIKIrmVQIrW4HB6rCnK92c7nY2Q5tIB9muq9
        JNxqFXVzVtqzEyNtLwqPSaBjxWh58pMXIswGOKUOYtUgys2u9x4p08mYMJw0fl06jgcw=;
Received: by maeck.lan (Postfix, from userid 501)
        id 79623480F7A8; Mon,  3 Dec 2018 13:24:15 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76: add size check for additional rx fragments
Date:   Mon,  3 Dec 2018 13:24:13 +0100
Message-Id: <20181203122415.22387-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

So far the code only validates the buffer size of the first skb.
Extend this check to cover additional fragments as well, in case the size
is corrupted during a DMA reset.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index e2ba26378575..710a77fccf63 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -430,6 +430,14 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 		if (!data)
 			break;
 
+		if (q->buf_size < len + q->buf_offset) {
+			dev_kfree_skb(q->rx_head);
+			q->rx_head = NULL;
+
+			skb_free_frag(data);
+			continue;
+		}
+
 		if (q->rx_head) {
 			mt76_add_fragment(dev, q, data, len, more);
 			continue;
-- 
2.17.0

