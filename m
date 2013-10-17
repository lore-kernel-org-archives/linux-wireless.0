Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48769 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab3JQHmq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:46 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 08/21] rt2x00: rt2800pci: use rt2800mmio prefix for queue functions
Date: Thu, 17 Oct 2013 09:42:22 +0200
Message-Id: <1381995755-16471-9-git-send-email-juhosg@openwrt.org> (sfid-20131017_100807_407585_3B7AD9F8)
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
index 12454b0..118f2d5 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -204,7 +204,7 @@ static inline int rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 /*
  * Queue handlers.
  */
-static void rt2800pci_start_queue(struct data_queue *queue)
+static void rt2800mmio_start_queue(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
@@ -231,7 +231,7 @@ static void rt2800pci_start_queue(struct data_queue *queue)
 	}
 }
 
-static void rt2800pci_kick_queue(struct data_queue *queue)
+static void rt2800mmio_kick_queue(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	struct queue_entry *entry;
@@ -255,7 +255,7 @@ static void rt2800pci_kick_queue(struct data_queue *queue)
 	}
 }
 
-static void rt2800pci_stop_queue(struct data_queue *queue)
+static void rt2800mmio_stop_queue(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	u32 reg;
@@ -669,9 +669,9 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.link_tuner		= rt2800_link_tuner,
 	.gain_calibration	= rt2800_gain_calibration,
 	.vco_calibration	= rt2800_vco_calibration,
-	.start_queue		= rt2800pci_start_queue,
-	.kick_queue		= rt2800pci_kick_queue,
-	.stop_queue		= rt2800pci_stop_queue,
+	.start_queue		= rt2800mmio_start_queue,
+	.kick_queue		= rt2800mmio_kick_queue,
+	.stop_queue		= rt2800mmio_stop_queue,
 	.flush_queue		= rt2x00mmio_flush_queue,
 	.write_tx_desc		= rt2800mmio_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
@@ -689,7 +689,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.sta_remove		= rt2800_sta_remove,
 };
 
-static void rt2800pci_queue_init(struct data_queue *queue)
+static void rt2800mmio_queue_init(struct data_queue *queue)
 {
 	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	unsigned short txwi_size, rxwi_size;
@@ -739,7 +739,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
-	.queue_init		= rt2800pci_queue_init,
+	.queue_init		= rt2800mmio_queue_init,
 	.lib			= &rt2800pci_rt2x00_ops,
 	.drv			= &rt2800pci_rt2800_ops,
 	.hw			= &rt2800pci_mac80211_ops,
-- 
1.7.10
