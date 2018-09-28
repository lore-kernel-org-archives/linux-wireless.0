Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9973DC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ADC62172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ADC62172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbeI1NDF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:03:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42921 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbeI1NDF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:03:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id b11-v6so5050730wru.9
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJ9BNfSJDWNGYrU3HEWDJQQ9OvApIBy7vg1qU0Ta0h4=;
        b=YSU/GKTZqtGYdxDtVhyDSwPH8kkujZ+PHremTOAotTdX1Q3evrg5h7GjhcWEMPT6mZ
         E+k92QsvGMUpWWTkW6/W0yW8CuB4iRHQH8O+q02TVL6Mkh1b2AOBc3ugDR+OGGKuNPhe
         KVTamZUYr0U1pDgwwirWnBjZDbWHGrb1yU4oQXAygfhVZfVYltDJG+c7SPOsdW9ZPU3T
         /FK1+y0Gka9u60mzTDOkg1AEZISJ0OR8+DUkUC7bC/1ryZ8h/NNbbjkaFx58Xf1k9LtN
         V5aUWW16a6VxqJ1ss0Vy16gYYXGlaw+/kWH9BmSxLSQlO3qx6m0Nzwt6zUJBtwa8eP4T
         kBQg==
X-Gm-Message-State: ABuFfoiaYJakMqhKlKnIxKnnO75yuZTLI2/zwyUhF9Gb/ED0GkpOEUeR
        7QC7aa32k+P8NDRm9vcS4MIrPA==
X-Google-Smtp-Source: ACcGV624O39/FKeTgTf+zVAIXmwS6UKzCHmiGcc6bcwiP7qtR9fDXHBUNtDNGUq1L0K4qLgs0z66Zw==
X-Received: by 2002:adf:9e06:: with SMTP id u6-v6mr10983182wre.51.1538116850084;
        Thu, 27 Sep 2018 23:40:50 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:49 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 21/24] mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature
Date:   Fri, 28 Sep 2018 08:40:14 +0200
Message-Id: <20180928064017.26870-22-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add ieee80211_ops ops pointer to mt76x0_alloc_device routine signature
in order to specify mac80211 callbacks and remove usb dependency from
mt76x0 generic code.
Move mt76x0_ops callbacks in usb module in order to remove leftover
usb dependency in mt76x0 generic code.
Introduce mt76x0e_ops mac80211 callbacks for pci code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 37 ++-------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 82 ++++---------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    | 16 +++-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 22 ++++-
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 80 +++++++++++++++++-
 6 files changed, 135 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index adeea0572c51..a3dcdf42f87a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -246,23 +246,13 @@ int mt76x0_mac_start(struct mt76x0_dev *dev)
 
 	return !mt76x02_wait_for_wpdma(&dev->mt76, 50) ? -ETIMEDOUT : 0;
 }
+EXPORT_SYMBOL_GPL(mt76x0_mac_start);
 
-static void mt76x0_mac_stop_hw(struct mt76x0_dev *dev)
+void mt76x0_mac_stop(struct mt76x0_dev *dev)
 {
-	int i, ok;
-
-	if (test_bit(MT76_REMOVED, &dev->mt76.state))
-		return;
-
-	mt76_clear(dev, MT_BEACON_TIME_CFG, MT_BEACON_TIME_CFG_TIMER_EN |
-		   MT_BEACON_TIME_CFG_SYNC_MODE | MT_BEACON_TIME_CFG_TBTT_EN |
-		   MT_BEACON_TIME_CFG_BEACON_TX);
-
-	if (!mt76_poll(dev, MT_USB_DMA_CFG, MT_USB_DMA_CFG_TX_BUSY, 0, 1000))
-		dev_warn(dev->mt76.dev, "Warning: TX DMA did not stop!\n");
+	int i = 200, ok = 0;
 
 	/* Page count on TxQ */
-	i = 200;
 	while (i-- && ((mt76_rr(dev, 0x0438) & 0xffffffff) ||
 		       (mt76_rr(dev, 0x0a30) & 0x000000ff) ||
 		       (mt76_rr(dev, 0x0a34) & 0x00ff00ff)))
@@ -275,9 +265,7 @@ static void mt76x0_mac_stop_hw(struct mt76x0_dev *dev)
 					 MT_MAC_SYS_CTRL_ENABLE_TX);
 
 	/* Page count on RxQ */
