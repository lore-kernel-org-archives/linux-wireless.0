Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbXB1OHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:12 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562557nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:11 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 28/28] rt2x00: Misc fixes
Date: Wed, 28 Feb 2007 15:07:05 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.05828.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Misc fixes:
 - sparse fixes
 - register initialization
 - device uninitialization
 - txpower updating

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 04ceda9..1a2164d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -395,6 +395,12 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	if (channel == rt2x00dev->rx_status.channel)
 		return;
 
+	/*
+	 * Switch on tuning bits.
+	 */
+	rt2x00_set_field32(&rf1, RF1_TUNER, 1);
+	rt2x00_set_field32(&rf3, RF3_TUNER, 1);
+
 	INFO("Switching channel. RF1: 0x%08x, RF2: 0x%08x, RF3: 0x%08x.\n",
 		rf1, rf2, rf3);
 
@@ -626,10 +632,8 @@ static void rt2400pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
  */
 static void rt2400pci_link_tuner(struct work_struct *work)
 {
-	struct link *link =
-		container_of(work, struct link, work.work);
 	struct rt2x00_dev *rt2x00dev =
-		container_of(link, struct rt2x00_dev, link);
+		container_of(work, struct rt2x00_dev, link.work.work);
 	u8 reg;
 	char false_cca_delta;
 
@@ -1086,6 +1090,7 @@ static int rt2400pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 		if ((value != 0xff) && (value != 0x00))
 			goto continue_csr_init;
 		NOTICE("Waiting for BBP register.\n");
+		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR("BBP register access failed, aborting.\n");
@@ -1800,6 +1805,7 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_entry *entry;
+	u32 reg;
 
 	entry = rt2x00_get_data_entry(&rt2x00dev->ring[RING_BEACON]);
 
@@ -1817,6 +1823,15 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw,
 	rt2400pci_write_tx_desc(rt2x00dev, entry->priv,
 		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
+	/*
+	 * Enable beacon generation.
+	 */
+	rt2x00_register_read(rt2x00dev, CSR14, &reg);
+	if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
+		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
+		rt2x00_register_write(rt2x00dev, CSR14, reg);
+	}
+
 	return 0;
 }
 
@@ -1829,7 +1844,7 @@ static int rt2400pci_tx_last_beacon(struct ieee80211_hw *hw)
 	return rt2x00_get_field32(reg, CSR15_BEACON_SENT);
 }
 
-static struct ieee80211_ops rt2400pci_mac80211_ops = {
+static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.tx			= rt2x00lib_tx,
 	.reset			= rt2x00lib_reset,
 	.add_interface		= rt2x00lib_add_interface,
@@ -1913,7 +1928,7 @@ static int rt2400pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
@@ -1930,7 +1945,7 @@ static int rt2400pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	eeprom.reg_chip_select = 0;
 
 	eeprom_93cx6_multiread(&eeprom, EEPROM_BASE, rt2x00dev->eeprom,
-		EEPROM_SIZE);
+		EEPROM_SIZE / sizeof(u16));
 
 	return 0;
 }
@@ -1982,8 +1997,10 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip(&rt2x00dev->chip, RT2460, value, reg);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2420) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2421))
+	    !rt2x00_rf(&rt2x00dev->chip, RF2421)) {
+		ERROR("Invalid RF chipset detected.");
 		return -ENODEV;
+	}
 
 	/*
 	 * Identify default antenna configuration.
@@ -2418,7 +2435,11 @@ static void rt2400pci_remove(struct pci_dev *pci_dev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pci_dev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
+	/*
+	 * Uninitialize the 80211 stack data.
+	 */
 	ieee80211_netif_oper(hw, NETIF_DETACH);
+	ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt2400pci driver data.
@@ -2428,9 +2449,8 @@ static void rt2400pci_remove(struct pci_dev *pci_dev)
 	rt2400pci_free_dev(rt2x00dev);
 
 	/*
-	 * Uninitialize and free the 80211 stack data.
+	 * Free the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
 	ieee80211_free_hw(hw);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index e1f244e..dee7091 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -403,7 +403,8 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	if (txpower == 0xff)
 		txpower = rt2x00dev->tx_power;
-	txpower = TXPOWER_TO_DEV(txpower);
+	else
+		txpower = TXPOWER_TO_DEV(txpower);
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF2525E) && channel == 14)
 		rf4 |= 0x00000010;
@@ -432,6 +433,14 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00_set_field32(&rf3, RF3_TXPOWER, txpower);
 
+	/*
+	 * Switch on tuning bits.
+	 * For RT2523 devices we do not need to update the R1 register.
+	 */
+	if (!rt2x00_rf(&rt2x00dev->chip, RF2523))
+		rt2x00_set_field32(&rf1, RF1_TUNER, 1);
+	rt2x00_set_field32(&rf3, RF3_TUNER, 1);
+
 	INFO("Switching channel. RF1: 0x%08x, RF2: 0x%08x, RF3: 0x%08x, "
 		"RF4: 0x%08x.\n", rf1, rf2, rf3, rf4);
 
