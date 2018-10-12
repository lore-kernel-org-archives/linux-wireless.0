Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7EFDC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAD0B20868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAD0B20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbeJLRse (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39683 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbeJLRse (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id 61-v6so12822656wrb.6
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nGrpyvovGZTYcPfwMIBYxR6wfRO9iJ3V3oy9T78GfaA=;
        b=HArT2h1tK7MJRRJVbDlKP0PtVo1rnthFa+8CQPMBxIB87QnJ8ROKu+CbVbIgqzwnLg
         G0NpiedNbJNC6eoF6+dNYiDDnuWAew49DEPoVmvUoBosyvi3DKLFUb0lKfJKZ+U4fcJE
         ZJCioaIlyA7hn95j2fYYCoMND++zEGB/AVdyyeW3nBOR7qoQEBrlsyDLWTQKMF2XFFUA
         /KWBsWzRuSy8QtgISPyyHtJ9rGkrZKSFPGv/+SUAnZKYjKgbiYMF0Z9AdFeVoOrXShal
         kNhiOp7cj/4ZCkD7MUHe9myVmU18s/OF3qExHvZfmJNH6AwGjm7lAU7fDUasgda7qUYM
         IgHg==
X-Gm-Message-State: ABuFfogaEYkqWcmT8g81oCOX/pdiEInX4VogwDXqP1RvIO2emtO2E3cS
        esTUzn3WWF4717xiAuvCmv35Aw==
X-Google-Smtp-Source: ACcGV61fJ4GIYyeuV11d/KsgaXpKaVxTaOqqrBK7nuGWxeiG3ISBetkDWBsTXtULiw/xuNHiPwMuag==
X-Received: by 2002:adf:93a5:: with SMTP id 34-v6mr4880451wrp.244.1539339411952;
        Fri, 12 Oct 2018 03:16:51 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:51 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 10/13] mt76: introduce mt76x02_init_agc_gain routine
Date:   Fri, 12 Oct 2018 12:16:26 +0200
Message-Id: <2a1e5f6ebd1d7a3ab35547d66e241b9f312b448e.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x02_init_agc_gain routine in mt76x02-lib moudule in
order to be reused by mt76x0 for vga initalization

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c    | 12 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h    |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c | 12 +-----------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index 97310da37d77..0f1d7b5c9f68 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -244,3 +244,15 @@ bool mt76x02_phy_adjust_vga_gain(struct mt76x02_dev *dev)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_adjust_vga_gain);
+
+void mt76x02_init_agc_gain(struct mt76x02_dev *dev)
+{
+	dev->cal.agc_gain_init[0] = mt76_get_field(dev, MT_BBP(AGC, 8),
+						   MT_BBP_AGC_GAIN);
+	dev->cal.agc_gain_init[1] = mt76_get_field(dev, MT_BBP(AGC, 9),
+						   MT_BBP_AGC_GAIN);
+	memcpy(dev->cal.agc_gain_cur, dev->cal.agc_gain_init,
+	       sizeof(dev->cal.agc_gain_cur));
+	dev->cal.low_gain = -1;
+}
+EXPORT_SYMBOL_GPL(mt76x02_init_agc_gain);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index 8e3a0f93ca80..2b316cf7c70c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -56,5 +56,6 @@ void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
 void mt76x02_phy_set_band(struct mt76x02_dev *dev, int band,
 			  bool primary_upper);
 bool mt76x02_phy_adjust_vga_gain(struct mt76x02_dev *dev);
+void mt76x02_init_agc_gain(struct mt76x02_dev *dev);
 
 #endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 818d2f3e8ac9..5bda44540225 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -124,13 +124,6 @@ void mt76x2_phy_set_antenna(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_BBP(AGC, 0), val);
 }
 
-static void
-mt76x2_get_agc_gain(struct mt76x02_dev *dev, u8 *dest)
-{
-	dest[0] = mt76_get_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN);
-	dest[1] = mt76_get_field(dev, MT_BBP(AGC, 9), MT_BBP_AGC_GAIN);
-}
-
 static void
 mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
 {
@@ -340,11 +333,8 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 	if (scan)
 		return 0;
 
-	dev->cal.low_gain = -1;
 	mt76x2_phy_channel_calibrate(dev, true);
-	mt76x2_get_agc_gain(dev, dev->cal.agc_gain_init);
-	memcpy(dev->cal.agc_gain_cur, dev->cal.agc_gain_init,
-	       sizeof(dev->cal.agc_gain_cur));
+	mt76x02_init_agc_gain(dev);
 
 	/* init default values for temp compensation */
 	if (mt76x2_tssi_enabled(dev)) {
-- 
2.17.2

