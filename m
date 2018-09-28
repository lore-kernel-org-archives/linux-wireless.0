Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9138C46470
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A59F821547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A59F821547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbeI1SC4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33495 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbeI1SCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id r1-v6so1654927wmh.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=C74prwgYg1lQpORograxT6QyEXINPWCW1QeYWYSSj18=;
        b=hwbewhT5hFA4MWxGjFEsVGr8cGs927fZhsJeWVROKf49ltRn08Nyeii3vZ9OhyUE7q
         wnaXhtkb9/XHvJIrrF6ZEn+3wj8KnyM4Gtn1mGBYFYHxPdLJyPxMdY5Qic6xtVPPb70J
         1SbQ4Fyr9wGDrDNtM1jb3lO9w/nYNyFXC5elgen0kA0S/sYp9MtraDb97xk6/8Tw1Ft2
         OSakEe58qfy4/CXEA5H6RjwvWgyw2AEfIi2Mk0hJ/BQaoykWZT0BPEdRdY47p546PL0R
         bTl4gNgefv6iQDzAjBO/r0/i7MPOqoIPogAuhIezrmjf1W3fj6pJpJ90S0mmeKZEOVRu
         uhfA==
X-Gm-Message-State: ABuFfohiq1bnlytTPHw8pViE1t92p54Xc0lyDl/zUZNc8czt6EsWK5GT
        ihrLHFb1FHVWVXJCNq42J/HAzBb45Ng=
X-Google-Smtp-Source: ACcGV62uLyg8v56uXDr5TvAkWPfwF+3oPdpIJCTfEkyO4g4F0RUy9J+IYFIbOjIbWWycADHzVmjiYQ==
X-Received: by 2002:a1c:1d6:: with SMTP id 205-v6mr1474722wmb.151.1538134772316;
        Fri, 28 Sep 2018 04:39:32 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:31 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 16/24] mt76: add mt76x02_mac_start routine
Date:   Fri, 28 Sep 2018 13:38:59 +0200
Message-Id: <27696725d863eb4bd39fac0c39aa0bfedd2ae74d.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76x02_mac_start since the mac start code is shared between
mt76x0e and mt76x2 drivers.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 13 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c  | 12 +-----------
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 8c083d2def37..1146fbfd8df5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -146,3 +146,16 @@ void mt76x02_dma_disable(struct mt76_dev *dev)
 	__mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
 }
 EXPORT_SYMBOL_GPL(mt76x02_dma_disable);
+
+void mt76x02_mac_start(struct mt76_dev *dev)
+{
+	mt76x02_dma_enable(dev);
+	__mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+	__mt76_wr(dev, MT_MAC_SYS_CTRL,
+		  MT_MAC_SYS_CTRL_ENABLE_TX |
+		  MT_MAC_SYS_CTRL_ENABLE_RX);
+	mt76x02_irq_enable(dev,
+			   MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+			   MT_INT_TX_STAT);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_start);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index cd9282194c97..ff4cab5ca038 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -55,6 +55,7 @@ bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76_dev *dev);
 void mt76x02_set_irq_mask(struct mt76_dev *dev, u32 clear, u32 set);
+void mt76x02_mac_start(struct mt76_dev *dev);
 
 static inline void mt76x02_irq_enable(struct mt76_dev *dev, u32 mask)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 37cbe550ad1a..3f77c13a6d54 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -188,17 +188,7 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 		mt76_rr(dev, MT_TX_STAT_FIFO);
 
 	memset(dev->aggr_stats, 0, sizeof(dev->aggr_stats));
-
-	mt76x02_dma_enable(&dev->mt76);
-	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
-
-	mt76_wr(dev, MT_MAC_SYS_CTRL,
-		MT_MAC_SYS_CTRL_ENABLE_TX |
-		MT_MAC_SYS_CTRL_ENABLE_RX);
-
-	mt76x02_irq_enable(&dev->mt76,
-			   MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
-			   MT_INT_TX_STAT);
+	mt76x02_mac_start(&dev->mt76);
 
 	return 0;
 }
-- 
2.17.1

