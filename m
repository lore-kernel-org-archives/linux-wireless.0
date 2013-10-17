Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48748 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3JQHmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 02/21] rt2x00: rt2800pci: use rt2800mmio prefix for TX descriptor functions
Date: Thu, 17 Oct 2013 09:42:16 +0200
Message-Id: <1381995755-16471-3-git-send-email-juhosg@openwrt.org> (sfid-20131017_100808_491512_2F73F1C8)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions are used for devices with memory
mapped I/O and contain no PCI specific code at
all. Use rt2800mmio prefix instead of rt2800pci
in the function names to reflect that.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f8f2abb..ddc6a42 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -629,13 +629,13 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static __le32 *rt2800pci_get_txwi(struct queue_entry *entry)
+static __le32 *rt2800mmio_get_txwi(struct queue_entry *entry)
 {
 	return (__le32 *) entry->skb->data;
 }
 
-static void rt2800pci_write_tx_desc(struct queue_entry *entry,
-				    struct txentry_desc *txdesc)
+static void rt2800mmio_write_tx_desc(struct queue_entry *entry,
+				     struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
@@ -826,7 +826,7 @@ static bool rt2800pci_txdone_release_entries(struct queue_entry *entry,
 {
 	if (test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
 		rt2800_txdone_entry(entry, entry->status,
-				    rt2800pci_get_txwi(entry));
+				    rt2800mmio_get_txwi(entry));
 		return false;
 	}
 
@@ -1146,7 +1146,7 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 	.hwcrypt_disabled	= rt2800pci_hwcrypt_disabled,
 	.drv_write_firmware	= rt2800pci_write_firmware,
 	.drv_init_registers	= rt2800pci_init_registers,
-	.drv_get_txwi		= rt2800pci_get_txwi,
+	.drv_get_txwi		= rt2800mmio_get_txwi,
 };
 
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
@@ -1175,7 +1175,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.kick_queue		= rt2800pci_kick_queue,
 	.stop_queue		= rt2800pci_stop_queue,
 	.flush_queue		= rt2x00mmio_flush_queue,
-	.write_tx_desc		= rt2800pci_write_tx_desc,
+	.write_tx_desc		= rt2800mmio_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.clear_beacon		= rt2800_clear_beacon,
-- 
1.7.10
