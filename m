Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0F5C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 256F52156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 256F52156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbeI0PTf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43856 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeI0PTe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id z14-v6so1680414wrs.10
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0WcyMbv0awbJ26H4edAGsO0WsCVDrxkXg4uTHAUbx4k=;
        b=GBeNWl8M0F8vPaPX9+76CM8fBWhws2tiUIa4XaVKiPcGEJH8de1RlCJm7+YVDFb+qR
         vwbLoJ9cMfKKObbU9t2G/P6EDpj9nixgf8MGxB9u4IMHvIQCyIrAmEW3oP+dYImoPmZq
         /6usKEi/yWNMJvB/IQn1iEXA3VVTbVZSBYJks57C3XlmCnWH9X76ClHnBm/PJzvvuf37
         HOv6Ip5jOB3Oygg4TtEz9vQDOKXNuRulHGjrRQRDj7U0tTbhAt8UT47MGpT5RVCYSd7N
         o8noz6maIzrdz1kjIREKVr9DfU3HscJk2gBwUWcAVu5dCgW1Ctukr2rm4U58iJm4cS5W
         9gTQ==
X-Gm-Message-State: ABuFfoiWzsHHuAhSwu1zxM986gLpuQPjOgKZWzcV3bRHMf+ZTeIfiIH5
        P4P47hyLiU7vOiahN+srgP49ayrZQjw=
X-Google-Smtp-Source: ACcGV61tXs5O4RGYyNzyM8hPlUjxTO9bl0JL8uFhBbXzSdimBlxd9L+a/WuXX2KOIt21xkYDgPTzJQ==
X-Received: by 2002:adf:f5ce:: with SMTP id k14-v6mr8115974wrp.59.1538038939433;
        Thu, 27 Sep 2018 02:02:19 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:18 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 18/26] mt76x0: usb: move initialization code in usb_init.c
Date:   Thu, 27 Sep 2018 11:01:47 +0200
Message-Id: <e60a1a27c87f19714279b9fa023f1e5da9ff5ee7.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move usb initialization code in a mt76x0 module in
order to remove usb dependency from generic init code
(not completed yet). Moreover fix a memory leak in usb probe
if mt76x02_wait_for_mac fails

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/Makefile    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  54 ---------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  28 +----
 .../wireless/mediatek/mt76/mt76x0/usb_init.c  | 107 ++++++++++++++++++
 5 files changed, 115 insertions(+), 80 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index 254d94efd24d..30c84a557076 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_MT76x0_COMMON) += mt76x0-common.o
 mt76x0-common-y := \
 	init.o main.o trace.o eeprom.o phy.o \
 	mac.o debugfs.o tx.o
-mt76x0u-y := usb.o usb_mcu.o
+mt76x0u-y := usb.o usb_mcu.o usb_init.o
 mt76x0e-y := pci.o pci_mcu.o
 
 # ccflags-y := -DDEBUG
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index a5529616cb8d..3426ec385380 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -109,33 +109,6 @@ static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
 	msleep(200);
 }
 
-static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
-{
-	u32 val;
-
-	val = mt76_rr(dev, MT_USB_DMA_CFG);
-
-	val |= MT_USB_DMA_CFG_RX_BULK_EN |
-	       MT_USB_DMA_CFG_TX_BULK_EN;
-
-	/* disable AGGR_BULK_RX in order to receive one
-	 * frame in each rx urb and avoid copies
-	 */
-	val &= ~MT_USB_DMA_CFG_RX_BULK_AGG_EN;
-	mt76_wr(dev, MT_USB_DMA_CFG, val);
-
-	val = mt76_rr(dev, MT_COM_REG0);
-	if (val & 1)
-		dev_dbg(dev->mt76.dev, "MCU not ready\n");
-
-	val = mt76_rr(dev, MT_USB_DMA_CFG);
-
-	val |= MT_USB_DMA_CFG_RX_DROP_OR_PAD;
-	mt76_wr(dev, MT_USB_DMA_CFG, val);
-	val &= ~MT_USB_DMA_CFG_RX_DROP_OR_PAD;
-	mt76_wr(dev, MT_USB_DMA_CFG, val);
-}
-
 #define RANDOM_WRITE(dev, tab)			\
 	mt76_wr_rp(dev, MT_MCU_MEMMAP_WLAN,	\
 		   tab, ARRAY_SIZE(tab))
