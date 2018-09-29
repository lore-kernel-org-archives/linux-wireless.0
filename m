Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E4AC43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 11:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BCA32064D
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 11:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BCA32064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbeI2Rgn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 13:36:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54548 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbeI2Rgn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 13:36:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id r63-v6so422199wma.4
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2018 04:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lj/Y7lWdzvwPAlQ4mwH72cQdk5eXE4nTXwly9gHhwYM=;
        b=FwcOrM3gcY/4KMQ5oRA6zYsGZTUe1rlgHNPZYbdM/4VV4udhx7wvI5CADOCeUYRFHO
         Lw2C6K9+B6pUVXeNewIPlH/b2As9fLL9Dfozhbq6b0ilDUJkDUzyWSP61upVrIq/EqBl
         302Zu+mGMSrwDKcC2qpYN/ESX7TB9gi3ZbBKQT28hICLgUkhcTUL+7dQpOxICZ4mGy+w
         B5xE2vIiq/97/Lij0EstB+BTB93liWQWfR3+uVnlfXY7+42SEnmZdC/uDrQ5uJx42eQH
         DdrUB6lT2WOhuWe5FHJITWbSb9gdFDVsSLvDt6luOceZcA9jP1SKMg0rgxICZiRXy/ZW
         4Uzg==
X-Gm-Message-State: ABuFfohlPNxdd3p1IabFmItAWcUyG85qSZ+3htru22n7MO78QIQ5zSY5
        9zzN8SQHo/Mg9JseWjGJ09ecqgLHu8k=
X-Google-Smtp-Source: ACcGV62SxZMey/38GsV3PjKd3q5/xiZLkhHzCs9zIhAOn28eUyA+Hg+6RfDdgDO4VPohHKrj2Tr0UA==
X-Received: by 2002:a1c:318b:: with SMTP id x133-v6mr4430334wmx.145.1538219317578;
        Sat, 29 Sep 2018 04:08:37 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id i4-v6sm17024639wrs.87.2018.09.29.04.08.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Sep 2018 04:08:36 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC] mt76x2: move mt76x2 source files to mt76x2 folder
