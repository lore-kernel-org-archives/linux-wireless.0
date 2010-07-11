Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61101 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0GKKcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:15 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so426234eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:14 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/17] rt2x00: Move driver callback functions into the ops structure
Date: Sun, 11 Jul 2010 12:31:23 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111230.14710.IvDoorn@gmail.com> <201007111230.38605.IvDoorn@gmail.com>
In-Reply-To: <201007111230.38605.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111231.24978.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All callback functions are gathered in rt2x00dev->ops except
for the callback functions which are used in rt2800lib to
acces rt2800pci/usb.

Move the priv pointer from rt2x00dev to rt2x00dev->ops and
rename it to drv to make it obvious that it is the driver callback
structure.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.h |   18 +++++++++---------
 drivers/net/wireless/rt2x00/rt2800pci.c |   30 +++++++++++++-----------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   30 +++++++++++++-----------------
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 +-----
 4 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index cecbd3a..091641e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -50,7 +50,7 @@ static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
 					const unsigned int offset,
 					u32 *value)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	rt2800ops->register_read(rt2x00dev, offset, value);
 }
@@ -59,7 +59,7 @@ static inline void rt2800_register_read_lock(struct rt2x00_dev *rt2x00dev,
 					     const unsigned int offset,
 					     u32 *value)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	rt2800ops->register_read_lock(rt2x00dev, offset, value);
 }
@@ -68,7 +68,7 @@ static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
 					 const unsigned int offset,
 					 u32 value)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	rt2800ops->register_write(rt2x00dev, offset, value);
 }
@@ -77,7 +77,7 @@ static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
 					      const unsigned int offset,
 					      u32 value)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	rt2800ops->register_write_lock(rt2x00dev, offset, value);
 }
@@ -86,7 +86,7 @@ static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
 					     const unsigned int offset,
 					     void *value, const u32 length)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	rt2800ops->register_multiread(rt2x00dev, offset, value, length);
 }
@@ -96,7 +96,7 @@ static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 					      const void *value,
 					      const u32 length)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	rt2800ops->register_multiwrite(rt2x00dev, offset, value, length);
 }
@@ -106,7 +106,7 @@ static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
 				      const struct rt2x00_field32 field,
 				      u32 *reg)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
@@ -114,14 +114,14 @@ static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
 static inline int rt2800_drv_write_firmware(struct rt2x00_dev *rt2x00dev,
 					    const u8 *data, const size_t len)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	return rt2800ops->drv_write_firmware(rt2x00dev, data, len);
 }
 
 static inline int rt2800_drv_init_registers(struct rt2x00_dev *rt2x00dev)
 {
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
 	return rt2800ops->drv_init_registers(rt2x00dev);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0fdd58b..39b3846 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -926,27 +926,10 @@ static int rt2800pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	return rt2800_validate_eeprom(rt2x00dev);
 }
 
-static const struct rt2800_ops rt2800pci_rt2800_ops = {
-	.register_read		= rt2x00pci_register_read,
-	.register_read_lock	= rt2x00pci_register_read, /* same for PCI */
-	.register_write		= rt2x00pci_register_write,
-	.register_write_lock	= rt2x00pci_register_write, /* same for PCI */
-
-	.register_multiread	= rt2x00pci_register_multiread,
-	.register_multiwrite	= rt2x00pci_register_multiwrite,
-
-	.regbusy_read		= rt2x00pci_regbusy_read,
-
-	.drv_write_firmware	= rt2800pci_write_firmware,
-	.drv_init_registers	= rt2800pci_init_registers,
-};
-
 static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
-	rt2x00dev->priv = (void *)&rt2800pci_rt2800_ops;
-
 	/*
 	 * Allocate eeprom data.
 	 */
@@ -1018,6 +1001,18 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.ampdu_action		= rt2800_ampdu_action,
 };
 
