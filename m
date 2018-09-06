Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNy5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 33/42] mt76x0: move mt76x0_init_hardware in mt76x0_register_device
Date: Thu,  6 Sep 2018 11:18:49 +0200
Message-Id: <1536225538-16454-34-git-send-email-sgruszka@redhat.com> (sfid-20180906_112033_675491_198F927F)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Move mt76x0_init_hardware routine in mt76x0_register_device
during hw probe. This is a preliminary patch to avoid {tx/rx}
buffer allocation during resume/suspend

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 55 ++++++++++--------------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c  |  8 ++--
 2 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index b1d5f647eac5..deceece52492 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -382,27 +382,21 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 	mt76x0_chip_onoff(dev, true, true);
 
-	if (!mt76x02_wait_for_mac(&dev->mt76)) {
-		ret = -ETIMEDOUT;
-		goto err;
-	}
+	if (!mt76x02_wait_for_mac(&dev->mt76))
+		return -ETIMEDOUT;
 
 	ret = mt76x0_mcu_init(dev);
 	if (ret)
-		goto err;
+		return ret;
 
 	if (!mt76_poll_msec(dev, MT_WPDMA_GLO_CFG,
 			    MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
-			    MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 100)) {
-		ret = -EIO;
-		goto err;
-	}
+			    MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 100))
+		return -EIO;
 
 	/* Wait for ASIC ready after FW load. */
-	if (!mt76x02_wait_for_mac(&dev->mt76)) {
-		ret = -ETIMEDOUT;
-		goto err;
-	}
+	if (!mt76x02_wait_for_mac(&dev->mt76))
+		return -ETIMEDOUT;
 
 	mt76x0_reset_csr_bbp(dev);
 	mt76x0_init_usb_dma(dev);
@@ -412,33 +406,33 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 	ret = mt76x0_mcu_cmd_init(dev);
 	if (ret)
-		goto err;
+		return ret;
 
 	ret = mt76u_alloc_queues(&dev->mt76);
 	if (ret < 0)
-		goto err_mcu;
+		return ret;
 
 	mt76x0_init_mac_registers(dev);
 
 	if (!mt76_poll_msec(dev, MT_MAC_STATUS,
-			    MT_MAC_STATUS_TX | MT_MAC_STATUS_RX, 0, 1000)) {
-		ret = -EIO;
-		goto err_rx;
-	}
+			    MT_MAC_STATUS_TX | MT_MAC_STATUS_RX, 0, 1000))
+		return -EIO;
 
 	ret = mt76x0_init_bbp(dev);
 	if (ret)
-		goto err_rx;
+		return ret;
 
 	ret = mt76x0_init_wcid_mem(dev);
 	if (ret)
-		goto err_rx;
+		return ret;
+
 	ret = mt76x0_init_key_mem(dev);
 	if (ret)
-		goto err_rx;
+		return ret;
+
 	ret = mt76x0_init_wcid_attr_mem(dev);
 	if (ret)
-		goto err_rx;
+		return ret;
 
 	mt76_clear(dev, MT_BEACON_TIME_CFG, (MT_BEACON_TIME_CFG_TIMER_EN |
 					     MT_BEACON_TIME_CFG_SYNC_MODE |
@@ -455,18 +449,11 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 	ret = mt76x0_eeprom_init(dev);
 	if (ret)
-		goto err_rx;
+		return ret;
 
 	mt76x0_phy_init(dev);
-	return 0;
 
-err_rx:
-	mt76u_queues_deinit(&dev->mt76);
-err_mcu:
-	mt76u_mcu_deinit(&dev->mt76);
-err:
-	mt76x0_chip_onoff(dev, false, false);
-	return ret;
+	return 0;
 }
 
 void mt76x0_cleanup(struct mt76x0_dev *dev)
@@ -627,6 +614,10 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
+	ret = mt76x0_init_hardware(dev);
+	if (ret)
+		return ret;
+
 	/* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
 	 * entry no. 1 like it does in the vendor driver.
 	 */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 219524c233ee..09b544890450 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -90,10 +90,6 @@ static int mt76x0_probe(struct usb_interface *usb_intf,
 	if (!(mt76_rr(dev, MT_EFUSE_CTRL) & MT_EFUSE_CTRL_SEL))
 		dev_warn(dev->mt76.dev, "Warning: eFUSE not present\n");
 
-	ret = mt76x0_init_hardware(dev);
-	if (ret)
-		goto err;
-
 	ret = mt76x0_register_device(dev);
 	if (ret)
 		goto err_hw;
@@ -143,8 +139,10 @@ static int mt76x0_resume(struct usb_interface *usb_intf)
 	int ret;
 
 	ret = mt76x0_init_hardware(dev);
-	if (ret)
+	if (ret) {
+		mt76x0_cleanup(dev);
 		return ret;
+	}
 
 	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
 
-- 
2.7.5