@@ -698,10 +707,8 @@ static void rt2500pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
  */
 static void rt2500pci_link_tuner(struct work_struct *work)
 {
-	struct link *link =
-		container_of(work, struct link, work.work);
 	struct rt2x00_dev *rt2x00dev =
-		container_of(link, struct rt2x00_dev, link);
+		container_of(work, struct rt2x00_dev, link.work.work);
 	u32 reg;
 	u32 rssi;
 	u8 reg_r17;
@@ -1193,6 +1200,7 @@ static int rt2500pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 		if ((value != 0xff) && (value != 0x00))
 			goto continue_csr_init;
 		NOTICE("Waiting for BBP register.\n");
+		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR("BBP register access failed, aborting.\n");
@@ -1938,6 +1946,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_entry *entry;
+	u32 reg;
 
 	entry = rt2x00_get_data_entry(&rt2x00dev->ring[RING_BEACON]);
 
@@ -1955,6 +1964,15 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw,
 	rt2500pci_write_tx_desc(rt2x00dev, entry->priv,
 		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
+	/*
+	 * Enable beacon generation.
+	 */
+	rt2x00_register_read(rt2x00dev, CSR14, &reg);
+	if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
+		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
+		rt2x00_register_write(rt2x00dev, CSR14, reg);
+	}
+
 	return 0;
 }
 
@@ -1967,7 +1985,7 @@ static int rt2500pci_tx_last_beacon(struct ieee80211_hw *hw)
 	return rt2x00_get_field32(reg, CSR15_BEACON_SENT);
 }
 
-static struct ieee80211_ops rt2500pci_mac80211_ops = {
+static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.tx			= rt2x00lib_tx,
 	.reset			= rt2x00lib_reset,
 	.add_interface		= rt2x00lib_add_interface,
@@ -2051,7 +2069,7 @@ static int rt2500pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
@@ -2068,7 +2086,7 @@ static int rt2500pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	eeprom.reg_chip_select = 0;
 
 	eeprom_93cx6_multiread(&eeprom, EEPROM_BASE, rt2x00dev->eeprom,
-		EEPROM_SIZE);
+		EEPROM_SIZE / sizeof(u16));
 
 	return 0;
 }
@@ -2125,8 +2143,10 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rf(&rt2x00dev->chip, RF2524) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2525) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2525E) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF5222))
+	    !rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+		ERROR("Invalid RF chipset detected.");
 		return -ENODEV;
+	}
 
 	/*
 	 * Identify default antenna configuration.
@@ -2163,7 +2183,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
 	rt2x00dev->hw->max_rssi =
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
-	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (s8)0xff)
+	if (rt2x00dev->hw->max_rssi < 0 || rt2x00dev->hw->max_rssi == (s8)0xff)
 		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 
 	return 0;
@@ -2712,7 +2732,11 @@ static void rt2500pci_remove(struct pci_dev *pci_dev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pci_dev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
+	/*
+	 * Uninitialize the 80211 stack data.
+	 */
 	ieee80211_netif_oper(hw, NETIF_DETACH);
+	ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt2500pci driver data.
@@ -2722,9 +2746,8 @@ static void rt2500pci_remove(struct pci_dev *pci_dev)
 	rt2500pci_free_dev(rt2x00dev);
 
 	/*
-	 * Uninitialize and free the 80211 stack data.
+	 * Free the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
 	ieee80211_free_hw(hw);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 47d4a78..1d64f6a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -444,7 +444,8 @@ static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	if (txpower == 0xff)
 		txpower = rt2x00dev->tx_power;
-	txpower = TXPOWER_TO_DEV(txpower);
+	else
+		txpower = TXPOWER_TO_DEV(txpower);
 
 	if ((rt2x00_rf(&rt2x00dev->chip, RF2523) ||
 	     rt2x00_rf(&rt2x00dev->chip, RF2524) ||
@@ -516,8 +517,6 @@ static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rx_status.freq = freq;
 	rt2x00dev->rx_status.channel = channel;
 
-	rt2x00dev->tx_power = txpower;
-
 	/*
 	 * Update rf fields
 	 */
