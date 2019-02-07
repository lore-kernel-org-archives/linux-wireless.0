Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972F1C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 10:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71F2A2084D
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 10:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfBGKOn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 05:14:43 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44749 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfBGKOn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 05:14:43 -0500
Received: by mail-wr1-f65.google.com with SMTP id v16so8999648wrn.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 02:14:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=giqE8jX7ioBjE6yj3tgYybrCF0vgSt7J+tzbAHd37+M=;
        b=JQoj3TFCO1fiSNF8BtdrKTywT5vw5FHMd3uvJXIUDjTYIAKaJERbHS8vczSOy7Y2av
         uzlZ4axJychy1Y/WHdYtcjComHB1373O7r3mqnP/3R416OHqurCI8JOo6qTmV8QfwifX
         PMJQ69G6ytUE61D7iLhkZL6gaocxHkhw3GdKyilgcds5STHI2uZ1gIQH4FqqMYvKDpNB
         t9uq5lV9VQFfI209IhX9J2IhDBdFHCFtPjSa8ldYo6Yq65nfaIhRd/kMBxmVC8ambGQp
         Y0sMQW0HRvt/WgHGA4rv8IP6TBDehZKAxcQXRy+VuMCwZkZfaDVOo5v+c5ysyNpSIZS0
         +QyQ==
X-Gm-Message-State: AHQUAuYabNgUDP21USdiqLocdFIgEcX2J9FPooj1Scp41in60g42G0MN
        on6EtcJI5/TQQOpDAo0PhiTBmQ==
X-Google-Smtp-Source: AHgI3IZjRBiIZk6VQopQnhX36k4PTFvLKrH2qFyGec1I06gvqbMrKLMoBEO51YpctaT11WIjAsELdg==
X-Received: by 2002:a5d:6487:: with SMTP id r7mr11819657wru.263.1549534481842;
        Thu, 07 Feb 2019 02:14:41 -0800 (PST)
Received: from lore-desk.lan ([151.66.10.5])
        by smtp.gmail.com with ESMTPSA id e27sm35897019wra.67.2019.02.07.02.14.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 07 Feb 2019 02:14:40 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76: remove add_buf pointer in mt76_queue_ops
Date:   Thu,  7 Feb 2019 11:14:34 +0100
Message-Id: <c84fc9d5a502acca6f7243bef0d2ace563e2a95c.1549533273.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549533273.git.lorenzo.bianconi@redhat.com>
References: <cover.1549533273.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove add_buf function pointer in mt76_queue_ops data structure since
it is no longer used

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
This patch is based on 'mt76: move mt76_dma_tx_queue_skb_raw in mt76-core
module'
https://patchwork.kernel.org/patch/10800701/
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 1 -
 drivers/net/wireless/mediatek/mt76/mt76.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 0dd78d364751..6eedc0ec7661 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -546,7 +546,6 @@ mt76_dma_init(struct mt76_dev *dev)
 static const struct mt76_queue_ops mt76_dma_ops = {
 	.init = mt76_dma_init,
 	.alloc = mt76_dma_alloc_queue,
-	.add_buf = mt76_dma_add_buf,
 	.tx_queue_skb_raw = mt76_dma_tx_queue_skb_raw,
 	.tx_queue_skb = mt76_dma_tx_queue_skb,
 	.tx_cleanup = mt76_dma_tx_cleanup,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 108d6bab70f0..399a97c51bf6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -568,7 +568,6 @@ static inline u16 mt76_rev(struct mt76_dev *dev)
 
 #define mt76_init_queues(dev)		(dev)->mt76.queue_ops->init(&((dev)->mt76))
 #define mt76_queue_alloc(dev, ...)	(dev)->mt76.queue_ops->alloc(&((dev)->mt76), __VA_ARGS__)
-#define mt76_queue_add_buf(dev, ...)	(dev)->mt76.queue_ops->add_buf(&((dev)->mt76), __VA_ARGS__)
 #define mt76_tx_queue_skb_raw(dev, ...)	(dev)->mt76.queue_ops->tx_queue_skb_raw(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
-- 
2.20.1

