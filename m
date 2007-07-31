Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763714AbXGaSeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:14 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:13 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/24] rt2x00: Rename init_hw -> probe_hw
Date: Tue, 31 Jul 2007 20:37:21 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.21642.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 36282c13af11a217f97125e7354d3965d9151336 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 28 Jul 2007 15:21:03 +0200
Subject: [PATCH 12/24] rt2x00: Rename init_hw -> probe_hw

Rename init_hw to probe_hw to better seperate
initialization routines and probe routines.
initialization is done when the radio is enabled
for the first time, probe is done when the probe()
function is called by the kernel.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |   10 +++++-----
 drivers/net/wireless/rt2500pci.c |   10 +++++-----
 drivers/net/wireless/rt2500usb.c |   10 +++++-----
 drivers/net/wireless/rt2x00.h    |    2 +-
 drivers/net/wireless/rt2x00dev.c |   16 ++++++++--------
 drivers/net/wireless/rt61pci.c   |   10 +++++-----
 drivers/net/wireless/rt73usb.c   |   10 +++++-----
 7 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index a43a407..838b64e 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -1307,7 +1307,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
 }
 
 /*
- * Device initialization functions.
+ * Device probe functions.
  */
 static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
@@ -1412,7 +1412,7 @@ static const u32 rf_vals_bg[] = {
 	0x000c20a2, 0x000c20b6, 0x000c20ca, 0x000c20fa
 };
 
-static void rt2400pci_init_hw_mode(struct rt2x00_dev *rt2x00dev)
+static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	u8 *txpower;
@@ -1456,7 +1456,7 @@ static void rt2400pci_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->chan_val_bg = rf_vals_bg;
 }
 
-static int rt2400pci_init_hw(struct rt2x00_dev *rt2x00dev)
+static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
@@ -1474,7 +1474,7 @@ static int rt2400pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt2400pci_init_hw_mode(rt2x00dev);
+	rt2400pci_probe_hw_mode(rt2x00dev);
 
 	/*
 	 * This device supports ATIM
@@ -1601,7 +1601,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 
 static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.irq_handler		= rt2400pci_interrupt,
-	.init_hw		= rt2400pci_init_hw,
+	.probe_hw		= rt2400pci_probe_hw,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
 	.set_device_state	= rt2400pci_set_device_state,
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 7f4287c..e1e5ee2 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -1476,7 +1476,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
 }
 
 /*
- * Device initialization functions.
+ * Device probe functions.
  */
 static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
@@ -1650,7 +1650,7 @@ static const u32 rf_vals_a_5x[] = {
 	0x000090ae, 0x000090b6, 0x000090be
 };
 
-static void rt2500pci_init_hw_mode(struct rt2x00_dev *rt2x00dev)
+static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	u8 *txpower;
@@ -1709,7 +1709,7 @@ static void rt2500pci_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static int rt2500pci_init_hw(struct rt2x00_dev *rt2x00dev)
+static int rt2500pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
@@ -1727,7 +1727,7 @@ static int rt2500pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt2500pci_init_hw_mode(rt2x00dev);
+	rt2500pci_probe_hw_mode(rt2x00dev);
 
 	/*
 	 * This device supports ATIM
@@ -1830,7 +1830,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 
 static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.irq_handler		= rt2500pci_interrupt,
-	.init_hw		= rt2500pci_init_hw,
+	.probe_hw		= rt2500pci_probe_hw,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
 	.set_device_state	= rt2500pci_set_device_state,
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 0d775fa..6ac9125 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -1155,7 +1155,7 @@ static int rt2500usb_fill_rxdone(struct data_entry *entry,
 }
 
 /*
- * Device initialization functions.
+ * Device probe functions.
  */
 static int rt2500usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
@@ -1364,7 +1364,7 @@ static const u32 rf_vals_abg_5222[] = {
 	0x000090b6, 0x000090be
 };
 
-static void rt2500usb_init_hw_mode(struct rt2x00_dev *rt2x00dev)
+static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	u8 *txpower;
@@ -1425,7 +1425,7 @@ static void rt2500usb_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static int rt2500usb_init_hw(struct rt2x00_dev *rt2x00dev)
+static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
@@ -1443,7 +1443,7 @@ static int rt2500usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt2500usb_init_hw_mode(rt2x00dev);
+	rt2500usb_probe_hw_mode(rt2x00dev);
 
 	/*
 	 * USB devices require scheduled promisc mode toggling
@@ -1498,7 +1498,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 };
 
 static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
-	.init_hw		= rt2500usb_init_hw,
+	.probe_hw		= rt2500usb_probe_hw,
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
 	.set_device_state	= rt2500usb_set_device_state,
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 227a50a..9d07e80 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -669,7 +669,7 @@ struct rt2x00lib_ops {
 	/*
 	 * Device init handlers.
 	 */
-	int (*init_hw)(struct rt2x00_dev *rt2x00dev);
+	int (*probe_hw)(struct rt2x00_dev *rt2x00dev);
 	char* (*get_fw_name)(struct rt2x00_dev *rt2x00dev);
 	int (*load_firmware)(struct rt2x00_dev *rt2x00dev, void *data,
 		const size_t len);
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 3ab1738..6d369cf 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -482,7 +482,7 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
 	entry->min_rssi_ack_delta = 0;
 }
 