@@ -347,8 +320,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 		return -ETIMEDOUT;
 
 	mt76x0_reset_csr_bbp(dev);
-	mt76x0_init_usb_dma(dev);
-
 	ret = mt76x02_mcu_function_select(&dev->mt76, Q_SELECT, 1, false);
 	if (ret)
 		return ret;
@@ -387,12 +358,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 	mt76x0_reset_counters(dev);
 
-	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
-
-	mt76_wr(dev, MT_TXOP_CTRL_CFG,
-		   FIELD_PREP(MT_TXOP_TRUN_EN, 0x3f) |
-		   FIELD_PREP(MT_TXOP_EXT_CCA_DLY, 0x58));
-
 	ret = mt76x0_eeprom_init(dev);
 	if (ret)
 		return ret;
@@ -403,15 +368,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x0_init_hardware);
 
-void mt76x0_cleanup(struct mt76x0_dev *dev)
-{
-	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
-	mt76x0_chip_onoff(dev, false, false);
-	mt76u_queues_deinit(&dev->mt76);
-	mt76u_mcu_deinit(&dev->mt76);
-}
-EXPORT_SYMBOL_GPL(mt76x0_cleanup);
-
 struct mt76x0_dev *
 mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops)
 {
@@ -443,10 +399,6 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
-	ret = mt76x0_init_hardware(dev);
-	if (ret)
-		return ret;
-
 	/* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
 	 * entry no. 1 like it does in the vendor driver.
 	 */
@@ -481,12 +433,6 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	if (mdev->cap.has_5ghz)
 		mt76x0_vht_cap_mask(&dev->mt76.sband_5g.sband);
 
-	/* check hw sg support in order to enable AMSDU */
-	if (mt76u_check_sg(mdev))
-		hw->max_tx_fragments = MT_SG_MAX_SIZE;
-	else
-		hw->max_tx_fragments = 1;
-
 	mt76x0_init_debugfs(dev);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 18fb763d6168..70bb2f3af90b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -130,12 +130,14 @@ struct mt76x0_dev *
 mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops);
 int mt76x0_init_hardware(struct mt76x0_dev *dev);
 int mt76x0_register_device(struct mt76x0_dev *dev);
-void mt76x0_cleanup(struct mt76x0_dev *dev);
 void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset);
 
 int mt76x0_mac_start(struct mt76x0_dev *dev);
 void mt76x0_mac_stop(struct mt76x0_dev *dev);
 
+void mt76x0u_cleanup(struct mt76x0_dev *dev);
+int mt76x0u_register_device(struct mt76x0_dev *dev);
+
 /* PHY */
 void mt76x0_phy_init(struct mt76x0_dev *dev);
 int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 7ad4dacb7411..04bf3a65f889 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -98,32 +98,12 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	if (!(mt76_rr(dev, MT_EFUSE_CTRL) & MT_EFUSE_CTRL_SEL))
 		dev_warn(dev->mt76.dev, "Warning: eFUSE not present\n");
 
-	ret = mt76u_alloc_queues(&dev->mt76);
+	ret = mt76x0u_register_device(dev);
 	if (ret < 0)
 		goto err;
 
-	ret = mt76u_mcu_init_rx(&dev->mt76);
-	if (ret < 0)
-		goto err;
-
-	mt76x0_chip_onoff(dev, true, true);
-
-	if (!mt76x02_wait_for_mac(&dev->mt76))
-		return -ETIMEDOUT;
-
-	ret = mt76x0u_mcu_init(dev);
-	if (ret)
-		goto err_hw;
-
-	ret = mt76x0_register_device(dev);
-	if (ret)
-		goto err_hw;
-
-	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
-
 	return 0;
