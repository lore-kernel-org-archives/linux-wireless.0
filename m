Return-Path: <SRS0=FAJS=OK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17307C04EB9
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Dec 2018 14:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D82B620867
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Dec 2018 14:01:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D82B620867
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbeLBBOP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Dec 2018 20:14:15 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41562 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbeLBBOP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Dec 2018 20:14:15 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so7859942wrs.8
        for <linux-wireless@vger.kernel.org>; Sat, 01 Dec 2018 06:01:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7ON34L400jtLVNPQlEDgnBe9WRZkgfwQI4Scb6znGE=;
        b=bclNWdTHLZIMDz0i0UZPXWl5IIC2QA0kQPNuau5p/xWmrXn6BYMgMdiNxrTY2w4glu
         ju7kp5tpmlXre7ncgpw7Ha4tYUhvb7in/1nlm2Na1KDtM1yMNyuCnQ4VJRgDR8LOWV7L
         fU0sjth5c7cmDqKXFD7WR6Sz9EDsu6C631TbSFoRA5Yxm7vo4k9Rher2NaAr/pnBGECY
         ytLDdVDyFbP0COLlScsrH10WfFM6MsF1yFBe84RTIPJmv8lAJDmi3vc6yF4Zw7NTrL9n
         3ALyohcNjcSALZ0V9mCceSlIRxp/2iqWy758T+QVCtIyzEqZBpuOXzqbbmlEoj5mVa5t
         PN1A==
X-Gm-Message-State: AA+aEWYhVBQ177N98yf1ECNhPDG2nVl93/kso4hofVZUlsmLGLPe2pe4
        hDQLDPiaEWbu57ScEgsB7wbQr4Hf8oQ=
X-Google-Smtp-Source: AFSGD/XMIUHp9JrdH5RixE3COp/FjtL0ZBRiIB7ENtqzziURvRWAsSM5wTNd2zDw7dFfaGOmBqBH/g==
X-Received: by 2002:adf:9dd2:: with SMTP id q18mr8245267wre.12.1543672899321;
        Sat, 01 Dec 2018 06:01:39 -0800 (PST)
Received: from localhost.localdomain ([151.66.56.232])
        by smtp.gmail.com with ESMTPSA id i16sm2260502wmd.28.2018.12.01.06.01.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Dec 2018 06:01:38 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: usb: do not build the skb if reported len does not fit in buf_size
Date:   Sat,  1 Dec 2018 15:01:19 +0100
Message-Id: <da26991b7aef3dfc8a1d29e66158cfb8809309cb.1543672649.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1543672649.git.lorenzo.bianconi@redhat.com>
References: <cover.1543672649.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Precompute data length in order to avoid to allocate the related
skb data structure if reported length does not fit in queue buf_size

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index b061263453d4..14ff06c5764e 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -407,17 +407,15 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
 	if (len < 0)
 		return 0;
 
+	data_len = min_t(int, len, urb->sg[0].length - MT_DMA_HDR_LEN);
+	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(q->buf_size))
+		return 0;
+
 	skb = build_skb(data, q->buf_size);
 	if (!skb)
 		return 0;
 
-	data_len = min_t(int, len, urb->sg[0].length - MT_DMA_HDR_LEN);
 	skb_reserve(skb, MT_DMA_HDR_LEN);
-	if (skb->tail + data_len > skb->end) {
-		dev_kfree_skb(skb);
-		return 1;
-	}
-
 	__skb_put(skb, data_len);
 	len -= data_len;
 
-- 
2.19.2

