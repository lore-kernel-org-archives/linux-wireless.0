Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84D1C004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE56D2157C
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE56D2157C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbeI0PTl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39268 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbeI0PTk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id s14-v6so1695431wrw.6
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UlhdRtyCjZ6PkewjO63B1b1S8rq4PQmJkcnDubAjEaw=;
        b=ASWr3IUA+T2way+kbgWXEBi+13s7jz2XCw+Ep+MqGpZmL/5uqoG7/oScgCuDTKRNfR
         If/UF6g5i6gTZy53yALVA/WOqKTkMUFvx0Rvn63qhLcIOdIHIRuyoAifl6Nvi9/hk0yO
         5QtFUI0OqTnniAg8jRppPkyp5SgYWnA9Oa9p2PoDwIzM12LtQyXpOgoDZl8wQPRCeKYd
         O2c20wC4gJ21L+EmiRx1E8kGToj8ccfnr49SjSE3UFwwOe45qA1syxzwEWZf5X/VsHra
         GtocjN9o+mCnbqZEU11Yb+e+Ib2bUszUuJO026BWgKP9ufMNf8HiAa0a0/yTjY+isyDg
         c7jA==
X-Gm-Message-State: ABuFfoiYQfwix/dZYf3vR5kf1hc46PZOojPIyu6m7iK9mNEviMvr9dfg
        yv3hC+VWFLazoFiEnWKERhntjAxg9oU=
X-Google-Smtp-Source: ACcGV61RfxdQwuOIvRCWpgqoCOQFgTUeDoH+OjVsqWYebGffQQ+qPlbNxcZH/Ktwj79CSPzzDeLX2g==
X-Received: by 2002:adf:e6c9:: with SMTP id y9-v6mr8112247wrm.35.1538038946960;
        Thu, 27 Sep 2018 02:02:26 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:26 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 26/26] mt76x0: introduce mt76x0{e,u}_eeprom_init routines
Date:   Thu, 27 Sep 2018 11:01:55 +0200
Message-Id: <1457f6867593da095e3103271bb810cbb5e42514.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x0e_eeprom_init/mt76x0u_eeprom_init routines to initialize
pci/usb eeprom and move eeprom init shared code between pci and usb
drivers in mt76x0_eeprom_init

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 19 +++------------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  5 ----
 .../wireless/mediatek/mt76/mt76x0/pci_init.c  | 15 ++++++++++++
 .../wireless/mediatek/mt76/mt76x0/usb_init.c  | 24 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   |  2 ++
 6 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index ef9c3df6a169..f4bff6e70087 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -24,8 +24,7 @@
 #include "../mt76x02_phy.h"
 
 #define MT_MAP_READS	DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
-static int
-mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
+int mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
 {
 	u8 data[MT_MAP_READS * 16];
 	int ret, i;
@@ -52,6 +51,7 @@ mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt76x0_efuse_physical_size_check);
 
 static void mt76x0_set_chip_cap(struct mt76x0_dev *dev)
 {
@@ -281,20 +281,6 @@ int mt76x0_eeprom_init(struct mt76x0_dev *dev)
 {
 	u8 version, fae;
 	u16 data;
-	int ret;
-
-	ret = mt76x0_efuse_physical_size_check(dev);
-	if (ret)
-		return ret;
-
-	ret = mt76_eeprom_init(&dev->mt76, MT76X0_EEPROM_SIZE);
-	if (ret < 0)
-		return ret;
-
-	ret = mt76x02_get_efuse_data(&dev->mt76, 0, dev->mt76.eeprom.data,
-				     MT76X0_EEPROM_SIZE, MT_EE_READ);
-	if (ret)
-		return ret;
 
 	data = mt76x02_eeprom_get(&dev->mt76, MT_EE_VERSION);
 	version = data >> 8;
@@ -317,5 +303,6 @@ int mt76x0_eeprom_init(struct mt76x0_dev *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt76x0_eeprom_init);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 4e1fafa5b8c3..0bcb37a66a10 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -35,6 +35,7 @@ int mt76x0_eeprom_init(struct mt76x0_dev *dev);
 void mt76x0_read_rx_gain(struct mt76x0_dev *dev);
 void mt76x0_get_tx_power_per_rate(struct mt76x0_dev *dev);
 void mt76x0_get_power_info(struct mt76x0_dev *dev, u8 *info);
+int mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev);
 
 static inline s8 s6_to_s8(u32 val)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index b566e1aa22a5..d79ad86b5262 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -329,11 +329,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	}
 
 	mt76x0_reset_counters(dev);
-
-	ret = mt76x0_eeprom_init(dev);
-	if (ret)
-		return ret;
-
 	mt76x0_phy_init(dev);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
index 29751b6ee470..315e90b53611 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
@@ -66,6 +66,17 @@ const struct ieee80211_ops mt76x0e_ops = {
 	.configure_filter = mt76x02_configure_filter,
 };
 
+static int mt76x0e_eeprom_init(struct mt76x0_dev *dev)
+{
+	int err;
+
+	err = mt76x02_eeprom_load(&dev->mt76, MT76X0_EEPROM_SIZE);
+	if (err < 0)
+		return err;
+
+	return mt76x0_eeprom_init(dev);
+}
+
 int mt76x0e_register_device(struct mt76x0_dev *dev)
 {
 	int err;
@@ -79,6 +90,10 @@ int mt76x0e_register_device(struct mt76x0_dev *dev)
 	if (err < 0)
 		return err;
 
+	err = mt76x0e_eeprom_init(dev);
+	if (err < 0)
+		return err;
+
 	err = mt76x02_dma_init(&dev->mt76);
 	if (err < 0)
 		return err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c
index 84572b0ea135..7bce1650240d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c
@@ -120,6 +120,26 @@ void mt76x0u_cleanup(struct mt76x0_dev *dev)
 	mt76u_mcu_deinit(&dev->mt76);
 }
 
+static int mt76x0u_eeprom_init(struct mt76x0_dev *dev)
+{
+	int err;
+
+	err = mt76x0_efuse_physical_size_check(dev);
+	if (err < 0)
+		return err;
+
+	err = mt76_eeprom_init(&dev->mt76, MT76X0_EEPROM_SIZE);
+	if (err < 0)
+		return err;
+
+	err = mt76x02_get_efuse_data(&dev->mt76, 0, dev->mt76.eeprom.data,
+				     MT76X0_EEPROM_SIZE, MT_EE_READ);
+	if (err < 0)
+		return err;
+
+	return mt76x0_eeprom_init(dev);
+}
+
 int mt76x0u_register_device(struct mt76x0_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->mt76.hw;
@@ -139,6 +159,10 @@ int mt76x0u_register_device(struct mt76x0_dev *dev)
 		goto err;
 	}
 
+	err = mt76x0u_eeprom_init(dev);
+	if (err < 0)
+		return err;
+
 	err = mt76x0u_mcu_init(dev);
 	if (err < 0)
 		goto err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
index f2a4dca3e05e..d9b80df8ce08 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -259,6 +259,8 @@ static int mt76x02_check_eeprom(struct mt76_dev *dev)
 	switch (val) {
 	case 0x7662:
 	case 0x7612:
+	case 0x7650:
+	case 0x7610:
 		return 0;
 	default:
 		dev_err(dev->dev, "EEPROM data check failed: %04x\n", val);
-- 
2.17.1