Date:   Sat, 29 Sep 2018 13:08:19 +0200
Message-Id: <20180929110819.23962-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x2 and mt76x2u drivers to mt76x2 subfolder and
leave just shared code in mt76 root folder

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig    | 43 +------------------
 drivers/net/wireless/mediatek/mt76/Makefile   | 22 +---------
 .../net/wireless/mediatek/mt76/mt76x0/Kconfig | 20 +++++++++
 .../net/wireless/mediatek/mt76/mt76x2/Kconfig | 20 +++++++++
 .../wireless/mediatek/mt76/mt76x2/Makefile    | 18 ++++++++
 .../mt76/{mt76x2_common.c => mt76x2/common.c} |  2 +-
 .../{mt76x2_debugfs.c => mt76x2/debugfs.c}    |  0
 .../mt76/{mt76x2_dfs.h => mt76x2/dfs.h}       |  0
 .../mt76/{mt76x2_eeprom.c => mt76x2/eeprom.c} |  2 +-
 .../mt76/{mt76x2_eeprom.h => mt76x2/eeprom.h} |  2 +-
 .../{mt76x2_init_common.c => mt76x2/init.c}   |  4 +-
 .../{mt76x2_mac_common.c => mt76x2/mac.c}     |  2 +-
 .../mt76/{mt76x2_mac.h => mt76x2/mac.h}       |  4 +-
 .../{mt76x2_mcu_common.c => mt76x2/mcu.c}     |  6 +--
 .../mt76/{mt76x2_mcu.h => mt76x2/mcu.h}       |  2 +-
 .../mediatek/mt76/{ => mt76x2}/mt76x2.h       |  8 ++--
 .../mediatek/mt76/{ => mt76x2}/mt76x2u.h      |  4 +-
 .../mt76/{mt76x2_pci.c => mt76x2/pci.c}       |  2 +-
 .../mt76/{mt76x2_core.c => mt76x2/pci_core.c} |  4 +-
 .../mt76/{mt76x2_dfs.c => mt76x2/pci_dfs.c}   |  2 +-
 .../mt76/{mt76x2_dma.c => mt76x2/pci_dma.c}   |  4 +-
 .../mt76/{mt76x2_init.c => mt76x2/pci_init.c} |  8 ++--
 .../mt76/{mt76x2_mac.c => mt76x2/pci_mac.c}   |  8 ++--
 .../mt76/{mt76x2_main.c => mt76x2/pci_main.c} |  2 +-
 .../mt76/{mt76x2_mcu.c => mt76x2/pci_mcu.c}   |  6 +--
 .../mt76/{mt76x2_phy.c => mt76x2/pci_phy.c}   |  4 +-
 .../{mt76x2_trace.c => mt76x2/pci_trace.c}    |  2 +-
 .../mt76/{mt76x2_tx.c => mt76x2/pci_tx.c}     |  4 +-
 .../{mt76x2_phy_common.c => mt76x2/phy.c}     |  6 +--
 .../mt76/{mt76x2_trace.h => mt76x2/trace.h}   |  2 +-
 .../mt76/{mt76x2_tx_common.c => mt76x2/tx.c}  |  2 +-
 .../mt76/{mt76x2_usb.c => mt76x2/usb.c}       |  2 +-
 .../{mt76x2u_core.c => mt76x2/usb_core.c}     |  6 +--
 .../{mt76x2u_init.c => mt76x2/usb_init.c}     |  6 +--
 .../mt76/{mt76x2u_mac.c => mt76x2/usb_mac.c}  |  2 +-
 .../{mt76x2u_main.c => mt76x2/usb_main.c}     |  2 +-
 .../mt76/{mt76x2u_mcu.c => mt76x2/usb_mcu.c}  |  4 +-
 .../mt76/{mt76x2u_phy.c => mt76x2/usb_phy.c}  |  2 +-
 38 files changed, 120 insertions(+), 119 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_common.c => mt76x2/common.c} (98%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_debugfs.c => mt76x2/debugfs.c} (100%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dfs.h => mt76x2/dfs.h} (100%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_eeprom.c => mt76x2/eeprom.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_eeprom.h => mt76x2/eeprom.h} (98%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_init_common.c => mt76x2/init.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mac_common.c => mt76x2/mac.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mac.h => mt76x2/mac.h} (97%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu_common.c => mt76x2/mcu.c} (97%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu.h => mt76x2/mcu.h} (99%)
 rename drivers/net/wireless/mediatek/mt76/{ => mt76x2}/mt76x2.h (98%)
 rename drivers/net/wireless/mediatek/mt76/{ => mt76x2}/mt76x2u.h (98%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_pci.c => mt76x2/pci.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_core.c => mt76x2/pci_core.c} (97%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dfs.c => mt76x2/pci_dfs.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dma.c => mt76x2/pci_dma.c} (95%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_init.c => mt76x2/pci_init.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mac.c => mt76x2/pci_mac.c} (98%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_main.c => mt76x2/pci_main.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu.c => mt76x2/pci_mcu.c} (98%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_phy.c => mt76x2/pci_phy.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_trace.c => mt76x2/pci_trace.c} (97%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_tx.c => mt76x2/pci_tx.c} (98%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_phy_common.c => mt76x2/phy.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_trace.h => mt76x2/trace.h} (98%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_tx_common.c => mt76x2/tx.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_usb.c => mt76x2/usb.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_core.c => mt76x2/usb_core.c} (95%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_init.c => mt76x2/usb_init.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_mac.c => mt76x2/usb_mac.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_main.c => mt76x2/usb_main.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_mcu.c => mt76x2/usb_mcu.c} (99%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_phy.c => mt76x2/usb_phy.c} (99%)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 7f24aad94efd..0ccbcd7e887d 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -13,44 +13,5 @@ config MT76x02_USB
 	tristate
 	select MT76_USB
 
