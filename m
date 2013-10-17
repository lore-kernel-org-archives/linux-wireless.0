Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48762 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3JQHmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:47 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 10/21] rt2x00: rt2800pci: use rt2800mmio prefix for initialization functions
Date: Thu, 17 Oct 2013 09:42:24 +0200
Message-Id: <1381995755-16471-11-git-send-email-juhosg@openwrt.org> (sfid-20131017_094255_233031_EE686100)
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
 drivers/net/wireless/rt2x00/rt2800pci.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index d0e4ec5..7770471 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -245,7 +245,7 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 /*
  * Initialization functions.
  */
-static bool rt2800pci_get_entry_state(struct queue_entry *entry)
+static bool rt2800mmio_get_entry_state(struct queue_entry *entry)
 {
 	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	u32 word;
@@ -261,7 +261,7 @@ static bool rt2800pci_get_entry_state(struct queue_entry *entry)
 	}
 }
 
-static void rt2800pci_clear_entry(struct queue_entry *entry)
+static void rt2800mmio_clear_entry(struct queue_entry *entry)
 {
 	struct queue_entry_priv_mmio *entry_priv = entry->priv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
@@ -290,7 +290,7 @@ static void rt2800pci_clear_entry(struct queue_entry *entry)
 	}
 }
 
-static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
+static int rt2800mmio_init_queues(struct rt2x00_dev *rt2x00dev)
 {
 	struct queue_entry_priv_mmio *entry_priv;
 
@@ -358,7 +358,7 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
+static int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
 
@@ -411,7 +411,7 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/* Wait for DMA, ignore error until we initialize queues. */
 	rt2800_wait_wpdma_ready(rt2x00dev);
 
-	if (unlikely(rt2800pci_init_queues(rt2x00dev)))
+	if (unlikely(rt2800mmio_init_queues(rt2x00dev)))
 		return -EIO;
 
 	retval = rt2800_enable_radio(rt2x00dev);
@@ -553,7 +553,7 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 	.read_eeprom		= rt2800pci_read_eeprom,
 	.hwcrypt_disabled	= rt2800pci_hwcrypt_disabled,
 	.drv_write_firmware	= rt2800pci_write_firmware,
-	.drv_init_registers	= rt2800pci_init_registers,
+	.drv_init_registers	= rt2800mmio_init_registers,
 	.drv_get_txwi		= rt2800mmio_get_txwi,
 };
 
@@ -570,8 +570,8 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.load_firmware		= rt2800_load_firmware,
 	.initialize		= rt2x00mmio_initialize,
 	.uninitialize		= rt2x00mmio_uninitialize,
-	.get_entry_state	= rt2800pci_get_entry_state,
-	.clear_entry		= rt2800pci_clear_entry,
+	.get_entry_state	= rt2800mmio_get_entry_state,
+	.clear_entry		= rt2800mmio_clear_entry,
 	.set_device_state	= rt2800pci_set_device_state,
 	.rfkill_poll		= rt2800_rfkill_poll,
 	.link_stats		= rt2800_link_stats,
-- 
1.7.10
