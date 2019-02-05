Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703D8C282D7
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 15:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 495962075D
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 15:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfBEPwi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 10:52:38 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39481 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728740AbfBEPwi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 10:52:38 -0500
Received: by mail-wm1-f68.google.com with SMTP id y8so4195856wmi.4
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2019 07:52:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/jFRO5KgRDg/HzuJwG7SsQCqpkW37vuVYVxdbKuCESQ=;
        b=GTFeLdj+iiL4Wnbz7fGlG7+IC0eFNlHQN+w55/2GojikqcMFOzCqHVBZLKgKFcyoLj
         /HOReNJYRPejPWzWR0uM/G7EEOzGGcr8t1rQQ8qhQj4R0uiZXOhbkvJ+hMU8yJzwTZfj
         n1RuyeapIwPzRUFqbjTts44O6aosiOFfQ74AvgN0ywVc0mZl2nw1/exp517FJhNqPSCX
         zO0/pJRoxiLKqLyMnYdwzBBht4Kb7GCmy15+fhEodjrbLM39YQf5B3P4dIkYoNolY4s4
         43aa34two+FDsLhhLZF8exDfdRgNwVI/LR7IS+24ClhF6gw1Ov2ggignRTG8u6O057aL
         lTyg==
X-Gm-Message-State: AHQUAuYs1g8O/kKGpyWim51BXjdVhGbZOwwjZumE4cVEIsOPb44WYX6E
        Te0fHN50+JgBH4I7OcDxyJnhyw==
X-Google-Smtp-Source: AHgI3IZlAVh2/FQn6IeUmzJBbztWQLMxyhBziuR/j5VzM3dAW8hqy9G3HPMjkZJ9juwiZOQ4aDDqJQ==
X-Received: by 2002:a1c:414:: with SMTP id 20mr4332387wme.67.1549381956160;
        Tue, 05 Feb 2019 07:52:36 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o64sm15671506wmo.47.2019.02.05.07.52.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 05 Feb 2019 07:52:35 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76x0: mcu: remove useless commented configuration
Date:   Tue,  5 Feb 2019 16:52:25 +0100
Message-Id: <7c17ba9e101c590ce3971d41f132fe9b31832b4d.1549381840.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549381840.git.lorenzo.bianconi@redhat.com>
References: <cover.1549381840.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove useless commented out configuration in mt76x0u_load_firmware
routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
index f391d2d21fbc..4a282761ca58 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
@@ -140,12 +140,6 @@ static int mt76x0u_load_firmware(struct mt76x02_dev *dev)
 		 FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, 0x20));
 	mt76x02u_mcu_fw_reset(dev);
 	usleep_range(5000, 6000);
-/*
-	mt76x0_rmw(dev, MT_PBF_CFG, 0, (MT_PBF_CFG_TX0Q_EN |
-					 MT_PBF_CFG_TX1Q_EN |
-					 MT_PBF_CFG_TX2Q_EN |
-					 MT_PBF_CFG_TX3Q_EN));
-*/
 
 	mt76_wr(dev, MT_FCE_PSE_CTRL, 1);
 
-- 
2.20.1

