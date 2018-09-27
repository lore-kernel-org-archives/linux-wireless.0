Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD696C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EC2B2156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EC2B2156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbeI0PTX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38284 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbeI0PTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id z16-v6so5145191wmi.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JgLafUdhLyejU1YNMVQm412Ferj4FxtAPZ9nqurf0J0=;
        b=sKMsr9fNKtXhVCiilg4aC1Lyi0hyOs8wlvWEq3VQwk0a+0zVJZbKVD7j7eqNUKtz24
         qwbSIWFHA5gbw/ku6rLGVjbqD4Sce7uoqPX9cakbdalDOXvOzBMgVEkvldSXsnsydT+g
         klLawnGzR5Lr4OuzYvEFxOeffqlAcMsUT6w8XOtvDYV7faN5/KGTJpL51hmHwZ1d3lP3
         9YzmC3l6KACcuS3opgdOLMLTKnKn+WvDYnkplzhy3xaZsF7sEDiDQVoHdTG+XRKa6a5W
         g4jT3mtWpV8ZyLId56IgzFPhYJEA6Q1cN0MiXhqpuPu8+L8iaChbo1KqHR/6AmLwQDE2
         QYhg==
X-Gm-Message-State: ABuFfoiSml3klzixSRsVPpECk3LwRQM0d9fomzwqAppscvil0PtYTeMQ
        JyQLGsaVV/P4v1NDTpWtUlA9O1k6qg8=
X-Google-Smtp-Source: ACcGV60efgYQVn/u1B8osvQE76EYU57/8wtZy/SNwbZZ3g6uj/vX7iRF7GfGq8zdOQpggh+XmdlBJQ==
X-Received: by 2002:a1c:2384:: with SMTP id j126-v6mr7086085wmj.124.1538038928661;
        Thu, 27 Sep 2018 02:02:08 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:08 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 07/26] mt76: mmio: add implementation of wr_rp and rd_rp
Date:   Thu, 27 Sep 2018 11:01:36 +0200
Message-Id: <5c61b31099057f6e66464bec864575e065352862.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mmio implementation of mt76_mmio_rd_rp and
mt76_mmio_wr_rp and remove mt76x2 duplicated code.
mt76_mmio_{wr,rd}_rp allows to reuse mt76x0 init code
adding mt76x0e support

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mmio.c     | 26 +++++++++++++++++++
 .../mediatek/mt76/mt76x2_init_common.c        | 15 ++---------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 08685f515bf6..30a5d928e655 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -46,6 +46,30 @@ static void mt76_mmio_copy(struct mt76_dev *dev, u32 offset, const void *data,
 	__iowrite32_copy(dev->mmio.regs + offset, data, len >> 2);
 }
 
+static int mt76_mmio_wr_rp(struct mt76_dev *dev, u32 base,
+			   const struct mt76_reg_pair *data, int len)
+{
+	while (len > 0) {
+		mt76_mmio_wr(dev, data->reg, data->value);
+		data++;
+		len--;
+	}
+
+	return 0;
+}
+
+static int mt76_mmio_rd_rp(struct mt76_dev *dev, u32 base,
+			   struct mt76_reg_pair *data, int len)
+{
+	while (len > 0) {
+		data->value = mt76_mmio_rr(dev, data->reg);
+		data++;
+		len--;
+	}
+
+	return 0;
+}
+
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 {
 	static const struct mt76_bus_ops mt76_mmio_ops = {
@@ -53,6 +77,8 @@ void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 		.rmw = mt76_mmio_rmw,
 		.wr = mt76_mmio_wr,
 		.copy = mt76_mmio_copy,
+		.wr_rp = mt76_mmio_wr_rp,
+		.rd_rp = mt76_mmio_rd_rp,
 	};
 
 	dev->bus = &mt76_mmio_ops;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index abf535da0c78..4eacc681de49 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -62,17 +62,6 @@ void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
 }
 EXPORT_SYMBOL_GPL(mt76x2_reset_wlan);
 
-static void
-mt76x2_write_reg_pairs(struct mt76x2_dev *dev,
-		       const struct mt76_reg_pair *data, int len)
-{
-	while (len > 0) {
-		mt76_wr(dev, data->reg, data->value);
-		len--;
-		data++;
-	}
-}
-
 void mt76_write_mac_initvals(struct mt76x2_dev *dev)
 {
 #define DEFAULT_PROT_CFG_CCK				\
@@ -164,8 +153,8 @@ void mt76_write_mac_initvals(struct mt76x2_dev *dev)
 		{ MT_GF40_PROT_CFG,		DEFAULT_PROT_CFG_40 },
 	};
 
-	mt76x2_write_reg_pairs(dev, vals, ARRAY_SIZE(vals));
-	mt76x2_write_reg_pairs(dev, prot_vals, ARRAY_SIZE(prot_vals));
+	mt76_wr_rp(dev, 0, vals, ARRAY_SIZE(vals));
+	mt76_wr_rp(dev, 0, prot_vals, ARRAY_SIZE(prot_vals));
 }
 EXPORT_SYMBOL_GPL(mt76_write_mac_initvals);
 
-- 
2.17.1

