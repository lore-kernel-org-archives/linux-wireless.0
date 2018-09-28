Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4913FC04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A8602172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A8602172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbeI1NDB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:03:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32901 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728995AbeI1NDA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:03:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id f10-v6so5104729wrs.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q/ri6L8OramlG743tbVejjSFQyQdNO01TOcJ8il9aqM=;
        b=avbGXR1Q27VDqLNBe5BZzp1PzYrlS42uptvkMNh/WwS6F1fCd0l9WIxYMQvsilLm+k
         EYqotaRiMPLCnXw+6eQE/R4SAKvSXLLTmHuWOBGcgQq8capAyJtrMBLk6X6WEUlIrC2Q
         jR2IYSjW6mhe48ogZnPyWOjD8JL7Gu+cHTW3Kfs4eGzdcAz/wqOQ4dZKJMJb0BKfIwY4
         xlSme65LQyiBCPrfB0tXz3EVWOUMcpZDgTEhDHQBujK1zvNMZ6Dwdzsx57WId1BlPBY9
         VeLt0ANslU9NbXK9wmvReGkb5ITje0EK8L4oCEa842OFTaMsCQY4G11UxLLkwjUJ9sEB
         JQrA==
X-Gm-Message-State: ABuFfoh7bMl8F5/w7eB3+awynpAAJ768tCHQVJ6TOkXVrlIZlE7x6Wjo
        o7ryy8z5FktT3j24CbrILD4aIw==
X-Google-Smtp-Source: ACcGV636pXFlz1ig+UKww6ibYohkeeynBcc41xNjp2qGSLvlbtShyGxDEMfdULdgHKaIezKUYvtpgA==
X-Received: by 2002:adf:bd10:: with SMTP id j16-v6mr10696661wrh.267.1538116846425;
        Thu, 27 Sep 2018 23:40:46 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:45 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 18/24] mt76x0: pci: add hw initialization at bootstrap
Date:   Fri, 28 Sep 2018 08:40:11 +0200
Message-Id: <20180928064017.26870-19-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x0e_register_device routine in pci.c
to initialize the device during hw probe.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 10 ++--
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 47 ++++++++++++++++++-
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  1 +
 3 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index fe3e64a47b5c..adeea0572c51 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -107,6 +107,9 @@ static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
 		MT_MAC_SYS_CTRL_RESET_CSR |
 		MT_MAC_SYS_CTRL_RESET_BBP);
 	msleep(200);
+	mt76_clear(dev, MT_MAC_SYS_CTRL,
+		   MT_MAC_SYS_CTRL_RESET_CSR |
+		   MT_MAC_SYS_CTRL_RESET_BBP);
 }
 
 #define RANDOM_WRITE(dev, tab)			\
@@ -152,13 +155,6 @@ static void mt76x0_init_mac_registers(struct mt76x0_dev *dev)
 	reg &= ~0x3;
 	mt76_wr(dev, MT_MAC_SYS_CTRL, reg);
 
-	if (is_mt7610e(dev)) {
-		/* Disable COEX_EN */
-		reg = mt76_rr(dev, MT_COEXCFG0);
-		reg &= 0xFFFFFFFE;
-		mt76_wr(dev, MT_COEXCFG0, reg);
-	}
-
 	/* Set 0x141C[15:12]=0xF */
 	reg = mt76_rr(dev, MT_EXT_CCA_CFG);
 	reg |= 0x0000F000;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 99d142319d1c..79db75811458 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -20,6 +20,51 @@
 
 #include "mt76x0.h"
 #include "mcu.h"
+#include "../mt76x02_dma.h"
+
+static int mt76x0e_register_device(struct mt76x0_dev *dev)
+{
+	int err;
+
+	mt76x0_chip_onoff(dev, true, false);
+	if (!mt76x02_wait_for_mac(&dev->mt76))
+		return -ETIMEDOUT;
+
+	mt76x02_dma_disable(&dev->mt76);
+	err = mt76x0e_mcu_init(dev);
+	if (err < 0)
+		return err;
+
+	err = mt76x02_dma_init(&dev->mt76);
+	if (err < 0)
+		return err;
+
+	err = mt76x0_init_hardware(dev);
+	if (err < 0)
+		return err;
+
+	if (mt76_chip(&dev->mt76) == 0x7610) {
+		u16 val;
+
+		mt76_clear(dev, MT_COEXCFG0, BIT(0));
+		val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
+		if (val & MT_EE_NIC_CONF_0_PA_IO_CURRENT) {
+			u32 data;
+
+			/* set external external PA I/O
+			 * current to 16mA
+			 */
+			data = mt76_rr(dev, 0x11c);
+			val |= 0xc03;
+			mt76_wr(dev, 0x11c, val);
+		}
+	}
+
+	mt76_clear(dev, 0x110, BIT(9));
+	mt76_set(dev, MT_MAX_LEN_CFG, BIT(13));
+
+	return 0;
+}
 
 static int
 mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -50,7 +95,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
 
-	ret = mt76x0e_mcu_init(dev);
+	ret = mt76x0e_register_device(dev);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index b45e2afeadd0..bcd05f7c5f45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -107,6 +107,7 @@ enum mt76x02_eeprom_field {
 #define MT_EE_NIC_CONF_0_PA_TYPE		GENMASK(9, 8)
 #define MT_EE_NIC_CONF_0_PA_INT_2G		BIT(8)
 #define MT_EE_NIC_CONF_0_PA_INT_5G		BIT(9)
+#define MT_EE_NIC_CONF_0_PA_IO_CURRENT		BIT(10)
 #define MT_EE_NIC_CONF_0_BOARD_TYPE		GENMASK(13, 12)
 
 #define MT_EE_NIC_CONF_1_HW_RF_CTRL		BIT(0)
-- 
2.19.0

