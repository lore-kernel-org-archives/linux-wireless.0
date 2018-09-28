Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57582C004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25C5C21547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25C5C21547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbeI1SCr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37082 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbeI1SCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id u12-v6so6026087wrr.4
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JgLafUdhLyejU1YNMVQm412Ferj4FxtAPZ9nqurf0J0=;
        b=cjmNHQIXcrSr9SSgM/i8iWdIABffAhj0jwdft32IkDKPx7HH5LH18C/rsBIVwKnCrX
         x30OiIk1COncm/F/JyCLCyPn1VJ7XPnPARAK8o8NXpSTM9/Tnmcd9Y3SWHNIPIbQRIKQ
         8HVTHnekKi19n+8Ae8dopoM/s7/tkrYFIYdV97Uw5Sm2VyelAMp0hx/gMIBrcLZiZseE
         fVv8vbyhS+TBwA8L6igOoMdtpkDbK3F9TiNA7a5rRwbjZA/j28W+JrzjSaIxGWbu030G
         B67F7u7HX4T4H4VdjONbRSzNvDPSYQ325kMZLXypYW8h10U0DaOiXY7peNhHiXJDEkvK
         sakw==
X-Gm-Message-State: ABuFfojf4hfybISSFq10YT+L+gvmZ6soXp+UqBfcP705SLp98EH/ZOm9
        Ccrj6JuKYO16Ogq6rqapzz3Z3Q==
X-Google-Smtp-Source: ACcGV605/kwhhRyG/HfR/CmCd7ZnC6uh4Koo5FhNpUm4+PexNqo+xqGGZ1VCHz7M7JHGDmZlRrDEJQ==
X-Received: by 2002:adf:f391:: with SMTP id m17-v6mr12603027wro.279.1538134763384;
        Fri, 28 Sep 2018 04:39:23 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:22 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 07/24] mt76: mmio: add implementation of wr_rp and rd_rp
Date:   Fri, 28 Sep 2018 13:38:50 +0200
Message-Id: <d660abf82b860e091508023b7c7bdb6fe420bc27.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
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

