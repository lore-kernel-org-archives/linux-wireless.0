Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D85AC004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA3A22172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA3A22172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbeI1NC6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39501 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728995AbeI1NC6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id s14-v6so5077493wrw.6
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1C6dxuZX0E2dkHQ3FCBLBLxRZmbrg/jl/7YDazJT0Xo=;
        b=ZTHaslAFIUDOyjFL6TzgHJR9Jr+UqjNQL1dMebxMQ8tVwy14R2sbszgu8YN7CkqzuU
         N28qPjtPSXiqmnrQqaOMlGCP+53fNepiijXsWmpiSJOll/tZlU0gJW2w21fBU9/wvVQR
         YiWHqEk7ZavrA1RtLPeaznn5UCI2DdKl+76d6uG7DfSifHEm7w0JTCmeV0VnrxxInWZy
         pBhE6A8McaBsxMI/Qu6RMDt/Ec3DqEe53vVW1V+EIc/X+c8wiRKOUPIQ0O3Yn28XHBaR
         +OPWImyyfv7HIdSWluMjQjdp4TqZglsdHmLD661+bUr10M14cAhm7/5buJLQQrSTAxU8
         WE4w==
X-Gm-Message-State: ABuFfogdDkeIl55ASHC/lNMbcjcrilXu4zgJ/qLNVLhAtN6kHIf8ghl4
        aGDK+Q7Zwy0+P8UhEUMrNc4B/Q==
X-Google-Smtp-Source: ACcGV636l1x5c8z7l91ZV5oLz/FKrlwfuCKt1HozQIuEFTWkBmvzZqVHjPKStEVGChdbu+6N8ZAhBw==
X-Received: by 2002:a5d:5002:: with SMTP id e2-v6mr8264203wrt.210.1538116844502;
        Thu, 27 Sep 2018 23:40:44 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:43 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 16/24] mt76: add mt76x02_mac_start routine
Date:   Fri, 28 Sep 2018 08:40:09 +0200
Message-Id: <20180928064017.26870-17-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 432c725da62f..d22cb133a272 100644
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
2.19.0

