Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21154C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E27DE2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E27DE2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbeJKQSw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35127 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbeJKQSw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id w5-v6so8725271wrt.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nGrpyvovGZTYcPfwMIBYxR6wfRO9iJ3V3oy9T78GfaA=;
        b=IK78I3EHKRG/F6SiInlC/3Ba4xz+D0DsVHe5YgBC6U6ySeIu5ffCehPgTqjNBff2nM
         hkwjfYzwmcc6fJpGWrK/7UnzFDBx9iWHehwumxzsrTfaIRe4jflH981iUBWxJ6/fF1If
         ai3/a2DsLxqDyD7ytxT8q3ZyfYUphtJPtl31PcXSi8DWqfHtrk+WiEmQ90a/RWOC453b
         kadHY9rAAqSIfoxF1pRGxXo3q06zgquQ8+VeOzu64uvKbGInRJidEnzTG+mHGO1Mdo39
         krIcIBBu3g78y9toHMJvDhiR2Nrt6wEGz6Rn1sZrKvWa9CiYngW0lTeyU4k5vX5C4cgD
         sq9w==
X-Gm-Message-State: ABuFfogaXTi9V4npeHNZ+TtiBBf9UUOa0t1PJOxxPnh0x3E0C3/BkBRZ
        cMXhuOOGXRs+vikFd5PQ3s0s0YP7q9I=
X-Google-Smtp-Source: ACcGV60yVK0PeBJKK58WlhvEKeP/wSku2CatmbH7KH8Cej1RUuCl9si4ag72GZejFAoUfQVoNZBfag==
X-Received: by 2002:a5d:6383:: with SMTP id p3-v6mr688045wru.291.1539247952326;
        Thu, 11 Oct 2018 01:52:32 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:31 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 10/12] mt76: introduce mt76x02_init_agc_gain routine
Date:   Thu, 11 Oct 2018 10:52:07 +0200
Message-Id: <7294496cc6211e224828cef08971cd6c1fca980f.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
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

