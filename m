Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:29452 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2DCBlC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 21:41:02 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v2 1/4] rt2800: introduce wpdma_disable function
Date: Tue,  3 Apr 2012 03:40:47 +0200
Message-Id: <1333417250-24560-2-git-send-email-kubakici@wp.pl> (sfid-20120403_034110_193310_B6093D1B)
In-Reply-To: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
References: <1333417250-24560-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce wpdma_disable function to simplify the code.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   32 ++++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt2800lib.h |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   10 +--------
 3 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6c0a12e..8aee6d4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -295,6 +295,20 @@ int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_wait_wpdma_ready);
 
+void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+}
+EXPORT_SYMBOL_GPL(rt2800_disable_wpdma);
+
 static bool rt2800_check_firmware_crc(const u8 *data, const size_t len)
 {
 	u16 fw_crc;
@@ -436,10 +450,7 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	 * Disable DMA, will be reenabled later when enabling
 	 * the radio.
 	 */
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_disable_wpdma(rt2x00dev);
 
 	/*
 	 * Initialize firmware.
@@ -2717,13 +2728,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 	int ret;
 
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_disable_wpdma(rt2x00dev);
 
 	ret = rt2800_drv_init_registers(rt2x00dev);
 	if (ret)
@@ -3997,10 +4002,7 @@ void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_disable_wpdma(rt2x00dev);
 
 	/* Wait for DMA, ignore error */
 	rt2800_wait_wpdma_ready(rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 419e36c..18a0b67 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -208,5 +208,6 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			u8 buf_size);
 int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 		      struct survey_info *survey);
+void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev);
 
 #endif /* RT2800LIB_H */
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0397bbf..e499389 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -361,7 +361,6 @@ static void rt2800pci_clear_entry(struct queue_entry *entry)
 static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 {
 	struct queue_entry_priv_pci *entry_priv;
-	u32 reg;
 
 	/*
 	 * Initialize registers.
@@ -402,14 +401,7 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 				 rt2x00dev->rx[0].limit - 1);
 	rt2x00pci_register_write(rt2x00dev, RX_DRX_IDX, 0);
 
-	/*
-	 * Enable global DMA configuration
-	 */
-	rt2x00pci_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2x00pci_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+	rt2800_disable_wpdma(rt2x00dev);
 
 	rt2x00pci_register_write(rt2x00dev, DELAY_INT_CFG, 0);
 
-- 
1.7.7.6

