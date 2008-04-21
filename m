Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:52877 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761287AbYDURAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:00:13 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2556605fkr.5
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 10:00:12 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 8/9] rt2x00: Fix kernel-doc
Date: Mon, 21 Apr 2008 19:02:17 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200804211858.46659.IvDoorn@gmail.com>
In-Reply-To: <200804211858.46659.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804211902.17790.IvDoorn@gmail.com> (sfid-20080421_190106_871593_7E32D828)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Add missing kernel-doc variables for structures/functions.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00pci.h |    6 ++++--
 drivers/net/wireless/rt2x00/rt2x00usb.h |    6 +++---
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d85553f..92656d0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -404,7 +404,7 @@ static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
  * @supported_rates: Rate types which are supported (CCK, OFDM).
  * @num_channels: Number of supported channels. This is used as array size
  *	for @tx_power_a, @tx_power_bg and @channels.
- * channels: Device/chipset specific channel values (See &struct rf_channel).
+ * @channels: Device/chipset specific channel values (See &struct rf_channel).
  * @tx_power_a: TX power values for all 5.2GHz channels (may be NULL).
  * @tx_power_bg: TX power values for all 2.4GHz channels (may be NULL).
  * @tx_power_default: Default TX power value to use when either
@@ -936,7 +936,7 @@ struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 
 /**
  * rt2x00queue_get_entry - Get queue entry where the given index points to.
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @queue: Pointer to &struct data_queue from where we obtain the entry.
  * @index: Index identifier for obtaining the correct index.
  */
 struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
@@ -945,7 +945,7 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
 /**
  * rt2x00queue_index_inc - Index incrementation function
  * @queue: Queue (&struct data_queue) to perform the action on.
- * @action: Index type (&enum queue_index) to perform the action on.
+ * @index: Index type (&enum queue_index) to perform the action on.
  *
  * This function will increase the requested index on the queue,
  * it will grab the appropriate locks and handle queue overflow events by
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 9d1cdb9..2b0ef17 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -98,8 +98,9 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
  * struct queue_entry_priv_pci_rx: Per RX entry PCI specific information
  *
  * @desc: Pointer to device descriptor.
+ * @desc_dma: DMA pointer to @desc.
  * @data: Pointer to device's entry memory.
- * @dma: DMA pointer to &data.
+ * @data_dma: DMA pointer to &data.
  */
 struct queue_entry_priv_pci_rx {
 	__le32 *desc;
@@ -113,8 +114,9 @@ struct queue_entry_priv_pci_rx {
  * struct queue_entry_priv_pci_tx: Per TX entry PCI specific information
  *
  * @desc: Pointer to device descriptor
+ * @desc_dma: DMA pointer to @desc.
  * @data: Pointer to device's entry memory.
- * @dma: DMA pointer to &data.
+ * @data_dma: DMA pointer to &data.
  * @control: mac80211 control structure used to transmit data.
  */
 struct queue_entry_priv_pci_tx {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 1efaaae..4da9eb3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -199,12 +199,12 @@ static inline int rt2x00usb_vendor_request_sw(struct rt2x00_dev *rt2x00dev,
  * kmalloc for correct handling inside the kernel USB layer.
  */
 static inline int rt2x00usb_eeprom_read(struct rt2x00_dev *rt2x00dev,
-					__le16 *eeprom, const u16 lenght)
+					__le16 *eeprom, const u16 length)
 {
 	return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_READ,
 					USB_VENDOR_REQUEST_IN, 0, 0,
-					eeprom, lenght,
-					REGISTER_TIMEOUT16(lenght));
+					eeprom, length,
+					REGISTER_TIMEOUT16(length));
 }
 
 /*
-- 
1.5.4.5

