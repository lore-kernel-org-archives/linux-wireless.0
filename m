Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:34662 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752224AbdLVTdy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 14:33:54 -0500
Received: by mail-wr0-f169.google.com with SMTP id y21so28756010wrc.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Dec 2017 11:33:53 -0800 (PST)
Date: Fri, 22 Dec 2017 20:33:49 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: linux-wireless@vger.kernel.org
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: mt76x0 support
Message-ID: <alpine.LNX.2.21.99.1712222018070.2576@localhost.localdomain> (sfid-20171222_203358_862450_06C1F6E2)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Felix, Stanislaw, linux-wireless list, and everybody reading this message.
So I am trying to see if it's possible to get an MT7630 device to a "workable" state.

So I used this
https://github.com/neurobin/MT7630E
as a reference, the MT7601u to look how things where done (upstream version in drivers/net/wireless/mediatek/mt7601u ).

Here is the diff I came up with. The diff is relative to mt76.git. Any idea and / or hint would be greatly apreciated.

I have some difficulties in understanding how to access the EEPROM to read e.g.: the MAC address and other data if needed (calibration etc).
The device is on a MIPS device, so unfortunately I will have to test my code there, since opening up the device and desoldering / removing the card is not easily done.
Is there some way I can debug things, get more infos on the device?
Thank you very much for your help and patience, and hints. They allowed me to get here, try this new approach.

For now I am modifying the code, but the palan would be to clean up things at the end a create a new module, and mark common functions as such.

Enrico

diff --git a/mt76x2_init.c b/mt76x2_init.c
index 6f942e5..1b321e2 100644
--- a/mt76x2_init.c
+++ b/mt76x2_init.c
@@ -330,6 +330,14 @@ int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
  	return 0;
  }

+int mt76x0_mac_reset(struct mt76x2_dev *dev)
+{
+	mt76_set(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_RESET_CSR);
+	udelay(50);
+	mt76_clear(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_RESET_CSR);
+	return 0;
+}
+
  int mt76x2_mac_start(struct mt76x2_dev *dev)
  {
  	int i;
@@ -364,6 +372,34 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
  	return 0;
  }

+int mt76x0_mac_start(struct mt76x2_dev *dev)
+{
+	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
+
+	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+						MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 200000))
+  	return -ETIMEDOUT;
+
+	dev->rxfilter = MT_RX_FILTR_CFG_CRC_ERR |
+		MT_RX_FILTR_CFG_PHY_ERR | MT_RX_FILTR_CFG_PROMISC |
+		MT_RX_FILTR_CFG_VER_ERR | MT_RX_FILTR_CFG_DUP |
+		MT_RX_FILTR_CFG_CFACK | MT_RX_FILTR_CFG_CFEND |
+		MT_RX_FILTR_CFG_ACK | MT_RX_FILTR_CFG_CTS |
+		MT_RX_FILTR_CFG_RTS | MT_RX_FILTR_CFG_PSPOLL |
+		MT_RX_FILTR_CFG_BA | MT_RX_FILTR_CFG_CTRL_RSV;
+
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
+
+	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+		MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 50))
+  return -ETIMEDOUT;
+
+	return 0;
+}
+
  void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
  {
  	bool stopped = false;
@@ -399,6 +435,38 @@ void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
  	mt76_wr(dev, MT_TX_RTS_CFG, rts_cfg);
  }

