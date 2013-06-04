Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38366 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab3FDLlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:41:10 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 11/13] rt2x00: rt61pci: implement queue_init callback
Date: Tue,  4 Jun 2013 13:40:48 +0200
Message-Id: <1370346050-7047-12-git-send-email-juhosg@openwrt.org> (sfid-20130604_134118_127881_448C42E2)
In-Reply-To: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic rt2x00 code has been changed to allow the
drivers toimplement dynamic data_queue initialization.

Remove the static data queue descriptor structures
and implement the queue_init callback instead.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Tested-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   54 ++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 7e1759b3..17507d1 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -3025,26 +3025,40 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.config			= rt61pci_config,
 };
 
-static const struct data_queue_desc rt61pci_queue_rx = {
-	.entry_num		= 32,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+static void rt61pci_queue_init(struct data_queue *queue)
+{
+	switch (queue->qid) {
+	case QID_RX:
+		queue->limit = 32;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = RXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
 
-static const struct data_queue_desc rt61pci_queue_tx = {
-	.entry_num		= 32,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		queue->limit = 32;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
 
-static const struct data_queue_desc rt61pci_queue_bcn = {
-	.entry_num		= 4,
-	.data_size		= 0, /* No DMA required for beacons */
-	.desc_size		= TXINFO_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+	case QID_BEACON:
+		queue->limit = 4;
+		queue->data_size = 0; /* No DMA required for beacons */
+		queue->desc_size = TXINFO_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
+
+	case QID_ATIM:
+		/* fallthrough */
+	default:
+		BUG();
+		break;
+	}
+}
 
 static const struct rt2x00_ops rt61pci_ops = {
 	.name			= KBUILD_MODNAME,
@@ -3053,9 +3067,7 @@ static const struct rt2x00_ops rt61pci_ops = {
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
 	.extra_tx_headroom	= 0,
-	.rx			= &rt61pci_queue_rx,
-	.tx			= &rt61pci_queue_tx,
-	.bcn			= &rt61pci_queue_bcn,
+	.queue_init		= rt61pci_queue_init,
 	.lib			= &rt61pci_rt2x00_ops,
 	.hw			= &rt61pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-- 
1.7.10

