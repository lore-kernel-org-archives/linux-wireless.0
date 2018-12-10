Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24650C04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 10:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E72BD2082F
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 10:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E72BD2082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbeLJKWR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 05:22:17 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55530 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbeLJKWR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 05:22:17 -0500
Received: by mail-wm1-f68.google.com with SMTP id y139so10245050wmc.5
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2018 02:22:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cP8maqR0PUqGazmANVsd18r4hn5bJ9AAXs9StmgRzNU=;
        b=Gz3Mu5FpVOAOYfnqS5vB7XVnmSzDsRqM6LIVzMwPbOphYwKQHXpN2hKXv6f41ej6RS
         ww53dAM9jG6ydLAglEzY0gNO0IIMgIwbGy1pLArqTNUIGGAZL6nNAinZzngezBj0qfVH
         0Oyz3+IbI4uAYeUV3Gh9GbuZJ6P6L1eNUv9zMyMJeAJWRX3N+UJm6gyTFSJZEbRxF1gq
         s+vNzkAy1WJisEhKpugLLycr3BArAUbMpvKj9VNW/o4IqVh2QWx5JSiFrf68fROjAZlx
         mVnvgPLafk7l8fzasnfDTgRm53YLJuRi+zY6oBCmTM5AMVv6PWvee2Ui657zvU6MmEpO
         9m8A==
X-Gm-Message-State: AA+aEWYAaP0Oi8Kg50V6Xop8SgENRCoUIEnYadFj6P8EoXHIv+LhaI41
        ohrII5aA+ta3fkmaVQw5XZWTQxPvVLQ=
X-Google-Smtp-Source: AFSGD/Wt8F4LGpR6gSDv/ui02Wo1AHYCMHmNPMZrXar1M2TwYafzsqgkqpfc+c/J+j1m/GpPJ2Drtg==
X-Received: by 2002:a1c:9d97:: with SMTP id g145mr10315398wme.152.1544437335798;
        Mon, 10 Dec 2018 02:22:15 -0800 (PST)
Received: from localhost.localdomain ([151.66.36.11])
        by smtp.gmail.com with ESMTPSA id u204sm23161466wmu.30.2018.12.10.02.22.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Dec 2018 02:22:15 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: pci: fix ACS support
Date:   Mon, 10 Dec 2018 11:22:00 +0100
Message-Id: <b058a52148fd7692e25cba8b9fdb52858f61e0a9.1544437007.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544437007.git.lorenzo.bianconi@redhat.com>
References: <cover.1544437007.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix Automatic Channel Selection (ACS) support in mt76x0e driver
configuring properly MT_CH_TIME_CFG register

Fixes: 6250318694ca ("mt76x0: pci: add get_survey support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index d895b6f3dc44..1906cc62690f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -141,6 +141,14 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 	mt76_clear(dev, 0x110, BIT(9));
 	mt76_set(dev, MT_MAX_LEN_CFG, BIT(13));
 
+	mt76_wr(dev, MT_CH_TIME_CFG,
+		MT_CH_TIME_CFG_TIMER_EN |
+		MT_CH_TIME_CFG_TX_AS_BUSY |
+		MT_CH_TIME_CFG_RX_AS_BUSY |
+		MT_CH_TIME_CFG_NAV_AS_BUSY |
+		MT_CH_TIME_CFG_EIFS_AS_BUSY |
+		FIELD_PREP(MT_CH_TIME_CFG_CH_TIMER_CLR, 1));
+
 	err = mt76x0_register_device(dev);
 	if (err < 0)
 		return err;
-- 
2.19.2