-config MT76x0_COMMON
-	tristate
-	select MT76x02_LIB
-
-config MT76x2_COMMON
-	tristate
-	select MT76x02_LIB
-
-config MT76x0U
-	tristate "MediaTek MT76x0U (USB) support"
-	select MT76x0_COMMON
-	select MT76x02_USB
-	depends on MAC80211
-	depends on USB
-	help
-	  This adds support for MT7610U-based wireless USB dongles.
-
-config MT76x0E
-	tristate "MediaTek MT76x0E (PCIe) support"
-	select MT76x0_COMMON
-	depends on MAC80211
-	depends on PCI
-	help
-	  This adds support for MT7610/MT7630-based wireless PCIe devices.
-
-config MT76x2E
-	tristate "MediaTek MT76x2E (PCIe) support"
-	select MT76x2_COMMON
-	depends on MAC80211
-	depends on PCI
-	---help---
-	  This adds support for MT7612/MT7602/MT7662-based wireless PCIe devices.
-
-config MT76x2U
-	tristate "MediaTek MT76x2U (USB) support"
-	select MT76x2_COMMON
-	select MT76x02_USB
-	depends on MAC80211
-	depends on USB
-	help
-	  This adds support for MT7612U-based wireless USB dongles.
+source "drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig"
+source "drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig"
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 2346a1b768bc..907b9e2d7044 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -1,11 +1,7 @@
 obj-$(CONFIG_MT76_CORE) += mt76.o
 obj-$(CONFIG_MT76_USB) += mt76-usb.o
-obj-$(CONFIG_MT76x0_COMMON) += mt76x0/
 obj-$(CONFIG_MT76x02_LIB) += mt76x02-lib.o
 obj-$(CONFIG_MT76x02_USB) += mt76x02-usb.o
-obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
-obj-$(CONFIG_MT76x2E) += mt76x2e.o
-obj-$(CONFIG_MT76x2U) += mt76x2u.o
 
 mt76-y := \
 	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o
@@ -20,19 +16,5 @@ mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
-mt76x2-common-y := \
-	mt76x2_eeprom.o mt76x2_tx_common.o mt76x2_mac_common.o \
-	mt76x2_init_common.o mt76x2_common.o mt76x2_phy_common.o \
-	mt76x2_debugfs.o mt76x2_mcu_common.o
-
-mt76x2e-y := \
-	mt76x2_pci.o mt76x2_dma.o \
-	mt76x2_main.o mt76x2_init.o mt76x2_tx.o \
-	mt76x2_core.o mt76x2_mac.o mt76x2_mcu.o mt76x2_phy.o \
-	mt76x2_dfs.o mt76x2_trace.o
-
-mt76x2u-y := \
-	mt76x2_usb.o mt76x2u_init.o mt76x2u_main.o mt76x2u_mac.o \
-	mt76x2u_mcu.o mt76x2u_phy.o mt76x2u_core.o
-
-CFLAGS_mt76x2_trace.o := -I$(src)
+obj-$(CONFIG_MT76x0_COMMON) += mt76x0/
+obj-$(CONFIG_MT76x2_COMMON) += mt76x2/
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig b/drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig
new file mode 100644
index 000000000000..9a6157db3893
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig
@@ -0,0 +1,20 @@
+config MT76x0_COMMON
+	tristate
+	select MT76x02_LIB
+
+config MT76x0U
+	tristate "MediaTek MT76x0U (USB) support"
+	select MT76x0_COMMON
+	select MT76x02_USB
+	depends on MAC80211
+	depends on USB
+	help
+	  This adds support for MT7610U-based wireless USB dongles.
+
+config MT76x0E
+	tristate "MediaTek MT76x0E (PCIe) support"
+	select MT76x0_COMMON
+	depends on MAC80211
+	depends on PCI
+	help
+	  This adds support for MT7610/MT7630-based wireless PCIe devices.
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig b/drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig
new file mode 100644
index 000000000000..2b414a0e9088
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig
@@ -0,0 +1,20 @@
+config MT76x2_COMMON
+	tristate
+	select MT76x02_LIB
+
+config MT76x2E
+	tristate "MediaTek MT76x2E (PCIe) support"
+	select MT76x2_COMMON
+	depends on MAC80211
+	depends on PCI
+	---help---
+	  This adds support for MT7612/MT7602/MT7662-based wireless PCIe devices.
+
+config MT76x2U
+	tristate "MediaTek MT76x2U (USB) support"
+	select MT76x2_COMMON
+	select MT76x02_USB
+	depends on MAC80211
+	depends on USB
+	help
+	  This adds support for MT7612U-based wireless USB dongles.
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
new file mode 100644
index 000000000000..2b5a3164274e
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -0,0 +1,18 @@
+obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
+obj-$(CONFIG_MT76x2E) += mt76x2e.o
+obj-$(CONFIG_MT76x2U) += mt76x2u.o
+
+mt76x2-common-y := \
+	eeprom.o tx.o mac.o init.o common.o phy.o \
+	debugfs.o mcu.o
+
+mt76x2e-y := \
+	pci.o pci_dma.o pci_main.o pci_init.o pci_tx.o \
+	pci_core.o pci_mac.o pci_mcu.o pci_phy.o \
+	pci_dfs.o pci_trace.o
+
+mt76x2u-y := \
+	usb.o usb_init.o usb_main.o usb_mac.o usb_mcu.o \
+	usb_phy.o usb_core.o
+
+CFLAGS_pci_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_common.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/common.c
index 3e667d8c0ee7..fa6bad3bf613 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
@@ -16,7 +16,7 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x02_mac.h"
+#include "../mt76x02_mac.h"
 
 void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c
