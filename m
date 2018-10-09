Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B7AC64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86CB72089D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 08:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86CB72089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbeJIQNN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 12:13:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46630 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIQNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 12:13:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id n11-v6so792337wru.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 01:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3XmQiT6bjcn5igtfUnfP+hhhgIXQuNpV4GSqp+q5P7k=;
        b=f8YsMhJsiWcniwWMLXyOpiSVTR8e2pAJgXmR3xnQl8Gsjwp9Z1MPUEuOJ5rJUVkwOa
         SdKAZqYxpJVK3oXLScDl3Zc2wMZe76G/iVrNnU6EGrOCIm1TzYsJM53khgHrX2mZ+bQ4
         TZHJb+be11l8TYe31qsW9LUeWWHhi8lLmkgTXi5dzxoKN+DozsOozBzRODbuvGQ0ihL7
         rv64pusI6fo61iVIyG6MXkUG5vplzNttS6nh+d6pktXeENKlA14LaZ1k1/k/SErhQRwL
         sVnAK0iibN/WLGqE1GD5X4R5bASoTV9SdLVoLztsSP5ysMIkF5ZUcXLe8+Olce0spSdH
         t62Q==
X-Gm-Message-State: ABuFfoioZPMV8CuQEheWy3l4vaUW06e1gNWA+bJDdteYX4sF2BdUoQF+
        qsusCr6hkzPjYfaxqcGYtYxHvA==
X-Google-Smtp-Source: ACcGV617o9u1BcsnokAldvck1DWqJL2M/AvVc2nbfKWWGbWGj4MZuZoptrygiEWevI/MEiaoX4EqfQ==
X-Received: by 2002:adf:fa4e:: with SMTP id y14-v6mr19612305wrr.155.1539075439591;
        Tue, 09 Oct 2018 01:57:19 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e67-v6sm13407869wmd.41.2018.10.09.01.57.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Oct 2018 01:57:19 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76x0: phy: fix restore phase in mt76x0_phy_recalibrate_after_assoc
Date:   Tue,  9 Oct 2018 10:57:06 +0200
Message-Id: <f3efae19baefd102fa2f08f12982c1199ba51997.1539074999.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1539074999.git.lorenzo.bianconi@redhat.com>
References: <cover.1539074999.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix restore value configured in MT_BBP(IBI, 9) register in
mt76x0_phy_recalibrate_after_assoc routine.

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1:
- use proper register name
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 99e0a91a2f99..29bc4e4623cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -733,9 +733,8 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_TX_ALC_CFG_0, 0);
 	usleep_range(500, 700);
 
-	reg_val = mt76_rr(dev, 0x2124);
-	reg_val &= 0xffffff7e;
-	mt76_wr(dev, 0x2124, reg_val);
+	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
+	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
 
 	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 0, false);
 
@@ -746,7 +745,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQ, is_5ghz, false);
 	mt76x02_mcu_calibrate(dev, MCU_CAL_RX_GROUP_DELAY, is_5ghz, false);
 
-	mt76_wr(dev, 0x2124, reg_val);
+	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
 	mt76_wr(dev, MT_TX_ALC_CFG_0, tx_alc);
 	msleep(100);
 
-- 
2.17.1