@@ -1042,20 +1041,17 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u16 reg;
 
-	if (rt2500usb_set_state(rt2x00dev, STATE_AWAKE))
-		return -EBUSY;
-
 	rt2x00_vendor_request(rt2x00dev, USB_DEVICE_MODE,
-		USB_VENDOR_REQUEST_OUT, 0x0000, USB_MODE_TEST, NULL, 0,
+		USB_VENDOR_REQUEST_OUT, 0x0001, USB_MODE_TEST, NULL, 0,
 		REGISTER_TIMEOUT);
 	rt2x00_vendor_request(rt2x00dev, USB_SINGLE_WRITE,
 		USB_VENDOR_REQUEST_OUT, 0x0308, 0xf0, NULL, 0,
 		REGISTER_TIMEOUT);
 
+	rt2x00_register_write(rt2x00dev, TXRX_CSR2, 0x0001);
 	rt2x00_register_write(rt2x00dev, MAC_CSR13, 0x1111);
 	rt2x00_register_write(rt2x00dev, MAC_CSR14, 0x1e11);
 
-	rt2x00_register_write(rt2x00dev, TXRX_CSR2, 0x0001);
 	rt2x00_register_write(rt2x00dev, MAC_CSR1, 0x0003);
 	rt2x00_register_write(rt2x00dev, MAC_CSR1, 0x0000);
 	rt2x00_register_write(rt2x00dev, TXRX_CSR5, 0x8c8d);
@@ -1064,6 +1060,10 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_register_write(rt2x00dev, TXRX_CSR8, 0x0085);
 	rt2x00_register_write(rt2x00dev, TXRX_CSR21, 0xe78f);
 	rt2x00_register_write(rt2x00dev, MAC_CSR9, 0xff1d);
+
+	if (rt2500usb_set_state(rt2x00dev, STATE_AWAKE))
+		return -EBUSY;
+
 	rt2x00_register_write(rt2x00dev, MAC_CSR1, 0x0004);
 
 	reg = 0;
@@ -1076,7 +1076,7 @@ static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	}
 	rt2x00_register_write(rt2x00dev, PHY_CSR2, reg);
 
-	rt2x00_register_write(rt2x00dev, MAC_CSR11, 0x0005);
+	rt2x00_register_write(rt2x00dev, MAC_CSR11, 0x0002);
 	rt2x00_register_write(rt2x00dev, MAC_CSR22, 0x0053);
 	rt2x00_register_write(rt2x00dev, MAC_CSR15, 0x01ee);
 	rt2x00_register_write(rt2x00dev, MAC_CSR16, 0x0000);
@@ -1117,6 +1117,7 @@ static int rt2500usb_init_bbp(struct rt2x00_dev *rt2x00dev)
 		if ((value != 0xff) && (value != 0x00))
 			goto continue_csr_init;
 		NOTICE("Waiting for BBP register.\n");
+		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR("BBP register access failed, aborting.\n");
@@ -1269,14 +1270,6 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
-	 * Check if the hardware has been initialized,
-	 * if not then do it now.
-	 */
-	if (!GET_FLAG(rt2x00dev, DEVICE_INITIALIZED))
-		if (rt2500usb_initialize(rt2x00dev))
-			return -EIO;
-
-	/*
 	 * Initialize all registers.
 	 */
 	if (rt2500usb_init_rings(rt2x00dev) ||
@@ -1896,7 +1889,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static struct ieee80211_ops rt2500usb_mac80211_ops = {
+static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.tx			= rt2x00lib_tx,
 	.reset			= rt2x00lib_reset,
 	.add_interface		= rt2x00lib_add_interface,
@@ -1937,14 +1930,14 @@ static int rt2500usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
 	rt2x00_vendor_request(
 		rt2x00dev, USB_EEPROM_READ, USB_VENDOR_REQUEST_IN,
-		EEPROM_BASE * sizeof(u16), 0x00, rt2x00dev->eeprom,
-		EEPROM_SIZE * sizeof(u16), REGISTER_TIMEOUT);
+		EEPROM_BASE, 0x00, rt2x00dev->eeprom, EEPROM_SIZE,
+		REGISTER_TIMEOUT * (EEPROM_SIZE / sizeof(u16)));
 
 	return 0;
 }