-	ok = 0;
-	i = 200;
-	while (i--) {
+	for (i = 0; i < 200; i++) {
 		if (!(mt76_rr(dev, MT_RXQ_STA) & 0x00ff0000) &&
 		    !mt76_rr(dev, 0x0a30) &&
 		    !mt76_rr(dev, 0x0a34)) {
@@ -290,17 +278,6 @@ static void mt76x0_mac_stop_hw(struct mt76x0_dev *dev)
 
 	if (!mt76_poll(dev, MT_MAC_STATUS, MT_MAC_STATUS_RX, 0, 1000))
 		dev_warn(dev->mt76.dev, "Warning: MAC RX did not stop!\n");
-
-	if (!mt76_poll(dev, MT_USB_DMA_CFG, MT_USB_DMA_CFG_RX_BUSY, 0, 1000))
-		dev_warn(dev->mt76.dev, "Warning: RX DMA did not stop!\n");
-}
-
-void mt76x0_mac_stop(struct mt76x0_dev *dev)
-{
-	cancel_delayed_work_sync(&dev->cal_work);
-	cancel_delayed_work_sync(&dev->mac_work);
-	mt76u_stop_stat_wk(&dev->mt76);
-	mt76x0_mac_stop_hw(dev);
 }
 EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
 
@@ -359,12 +336,14 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 EXPORT_SYMBOL_GPL(mt76x0_init_hardware);
 
 struct mt76x0_dev *
-mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops)
+mt76x0_alloc_device(struct device *pdev,
+		    const struct mt76_driver_ops *drv_ops,
+		    const struct ieee80211_ops *ops)
 {
 	struct mt76x0_dev *dev;
 	struct mt76_dev *mdev;
 
-	mdev = mt76_alloc_device(sizeof(*dev), &mt76x0_ops);
+	mdev = mt76_alloc_device(sizeof(*dev), ops);
 	if (!mdev)
 		return NULL;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index e0fc691ce78e..c3cea52ec0dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -18,42 +18,7 @@
 #include "../mt76x02_util.h"
 #include <linux/etherdevice.h>
 
-static int mt76x0_start(struct ieee80211_hw *hw)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	int ret;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	ret = mt76x0_mac_start(dev);
-	if (ret)
-		goto out;
-
-	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
-				     MT_CALIBRATE_INTERVAL);
-	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
-				     MT_CALIBRATE_INTERVAL);
-
-	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
-
-out:
-	mutex_unlock(&dev->mt76.mutex);
-	return ret;
-}
-
-static void mt76x0_stop(struct ieee80211_hw *hw)
-{
-	struct mt76x0_dev *dev = hw->priv;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
-	mt76x0_mac_stop(dev);
-
-	mutex_unlock(&dev->mt76.mutex);
-}
-
-static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
+int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct mt76x0_dev *dev = hw->priv;
 	int ret = 0;
@@ -86,6 +51,7 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mt76x0_config);
 
 static void
 mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr)
@@ -94,9 +60,9 @@ mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr)
 	mt76_wr(dev, offset + 4, addr[4] | addr[5] << 8);
 }
 
-static void
-mt76x0_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			 struct ieee80211_bss_conf *info, u32 changed)
+void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_bss_conf *info, u32 changed)
 {
 	struct mt76x0_dev *dev = hw->priv;
 
@@ -146,11 +112,10 @@ mt76x0_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_unlock(&dev->mt76.mutex);
 }
+EXPORT_SYMBOL_GPL(mt76x0_bss_info_changed);
 
-static void
-mt76x0_sw_scan(struct ieee80211_hw *hw,
-		struct ieee80211_vif *vif,
-		const u8 *mac_addr)
+void mt76x0_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		    const u8 *mac_addr)
 {
 	struct mt76x0_dev *dev = hw->priv;
 
@@ -158,10 +123,10 @@ mt76x0_sw_scan(struct ieee80211_hw *hw,
 	mt76x0_agc_save(dev);
 	set_bit(MT76_SCANNING, &dev->mt76.state);
 }
+EXPORT_SYMBOL_GPL(mt76x0_sw_scan);
 
-static void
-mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
-			 struct ieee80211_vif *vif)
+void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif)
 {
 	struct mt76x0_dev *dev = hw->priv;
 
@@ -171,8 +136,9 @@ mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 }
+EXPORT_SYMBOL_GPL(mt76x0_sw_scan_complete);
 