+void mt76x0_mac_stop(struct mt76x2_dev *dev) {
+	int i, ok;
+
+	mt76_clear(dev, MT_BEACON_TIME_CFG, MT_BEACON_TIME_CFG_TIMER_EN |
+		MT_BEACON_TIME_CFG_SYNC_MODE | MT_BEACON_TIME_CFG_TBTT_EN |
+		MT_BEACON_TIME_CFG_BEACON_TX);
+
+	/* Page count on TxQ */
+	i = 200;
+	while (i-- && ((mt76_rr(dev, 0x0438) & 0xffffffff) ||
+		(mt76_rr(dev, 0x0a30) & 0x000000ff) ||
+		(mt76_rr(dev, 0x0a34) & 0x00ff00ff)))
+		msleep(10);
+
+	mt76_clear(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_RX |
+		MT_MAC_SYS_CTRL_ENABLE_TX);
+
+	/* Page count on RxQ */
+	ok = 0;
+	i = 200;
+	while (i--) {
+		if (!(mt76_rr(dev, MT_RXQ_STA) & 0x00ff0000) &&
+			!mt76_rr(dev, 0x0a30) &&
+			!mt76_rr(dev, 0x0a34)) {
+				if (ok++ > 5)
+					break;
+				continue;
+			}
+			msleep(1);
+	}
+}
+
  void mt76x2_mac_resume(struct mt76x2_dev *dev)
  {
  	mt76_wr(dev, MT_MAC_SYS_CTRL,
@@ -485,6 +553,34 @@ mt76x2_power_on(struct mt76x2_dev *dev)
  	mt76x2_power_on_rf(dev, 1);
  }

+/* Big thanks to the author(s?) of mt7601U, upstream version */
+static void
+mt76x2_power_on_76x0(struct mt76x2_dev *dev)
+{
+	int i;
+	u32 val;
+
+	val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
+
+	/* Note: we don't turn off WLAN_CLK because that may make the device not responsive. */
+	val |= (MT_WLAN_FUN_CTRL_WLAN_EN |
+		MT_WLAN_FUN_CTRL_WLAN_CLK_EN);
+
+	mt76_wr(dev, MT_WLAN_FUN_CTRL, val);
+	udelay(50);
+
+	for (i = 200; i; i--) {
+		val = mt76_rr(dev, MT_CMB_CTRL);
+		if (val & MT_CMB_CTRL_XTAL_RDY && val & MT_CMB_CTRL_PLL_LD)
+			break;
+
+		udelay(50);
+	}
+
+	if (!i)
+		dev_err(dev->mt76.dev, "Error: PLL and XTAL check failed!\n");
+}
+
  void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
  {
  	u8 ackto, sifs, slottime = dev->slottime;
@@ -543,23 +639,21 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
  	static const u16 beacon_offsets[16] = {
  		/* 1024 byte per beacon */
  		0xc000,
+		0xc200,
  		0xc400,
+		0xc600,
  		0xc800,
+		0xca00,
  		0xcc00,
+		0xce00,
  		0xd000,
+		0xd200,
  		0xd400,
+		0xd600,
  		0xd800,
+		0xda00,
  		0xdc00,
-
-		/* BSS idx 8-15 not used for beacons */
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
-		0xc000,
+		0xde00,
  	};
  	u32 val;
  	int ret;
@@ -581,24 +675,28 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
  	mt76_wr(dev, MT_WPDMA_GLO_CFG, val);

  	mt76x2_reset_wlan(dev, true);
-	mt76x2_power_on(dev);
+	mt76x2_power_on_76x0(dev);

-	ret = mt76x2_eeprom_init(dev);
+	/* Note: at this point the vendor driver does write some things to MT_CMB_CTRL; we aren't. */
+
+	/* Note: at this point the vendor driver does write some things to MT_CMB_CTRL; we aren't. */
+
+	/* ret = mt76x2_eeprom_init(dev);
  	if (ret)
-		return ret;
+		return ret; */

-	ret = mt76x2_mac_reset(dev, true);
+	ret = mt76x0_mac_reset(dev);
  	if (ret)
  		return ret;

  	dev->rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);

-	ret = mt76x2_dma_init(dev);
+	//ret = mt76x0_dma_init(dev); XXX MISSING BUT NEEDED
  	if (ret)
  		return ret;

  	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
-	ret = mt76x2_mac_start(dev);
+	ret = mt76x0_mac_start(dev);
  	if (ret)
  		return ret;

diff --git a/mt76x2_regs.h b/mt76x2_regs.h
index 95c1e95..ca2bca4 100644
--- a/mt76x2_regs.h
+++ b/mt76x2_regs.h
@@ -47,6 +47,7 @@
  #define MT_WLAN_FUN_CTRL_WLAN_RESET_RF	BIT(2)

  #define MT_WLAN_FUN_CTRL_WLAN_RESET	BIT(3) /* MT76x0 */
+#define MT_RXQ_STA 0x0430
  #define MT_WLAN_FUN_CTRL_CSR_F20M_CKEN	BIT(3) /* MT76x2 */

  #define MT_WLAN_FUN_CTRL_PCIE_CLK_REQ	BIT(4)
