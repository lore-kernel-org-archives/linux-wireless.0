Return-Path: <SRS0=CpGI=PI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE596C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Dec 2018 14:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 912752133F
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Dec 2018 14:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbeLaOnF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 Dec 2018 09:43:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39877 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeLaOnF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Dec 2018 09:43:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id t27so26637169wra.6
        for <linux-wireless@vger.kernel.org>; Mon, 31 Dec 2018 06:43:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AdQgKVoKDkjh5PCRSsBKveHA65/ubd9hH6bngpqGsv4=;
        b=oM2zVgGM9tNTBPOx/7QyZxVYQUxPHnanBynMyBGV3Hq4uBDgqEgyLBcbBFkNLTCfR0
         FR1tIkAbUT49cabr3r4svtYFBQ5qsoIfbkW/znM2u9DIz3EgjLOtXMBImDbuiQ6apVTe
         lw46kH0GJyjwHKb+rDGSdxznAF1KTnvC1Ojy0Ma+LjKahEXk5qvdXxYbZ4LXzBRAyyAW
         wT4M9LmplBqEzei5wgTmE9FqznxwcKnBqPU3r9yZclA7roFn4bymStUOo2z2gjnhb2+8
         HRFXFfk6sBHIe0dmXYnT7XileKqTM7jCkxealYfgdjj9+7u28poUUCZGDX58rBAdPmvv
         p9RQ==
X-Gm-Message-State: AJcUukfdAcLr0yeQLJN2jP3r5K0L3qjB2T4QthNLhNH8fk/XJWU0BXfb
        1GEsfWfsOHRaQcF/1o0/ap8fKA==
X-Google-Smtp-Source: ALg8bN5dFTWRW+k+gAVb9cwGb84FklhpmUywexFqSJmFrICQET9xghlJD+yRp9Pv/+RxhtRWoq8M9A==
X-Received: by 2002:adf:e383:: with SMTP id e3mr10463971wrm.31.1546267383643;
        Mon, 31 Dec 2018 06:43:03 -0800 (PST)
Received: from localhost.lan ([151.21.137.205])
        by smtp.gmail.com with ESMTPSA id l14sm97178153wrp.55.2018.12.31.06.43.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 Dec 2018 06:43:02 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76: dma: avoid indirect call in mt76_dma_tx_queue_skb
Date:   Mon, 31 Dec 2018 15:42:54 +0100
Message-Id: <c4d933d0332d09c2c2377876c07383691ca50396.1546267294.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1546267294.git.lorenzo.bianconi@redhat.com>
References: <cover.1546267294.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Call mt76_dma_add_buf routine directly in mt76_dma_tx_queue_skb
and avoid indirect call if not necessary

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1db163c40dcf..e769c8a555dd 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -300,7 +300,7 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	if (q->queued + (n + 1) / 2 >= q->ndesc - 1)
 		goto unmap;
 
-	return dev->queue_ops->add_buf(dev, q, buf, n, tx_info, skb, t);
+	return mt76_dma_add_buf(dev, q, buf, n, tx_info, skb, t);
 
 unmap:
 	ret = -ENOMEM;
-- 
2.20.1