-static int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct mt76x0_dev *dev = hw->priv;
 
@@ -180,24 +146,4 @@ static int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 	return 0;
 }
-
-const struct ieee80211_ops mt76x0_ops = {
-	.tx = mt76x0_tx,
-	.start = mt76x0_start,
-	.stop = mt76x0_stop,
-	.add_interface = mt76x02_add_interface,
-	.remove_interface = mt76x02_remove_interface,
-	.config = mt76x0_config,
-	.configure_filter = mt76x02_configure_filter,
-	.bss_info_changed = mt76x0_bss_info_changed,
-	.sta_add = mt76x02_sta_add,
-	.sta_remove = mt76x02_sta_remove,
-	.set_key = mt76x02_set_key,
-	.conf_tx = mt76x02_conf_tx,
-	.sw_scan_start = mt76x0_sw_scan,
-	.sw_scan_complete = mt76x0_sw_scan_complete,
-	.ampdu_action = mt76x02_ampdu_action,
-	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
-	.set_rts_threshold = mt76x0_set_rts_threshold,
-	.wake_tx_queue = mt76_wake_tx_queue,
-};
+EXPORT_SYMBOL_GPL(mt76x0_set_rts_threshold);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 08e081e32852..2a7dfbd9e84d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -110,8 +110,6 @@ struct mt76x0_dev {
 	struct mac_stats stats;
 };
 
-extern const struct ieee80211_ops mt76x0_ops;
-
 static inline bool is_mt7610e(struct mt76x0_dev *dev)
 {
 	/* TODO */
@@ -126,7 +124,9 @@ void mt76x0_init_debugfs(struct mt76x0_dev *dev);
 
 /* Init */
 struct mt76x0_dev *
-mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops);
+mt76x0_alloc_device(struct device *pdev,
+		    const struct mt76_driver_ops *drv_ops,
+		    const struct ieee80211_ops *ops);
 int mt76x0_init_hardware(struct mt76x0_dev *dev);
 int mt76x0_register_device(struct mt76x0_dev *dev);
 void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset);
@@ -134,6 +134,16 @@ void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset);
 int mt76x0_mac_start(struct mt76x0_dev *dev);
 void mt76x0_mac_stop(struct mt76x0_dev *dev);
 
+int mt76x0_config(struct ieee80211_hw *hw, u32 changed);
+void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_bss_conf *info, u32 changed);
+void mt76x0_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		    const u8 *mac_addr);
+void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif);
+int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
+
 /* PHY */
 void mt76x0_phy_init(struct mt76x0_dev *dev);
 int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 79db75811458..8c020aaf1f0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -21,6 +21,26 @@
 #include "mt76x0.h"
 #include "mcu.h"
 #include "../mt76x02_dma.h"
+#include "../mt76x02_util.h"
+
+static int mt76x0e_start(struct ieee80211_hw *hw)
+{
+	return 0;
+}
+
+static void mt76x0e_stop(struct ieee80211_hw *hw)
+{
+}
+
+static const struct ieee80211_ops mt76x0e_ops = {
+	.tx = mt76x0_tx,
+	.start = mt76x0e_start,
+	.stop = mt76x0e_stop,
+	.config = mt76x0_config,
+	.add_interface = mt76x02_add_interface,
+	.remove_interface = mt76x02_remove_interface,
+	.configure_filter = mt76x02_configure_filter,
+};
 
 static int mt76x0e_register_device(struct mt76x0_dev *dev)
 {
@@ -86,7 +106,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
-	dev = mt76x0_alloc_device(&pdev->dev, NULL);
+	dev = mt76x0_alloc_device(&pdev->dev, NULL, &mt76x0e_ops);
 	if (!dev)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index c6d8ba01feb1..36148518cdf7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -81,6 +81,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 
 	mt76_tx(&dev->mt76, control->sta, wcid, skb);
 }