+static const struct rt2800_ops rt2800pci_rt2800_ops = {
+	.register_read		= rt2x00pci_register_read,
+	.register_read_lock	= rt2x00pci_register_read, /* same for PCI */
+	.register_write		= rt2x00pci_register_write,
+	.register_write_lock	= rt2x00pci_register_write, /* same for PCI */
+	.register_multiread	= rt2x00pci_register_multiread,
+	.register_multiwrite	= rt2x00pci_register_multiwrite,
+	.regbusy_read		= rt2x00pci_regbusy_read,
+	.drv_write_firmware	= rt2800pci_write_firmware,
+	.drv_init_registers	= rt2800pci_init_registers,
+};
+
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.irq_handler		= rt2800pci_interrupt,
 	.irq_handler_thread	= rt2800pci_interrupt_thread,
@@ -1082,6 +1077,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 	.tx			= &rt2800pci_queue_tx,
 	.bcn			= &rt2800pci_queue_bcn,
 	.lib			= &rt2800pci_rt2x00_ops,
+	.drv			= &rt2800pci_rt2800_ops,
 	.hw			= &rt2800pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 	.debugfs		= &rt2800_rt2x00debug,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 7b8d51f..5a2dfe8 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -470,27 +470,10 @@ static int rt2800usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	return rt2800_validate_eeprom(rt2x00dev);
 }
 
-static const struct rt2800_ops rt2800usb_rt2800_ops = {
-	.register_read		= rt2x00usb_register_read,
-	.register_read_lock	= rt2x00usb_register_read_lock,
-	.register_write		= rt2x00usb_register_write,
-	.register_write_lock	= rt2x00usb_register_write_lock,
-
-	.register_multiread	= rt2x00usb_register_multiread,
-	.register_multiwrite	= rt2x00usb_register_multiwrite,
-
-	.regbusy_read		= rt2x00usb_regbusy_read,
-
-	.drv_write_firmware	= rt2800usb_write_firmware,
-	.drv_init_registers	= rt2800usb_init_registers,
-};
-
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
-	rt2x00dev->priv = (void *)&rt2800usb_rt2800_ops;
-
 	/*
 	 * Allocate eeprom data.
 	 */
@@ -556,6 +539,18 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.ampdu_action		= rt2800_ampdu_action,
 };
 
+static const struct rt2800_ops rt2800usb_rt2800_ops = {
+	.register_read		= rt2x00usb_register_read,
+	.register_read_lock	= rt2x00usb_register_read_lock,
+	.register_write		= rt2x00usb_register_write,
+	.register_write_lock	= rt2x00usb_register_write_lock,
+	.register_multiread	= rt2x00usb_register_multiread,
+	.register_multiwrite	= rt2x00usb_register_multiwrite,
+	.regbusy_read		= rt2x00usb_regbusy_read,
+	.drv_write_firmware	= rt2800usb_write_firmware,
+	.drv_init_registers	= rt2800usb_init_registers,
+};
+
 static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.probe_hw		= rt2800usb_probe_hw,
 	.get_firmware_name	= rt2800usb_get_firmware_name,
@@ -619,6 +614,7 @@ static const struct rt2x00_ops rt2800usb_ops = {
 	.tx			= &rt2800usb_queue_tx,
 	.bcn			= &rt2800usb_queue_bcn,
 	.lib			= &rt2800usb_rt2x00_ops,
+	.drv			= &rt2800usb_rt2800_ops,
 	.hw			= &rt2800usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 	.debugfs		= &rt2800_rt2x00debug,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9dd0d17..c21af38 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -621,6 +621,7 @@ struct rt2x00_ops {
 	const struct data_queue_desc *bcn;
 	const struct data_queue_desc *atim;
 	const struct rt2x00lib_ops *lib;
+	const void *drv;
 	const struct ieee80211_ops *hw;
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 	const struct rt2x00debug *debugfs;
@@ -881,11 +882,6 @@ struct rt2x00_dev {
 	 * and interrupt thread routine.
 	 */
 	u32 irqvalue[2];
-
-	/*
-	 * Driver specific data.
-	 */
-	void *priv;
 };
 
 /*
-- 
1.7.1.1

