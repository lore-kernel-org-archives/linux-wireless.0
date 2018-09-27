Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E30ECE561
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B8062156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B8062156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbeI0PTf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:35 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50427 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbeI0PTe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id s12-v6so5072185wmc.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pRhLEWIzURneDkCF1FdG+Lo5aC3V5zN711+ZsXNGHto=;
        b=OnLJehcfgm2DutWqXw3ecXB8JzMHmFySlfSLsTAiMCG47pQCMtpsPTLf9HfVyxDeO0
         ydV91+yID8KMTNlO4ytKkNzQPoo2rkgxJbQxC8y8pq9IgInqaTQh7QxdsG+gZpYimspY
         hStOV/ZY11CK9/XT9TeXX1bkbWnEm3mlUkFa4fKQyM94hBhqyw/UljKEmxmDWyTdNuHx
         RfNmgFKppm369h56uTA8DDWfg3onvLZOdP4exiaSKGblMXwjk5r8H0ikeGqtgzNY0rcn
         Nt0THkK4I5On9ioc7uS2gKqb1UvXF3pV5idddnHioFXMe+zOwqUQR0U3sfemsGVd1Gxb
         M1GQ==
X-Gm-Message-State: ABuFfojfvp1LfyRjFTmjnNXJg3SUEzcaXNZpJoEf++TfsQvYNaxVtls3
        w29ave+/yfV5wVDmbqvyGcYgWQ==
X-Google-Smtp-Source: ACcGV610h5cyMGt+YvGKLOgyijXehzIpRc2nwyKvekxl8tCywnRIp4mRh/kBVGeB8kWRnO8xZKWeSg==
X-Received: by 2002:a1c:f60c:: with SMTP id w12-v6mr7260723wmc.80.1538038940341;
        Thu, 27 Sep 2018 02:02:20 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:19 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 19/26] mt76x0: pci: add hw initialization at bootstrap
Date:   Thu, 27 Sep 2018 11:01:48 +0200
Message-Id: <74b90927973b06ffe237f7d568ffb3fa12791058.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x0e_register_device routine in pci_init.c
to initialize the device during hw probe.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/Makefile    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 10 +--
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 +
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x0/pci_init.c  | 65 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  1 +
 6 files changed, 73 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index 30c84a557076..daa4929bdee6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -6,7 +6,7 @@ mt76x0-common-y := \
 	init.o main.o trace.o eeprom.o phy.o \
 	mac.o debugfs.o tx.o
 mt76x0u-y := usb.o usb_mcu.o usb_init.o
-mt76x0e-y := pci.o pci_mcu.o
+mt76x0e-y := pci.o pci_mcu.o pci_init.o
 
 # ccflags-y := -DDEBUG
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 3426ec385380..ffd5c864aef1 100644
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
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 70bb2f3af90b..507fa5a9da88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -138,6 +138,8 @@ void mt76x0_mac_stop(struct mt76x0_dev *dev);
 void mt76x0u_cleanup(struct mt76x0_dev *dev);
 int mt76x0u_register_device(struct mt76x0_dev *dev);
 
+int mt76x0e_register_device(struct mt76x0_dev *dev);
+
 /* PHY */
 void mt76x0_phy_init(struct mt76x0_dev *dev);
 int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 99d142319d1c..8cb33f44ac6c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -50,7 +50,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
 
-	ret = mt76x0e_mcu_init(dev);
+	ret = mt76x0e_register_device(dev);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
new file mode 100644
index 000000000000..a3aab7d75f2b
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/kernel.h>
+#include <linux/firmware.h>
+
+#include "mt76x0.h"
+#include "mcu.h"
+#include "../mt76x02_dma.h"
+
+int mt76x0e_register_device(struct mt76x0_dev *dev)
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