-static int rt2x00lib_init_hw_modes(struct rt2x00_dev *rt2x00dev,
+static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	struct hw_mode_spec *spec)
 {
 	struct ieee80211_hw *hw = rt2x00dev->hw;
@@ -620,7 +620,7 @@ exit:
 	return -ENOMEM;
 }
 
-static void rt2x00lib_deinit_hw(struct rt2x00_dev *rt2x00dev)
+static void rt2x00lib_remove_hw(struct rt2x00_dev *rt2x00dev)
 {
 	if (test_bit(DEVICE_INITIALIZED_HW, &rt2x00dev->flags))
 		ieee80211_unregister_hw(rt2x00dev->hw);
@@ -633,7 +633,7 @@ static void rt2x00lib_deinit_hw(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static int rt2x00lib_init_hw(struct rt2x00_dev *rt2x00dev)
+static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	int status;
@@ -641,7 +641,7 @@ static int rt2x00lib_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize HW modes.
 	 */
-	status = rt2x00lib_init_hw_modes(rt2x00dev, spec);
+	status = rt2x00lib_probe_hw_modes(rt2x00dev, spec);
 	if (status)
 		return status;
 
@@ -650,7 +650,7 @@ static int rt2x00lib_init_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	status = ieee80211_register_hw(rt2x00dev->hw);
 	if (status) {
-		rt2x00lib_deinit_hw(rt2x00dev);
+		rt2x00lib_remove_hw(rt2x00dev);
 		return status;
 	}
 
@@ -866,7 +866,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Let the driver probe the device to detect the capabilities.
 	 */
-	retval = rt2x00dev->ops->lib->init_hw(rt2x00dev);
+	retval = rt2x00dev->ops->lib->probe_hw(rt2x00dev);
 	if (retval) {
 		ERROR(rt2x00dev, "Failed to allocate device.\n");
 		goto exit;
@@ -892,7 +892,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize ieee80211 structure.
 	 */
-	retval = rt2x00lib_init_hw(rt2x00dev);
+	retval = rt2x00lib_probe_hw(rt2x00dev);
 	if (retval) {
 		ERROR(rt2x00dev, "Failed to initialize hw.\n");
 		goto exit;
@@ -944,7 +944,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Free ieee80211_hw memory.
 	 */
-	rt2x00lib_deinit_hw(rt2x00dev);
+	rt2x00lib_remove_hw(rt2x00dev);
 
 	/*
 	 * Free ring structures.
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 37191a4..cb50956 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -1910,7 +1910,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
 }
 
 /*
- * Device initialization functions.
+ * Device probe functions.
  */
 static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
@@ -2162,7 +2162,7 @@ static const u32 rf_vals_a_5x_seq[] = {
 	0x00044736, 0x0004490a, 0x00044912, 0x0004491a
 };
 
-static void rt61pci_init_hw_mode(struct rt2x00_dev *rt2x00dev)
+static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	u8 *txpower;
@@ -2222,7 +2222,7 @@ static void rt61pci_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
+static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
@@ -2240,7 +2240,7 @@ static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt61pci_init_hw_mode(rt2x00dev);
+	rt61pci_probe_hw_mode(rt2x00dev);
 
 	/*
 	 * This device requires firmware
@@ -2333,7 +2333,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 
 static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.irq_handler		= rt61pci_interrupt,
-	.init_hw		= rt61pci_init_hw,
+	.probe_hw		= rt61pci_probe_hw,
 	.get_fw_name		= rt61pci_get_fw_name,
 	.load_firmware		= rt61pci_load_firmware,
 	.initialize		= rt2x00pci_initialize,
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 8add8d3..6e237df 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -1410,7 +1410,7 @@ static int rt73usb_fill_rxdone(struct data_entry *entry,
 }
 
 /*
- * Device initialization functions.
+ * Device probe functions.
  */
 static int rt73usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
@@ -1620,7 +1620,7 @@ static const u32 rf_vals_a_5x[] = {
 	0x00000aa6, 0x00000aae, 0x00000ab2, 0x00000ab6
 };
 
-static void rt73usb_init_hw_mode(struct rt2x00_dev *rt2x00dev)
+static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	u8 *txpower;
@@ -1677,7 +1677,7 @@ static void rt73usb_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
-static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
+static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
@@ -1695,7 +1695,7 @@ static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw specifications.
 	 */
-	rt73usb_init_hw_mode(rt2x00dev);
+	rt73usb_probe_hw_mode(rt2x00dev);
 
 	/*
 	 * USB devices require scheduled promisc mode toggling
@@ -1802,7 +1802,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 };
 
 static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
-	.init_hw		= rt73usb_init_hw,
+	.probe_hw		= rt73usb_probe_hw,
 	.get_fw_name		= rt73usb_get_fw_name,
 	.load_firmware		= rt73usb_load_firmware,
 	.initialize		= rt2x00usb_initialize,
-- 
1.5.2.4

