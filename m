Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:65248 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752560AbZL3Kgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 05:36:53 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Wireless list <linux-wireless@vger.kernel.org>,
	rt2x00 users list <users@rt2x00.serialmonkey.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/6] rt2x00: Unify rt2800 WPDMA ready waiting functions.
Date: Wed, 30 Dec 2009 11:36:32 +0100
Message-Id: <1262169394-11647-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1262169394-11647-4-git-send-email-gwingerde@gmail.com>
References: <1262169394-11647-1-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-2-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-3-git-send-email-gwingerde@gmail.com>
 <1262169394-11647-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2800pci_wait_wpdma_ready and rt2800usb_wait_wpdma_ready functions are
exactly the same, so unify them into rt200lib.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   19 +++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   24 +++---------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   22 ++--------------------
 4 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bcb7e17..9a02589 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -245,6 +245,25 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2800_mcu_request);
 
+int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+	u32 reg;
+
+	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+		if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
+		    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
+			return 0;
+
+		msleep(1);
+	}
+
+	ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
+	return -EACCES;
+}
+EXPORT_SYMBOL_GPL(rt2800_wait_wpdma_ready);
+
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 const struct rt2x00debug rt2800_rt2x00debug = {
 	.owner	= THIS_MODULE,
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 535ce22..9adb343 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -139,6 +139,7 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 int rt2800_init_registers(struct rt2x00_dev *rt2x00dev);
 int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev);
 int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev);
+int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev);
 void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b93eabb..daea0b7 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -453,24 +453,6 @@ static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2800_register_write(rt2x00dev, INT_MASK_CSR, reg);
 }
 
-static int rt2800pci_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u32 reg;
-
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-		if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
-		    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
-			return 0;
-
-		msleep(1);
-	}
-
-	ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
-	return -EACCES;
-}
-
 static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -479,10 +461,10 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all registers.
 	 */
-	if (unlikely(rt2800pci_wait_wpdma_ready(rt2x00dev) ||
+	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
 		     rt2800pci_init_queues(rt2x00dev) ||
 		     rt2800_init_registers(rt2x00dev) ||
-		     rt2800pci_wait_wpdma_ready(rt2x00dev) ||
+		     rt2800_wait_wpdma_ready(rt2x00dev) ||
 		     rt2800_init_bbp(rt2x00dev) ||
 		     rt2800_init_rfcsr(rt2x00dev)))
 		return -EIO;
@@ -562,7 +544,7 @@ static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
 
 	/* Wait for DMA, ignore error */
-	rt2800pci_wait_wpdma_ready(rt2x00dev);
+	rt2800_wait_wpdma_ready(rt2x00dev);
 }
 
 static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 411655e..80b49a8 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -248,24 +248,6 @@ static void rt2800usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
 }
 
-static int rt2800usb_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	u32 reg;
-
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-		if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
-		    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
-			return 0;
-
-		msleep(1);
-	}
-
-	ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
-	return -EACCES;
-}
-
 static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -274,7 +256,7 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize all registers.
 	 */
-	if (unlikely(rt2800usb_wait_wpdma_ready(rt2x00dev) ||
+	if (unlikely(rt2800_wait_wpdma_ready(rt2x00dev) ||
 		     rt2800_init_registers(rt2x00dev) ||
 		     rt2800_init_bbp(rt2x00dev) ||
 		     rt2800_init_rfcsr(rt2x00dev)))
@@ -344,7 +326,7 @@ static void rt2800usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
 
 	/* Wait for DMA, ignore error */
-	rt2800usb_wait_wpdma_ready(rt2x00dev);
+	rt2800_wait_wpdma_ready(rt2x00dev);
 
 	rt2x00usb_disable_radio(rt2x00dev);
 }
-- 
1.6.6