@@ -2001,8 +1994,10 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rf(&rt2x00dev->chip, RF2524) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2525) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2525E) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF5222))
+	    !rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+		ERROR("Invalid RF chipset detected.");
 		return -ENODEV;
+	}
 
 	/*
 	 * Identify default antenna configuration.
@@ -2033,7 +2028,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_CALIBRATE_OFFSET, &eeprom);
 	rt2x00dev->hw->max_rssi =
 		rt2x00_get_field16(eeprom, EEPROM_CALIBRATE_OFFSET_RSSI);
-	if (rt2x00dev->hw->max_rssi == 0x00 || rt2x00dev->hw->max_rssi == (s8)0xff)
+	if (rt2x00dev->hw->max_rssi < 0 || rt2x00dev->hw->max_rssi == (s8)0xff)
 		rt2x00dev->hw->max_rssi = MAX_RX_SSI;
 
 	return 0;
@@ -2535,7 +2530,11 @@ static void rt2500usb_disconnect(struct usb_interface *usb_intf)
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
+	/*
+	 * Uninitialize the 80211 stack data.
+	 */
 	ieee80211_netif_oper(hw, NETIF_DETACH);
+	ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt2500usb driver data.
@@ -2545,9 +2544,8 @@ static void rt2500usb_disconnect(struct usb_interface *usb_intf)
 	rt2500usb_free_dev(rt2x00dev);
 
 	/*
-	 * Uninitialize and free the 80211 stack data.
+	 * Free the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
 	ieee80211_free_hw(hw);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
index 4cb05e5..287160c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.h
@@ -547,7 +547,7 @@
 /*
  * EEPROM BBP.
  */
-#define EEPROM_BBP_START		0x0076
+#define EEPROM_BBP_START		0x000e
 #define EEPROM_BBP_SIZE			16
 #define EEPROM_BBP_VALUE		FIELD16(0x00ff)
 #define EEPROM_BBP_REG_ID		FIELD16(0xff00)
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 3625843..4bddf17 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -428,7 +428,8 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	if (txpower == 0xff)
 		txpower = rt2x00dev->tx_power;
-	txpower = TXPOWER_TO_DEV(txpower);
+	else
+		txpower = TXPOWER_TO_DEV(txpower);
 
 	if (!GET_FLAG(rt2x00dev, CONFIG_RF_SEQUENCE) || channel <= 14)
 		rf1 = 0x00002ccc;
@@ -644,8 +645,6 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rx_status.freq = freq;
 	rt2x00dev->rx_status.channel = channel;
 
-	rt2x00dev->tx_power = txpower;
-
 	/*
 	 * Update rf fields
 	 */
@@ -653,6 +652,8 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rf2 = rf2;
 	rt2x00dev->rf3 = rf3;
 	rt2x00dev->rf4 = rf4;
+
+	rt2x00dev->tx_power = txpower;
 }
 
 static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
@@ -931,10 +932,8 @@ static void rt61pci_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
  */
 static void rt61pci_link_tuner(struct work_struct *work)
 {
-	struct link *link =
-		container_of(work, struct link, work.work);
 	struct rt2x00_dev *rt2x00dev =
-		container_of(link, struct rt2x00_dev, link);
+		container_of(work, struct rt2x00_dev, link.work.work);
 	u32 reg;
 	u32 rssi;
 	u8 reg_r17;
@@ -1481,6 +1480,7 @@ static int rt61pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 		if ((value != 0xff) && (value != 0x00))
 			goto continue_csr_init;
 		NOTICE("Waiting for BBP register.\n");
+		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR("BBP register access failed, aborting.\n");
@@ -2269,6 +2269,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_entry *entry;
+	u32 reg;
 
 	entry = rt2x00_get_data_entry(&rt2x00dev->ring[RING_BEACON]);
 
@@ -2286,10 +2287,19 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw,
 	rt61pci_write_tx_desc(rt2x00dev, entry->priv,
 		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
+	/*
+	 * Enable beacon generation.
+	 */
+	rt2x00_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	if (!rt2x00_get_field32(reg, TXRX_CSR9_BEACON_GEN)) {
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
+		rt2x00_register_write(rt2x00dev, TXRX_CSR9, reg);
+	}
+
 	return 0;
 }
 
-static struct ieee80211_ops rt61pci_mac80211_ops = {
+static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.tx			= rt2x00lib_tx,
 	.reset			= rt2x00lib_reset,
 	.add_interface		= rt2x00lib_add_interface,
@@ -2372,7 +2382,7 @@ static int rt61pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
@@ -2389,7 +2399,7 @@ static int rt61pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	eeprom.reg_chip_select = 0;
 
 	eeprom_93cx6_multiread(&eeprom, EEPROM_BASE, rt2x00dev->eeprom,
-		EEPROM_SIZE);
+		EEPROM_SIZE / sizeof(u16));
 
 	return 0;
 }