similarity index 100%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
similarity index 100%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
rename to drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
index 136faa4066a5..55eda67f0e79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
@@ -17,7 +17,7 @@
 #include <linux/module.h>
 #include <asm/unaligned.h>
 #include "mt76x2.h"
-#include "mt76x2_eeprom.h"
+#include "eeprom.h"
 
 #define EE_FIELD(_name, _value) [MT_EE_##_name] = (_value) | 1
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
rename to drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
index c2e99bbeac3b..33277c7bca9c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
@@ -17,7 +17,7 @@
 #ifndef __MT76x2_EEPROM_H
 #define __MT76x2_EEPROM_H
 
-#include "mt76x02_eeprom.h"
+#include "../mt76x02_eeprom.h"
 
 enum mt76x2_cal_channel_group {
 	MT_CH_5G_JAPAN,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index f4c4cde9301e..d672771963d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -16,8 +16,8 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x2_eeprom.h"
-#include "mt76x02_phy.h"
+#include "eeprom.h"
+#include "../mt76x02_phy.h"
 
 static void
 mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index ed4f56a3aae9..568bac76097c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -16,7 +16,7 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x02_util.h"
+#include "../mt76x02_util.h"
 
 void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
similarity index 97%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
rename to drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index 66a57294fcfc..b2176f9a661a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -17,8 +17,8 @@
 #ifndef __MT76x2_MAC_H
 #define __MT76x2_MAC_H
 
-#include "mt76.h"
-#include "mt76x02_mac.h"
+#include "../mt76.h"
+#include "../mt76x02_mac.h"
 
 struct mt76x2_dev;
 struct mt76x2_sta;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
similarity index 97%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
index eff483333183..86b09534326e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
@@ -20,9 +20,9 @@
 #include <linux/delay.h>
 
 #include "mt76x2.h"
-#include "mt76x2_mcu.h"
-#include "mt76x2_eeprom.h"
-#include "mt76x02_dma.h"
+#include "mcu.h"
+#include "eeprom.h"
+#include "../mt76x02_dma.h"
 
 int mt76x2_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
 			   u8 bw_index, bool scan)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
rename to drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
index fa72d5a5ecad..98a73e285a45 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
@@ -17,7 +17,7 @@
 #ifndef __MT76x2_MCU_H
 #define __MT76x2_MCU_H
 
-#include "mt76x02_mcu.h"
+#include "../mt76x02_mcu.h"
 
 /* Register definitions */
 #define MT_MCU_CPU_CTL			0x0704
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x2.h
rename to drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index d6ccab06a594..ecbb9e4ab888 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -39,10 +39,10 @@
 
 #define MT_CALIBRATE_INTERVAL	HZ
 
