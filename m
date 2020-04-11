Return-Path: <SRS0=JTkr=53=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BA3C2BA19
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C7B1206F7
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Apr 2020 23:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648842;
	bh=w68oapllwXBcXuPwr+A/R2ShE4TVv5AB6GPxa7PIA1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Hjzc8GzyXfOFvVWnPKjzuytmiMvx6oiXOT2IB7DW73AzHDa380KL14xNoNhUUQEPG
	 ZDJb84BjHFCpBB2vrX3xERBzxgpj/ZlWQByxuJQPkQ0NAs/o1dopnvczg+hGaNc+MI
	 KOQ9LV5BKRZT+/VpZOFkI/4ncsKQiKphFlz5lG78=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgDKXrU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:47:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbgDKXFC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA92E21841;
        Sat, 11 Apr 2020 23:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646302;
        bh=w68oapllwXBcXuPwr+A/R2ShE4TVv5AB6GPxa7PIA1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3Dgskd7nGUMEBBHuGSQoYj9yAvax7I2NUvGpeeMCeNst65cbnSrMWJR9XUB+TW73
         lFmGYK41NlbIaA6lUJwqe8km3LmP5OhqNpuu/LA79a0A7ezSMTuJl1WeW6tFPpWXQB
         WCtpsCErDMA0Fk1xSpNfSitmywZnY1h1rVfRhYcE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 061/149] mt76: fix handling full tx queues in mt76_dma_tx_queue_skb_raw
Date:   Sat, 11 Apr 2020 19:02:18 -0400
Message-Id: <20200411230347.22371-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 93eaec7625f13cffb593b471405b017c7e64d4ee ]

Fixes a theoretical issue where it could potentially overwrite an existing
descriptor entry (and leaking its skb)

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1847f55e199b0..c001d94958d83 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -261,10 +261,13 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	struct mt76_queue_buf buf;
 	dma_addr_t addr;
 
+	if (q->queued + 1 >= q->ndesc - 1)
+		goto error;
+
 	addr = dma_map_single(dev->dev, skb->data, skb->len,
 			      DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev->dev, addr)))
-		return -ENOMEM;
+		goto error;
 
 	buf.addr = addr;
 	buf.len = skb->len;
@@ -275,6 +278,10 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	spin_unlock_bh(&q->lock);
 
 	return 0;
+
+error:
+	dev_kfree_skb(skb);
+	return -ENOMEM;
 }
 
 static int
-- 
2.20.1

