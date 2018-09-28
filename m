Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 912EAC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B47621547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B47621547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbeI1SCw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52190 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbeI1SCv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id y25-v6so1891272wmi.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ef+MU/Jw6B5uEp/Vlf3IJMGkYtnDsSnUksBTkKp+yMg=;
        b=hrhjfWmohEuZQDsbBSQdYaUICtLpiM5MqpXJ8SD7E/2epGLyVnFFihBNNFIyhuBjn+
         4/vxKZXBw4jiXNT2fSRTlM1bSoJUDzHjHSAFnq7B14xZECnGrqDKr0tvLQe/NPvwqwGY
         DjkWyWaPeE/lRbqd5ORAqMxqXNDMmrcgY9LTm5z3Snu5fDzAH9LBBWwHiz0mFAfvH3Qk
         3u74sxhtQ/LHLd573SSp62qxgRjjB+URJXYZw/vaTxg4wyjQ93/Fy95vz7QCH8UyvVXn
         bsnc7h4Ik6Ts4YoAQ+0ZcDjTd7bUr6CB+JAm4VlKH8YWtc6W+MRNQy2ttl6S0QUyvqtb
         O+uA==
X-Gm-Message-State: ABuFfohTO8cKuPFOBjpE6wAXNpZAetQdq+9drGolO0wzRGdO0XZaggB2
        OBpvped1yXcrzv4MdFr+oGENB8xrbGA=
X-Google-Smtp-Source: ACcGV61m1I7buMIwOkdfUffSp7ROnXl1R0ktNdJQn+21eLhlinLXzG/zNQmDSKV4jYxhwDfX2gsozw==
X-Received: by 2002:a1c:adcc:: with SMTP id w195-v6mr1488594wme.41.1538134768452;
        Fri, 28 Sep 2018 04:39:28 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:27 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 12/24] mt76x0: use mt76x02 utility routines in mt76x0 init code
Date:   Fri, 28 Sep 2018 13:38:55 +0200
Message-Id: <6e5a89235a838a1a0e015abd83ed4502b3e9c8c3.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_wait_for_wpdma and mt76x02_wait_for_txrx_idle
utility routines in mt76x0_init_hardware and mt76x0_mac_start
and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 3b4a67bf7039..8870f9225424 100644
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
+	if (!mt76x02_wait_for_txrx_idle(&dev->mt76))
 		return -EIO;
 
 	ret = mt76x0_init_bbp(dev);
-- 
2.17.1

