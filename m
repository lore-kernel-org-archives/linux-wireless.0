Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765532AbXGaSeB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:01 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:00 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/24] rt2x00: Add reset_tuner handler
Date: Tue, 31 Jul 2007 20:37:04 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.04676.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 79fd787737bd6af5962db6771a897253734e45ae Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 27 Jul 2007 18:14:40 +0200
Subject: [PATCH 04/24] rt2x00: Add reset_tuner handler

At the start of link tuning the initial register
value should be written in order to later on correct it.
This value needs to be reset when the channel and/or
antenna have been changed because those 2 events have
impact on the link quality and the tuning should restart
the tuning.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    7 ++++++-
 drivers/net/wireless/rt2500pci.c |    7 ++++++-
 drivers/net/wireless/rt2500usb.c |    7 ++++++-
 drivers/net/wireless/rt2x00.h    |    6 ++++++
 drivers/net/wireless/rt2x00dev.c |    2 ++
 drivers/net/wireless/rt61pci.c   |   11 ++++++-----
 drivers/net/wireless/rt73usb.c   |   11 ++++++-----
 7 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 55975d3..46abf85 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -605,6 +605,11 @@ static void rt2400pci_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
+static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	rt2400pci_bbp_write(rt2x00dev, 13, 0x08);
+}
+
 static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	u8 reg;
@@ -874,7 +879,6 @@ continue_csr_init:
 	rt2400pci_bbp_write(rt2x00dev, 3, 0x27);
 	rt2400pci_bbp_write(rt2x00dev, 4, 0x08);
 	rt2400pci_bbp_write(rt2x00dev, 10, 0x0f);
-	rt2400pci_bbp_write(rt2x00dev, 13, 0x08);
 	rt2400pci_bbp_write(rt2x00dev, 15, 0x72);
 	rt2400pci_bbp_write(rt2x00dev, 16, 0x74);
 	rt2400pci_bbp_write(rt2x00dev, 17, 0x20);
@@ -1601,6 +1605,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 #ifdef CONFIG_RT2400PCI_RFKILL
 	.rfkill_poll		= rt2400pci_rfkill_poll,
 #endif /* CONFIG_RT2400PCI_RFKILL */
+	.reset_tuner		= rt2400pci_reset_tuner,
 	.link_tuner		= rt2400pci_link_tuner,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 5996876..46e11bf 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -703,6 +703,11 @@ static void rt2500pci_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
+static void rt2500pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	rt2500pci_bbp_write(rt2x00dev, 17, 0x48);
+}
+
 static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
@@ -1042,7 +1047,6 @@ continue_csr_init:
 	rt2500pci_bbp_write(rt2x00dev, 14, 0x1c);
 	rt2500pci_bbp_write(rt2x00dev, 15, 0x30);
 	rt2500pci_bbp_write(rt2x00dev, 16, 0xac);
-	rt2500pci_bbp_write(rt2x00dev, 17, 0x48);
 	rt2500pci_bbp_write(rt2x00dev, 18, 0x18);
 	rt2500pci_bbp_write(rt2x00dev, 19, 0xff);
 	rt2500pci_bbp_write(rt2x00dev, 20, 0x1e);
@@ -1826,6 +1830,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 #ifdef CONFIG_RT2500PCI_RFKILL
 	.rfkill_poll		= rt2500pci_rfkill_poll,
 #endif /* CONFIG_RT2500PCI_RFKILL */
+	.reset_tuner		= rt2500pci_reset_tuner,
 	.link_tuner		= rt2500pci_link_tuner,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 375971e..7f9d9ad 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -646,6 +646,11 @@ static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev)
 /*
  * Link tuning
  */
+static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	rt2500usb_bbp_write(rt2x00dev, 17, 0x48);
+}
+
 static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
@@ -849,7 +854,6 @@ continue_csr_init:
 	rt2500usb_bbp_write(rt2x00dev, 14, 0x1c);
 	rt2500usb_bbp_write(rt2x00dev, 15, 0x30);
 	rt2500usb_bbp_write(rt2x00dev, 16, 0xac);
