Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbXB1OHX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:23 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562557nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:22 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 9/28] rt2x00: Create toggle_rx function
Date: Wed, 28 Feb 2007 15:07:11 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.12083.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create toggle_rx function to simplify enabling/disabling
the RX of the device.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index b6bf9f3..afdaa9a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1296,6 +1296,15 @@ static void rt2400pci_uninitialize(struct rt2x00_dev *rt2x00dev)
 /*
  * Radio control functions.
  */
+static void rt2400pci_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
+{
+	u32 reg;
+
+	rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
+	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, !enable);
+	rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+}
+
 static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -1346,9 +1355,7 @@ static int rt2400pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 0);
-	rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+	rt2400pci_toggle_rx(rt2x00dev, 1);
 
 	/*
 	 * Enable LED
@@ -1396,9 +1403,7 @@ static void rt2400pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
 	rt2x00_register_write(rt2x00dev, TXCSR0, reg);
 
-	rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 1);
-	rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+	rt2400pci_toggle_rx(rt2x00dev, 0);
 
 	/*
 	 * Disable interrupts.
@@ -2002,7 +2007,6 @@ static int rt2400pci_config(struct ieee80211_hw *hw,
 	struct ieee80211_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
 
 	/*
 	 * Check if we need to disable the radio,
@@ -2012,9 +2016,7 @@ static int rt2400pci_config(struct ieee80211_hw *hw,
 		if (!conf->radio_enabled)
 			rt2400pci_disable_radio(rt2x00dev);
 		else {
-			rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
-			rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 1);
-			rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+			rt2400pci_toggle_rx(rt2x00dev, 0);
 		}
 	}
 
@@ -2031,9 +2033,7 @@ static int rt2400pci_config(struct ieee80211_hw *hw,
 	 * Reenable RX only if the radio should be on.
 	 */
 	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
-		rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
-		rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 0);
-		rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+		rt2400pci_toggle_rx(rt2x00dev, 1);
 	} else if (conf->radio_enabled)
 		return rt2400pci_enable_radio(rt2x00dev);
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 69ada0e..1793040 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1423,6 +1423,15 @@ static void rt2500pci_uninitialize(struct rt2x00_dev *rt2x00dev)
 /*
  * Radio control functions.
  */
+static void rt2500pci_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
+{
+	u32 reg;
+
+	rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
+	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, !enable);
+	rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+}
+
 static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -1473,9 +1482,7 @@ static int rt2500pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 0);
-	rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+	rt2500pci_toggle_rx(rt2x00dev, 1);
 
 	/*
 	 * Enable LED
@@ -1523,9 +1530,7 @@ static void rt2500pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
 	rt2x00_register_write(rt2x00dev, TXCSR0, reg);
 
-	rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 1);
-	rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+	rt2500pci_toggle_rx(rt2x00dev, 0);
 
 	/*
 	 * Disable interrupts.
@@ -2168,7 +2173,6 @@ static int rt2500pci_config(struct ieee80211_hw *hw,
 	struct ieee80211_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
 
 	/*
 	 * Check if we need to disable the radio,
@@ -2178,9 +2182,7 @@ static int rt2500pci_config(struct ieee80211_hw *hw,
 		if (!conf->radio_enabled)
 			rt2500pci_disable_radio(rt2x00dev);
 		else {
-			rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
-			rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 1);
-			rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+			rt2500pci_toggle_rx(rt2x00dev, 0);
 		}
 	}
 
@@ -2198,9 +2200,7 @@ static int rt2500pci_config(struct ieee80211_hw *hw,
 	 * Reenable RX only if the radio should be on.
 	 */
 	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
-		rt2x00_register_read(rt2x00dev, RXCSR0, &reg);
-		rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 0);
-		rt2x00_register_write(rt2x00dev, RXCSR0, reg);
+		rt2500pci_toggle_rx(rt2x00dev, 1);
 	} else if (conf->radio_enabled)
 		return rt2500pci_enable_radio(rt2x00dev);
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 86c06ac..a4b410a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1380,10 +1380,18 @@ static void rt2500usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 /*
  * Radio control functions.
  */
+static void rt2500usb_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
+{
+	u16 reg;
+
+	rt2x00_register_read(rt2x00dev, TXRX_CSR2, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX, !enable);
+	rt2x00_register_write(rt2x00dev, TXRX_CSR2, reg);
+}
+
 static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
-	u16 reg;
 	unsigned int i;
 
 	/*
@@ -1421,9 +1429,7 @@ static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00_register_read(rt2x00dev, TXRX_CSR2, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX, 0);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR2, reg);
+	rt2500usb_toggle_rx(rt2x00dev, 1);
 
 	ring = &rt2x00dev->ring[RING_RX];
 	for (i = 0; i < ring->stats.limit; i++) {
@@ -1449,7 +1455,6 @@ exit_fail:
 static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
-	u16 reg;
 	unsigned int i;
 
 	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
@@ -1476,9 +1481,7 @@ static void rt2500usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Cancel RX and TX.
 	 */
-	rt2x00_register_read(rt2x00dev, TXRX_CSR2, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX, 1);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR2, reg);
+	rt2500usb_toggle_rx(rt2x00dev, 0);
 
 	rt2x00_vendor_request(rt2x00dev, USB_RX_CONTROL,
 		USB_VENDOR_REQUEST_OUT, 0x00, 0x00, NULL, 0, REGISTER_TIMEOUT);