-err_hw:
-	mt76x0_cleanup(dev);
+
 err:
 	usb_set_intfdata(usb_intf, NULL);
 	usb_put_dev(interface_to_usbdev(usb_intf));
@@ -141,7 +121,7 @@ static void mt76x0_disconnect(struct usb_interface *usb_intf)
 		return;
 
 	ieee80211_unregister_hw(dev->mt76.hw);
-	mt76x0_cleanup(dev);
+	mt76x0u_cleanup(dev);
 
 	usb_set_intfdata(usb_intf, NULL);
 	usb_put_dev(interface_to_usbdev(usb_intf));
@@ -190,7 +170,7 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 
 	return 0;
 err:
-	mt76x0_cleanup(dev);
+	mt76x0u_cleanup(dev);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c
new file mode 100644
index 000000000000..3d5413ea0f22
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_init.c
@@ -0,0 +1,107 @@
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
+
+static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
+{
+	u32 val;
+
+	val = mt76_rr(dev, MT_USB_DMA_CFG);
+
+	val |= MT_USB_DMA_CFG_RX_BULK_EN |
+	       MT_USB_DMA_CFG_TX_BULK_EN;
+
+	/* disable AGGR_BULK_RX in order to receive one
+	 * frame in each rx urb and avoid copies
+	 */
+	val &= ~MT_USB_DMA_CFG_RX_BULK_AGG_EN;
+	mt76_wr(dev, MT_USB_DMA_CFG, val);
+
+	val = mt76_rr(dev, MT_COM_REG0);
+	if (val & 1)
+		dev_dbg(dev->mt76.dev, "MCU not ready\n");
+
+	val = mt76_rr(dev, MT_USB_DMA_CFG);
+
+	val |= MT_USB_DMA_CFG_RX_DROP_OR_PAD;
+	mt76_wr(dev, MT_USB_DMA_CFG, val);
+	val &= ~MT_USB_DMA_CFG_RX_DROP_OR_PAD;
+	mt76_wr(dev, MT_USB_DMA_CFG, val);
+}
+
+void mt76x0u_cleanup(struct mt76x0_dev *dev)
+{
+	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+	mt76x0_chip_onoff(dev, false, false);
+	mt76u_queues_deinit(&dev->mt76);
+	mt76u_mcu_deinit(&dev->mt76);
+}
+
+int mt76x0u_register_device(struct mt76x0_dev *dev)
+{
+	struct ieee80211_hw *hw = dev->mt76.hw;
+	int err;
+
+	err = mt76u_mcu_init_rx(&dev->mt76);
+	if (err < 0)
+		return err;
+
+	err = mt76u_alloc_queues(&dev->mt76);
+	if (err < 0)
+		return err;
+
+	mt76x0_chip_onoff(dev, true, true);
+	if (!mt76x02_wait_for_mac(&dev->mt76)) {
+		err = -ETIMEDOUT;
+		goto err;
+	}
+
+	err = mt76x0u_mcu_init(dev);
+	if (err < 0)
+		goto err;
+
+	mt76x0_init_usb_dma(dev);
+	err = mt76x0_init_hardware(dev);
+	if (err < 0)
+		goto err;
+
+	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
+	mt76_wr(dev, MT_TXOP_CTRL_CFG,
+		FIELD_PREP(MT_TXOP_TRUN_EN, 0x3f) |
+		FIELD_PREP(MT_TXOP_EXT_CCA_DLY, 0x58));
+
+	err = mt76x0_register_device(dev);
+	if (err < 0)
+		goto err;
+
+	/* check hw sg support in order to enable AMSDU */
+	if (mt76u_check_sg(&dev->mt76))
+		hw->max_tx_fragments = MT_SG_MAX_SIZE;
+	else
+		hw->max_tx_fragments = 1;
+
+	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+
+	return 0;
+
+err:
+	mt76x0u_cleanup(dev);
+	return err;
+}
-- 
2.17.1

