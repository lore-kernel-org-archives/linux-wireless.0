Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55040 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1AJK2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 05:28:53 -0500
Received: by fxm20 with SMTP id 20so18677090fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 02:28:52 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] rt2x00: Fix radio off hang issue for PCIE interface
Date: Mon, 10 Jan 2011 11:27:43 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101101127.45155.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <jay_hung@ralinktech.com>

PCI/PCIE radio off behavior is different from SOC/USB.
They mainly use MCU command to disable DMA, TX/RX and enter power saving mode.

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 -----
 drivers/net/wireless/rt2x00/rt2800pci.c |   36 ++++++++----------------------
 2 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 54917a2..e2a528d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2810,10 +2810,7 @@ void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
 	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
 	/* Wait for DMA, ignore error */
@@ -2823,9 +2820,6 @@ void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 0);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-	rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
 }
 EXPORT_SYMBOL_GPL(rt2800_disable_radio);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index aa97971..bfc2fc5 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -475,39 +475,23 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
-
-	rt2800_disable_radio(rt2x00dev);
-
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001280);
-
-	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
-
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+	if (rt2x00_is_soc(rt2x00dev)) {
+		rt2800_disable_radio(rt2x00dev);
+		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
+		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
+	}
 }
 
 static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
-	/*
-	 * Always put the device to sleep (even when we intend to wakeup!)
-	 * if the device is booting and wasn't asleep it will return
-	 * failure when attempting to wakeup.
-	 */
-	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0xff, 2);
-
 	if (state == STATE_AWAKE) {
-		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0);
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0x02);
 		rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
+	} else if (state == STATE_SLEEP) {
+		rt2800_register_write(rt2x00dev, H2M_MAILBOX_STATUS, 0xffffffff);
+		rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, 0xffffffff);
+		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0x01, 0xff, 0x01);
 	}
 
 	return 0;
-- 
1.7.2.3