@@ -2104,7 +2107,6 @@ static int rt2500usb_config(struct ieee80211_hw *hw,
 	struct ieee80211_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u16 reg;
 
 	/*
 	 * Check if we need to disable the radio,
@@ -2114,9 +2116,7 @@ static int rt2500usb_config(struct ieee80211_hw *hw,
 		if (!conf->radio_enabled)
 			rt2500usb_disable_radio(rt2x00dev);
 		else {
-			rt2x00_register_read(rt2x00dev, TXRX_CSR2, &reg);
-			rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX, 1);
-			rt2x00_register_write(rt2x00dev, TXRX_CSR2, reg);
+			rt2500usb_toggle_rx(rt2x00dev, 0);
 		}
 	}
 
@@ -2134,9 +2134,7 @@ static int rt2500usb_config(struct ieee80211_hw *hw,
 	 * Reenable RX only if the radio should be on.
 	 */
 	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
-		rt2x00_register_read(rt2x00dev, TXRX_CSR2, &reg);
-		rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX, 0);
-		rt2x00_register_write(rt2x00dev, TXRX_CSR2, reg);
+		rt2500usb_toggle_rx(rt2x00dev, 1);
 	} else if (conf->radio_enabled)
 		return rt2500usb_enable_radio(rt2x00dev);
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 2f7d18e..58b90cd 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1865,6 +1865,15 @@ static void rt61pci_uninitialize(struct rt2x00_dev *rt2x00dev)
 /*
  * Radio control functions.
  */
+static void rt61pci_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
+{
+	u32 reg;
+
+	rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, !enable);
+	rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+}
+
 static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -1918,9 +1927,7 @@ static int rt61pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Enable RX.
 	 */
 	rt2x00_register_write(rt2x00dev, RX_CNTL_CSR, 0x00000001);
-	rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+	rt61pci_toggle_rx(rt2x00dev, 1);
 
 	/*
 	 * Enable LED
@@ -1972,9 +1979,7 @@ static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_MGMT, 1);
 	rt2x00_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 
-	rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 1);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+	rt61pci_toggle_rx(rt2x00dev, 0);
 
 	/*
 	 * Disable interrupts.
@@ -2656,7 +2661,6 @@ static int rt61pci_config(struct ieee80211_hw *hw,
 	struct ieee80211_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
 
 	/*
 	 * Check if we need to disable the radio,
@@ -2666,9 +2670,7 @@ static int rt61pci_config(struct ieee80211_hw *hw,
 		if (!conf->radio_enabled)
 			rt61pci_disable_radio(rt2x00dev);
 		else {
-			rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
-			rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 1);
-			rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+			rt61pci_toggle_rx(rt2x00dev, 0);
 		}
 	}
 
@@ -2686,9 +2688,7 @@ static int rt61pci_config(struct ieee80211_hw *hw,
 	 * Reenable RX only if the radio should be on.
 	 */
 	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
-		rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
-		rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+		rt61pci_toggle_rx(rt2x00dev, 1);
 	} else if (conf->radio_enabled)
 		return rt61pci_enable_radio(rt2x00dev);
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index f0fff49..e43404c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1634,10 +1634,18 @@ static void rt73usb_uninitialize(struct rt2x00_dev *rt2x00dev)
 /*
  * Radio control functions.
  */
+static void rt73usb_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable)
+{
+	u32 reg;
+
+	rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, !enable);
+	rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+}
+
 static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
-	u32 reg;
 	unsigned int i;
 
 	/*
@@ -1675,9 +1683,7 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+	rt73usb_toggle_rx(rt2x00dev, 1);
 
 	ring = &rt2x00dev->ring[RING_RX];
 	for (i = 0; i < ring->stats.limit; i++) {
@@ -1703,7 +1709,6 @@ exit_fail:
 static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
-	u32 reg;
 	unsigned int i;
 
 	if (!GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO))
@@ -1729,9 +1734,7 @@ static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Cancel RX and TX.
 	 */
-	rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 1);
-	rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+	rt73usb_toggle_rx(rt2x00dev, 0);
 
 	rt2x00_vendor_request(rt2x00dev, USB_RX_CONTROL,
 		USB_VENDOR_REQUEST_OUT, 0x00, 0x00, NULL, 0, REGISTER_TIMEOUT);
@@ -2368,7 +2371,6 @@ static int rt73usb_config(struct ieee80211_hw *hw,
 	struct ieee80211_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	u32 reg;
 
 	/*
 	 * Check if we need to disable the radio,
@@ -2378,9 +2380,7 @@ static int rt73usb_config(struct ieee80211_hw *hw,
 		if (!conf->radio_enabled)
 			rt73usb_disable_radio(rt2x00dev);
 		else {
-			rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
-			rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 1);
-			rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+			rt73usb_toggle_rx(rt2x00dev, 0);
 		}
 	}
 
@@ -2398,9 +2398,7 @@ static int rt73usb_config(struct ieee80211_hw *hw,
 	 * Reenable RX only if the radio should be on.
 	 */
 	if (GET_FLAG(rt2x00dev, DEVICE_ENABLED_RADIO)) {
-		rt2x00_register_read(rt2x00dev, TXRX_CSR0, &reg);
-		rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
-		rt2x00_register_write(rt2x00dev, TXRX_CSR0, reg);
+		rt73usb_toggle_rx(rt2x00dev, 1);
 	} else if (conf->radio_enabled)
 		return rt73usb_enable_radio(rt2x00dev);
 
