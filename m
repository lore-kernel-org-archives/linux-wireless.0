Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41924 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab3CPSUO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:14 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 22/25] rt2800: 5592: TXWI & RXWI descriptors size
Date: Sat, 16 Mar 2013 19:19:50 +0100
Message-Id: <1363457993-15541-23-git-send-email-stf_xl@wp.pl> (sfid-20130316_192023_144821_5F7ED3AF)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
TXWI_STRUC
RXWI_STRUC

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/include/chip/rtmp_mac.h

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    2 +
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 ---
 drivers/net/wireless/rt2x00/rt2800pci.c |    5 +++
 drivers/net/wireless/rt2x00/rt2800usb.c |   53 +++++++++++++++++++++++++++++-
 4 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 6105243..a7630d5 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2628,6 +2628,8 @@ struct mac_iveiv_entry {
 #define TXWI_DESC_SIZE			(4 * sizeof(__le32))
 #define RXWI_DESC_SIZE			(4 * sizeof(__le32))
 
+#define TXWI_DESC_SIZE_5592		(5 * sizeof(__le32))
+#define RXWI_DESC_SIZE_5592		(6 * sizeof(__le32))
 /*
  * TX WI structure
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5adb92b..9b1f293 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -676,11 +676,6 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 	 * Convert descriptor AGC value to RSSI value.
 	 */
 	rxdesc->rssi = rt2800_agc_to_rssi(entry->queue->rt2x00dev, word);
-
-	/*
-	 * Remove RXWI descriptor from start of buffer.
-	 */
-	skb_pull(entry->skb, RXWI_DESC_SIZE);
 }
 EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 48a01aa..5b3295d 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -729,6 +729,11 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 	 * Process the RXWI structure that is at the start of the buffer.
 	 */
 	rt2800_process_rxwi(entry, rxdesc);
+
+	/*
+	 * Remove RXWI descriptor from start of buffer.
+	 */
+	skb_pull(entry->skb, RXWI_DESC_SIZE);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f9ca795..9b1ca67 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -485,7 +485,7 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
 	 */
 	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
 	skbdesc->desc = txi;
-	skbdesc->desc_len = TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
+	skbdesc->desc_len = entry->queue->desc_size;
 }
 
 /*
@@ -730,6 +730,11 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	 * Process the RXWI structure.
 	 */
 	rt2800_process_rxwi(entry, rxdesc);
+
+	/*
+	 * Remove RXWI descriptor from start of buffer.
+	 */
+	skb_pull(entry->skb, entry->queue->desc_size - RXINFO_DESC_SIZE);
 }
 
 /*
@@ -890,6 +895,47 @@ static const struct rt2x00_ops rt2800usb_ops = {
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
+static const struct data_queue_desc rt2800usb_queue_rx_5592 = {
+	.entry_num		= 128,
+	.data_size		= AGGREGATION_SIZE,
+	.desc_size		= RXINFO_DESC_SIZE + RXWI_DESC_SIZE_5592,
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
+};
+
+static const struct data_queue_desc rt2800usb_queue_tx_5592 = {
+	.entry_num		= 16,
+	.data_size		= AGGREGATION_SIZE,
+	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592,
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
+};
+
+static const struct data_queue_desc rt2800usb_queue_bcn_5592 = {
+	.entry_num		= 8,
+	.data_size		= MGMT_FRAME_SIZE,
+	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592,
+	.priv_size		= sizeof(struct queue_entry_priv_usb),
+};
+
+
+static const struct rt2x00_ops rt2800usb_ops_5592 = {
+	.name			= KBUILD_MODNAME,
+	.drv_data_size		= sizeof(struct rt2800_drv_data),
+	.max_ap_intf		= 8,
+	.eeprom_size		= EEPROM_SIZE,
+	.rf_size		= RF_SIZE,
+	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592,
+	.rx			= &rt2800usb_queue_rx_5592,
+	.tx			= &rt2800usb_queue_tx_5592,
+	.bcn			= &rt2800usb_queue_bcn_5592,
+	.lib			= &rt2800usb_rt2x00_ops,
+	.drv			= &rt2800usb_rt2800_ops,
+	.hw			= &rt2800usb_mac80211_ops,
+#ifdef CONFIG_RT2X00_LIB_DEBUGFS
+	.debugfs		= &rt2800_rt2x00debug,
+#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
+};
+
 /*
  * rt2800usb module information.
  */
@@ -1201,7 +1247,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x148f, 0x5372) },
 #endif
 #ifdef CONFIG_RT2800USB_RT55XX
-	{ USB_DEVICE(0x148f, 0x5572) },
+	{ USB_DEVICE(0x148f, 0x5572), .driver_info = 5592 },
 #endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
@@ -1306,6 +1352,9 @@ MODULE_LICENSE("GPL");
 static int rt2800usb_probe(struct usb_interface *usb_intf,
 			   const struct usb_device_id *id)
 {
+	if (id->driver_info == 5592)
+		return rt2x00usb_probe(usb_intf, &rt2800usb_ops_5592);
+
 	return rt2x00usb_probe(usb_intf, &rt2800usb_ops);
 }
 
-- 
1.7.4.4