+EXPORT_SYMBOL_GPL(mt76x0_tx);
 
 int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			  struct sk_buff *skb, struct mt76_queue *q,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 3ed2e1a89e3f..0cd46a48c5bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -84,6 +84,81 @@ static void mt76x0u_cleanup(struct mt76x0_dev *dev)
 	mt76u_mcu_deinit(&dev->mt76);
 }
 
+static void mt76x0u_mac_stop(struct mt76x0_dev *dev)
+{
+	if (test_bit(MT76_REMOVED, &dev->mt76.state))
+		return;
+
+	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	cancel_delayed_work_sync(&dev->cal_work);
+	cancel_delayed_work_sync(&dev->mac_work);
+	mt76u_stop_stat_wk(&dev->mt76);
+
+	mt76_clear(dev, MT_BEACON_TIME_CFG, MT_BEACON_TIME_CFG_TIMER_EN |
+		   MT_BEACON_TIME_CFG_SYNC_MODE | MT_BEACON_TIME_CFG_TBTT_EN |
+		   MT_BEACON_TIME_CFG_BEACON_TX);
+
+	if (!mt76_poll(dev, MT_USB_DMA_CFG, MT_USB_DMA_CFG_TX_BUSY, 0, 1000))
+		dev_warn(dev->mt76.dev, "TX DMA did not stop\n");
+
+	mt76x0_mac_stop(dev);
+
+	if (!mt76_poll(dev, MT_USB_DMA_CFG, MT_USB_DMA_CFG_RX_BUSY, 0, 1000))
+		dev_warn(dev->mt76.dev, "RX DMA did not stop\n");
+}
+
+static int mt76x0u_start(struct ieee80211_hw *hw)
+{
+	struct mt76x0_dev *dev = hw->priv;
+	int ret;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	ret = mt76x0_mac_start(dev);
+	if (ret)
+		goto out;
+
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
+				     MT_CALIBRATE_INTERVAL);
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+
+out:
+	mutex_unlock(&dev->mt76.mutex);
+	return ret;
+}
+
+static void mt76x0u_stop(struct ieee80211_hw *hw)
+{
+	struct mt76x0_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+	mt76x0u_mac_stop(dev);
+	mutex_unlock(&dev->mt76.mutex);
+}
+
+static const struct ieee80211_ops mt76x0u_ops = {
+	.tx = mt76x0_tx,
+	.start = mt76x0u_start,
+	.stop = mt76x0u_stop,
+	.add_interface = mt76x02_add_interface,
+	.remove_interface = mt76x02_remove_interface,
+	.config = mt76x0_config,
+	.configure_filter = mt76x02_configure_filter,
+	.bss_info_changed = mt76x0_bss_info_changed,
+	.sta_add = mt76x02_sta_add,
+	.sta_remove = mt76x02_sta_remove,
+	.set_key = mt76x02_set_key,
+	.conf_tx = mt76x02_conf_tx,
+	.sw_scan_start = mt76x0_sw_scan,
+	.sw_scan_complete = mt76x0_sw_scan_complete,
+	.ampdu_action = mt76x02_ampdu_action,
+	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
+	.set_rts_threshold = mt76x0_set_rts_threshold,
+	.wake_tx_queue = mt76_wake_tx_queue,
+};
+
 static int mt76x0u_register_device(struct mt76x0_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->mt76.hw;
@@ -150,7 +225,8 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	u32 asic_rev, mac_rev;
 	int ret;
 
-	dev = mt76x0_alloc_device(&usb_intf->dev, &drv_ops);
+	dev = mt76x0_alloc_device(&usb_intf->dev, &drv_ops,
+				  &mt76x0u_ops);
 	if (!dev)
 		return -ENOMEM;
 
@@ -223,7 +299,7 @@ static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
 	struct mt76_usb *usb = &dev->mt76.usb;
 
 	mt76u_stop_queues(&dev->mt76);
-	mt76x0_mac_stop(dev);
+	mt76x0u_mac_stop(dev);
 	usb_kill_urb(usb->mcu.res.urb);
 
 	return 0;
-- 
2.19.0