-	rt2500usb_bbp_write(rt2x00dev, 17, 0x48);
 	rt2500usb_bbp_write(rt2x00dev, 18, 0x18);
 	rt2500usb_bbp_write(rt2x00dev, 19, 0xff);
 	rt2500usb_bbp_write(rt2x00dev, 20, 0x1e);
@@ -1489,6 +1493,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
 	.set_device_state	= rt2500usb_set_device_state,
+	.reset_tuner		= rt2500usb_reset_tuner,
 	.link_tuner		= rt2500usb_link_tuner,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index eb96d07..14aba76 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -686,6 +686,7 @@ struct rt2x00lib_ops {
 	int (*set_device_state)(struct rt2x00_dev *rt2x00dev,
 		enum dev_state state);
 	int (*rfkill_poll)(struct rt2x00_dev *rt2x00dev);
+	void (*reset_tuner)(struct rt2x00_dev *rt2x00dev);
 	void (*link_tuner)(struct rt2x00_dev *rt2x00dev);
 
 	/*
@@ -984,6 +985,11 @@ static inline void rt2x00_start_link_tune(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->link.vgc_level = 0;
 	rt2x00dev->link.false_cca = 0;
 
+	/*
+	 * Reset the link tuner.
+	 */
+	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
+
 	queue_delayed_work(rt2x00dev->hw->workqueue,
 		&rt2x00dev->link.work, LINK_TUNE_INTERVAL);
 }
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 43a606f..5c45f63 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -167,6 +167,7 @@ void rt2x00lib_config_channel(struct rt2x00_dev *rt2x00dev, const int value,
 		return;
 
 	rt2x00dev->ops->lib->config_channel(rt2x00dev, value, channel, txpower);
+	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
 
 	INFO(rt2x00dev, "Switching channel. "
 		"RF1: 0x%08x, RF2: 0x%08x, RF3: 0x%08x, RF3: 0x%08x.\n",
@@ -212,6 +213,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 		return;
 
 	rt2x00dev->ops->lib->config_antenna(rt2x00dev, antenna_tx, antenna_rx);
+	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
 
 	rt2x00dev->rx_status.antenna = antenna_rx;
 }
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index d900af3..326112d 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -627,14 +627,12 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00dev->curr_hwmode == HWMODE_A) {
 		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
-			rt61pci_bbp_write(rt2x00dev, 17, 0x38);
 			rt61pci_bbp_write(rt2x00dev, 96, 0x78);
 			rt61pci_bbp_write(rt2x00dev, 104, 0x48);
 			rt61pci_bbp_write(rt2x00dev, 75, 0x80);
 			rt61pci_bbp_write(rt2x00dev, 86, 0x80);
 			rt61pci_bbp_write(rt2x00dev, 88, 0x80);
 		} else {
-			rt61pci_bbp_write(rt2x00dev, 17, 0x28);
 			rt61pci_bbp_write(rt2x00dev, 96, 0x58);
 			rt61pci_bbp_write(rt2x00dev, 104, 0x38);
 			rt61pci_bbp_write(rt2x00dev, 75, 0xfe);
@@ -649,14 +647,12 @@ static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
 	} else {
 		if (test_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags)) {
-			rt61pci_bbp_write(rt2x00dev, 17, 0x30);
 			rt61pci_bbp_write(rt2x00dev, 96, 0x68);
 			rt61pci_bbp_write(rt2x00dev, 104, 0x3c);
 			rt61pci_bbp_write(rt2x00dev, 75, 0x80);
 			rt61pci_bbp_write(rt2x00dev, 86, 0x80);
 			rt61pci_bbp_write(rt2x00dev, 88, 0x80);
 		} else {
-			rt61pci_bbp_write(rt2x00dev, 17, 0x20);
 			rt61pci_bbp_write(rt2x00dev, 96, 0x48);
 			rt61pci_bbp_write(rt2x00dev, 104, 0x2c);
 			rt61pci_bbp_write(rt2x00dev, 75, 0xfe);
@@ -912,6 +908,11 @@ static void rt61pci_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
 /*
  * Link tuning
  */
+static void rt61pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	rt61pci_bbp_write(rt2x00dev, 17, 0x20);
+}
+
 static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
