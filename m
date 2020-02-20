Return-Path: <SRS0=UygI=4I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437E7C11D04
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Feb 2020 11:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1646208C4
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Feb 2020 11:41:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="KyTEzFR0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBTLlm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Feb 2020 06:41:42 -0500
Received: from nbd.name ([46.4.11.11]:55068 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbgBTLlm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Feb 2020 06:41:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QmGrF9CoFgVUhqNJ0kmrFs4wsbbx9jdjenAphQiCtk4=; b=KyTEzFR0eIZU8BJkWkVttAE/K6
        jblo1l90aY4jYymoDG6rQ+Kse8KacbqeUj7yXiSqFtQBP7Dm1iSPaTHq/vh25rMLPV2jrYhZdPqqM
        jnzReGZ6eMkhnWYsDGLX4cL2YkihJzd/VOhLlSEmxIlJ9Xo/2hoKdH6lbLIKWbO4o32M=;
Received: from [80.255.7.124] (helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1j4kD6-000544-KI; Thu, 20 Feb 2020 12:41:40 +0100
Received: by maeck.local (Postfix, from userid 501)
        id 9F2B87CE7105; Thu, 20 Feb 2020 12:41:39 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, stable@vger.kernel.org
Subject: [PATCH 5.6] mt76: fix array overflow on receiving too many fragments for a packet
Date:   Thu, 20 Feb 2020 12:41:39 +0100
Message-Id: <20200220114139.46508-1-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If the hardware receives an oversized packet with too many rx fragments,
skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
This becomes especially visible if it corrupts the freelist pointer of
a slab page.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 6173c80189ba..1847f55e199b 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -447,10 +447,13 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
 	struct page *page = virt_to_head_page(data);
 	int offset = data - page_address(page);
 	struct sk_buff *skb = q->rx_head;
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-	offset += q->buf_offset;
-	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page, offset, len,
-			q->buf_size);
+	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
+		offset += q->buf_offset;
+		skb_add_rx_frag(skb, shinfo->nr_frags, page, offset, len,
+				q->buf_size);
+	}
 
 	if (more)
 		return;
-- 
2.24.0

