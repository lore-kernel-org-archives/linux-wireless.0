Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67117C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3442421547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3442421547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbeI1SCo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52638 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbeI1SCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id 189-v6so1571538wmw.2
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mV505NQrVa8yhJ5wxtOo1S5kf0mYpBcj7E1A4phxQ/Y=;
        b=OeWEWjy9kmPhPoCgxVhMKRmt0bHqzvpcrc/aD7o8026LB1I8uKF0gX5OsnI40eQPCD
         gGvG14AC7ywLhmTSOjkZfYVnrVWKlGIvYH95SLuOvcvX5NUz/sp+0JL+03Ye/BaP9+mE
         RhJxjOywo9jG7+hiTWYo0Sjb8z+jD2PhHrWr38BgrQK3aygCFvyCArLha3eQh0QOP2Za
         wBNGaU1atNTc6Kv7+uPcY4jzpI+yIs56M3ytP7g0kr3E+nCEXdR7j9ZFQyKO2H83KAiK
         QaSPg/8M9175FCO6XZGiwt2pqv4Bi6t7Vx7sVGHn9swrwGwmGd2Rpj5Es/sC974CwwNa
         orpw==
X-Gm-Message-State: ABuFfogtNJLl1VtsOZX/qe6TlBbHTc3yieXud56kKyolA2ZMrJIGmiFI
        k9sgVx8CW6HYdPG/9wpa8s4hGEZcoXs=
X-Google-Smtp-Source: ACcGV618JcrJdBdA0seIrpLtTOyJ4MbOox/VBT4/O/opuxSa5/+oNNRIr9kkUKNUJ2b73DmDJE/5PQ==
X-Received: by 2002:a1c:9616:: with SMTP id y22-v6mr1419253wmd.72.1538134759222;
        Fri, 28 Sep 2018 04:39:19 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:18 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 03/24] mt76: add mt76x02_dma_enable/mt76x02_dma_disable utility routines
Date:   Fri, 28 Sep 2018 13:38:46 +0200
Message-Id: <38a68f67659e748ea2f158520c92b89159a6056b.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
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
2.17.1