@@ -1373,7 +1374,6 @@ static int rt61pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 continue_csr_init:
 	rt61pci_bbp_write(rt2x00dev, 3, 0x00);
 	rt61pci_bbp_write(rt2x00dev, 15, 0x30);
-	rt61pci_bbp_write(rt2x00dev, 17, 0x20);
 	rt61pci_bbp_write(rt2x00dev, 21, 0xc8);
 	rt61pci_bbp_write(rt2x00dev, 22, 0x38);
 	rt61pci_bbp_write(rt2x00dev, 23, 0x06);
@@ -2330,6 +2330,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 #ifdef CONFIG_RT61PCI_RFKILL
 	.rfkill_poll		= rt61pci_rfkill_poll,
 #endif /* CONFIG_RT61PCI_RFKILL */
+	.reset_tuner		= rt61pci_reset_tuner,
 	.link_tuner		= rt61pci_link_tuner,
 	.write_tx_desc		= rt61pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 03a842b..5cd7953 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -518,14 +518,12 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00dev->curr_hwmode == HWMODE_A) {
 		if (test_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags)) {
-			rt73usb_bbp_write(rt2x00dev, 17, 0x38);
 			rt73usb_bbp_write(rt2x00dev, 96, 0x78);
 			rt73usb_bbp_write(rt2x00dev, 104, 0x48);
 			rt73usb_bbp_write(rt2x00dev, 75, 0x80);
 			rt73usb_bbp_write(rt2x00dev, 86, 0x80);
 			rt73usb_bbp_write(rt2x00dev, 88, 0x80);
 		} else {
-			rt73usb_bbp_write(rt2x00dev, 17, 0x28);
 			rt73usb_bbp_write(rt2x00dev, 96, 0x58);
 			rt73usb_bbp_write(rt2x00dev, 104, 0x38);
 			rt73usb_bbp_write(rt2x00dev, 75, 0xfe);
@@ -540,14 +538,12 @@ static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A, 1);
 	} else {
 		if (test_bit(CONFIG_EXTERNAL_LNA, &rt2x00dev->flags)) {
-			rt73usb_bbp_write(rt2x00dev, 17, 0x30);
 			rt73usb_bbp_write(rt2x00dev, 96, 0x68);
 			rt73usb_bbp_write(rt2x00dev, 104, 0x3c);
 			rt73usb_bbp_write(rt2x00dev, 75, 0x80);
 			rt73usb_bbp_write(rt2x00dev, 86, 0x80);
 			rt73usb_bbp_write(rt2x00dev, 88, 0x80);
 		} else {
-			rt73usb_bbp_write(rt2x00dev, 17, 0x20);
 			rt73usb_bbp_write(rt2x00dev, 96, 0x48);
 			rt73usb_bbp_write(rt2x00dev, 104, 0x2c);
 			rt73usb_bbp_write(rt2x00dev, 75, 0xfe);
@@ -787,6 +783,11 @@ static void rt73usb_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
 /*
  * Link tuning
  */
+static void rt73usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
+{
+	rt73usb_bbp_write(rt2x00dev, 17, 0x20);
+}
+
 static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
 	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
@@ -1073,7 +1074,6 @@ static int rt73usb_init_bbp(struct rt2x00_dev *rt2x00dev)
 continue_csr_init:
 	rt73usb_bbp_write(rt2x00dev, 3, 0x80);
 	rt73usb_bbp_write(rt2x00dev, 15, 0x30);
-	rt73usb_bbp_write(rt2x00dev, 17, 0x20);
 	rt73usb_bbp_write(rt2x00dev, 21, 0xc8);
 	rt73usb_bbp_write(rt2x00dev, 22, 0x38);
 	rt73usb_bbp_write(rt2x00dev, 23, 0x06);
@@ -1792,6 +1792,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
 	.set_device_state	= rt73usb_set_device_state,
+	.reset_tuner		= rt73usb_reset_tuner,
 	.link_tuner		= rt73usb_link_tuner,
 	.write_tx_desc		= rt73usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
-- 
1.5.2.4