-#include "mt76.h"
-#include "mt76x02_regs.h"
-#include "mt76x2_mac.h"
-#include "mt76x2_dfs.h"
+#include "../mt76.h"
+#include "../mt76x02_regs.h"
+#include "mac.h"
+#include "dfs.h"
 
 struct mt76x2_rx_freq_cal {
 	s8 high_gain[MT_MAX_CHAINS];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x2u.h
rename to drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
index 5d2ebdf42c63..969e8e15fc58 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
@@ -20,8 +20,8 @@
 #include <linux/device.h>
 
 #include "mt76x2.h"
-#include "mt76x2_mcu.h"
-#include "mt76x02_dma.h"
+#include "mcu.h"
+#include "../mt76x02_dma.h"
 
 #define MT7612U_EEPROM_SIZE		512
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 26cfda24ce08..49556becb72d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -19,7 +19,7 @@
 #include <linux/pci.h>
 
 #include "mt76x2.h"
-#include "mt76x2_trace.h"
+#include "trace.h"
 
 static const struct pci_device_id mt76pci_device_table[] = {
 	{ PCI_DEVICE(0x14c3, 0x7662) },
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
similarity index 97%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_core.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
index 06e47f960f9a..b343742b36ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
@@ -16,8 +16,8 @@
 
 #include <linux/delay.h>
 #include "mt76x2.h"
-#include "mt76x2_trace.h"
-#include "mt76x02_util.h"
+#include "trace.h"
+#include "../mt76x02_util.h"
 
 void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
index 8cfa3a063bda..18926a6478ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
@@ -15,7 +15,7 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x02_util.h"
+#include "../mt76x02_util.h"
 
 #define RADAR_SPEC(m, len, el, eh, wl, wh,		\
 		   w_tolerance, tl, th, t_tolerance,	\
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
similarity index 95%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
index 7e5eccda47f8..fdd5103e8c93 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
@@ -15,8 +15,8 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x02_dma.h"
-#include "mt76x02_util.h"
+#include "../mt76x02_dma.h"
+#include "../mt76x02_util.h"
 
 void mt76x2_tx_tasklet(unsigned long data)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_init.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 3f77c13a6d54..7036f4cbc836 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -16,10 +16,10 @@
 
 #include <linux/delay.h>
 #include "mt76x2.h"
-#include "mt76x2_eeprom.h"
-#include "mt76x2_mcu.h"
-#include "mt76x02_util.h"
-#include "mt76x02_dma.h"
+#include "eeprom.h"
+#include "mcu.h"
+#include "../mt76x02_util.h"
+#include "../mt76x02_dma.h"
 
 static void
 mt76x2_mac_pbf_init(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 25ce8fcbb873..45b21a9a7385 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -16,10 +16,10 @@
 
 #include <linux/delay.h>
 #include "mt76x2.h"
-#include "mt76x2_mcu.h"
-#include "mt76x2_eeprom.h"
-#include "mt76x2_trace.h"
-#include "mt76x02_util.h"
+#include "mcu.h"
+#include "eeprom.h"
+#include "trace.h"
+#include "../mt76x02_util.h"
 
 void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_main.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 63691b68a436..521c9265bfe0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -15,7 +15,7 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x02_util.h"
+#include "../mt76x02_util.h"
 
 static int
 mt76x2_start(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index 55716fd7e01d..38fa84bddf7b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -19,9 +19,9 @@
 #include <linux/delay.h>
 
 #include "mt76x2.h"
-#include "mt76x2_mcu.h"
-#include "mt76x2_eeprom.h"
-#include "mt76x02_dma.h"
+#include "mcu.h"
+#include "eeprom.h"
+#include "../mt76x02_dma.h"
 
 static int
 mt76pci_load_rom_patch(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 22e66006a5f8..392601310e39 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -16,8 +16,8 @@
 
 #include <linux/delay.h>
 #include "mt76x2.h"
-#include "mt76x2_mcu.h"
-#include "mt76x2_eeprom.h"
+#include "mcu.h"
+#include "eeprom.h"
 
 static bool
 mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_trace.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_trace.c
similarity index 97%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_trace.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_trace.c
index a09f117848d6..ea4ab8729ae4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_trace.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_trace.c
@@ -18,6 +18,6 @@
 
 #ifndef __CHECKER__
 #define CREATE_TRACE_POINTS
-#include "mt76x2_trace.h"
+#include "trace.h"
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
index fcdf1879162e..69dc1f368f52 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
@@ -15,8 +15,8 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x02_util.h"
-#include "mt76x02_dma.h"
+#include "../mt76x02_util.h"
+#include "../mt76x02_dma.h"
 
 struct beacon_bc_data {
 	struct mt76x2_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index dd32e756d8b7..b3ecb80340b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -16,9 +16,9 @@
  */
 
 #include "mt76x2.h"
-#include "mt76x2_eeprom.h"
-#include "mt76x2_mcu.h"
-#include "mt76x02_phy.h"
+#include "eeprom.h"
+#include "mcu.h"
+#include "../mt76x02_phy.h"
 
 static void
 mt76x2_adjust_high_lna_gain(struct mt76x2_dev *dev, int reg, s8 offset)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
similarity index 98%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
rename to drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
index eb5afeaefa44..9dceabace936 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
@@ -139,6 +139,6 @@ TRACE_EVENT(dev_irq,
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
 #undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE mt76x2_trace
+#define TRACE_INCLUDE_FILE trace
 
 #include <trace/define_trace.h>
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
index 1ec3c293e2c4..aea142600042 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
@@ -16,7 +16,7 @@
  */
 
 #include "mt76x2.h"
-#include "dma.h"
+#include "../dma.h"
 
 void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index feb5cec66c67..b0c172107aae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -17,7 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include "mt76x02_usb.h"
+#include "../mt76x02_usb.h"
 #include "mt76x2u.h"
 
 static const struct usb_device_id mt76x2u_device_table[] = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c
similarity index 95%
rename from drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c
index c2ccdebca470..6eb7b28d102f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_core.c
@@ -15,9 +15,9 @@
  */
 
 #include "mt76x2u.h"
-#include "dma.h"
-#include "mt76x02_util.h"
-#include "mt76x02_usb.h"
+#include "../dma.h"
+#include "../mt76x02_util.h"
+#include "../mt76x02_usb.h"
 
 static int
 mt76x2u_check_skb_rooms(struct sk_buff *skb)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 5759a72d7ef6..55e0dea568b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -17,9 +17,9 @@
 #include <linux/delay.h>
 
 #include "mt76x2u.h"
-#include "mt76x02_util.h"
-#include "mt76x02_phy.h"
-#include "mt76x2_eeprom.h"
+#include "../mt76x02_util.h"
+#include "../mt76x02_phy.h"
+#include "eeprom.h"
 
 static void mt76x2u_init_dma(struct mt76x2_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
index f28c6fbcc305..ae89461f803c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
@@ -15,7 +15,7 @@
  */
 
 #include "mt76x2u.h"
-#include "mt76x2_eeprom.h"
+#include "eeprom.h"
 
 static void mt76x2u_mac_reset_counters(struct mt76x2_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index a80704568780..26f1c04ea448 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -15,7 +15,7 @@
  */
 
 #include "mt76x2u.h"
-#include "mt76x02_util.h"
+#include "../mt76x02_util.h"
 
 static int mt76x2u_start(struct ieee80211_hw *hw)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index fdd94cad7b66..35e157be456c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -17,8 +17,8 @@
 #include <linux/firmware.h>
 
 #include "mt76x2u.h"
-#include "mt76x2_eeprom.h"
-#include "mt76x02_usb.h"
+#include "eeprom.h"
+#include "../mt76x02_usb.h"
 
 #define MT_CMD_HDR_LEN			4
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
similarity index 99%
rename from drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
rename to drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index 06362d3487be..9dd1943a71bb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -15,7 +15,7 @@
  */
 
 #include "mt76x2u.h"
-#include "mt76x2_eeprom.h"
+#include "eeprom.h"
 
 void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev)
 {
-- 
2.19.0

