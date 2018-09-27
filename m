Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF08C004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD8802156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD8802156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbeI0PT1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34766 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeI0PT1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id z4-v6so324669wrb.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rEKY+R/i4lCekG9ZlfxLBE6HecB1bHnMB4vPCsCxYqQ=;
        b=ZYQ0AFJBc9LQy1tZVdLqKjo57BcWttsLp13D8Q8ZXtNf8RmVzbGplXCweP7WXTBJs1
         L1qw5ITNAqtgf+ZyIMhftAt8z9AtgM5+y++aHapyz4mPfnVH2+Edva/VBajN2UkbYcTa
         RuBQoVCOCPG3sBF4q7IHYt7IdmgTO12DkkbacGkkq7HLBcRX+/X9jnGG/Q49L/brwmgM
         g7BjJUGmKi+7rlqTTE4gEmugdJ1pKX0syE2VWQ6q0KPVL6NhEfjgRZJGnLyXFi8+4tNE
         6rtEVxbiLrbcru5kDjQE4JU0AAdx8xsDHt+i3CJUnrGJwFM5zSzg9pnEZyJcjd7OwZGc
         3FAA==
X-Gm-Message-State: ABuFfohBjleDw+BhHMq7AocMaHnkbtjdtbGSQzAi8wrWgzhGNaEfSN99
        P1UVvrhkOaUMoAogYnLlqh6k4g==
X-Google-Smtp-Source: ACcGV63/+pd1W9Ac0A9yss0oNM+C/J5lC6UDMcXQ4GWX4L4HV/utUVatHbe17OZFRJST5nKvZxyHvw==
X-Received: by 2002:adf:c3cd:: with SMTP id d13-v6mr8401691wrg.68.1538038933485;
        Thu, 27 Sep 2018 02:02:13 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:13 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 12/26] mt76x0: use mt76x02 utility routines in mt76x0 init code
Date:   Thu, 27 Sep 2018 11:01:41 +0200
Message-Id: <3c7fd7b2ffd045b9234e51f250ff25693a3b0448.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_wait_for_wpdma and mt76x02_wait_for_mac utility
routines in mt76x0_init_hardware and mt76x0_mac_start
and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 3b4a67bf7039..35aa2d8fae81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -19,6 +19,7 @@
 #include "trace.h"
 #include "mcu.h"
 #include "../mt76x02_util.h"
+#include "../mt76x02_dma.h"
 
 #include "initvals.h"
 
@@ -273,8 +274,7 @@ int mt76x0_mac_start(struct mt76x0_dev *dev)
 {
 	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
 
-	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
-		       MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 200000))
+	if (!mt76x02_wait_for_wpdma(&dev->mt76, 200000))
 		return -ETIMEDOUT;
 
 	dev->mt76.rxfilter = MT_RX_FILTR_CFG_CRC_ERR |
@@ -287,13 +287,9 @@ int mt76x0_mac_start(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
-		   MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
+		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
 
-	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
-		       MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 50))
-		return -ETIMEDOUT;
-
-	return 0;
+	return !mt76x02_wait_for_wpdma(&dev->mt76, 50) ? -ETIMEDOUT : 0;
 }
 
 static void mt76x0_mac_stop_hw(struct mt76x0_dev *dev)
@@ -357,9 +353,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 {
 	int ret;
 
-	if (!mt76_poll_msec(dev, MT_WPDMA_GLO_CFG,
-			    MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
-			    MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 100))
+	if (!mt76x02_wait_for_wpdma(&dev->mt76, 1000))
 		return -EIO;
 
 	/* Wait for ASIC ready after FW load. */
@@ -378,8 +372,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 	mt76x0_init_mac_registers(dev);
 
-	if (!mt76_poll_msec(dev, MT_MAC_STATUS,
-			    MT_MAC_STATUS_TX | MT_MAC_STATUS_RX, 0, 1000))
+	if (!mt76x02_wait_for_bbp(&dev->mt76))
 		return -EIO;
 
 	ret = mt76x0_init_bbp(dev);
-- 
2.17.1