@@ -2447,8 +2457,10 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_rf(&rt2x00dev->chip, RF5225) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF5325) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2527) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2529))
+	    !rt2x00_rf(&rt2x00dev->chip, RF2529)) {
+		ERROR("Invalid RF chipset detected.");
 		return -ENODEV;
+	}
 
 	/*
 	 * Identify default antenna configuration.
@@ -2622,7 +2634,7 @@ static void rt61pci_init_hw_channels(struct rt2x00_dev *rt2x00dev,
 
 		if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 		    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
-			static const u32 vals[] = {
+			static const u32 vals_a[] = {
 				0x0000499a, 0x000049a2, 0x000049a6, 0x000049aa,
 				0x000049ae, 0x000049b2, 0x000049ba, 0x000049be,
 				0x00004a2a, 0x00004a2e, 0x00004a32, 0x00004a36,
@@ -2633,8 +2645,8 @@ static void rt61pci_init_hw_channels(struct rt2x00_dev *rt2x00dev,
 
 			struct ieee80211_channel *chan = channels + 14;
 
-			for (i = 0; i < ARRAY_SIZE(vals); i++)
-				(chan++)->val = vals[i];
+			for (i = 0; i < ARRAY_SIZE(vals_a); i++)
+				(chan++)->val = vals_a[i];
 		}
 	} else {
 		static const u32 vals[] = {
@@ -2649,7 +2661,7 @@ static void rt61pci_init_hw_channels(struct rt2x00_dev *rt2x00dev,
 
 		if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 		    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
-			static const u32 vals[] = {
+			static const u32 vals_a[] = {
 				0x0004481a, 0x00044682, 0x00044686, 0x0004468e,
 				0x00044692, 0x0004469a, 0x000446a2, 0x000446a6,
 				0x0004489a, 0x000448a2, 0x000448aa, 0x000448b2,
@@ -2660,8 +2672,8 @@ static void rt61pci_init_hw_channels(struct rt2x00_dev *rt2x00dev,
 
 			struct ieee80211_channel *chan = channels + 14;
 
-			for (i = 0; i < ARRAY_SIZE(vals); i++)
-				(chan++)->val = vals[i];
+			for (i = 0; i < ARRAY_SIZE(vals_a); i++)
+				(chan++)->val = vals_a[i];
 		}
 	}
 
@@ -3195,7 +3207,11 @@ static void rt61pci_remove(struct pci_dev *pci_dev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pci_dev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
+	/*
+	 * Uninitialize the 80211 stack data.
+	 */
 	ieee80211_netif_oper(hw, NETIF_DETACH);
+	ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt61pci driver data.
@@ -3205,9 +3221,8 @@ static void rt61pci_remove(struct pci_dev *pci_dev)
 	rt61pci_free_dev(rt2x00dev);
 
 	/*
-	 * Uninitialize and free the 80211 stack data.
+	 * Free the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
 	ieee80211_free_hw(hw);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 170fbb6..0baa119 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -435,7 +435,8 @@ static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	if (txpower == 0xff)
 		txpower = rt2x00dev->tx_power;
-	txpower = TXPOWER_TO_DEV(txpower);
+	else
+		txpower = TXPOWER_TO_DEV(txpower);
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225)) {
 		if (channel <= 14)
@@ -554,8 +555,6 @@ static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->rx_status.freq = freq;
 	rt2x00dev->rx_status.channel = channel;
 
-	rt2x00dev->tx_power = txpower;
-
 	/*
 	 * Update rf fields
 	 */
