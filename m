Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0345C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66C4321547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66C4321547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbeI1SC6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36609 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729093AbeI1SC6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id l10-v6so6041970wrp.3
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mrDn2uIbVdWeM9084FD+7vFY3c1BB4eWWF+mZOY20Lw=;
        b=FBHTV/7djA2FAdyLdumug6TQYVeNSeoWGJq2JUx+PNAcfV0UUFiLK6yQerQl65RRYK
         nkES3KTWRFyhXr0MIBHTRVvHoE1CEgEJ2vxJIkdF8d+r2LzmVCGlYN64IRQZoYB5toYn
         8EslluvLFvYK3MHY+p6O29NCgHNm66hjUc0D5s4ECQtaBsGtsGMiQ0MU+L9VbM96hKll
         k8/Ae2DAUhr/0Zrk2XC3PQEDZd/Mral6KEYGsmVA2aS6cOoI/Zw8Y29aniLcPBzOmVei
         WTa6YflVRFETN9jg649MlyHVLiwJit5/fIdltk6p6o5CnxnFKvRoQNdOBT7DJ4Avvv+g
         W3Tg==
X-Gm-Message-State: ABuFfojX7cngebFBIPLn8haaJsTOYFP9JfujbsHhkiwwYLSsxhvx1nn1
        djzlPu7RXdo8+dMmDsO0Gu2NA7GIqOY=
X-Google-Smtp-Source: ACcGV61STgLesunpaNcHibNToDQIf6vFpOrtq0c7g3LsJU1/6ARat5AWXOLjuuYAQgPgZfqa6RC9MQ==
X-Received: by 2002:a5d:4488:: with SMTP id j8-v6mr7879771wrq.236.1538134774220;
        Fri, 28 Sep 2018 04:39:34 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:33 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 18/24] mt76x0: pci: add hw initialization at bootstrap
Date:   Fri, 28 Sep 2018 13:39:01 +0200
Message-Id: <23558d6b89284a8abe04b78e4d9c4068d59f069b.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
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
index 1d20ed56d201..5ec0ee6ce38d 100644
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
2.17.1

