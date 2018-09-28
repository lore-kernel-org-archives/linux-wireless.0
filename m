Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94911C004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B50A2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B50A2172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbeI1NCs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41295 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeI1NCs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id j15-v6so5060875wrt.8
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F5Wllo0b0VPvl3qCUf4P7Ajz7g8NkenhRRKKiK0YTT8=;
        b=ei/G1sOAc0Od6cSmaH6axZ/j88SnHJksT08p0vp0qW6nQDZwU+9EXzuGcYMeZXF8dy
         wL2PpTCWlrGq570yP4Rqk/Xrq4Ldp/VSiDFJNtZt2DOWED0SJradkl2wNFlqktAKiFls
         Ws+508IXDId1xyhgDYvZZhGzZFhZRMbzv7kmwVHg2AF0Un0hhK3c4z3W6abRL+fBtJ46
         CRJhODNRqN4zWaU3JBMgSXR87EMMjQiVT9lIBgmXXExOvX0eJ+vh0DJ54MzGY6fvwGxW
         DjGssxnUjcRSPZRivrUquH8+utx5B4gSKuRcfabIh5zEppZQyiIr7bfqnt/nfma3/KY5
         chlw==
X-Gm-Message-State: ABuFfoid2uLsVIcQvONCTSZUl4d9D8X2ITb0jv63zuOEe7yjqMEmBYF6
        NKXR238w689dKFSOI2PzpQkhsA==
X-Google-Smtp-Source: ACcGV63QP7W85dZ1d35W9wXD9iAjblnIzJ9d+RhrTip4JSQhA69Kw4Z6aJDOjOxwJvDZYfVpMS7nNw==
X-Received: by 2002:adf:e846:: with SMTP id d6-v6mr10495183wrn.269.1538116834843;
        Thu, 27 Sep 2018 23:40:34 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:34 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 07/24] mt76: mmio: add implementation of wr_rp and rd_rp
Date:   Fri, 28 Sep 2018 08:40:00 +0200
Message-Id: <20180928064017.26870-8-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.19.0