@@ -828,10 +827,8 @@ static void rt73usb_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *addr)
  */
 static void rt73usb_link_tuner(struct work_struct *work)
 {
-	struct link *link =
-		container_of(work, struct link, work.work);
 	struct rt2x00_dev *rt2x00dev =
-		container_of(link, struct rt2x00_dev, link);
+		container_of(work, struct rt2x00_dev, link.work.work);
 	u32 reg;
 	u32 rssi;
 	u8 reg_r17;
@@ -1275,6 +1272,7 @@ static int rt73usb_init_bbp(struct rt2x00_dev *rt2x00dev)
 		if ((value != 0xff) && (value != 0x00))
 			goto continue_csr_init;
 		NOTICE("Waiting for BBP register.\n");
+		udelay(REGISTER_BUSY_DELAY);
 	}
 
 	ERROR("BBP register access failed, aborting.\n");
@@ -1412,14 +1410,6 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return 0;
 
 	/*
-	 * Check if the hardware has been initialized,
-	 * if not then do it now.
-	 */
-	if (!GET_FLAG(rt2x00dev, DEVICE_INITIALIZED))
-		if (rt73usb_initialize(rt2x00dev))
-			return -EIO;
-
-	/*
 	 * Initialize all registers.
 	 */
 	if (rt73usb_init_rings(rt2x00dev) ||
@@ -2084,7 +2074,7 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static struct ieee80211_ops rt73usb_mac80211_ops = {
+static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.tx			= rt2x00lib_tx,
 	.reset			= rt2x00lib_reset,
 	.add_interface		= rt2x00lib_add_interface,
@@ -2128,14 +2118,14 @@ static int rt73usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * Allocate the eeprom memory, check the eeprom width
 	 * and copy the entire eeprom into this allocated memory.
 	 */
-	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE * sizeof(u16), GFP_KERNEL);
+	rt2x00dev->eeprom = kzalloc(EEPROM_SIZE, GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
 		return -ENOMEM;
 
 	rt2x00_vendor_request(
 		rt2x00dev, USB_EEPROM_READ, USB_VENDOR_REQUEST_IN,
-		EEPROM_BASE * sizeof(u16), 0x00, rt2x00dev->eeprom,
-		EEPROM_SIZE * sizeof(u16), REGISTER_TIMEOUT);
+		EEPROM_BASE, 0x00, rt2x00dev->eeprom, EEPROM_SIZE,
+		REGISTER_TIMEOUT * (EEPROM_SIZE / sizeof(u16)));
 
 	return 0;
 }
@@ -2188,8 +2178,10 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_rf(&rt2x00dev->chip, RF5226) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2528) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF5225) &&
-	    !rt2x00_rf(&rt2x00dev->chip, RF2527))
+	    !rt2x00_rf(&rt2x00dev->chip, RF2527)) {
+		ERROR("Invalid RF chipset detected.");
 		return -ENODEV;
+	}
 
 	/*
 	 * Identify default antenna configuration.
@@ -2362,7 +2354,7 @@ static void rt73usb_init_hw_channels(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5226)) {
-		static const u32 vals[] = {
+		static const u32 vals_a[] = {
 			0x0000099a, 0x000009a2, 0x000009a6, 0x000009aa,
 			0x000009ae, 0x000009b2, 0x000009ba, 0x000009be,
 			0x00000a2a, 0x00000a2e, 0x00000a32, 0x00000a36,
@@ -2373,8 +2365,8 @@ static void rt73usb_init_hw_channels(struct rt2x00_dev *rt2x00dev,
 
 		struct ieee80211_channel *chan = channels + 14;
 
-		for (i = 0; i < ARRAY_SIZE(vals); i++)
-			(chan++)->val = vals[i];
+		for (i = 0; i < ARRAY_SIZE(vals_a); i++)
+			(chan++)->val = vals_a[i];
 	}
 
 	/*
@@ -2838,7 +2830,11 @@ static void rt73usb_disconnect(struct usb_interface *usb_intf)
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 
+	/*
+	 * Uninitialize the 80211 stack data.
+	 */
 	ieee80211_netif_oper(hw, NETIF_DETACH);
+	ieee80211_unregister_hw(hw);
 
 	/*
 	 * Uninitialize and free the rt73usb driver data.
@@ -2848,9 +2844,8 @@ static void rt73usb_disconnect(struct usb_interface *usb_intf)
 	rt73usb_free_dev(rt2x00dev);
 
 	/*
-	 * Uninitialize and free the 80211 stack data.
+	 * Free the 80211 stack data.
 	 */
-	ieee80211_unregister_hw(hw);
 	ieee80211_free_hw(hw);
 
 	/*
