Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB11C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B57A2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B57A2172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbeI1NDA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:03:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52222 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbeI1NDA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:03:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id y25-v6so1044365wmi.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xuu33AYSGiH4x009+1RnxWnku5q+mkYdH4G7m7LYhmk=;
        b=ETt9qPQryk1ZhQlyXeekoQ28InKRlLyEl6WG2wYKPf6hfHo3mb946qO7HZ5FelpqAn
         j69X+r/HfYdDKR5HjKZP/TlxoCNquszMFGwGR9NCN/n0O0syJNVEyPWYCFnmetfdrQAi
         nl4nynOl2HeqUayu9JDqhuud3WFPHnKLDBBh7DnTVqIANJB2MbEGNC3pZfSIhfJ6csYw
         t+8uypU9r0/zJREMQ1BRQCqlAFK2qyhbUO4HKaC73bJBdN6r4Ifi2adMurT5phur+vtE
         se0chhdKDN39KKgd2985z0UlzAiO0ZjGhc9QucRGdcSb0GdbhRSNIiewFzhf0C78iO8/
         IImQ==
X-Gm-Message-State: ABuFfogybjieHJ5puDCIe4aDEEpcY+E56xnYV8TlLlUWgc2YO/8T/cTA
        1E0Ts+QnmYjy2r0sUBtctzQHqB5nWj8=
X-Google-Smtp-Source: ACcGV62ESomaDgvRrTXfO9PrSEXnqU0I1640zR91xibJDZQZ/ylIQhcKW7ZuUvjBRNCijODpmb0vHw==
X-Received: by 2002:a1c:6c0a:: with SMTP id h10-v6mr677938wmc.47.1538116845557;
        Thu, 27 Sep 2018 23:40:45 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:45 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 17/24] mt76x0: usb: move initialization code in usb.c
Date:   Fri, 28 Sep 2018 08:40:10 +0200
Message-Id: <20180928064017.26870-18-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move usb initialization code in mt76x0-usb module in
order to remove usb dependency from generic init code
(not completed yet). Moreover fix a memory leak in usb probe
if mt76x02_wait_for_mac fails

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  54 --------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   1 -
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 115 ++++++++++++++----
 3 files changed, 91 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index f5a1c5fb739c..fe3e64a47b5c 100644
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
@@ -381,12 +352,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
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
@@ -397,15 +362,6 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
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
@@ -437,10 +393,6 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
-	ret = mt76x0_init_hardware(dev);
-	if (ret)
-		return ret;
-
 	/* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
 	 * entry no. 1 like it does in the vendor driver.
 	 */
@@ -475,12 +427,6 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
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
index 66fcb90c1083..e2e23df1b40a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -130,7 +130,6 @@ struct mt76x0_dev *
 mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops);
 int mt76x0_init_hardware(struct mt76x0_dev *dev);
 int mt76x0_register_device(struct mt76x0_dev *dev);
-void mt76x0_cleanup(struct mt76x0_dev *dev);
 void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset);
 
 int mt76x0_mac_start(struct mt76x0_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 7ad4dacb7411..3ed2e1a89e3f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -49,6 +49,93 @@ static struct usb_device_id mt76x0_device_table[] = {
 	{ 0, }
 };
 
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
+static void mt76x0u_cleanup(struct mt76x0_dev *dev)
+{
+	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+	mt76x0_chip_onoff(dev, false, false);
+	mt76u_queues_deinit(&dev->mt76);
+	mt76u_mcu_deinit(&dev->mt76);
+}
+
+static int mt76x0u_register_device(struct mt76x0_dev *dev)
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
+
 static int mt76x0u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
@@ -98,32 +185,12 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
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
@@ -141,7 +208,7 @@ static void mt76x0_disconnect(struct usb_interface *usb_intf)
 		return;
 
 	ieee80211_unregister_hw(dev->mt76.hw);
-	mt76x0_cleanup(dev);
+	mt76x0u_cleanup(dev);
 
 	usb_set_intfdata(usb_intf, NULL);
 	usb_put_dev(interface_to_usbdev(usb_intf));
@@ -190,7 +257,7 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 
 	return 0;
 err:
-	mt76x0_cleanup(dev);
+	mt76x0u_cleanup(dev);
 	return ret;
 }
 
-- 
2.19.0

