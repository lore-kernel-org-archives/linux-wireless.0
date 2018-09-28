Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6007EC1B0E3
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 342D22172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 342D22172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbeI1NCz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39494 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbeI1NCz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id s14-v6so5077351wrw.6
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VzMTsnVWDBtGst4/qG4qXkFPWryppshaf69SE4703Co=;
        b=jkijhF36rYnk5nyZWqhV6areb0fTBHbmDANfVYsUP5oSgkCGrV/ccLnRkJuwKWfNeh
         0A8bLV+6BWUHGDKnzWn4VAtZzTDcQuTjAlD+3vyZlwvaPq3vAfLygL4/1my/vDD55uKF
         HlIlq72w0OcxH68y7xcIGaZJlTllH3IbJd0NcDZRvmP8btPW8CFutjhSDEWPooNwcNhA
         2Et/bPZbnf1eIHrY1khEXe2UQAjVBwIyRi+N+9xj0GYfIbe93tW2hL53dk5zm2/XncvV
         IdI25UAlArBaBqeqHJrqdHjbLGbMknYSq9MNkbtZt1MhMTDIm8uA+KsXTU2sd8Cou9iY
         uFtg==
X-Gm-Message-State: ABuFfojaMGYF9QcItN9zgsQ6Uj58KC56MpgBi4eJGk1DM7akQFzzKUN6
        X6zkkFmIZZfe22/JuKdIExxc5ZX7SPg=
X-Google-Smtp-Source: ACcGV63xlLhU7QzjEM+KyzgEp8AGyai70ll5PDxX4CzluZfpkjD8sa+D4Ip5i692Hz/3GQ5h3pPqIg==
X-Received: by 2002:adf:f701:: with SMTP id r1-v6mr11324416wrp.85.1538116840764;
        Thu, 27 Sep 2018 23:40:40 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:39 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 12/24] mt76x0: use mt76x02 utility routines in mt76x0 init code
Date:   Fri, 28 Sep 2018 08:40:05 +0200
Message-Id: <20180928064017.26870-13-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_wait_for_wpdma and mt76x02_wait_for_txrx_active
utility routines in mt76x0_init_hardware and mt76x0_mac_start
and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 3b4a67bf7039..d7525fcc9f0d 100644
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
+	if (!mt76x02_wait_for_txrx_active(&dev->mt76))
 		return -EIO;
 
 	ret = mt76x0_init_bbp(dev);
-- 
2.19.0

