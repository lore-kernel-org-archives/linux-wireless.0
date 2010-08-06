Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59602 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761842Ab0HFSt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:49:58 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so2918051ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:49:58 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/7] rt2x00: Request TXWI pointer from driver
Date: Fri, 6 Aug 2010 20:47:20 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <201008062045.05288.IvDoorn@gmail.com> <201008062046.19946.IvDoorn@gmail.com> <201008062046.54483.IvDoorn@gmail.com>
In-Reply-To: <201008062046.54483.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008062047.21710.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only reason why the write_tx_data callback function
is needed inside the driver, is because the location of
the TXWI descriptor is different on PCI and USB hardware.
Except for the beacon, where the TXWI is always at the
start of the SKB buffer.

In both cases the drivers write_tx_data function only
wrap around the function rt2800_write_txwi. Move write_tx_data
completely into the rt2800lib library, and add a callback
function to obtain the TXWI pointer.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 +++++---
 drivers/net/wireless/rt2x00/rt2800lib.h |   11 ++++++++++-
 drivers/net/wireless/rt2x00/rt2800pci.c |   11 ++++-------
 drivers/net/wireless/rt2x00/rt2800usb.c |   14 +++++++-------
 4 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 833b157..6f1eb58 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -427,8 +427,10 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 }
 EXPORT_SYMBOL_GPL(rt2800_load_firmware);
 
-void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc)
+void rt2800_write_tx_data(struct queue_entry *entry,
+			  struct txentry_desc *txdesc)
 {
+	__le32 *txwi = rt2800_drv_get_txwi(entry);
 	u32 word;
 
 	/*
@@ -479,7 +481,7 @@ void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc)
 	_rt2x00_desc_write(txwi, 2, 0 /* skbdesc->iv[0] */);
 	_rt2x00_desc_write(txwi, 3, 0 /* skbdesc->iv[1] */);
 }
-EXPORT_SYMBOL_GPL(rt2800_write_txwi);
+EXPORT_SYMBOL_GPL(rt2800_write_tx_data);
 
 static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxwi_w2)
 {
@@ -601,7 +603,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	/*
 	 * Add the TXWI for the beacon to the skb.
 	 */
-	rt2800_write_txwi((__le32 *)entry->skb->data, txdesc);
+	rt2800_write_tx_data(entry, txdesc);
 
 	/*
 	 * Dump beacon to userspace through debugfs.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 091641e..8f97518 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -44,6 +44,7 @@ struct rt2800_ops {
 	int (*drv_write_firmware)(struct rt2x00_dev *rt2x00dev,
 				  const u8 *data, const size_t len);
 	int (*drv_init_registers)(struct rt2x00_dev *rt2x00dev);
+	__le32 *(*drv_get_txwi)(struct queue_entry *entry);
 };
 
 static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
@@ -126,6 +127,13 @@ static inline int rt2800_drv_init_registers(struct rt2x00_dev *rt2x00dev)
 	return rt2800ops->drv_init_registers(rt2x00dev);
 }
 
+static inline __le32 *rt2800_drv_get_txwi(struct queue_entry *entry)
+{
+	const struct rt2800_ops *rt2800ops = entry->queue->rt2x00dev->ops->drv;
+
+	return rt2800ops->drv_get_txwi(entry);
+}
+
 void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 command, const u8 token,
 			const u8 arg0, const u8 arg1);
@@ -135,7 +143,8 @@ int rt2800_check_firmware(struct rt2x00_dev *rt2x00dev,
 int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 			 const u8 *data, const size_t len);
 
-void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc);
+void rt2800_write_tx_data(struct queue_entry *entry,
+			  struct txentry_desc *txdesc);
 void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *txdesc);
 
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 39b3846..f415f6d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -566,15 +566,11 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt2800pci_write_tx_data(struct queue_entry* entry,
-				    struct txentry_desc *txdesc)
+static __le32 *rt2800pci_get_txwi(struct queue_entry *entry)
 {
-	__le32 *txwi = (__le32 *) entry->skb->data;
-
-	rt2800_write_txwi(txwi, txdesc);
+	return (__le32 *) entry->skb->data;
 }
 
-
 static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct sk_buff *skb,
 				    struct txentry_desc *txdesc)
@@ -1011,6 +1007,7 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 	.regbusy_read		= rt2x00pci_regbusy_read,
 	.drv_write_firmware	= rt2800pci_write_firmware,
 	.drv_init_registers	= rt2800pci_init_registers,
+	.drv_get_txwi		= rt2800pci_get_txwi,
 };
 
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
@@ -1030,7 +1027,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
-	.write_tx_data		= rt2800pci_write_tx_data,
+	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.kick_tx_queue		= rt2800pci_kick_tx_queue,
 	.kill_tx_queue		= rt2800pci_kill_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5a2dfe8..9084b9a 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -320,15 +320,14 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt2800usb_write_tx_data(struct queue_entry* entry,
-				    struct txentry_desc *txdesc)
+static __le32 *rt2800usb_get_txwi(struct queue_entry *entry)
 {
-	__le32 *txwi = (__le32 *) (entry->skb->data + TXINFO_DESC_SIZE);
-
-	rt2800_write_txwi(txwi, txdesc);
+	if (entry->queue->qid == QID_BEACON)
+		return (__le32 *) (entry->skb->data);
+	else
+		return (__le32 *) (entry->skb->data + TXINFO_DESC_SIZE);
 }
 
-
 static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 				    struct sk_buff *skb,
 				    struct txentry_desc *txdesc)
@@ -549,6 +548,7 @@ static const struct rt2800_ops rt2800usb_rt2800_ops = {
 	.regbusy_read		= rt2x00usb_regbusy_read,
 	.drv_write_firmware	= rt2800usb_write_firmware,
 	.drv_init_registers	= rt2800usb_init_registers,
+	.drv_get_txwi		= rt2800usb_get_txwi,
 };
 
 static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
@@ -566,7 +566,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.link_tuner		= rt2800_link_tuner,
 	.watchdog		= rt2x00usb_watchdog,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
-	.write_tx_data		= rt2800usb_write_tx_data,
+	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-- 
1.7.2

