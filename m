Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3632FC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00883217F9
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfAVPjp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:39:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33477 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbfAVPjp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:39:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so27940180wrr.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 07:39:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DVT6vKfIH8kHvYsW7E5SQfYI4wLjSB5zdodEFT4i124=;
        b=U2U7aOKKEVlCpImg/5jTU4AzZDqZIDrZOgFY6B4ddgDfHn+Q970Mr4K0vP0aRJePoU
         Czxt6P+KeQNrkwrM6M5fMQtELj+EGH4IooxTxnvSu/p2LMDb9vfC+ykVIQPCdNdR7vg0
         iEYsIdOoTQA5NGDR9Sv0+7FjmMc4dKGSnj1rozDiANA0sFlZZB0owmyMDbCjZ7lA1iQU
         UmA2axcWd+mLgubbwBLrUI8ZJn0mS6GRqR6AtR4KOJgTrHAY1Vrj3zO+T7FXpEP0HsNh
         LnnMfJ45Ys4azYyf+kA3UZppv1Ul6ENnfI8az4vGkzKbWWpzFenx3mdVEKR75nM3rqYr
         S2XA==
X-Gm-Message-State: AJcUukdg3yYIplAp/p5/yvZMDzqR1FRzAFcZtZNKH8ZTT1pRLy2R8M7O
        DTMUcvdyTYPaFBgH58sSWYJYVQSmZ9g=
X-Google-Smtp-Source: ALg8bN66+SHdVYQlvx7geaIsDzuBGXQfAMjwHObxkCf+ULeSKgNrvff6giHkvyIH54Zn7u5YJAwRbA==
X-Received: by 2002:adf:e5d0:: with SMTP id a16mr33213415wrn.89.1548171583079;
        Tue, 22 Jan 2019 07:39:43 -0800 (PST)
Received: from localhost.localdomain.it ([151.11.217.99])
        by smtp.gmail.com with ESMTPSA id f130sm50069741wme.41.2019.01.22.07.39.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 07:39:42 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     kubakici@wp.pl
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt7601u: do not use WARN_ON in the datapath
Date:   Tue, 22 Jan 2019 16:39:34 +0100
Message-Id: <ea874df744d188833cf8c38261b509ef246f3d5d.1548171270.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548171270.git.lorenzo.bianconi@redhat.com>
References: <cover.1548171270.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Substitute WARN_ON with WARN_ON_ONCE in mt7601u_rx_next_seg_len
routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 7f3e3983b781..f7edeffb2b19 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -124,9 +124,9 @@ static u16 mt7601u_rx_next_seg_len(u8 *data, u32 data_len)
 	u16 dma_len = get_unaligned_le16(data);
 
 	if (data_len < min_seg_len ||
-	    WARN_ON(!dma_len) ||
-	    WARN_ON(dma_len + MT_DMA_HDRS > data_len) ||
-	    WARN_ON(dma_len & 0x3))
+	    WARN_ON_ONCE(!dma_len) ||
+	    WARN_ON_ONCE(dma_len + MT_DMA_HDRS > data_len) ||
+	    WARN_ON_ONCE(dma_len & 0x3))
 		return 0;
 
 	return MT_DMA_HDRS + dma_len;
-- 
2.20.1

