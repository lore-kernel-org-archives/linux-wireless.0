Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A5AC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6688A2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6688A2172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbeI1NCp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34811 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbeI1NCp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id z4-v6so3699595wrb.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7ZPOANbS2Sgw9vG0bvcs9xS8u5oyZzLPDd9SBsP9/w=;
        b=r8mQlzn/04m0afDAwWZWmvbyM/pkwuiUxmrcipfUTkP6ZAUG6lUbdz3eq2SsnjmCUm
         vQOg7K+DpRHuYa2SeK0i/THM9OVQp9EqAUQ6NO1GOgk9K/M4nh4gO+YL3mKtA8S/3DT2
         takk7DozJaBPu+gSSsLA6itzp44dtLNImGfI0mkAuZ+VsqbaQeuGwCC3yfBsgC+MVNcl
         qzgV9aR2vL3MSUgS/yvCOv6u0xqVOzSCY3zVN/IodoTEI+sotH5i5fJFZk+pgeY2Hjx0
         oWO5VES8aNLRJwHw2wpkYnWKCgNMjAyfoQZQuMjZ6hH+6cdx3q8ELWA3NBl65ind5TqA
         HxDQ==
X-Gm-Message-State: ABuFfohI/YBKzzT8S3OfdKhlYluftCWRvIlQ65a+xGh54xBwJfokpt++
        asGt8px4Zea52bmyr5+vbZpiMPwMpDo=
X-Google-Smtp-Source: ACcGV63Vy48l6NoQGVzfn2RS9IXbMNNMxUX0WluRXhvsD1DmZVqaw7AibTDohI2nltd8NycxXRDYBA==
X-Received: by 2002:adf:bd10:: with SMTP id j16-v6mr10696003wrh.267.1538116830766;
        Thu, 27 Sep 2018 23:40:30 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:30 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 03/24] mt76: add mt76x02_dma_enable/mt76x02_dma_disable utility routines
Date:   Fri, 28 Sep 2018 08:39:56 +0200
Message-Id: <20180928064017.26870-4-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76x02_dma_enable and mt76x02_dma_disable utility routines
in order to be reused in mt76x0 mac configuration and remove duplicated
code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |  3 ++
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 51 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2_init.c  | 20 +-------
 4 files changed, 57 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 1fc7450650ee..2346a1b768bc 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -16,7 +16,7 @@ CFLAGS_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
-		 mt76x02_eeprom.o mt76x02_phy.o
+		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_mmio.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
index 2396d49a84dd..0b78857c9b4c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
@@ -67,4 +67,7 @@ mt76x02_wait_for_wpdma(struct mt76_dev *dev, int timeout)
 			   0, timeout);
 }
 
+void mt76x02_dma_enable(struct mt76_dev *dev);
+void mt76x02_dma_disable(struct mt76_dev *dev);
+
 #endif /* __MT76x02_DMA_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
new file mode 100644
index 000000000000..f471c3a0674a
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+
+#include "mt76.h"
+#include "mt76x02_dma.h"
+#include "mt76x02_regs.h"
+
+void mt76x02_dma_enable(struct mt76_dev *dev)
+{
+	u32 val;
+
+	__mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
+	mt76x02_wait_for_wpdma(dev, 1000);
+	usleep_range(50, 100);
+
+	val = FIELD_PREP(MT_WPDMA_GLO_CFG_DMA_BURST_SIZE, 3) |
+	      MT_WPDMA_GLO_CFG_TX_DMA_EN |
+	      MT_WPDMA_GLO_CFG_RX_DMA_EN;
+	__mt76_set(dev, MT_WPDMA_GLO_CFG, val);
+	__mt76_clear(dev, MT_WPDMA_GLO_CFG,
+		     MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
+}
+EXPORT_SYMBOL_GPL(mt76x02_dma_enable);
+
+void mt76x02_dma_disable(struct mt76_dev *dev)
+{
+	u32 val = __mt76_rr(dev, MT_WPDMA_GLO_CFG);
+
+	val &= MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
+	       MT_WPDMA_GLO_CFG_BIG_ENDIAN |
+	       MT_WPDMA_GLO_CFG_HDR_SEG_LEN;
+	val |= MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE;
+	__mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
+}
+EXPORT_SYMBOL_GPL(mt76x02_dma_disable);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 68244b47312a..bd52c8b2ee9f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -206,16 +206,7 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 
 	memset(dev->aggr_stats, 0, sizeof(dev->aggr_stats));
 
-	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
-	mt76x02_wait_for_wpdma(&dev->mt76, 1000);
-	usleep_range(50, 100);
-
-	mt76_set(dev, MT_WPDMA_GLO_CFG,
-		 MT_WPDMA_GLO_CFG_TX_DMA_EN |
-		 MT_WPDMA_GLO_CFG_RX_DMA_EN);
-
-	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
-
+	mt76x02_dma_enable(&dev->mt76);
 	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
@@ -354,20 +345,13 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
 		0xc000,
 		0xc000,
 	};
-	u32 val;
 	int ret;
 
 	dev->beacon_offsets = beacon_offsets;
 	tasklet_init(&dev->pre_tbtt_tasklet, mt76x2_pre_tbtt_tasklet,
 		     (unsigned long) dev);
 
-	val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
-	val &= MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
-	       MT_WPDMA_GLO_CFG_BIG_ENDIAN |
-	       MT_WPDMA_GLO_CFG_HDR_SEG_LEN;
-	val |= MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE;
-	mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
-
+	mt76x02_dma_disable(&dev->mt76);
 	mt76x2_reset_wlan(dev, true);
 	mt76x2_power_on(dev);
 
-- 
2.19.0

