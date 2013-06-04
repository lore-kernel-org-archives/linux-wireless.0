Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38374 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab3FDLlI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:41:08 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 07/13] rt2x00: rt2800pci: implement queue_init callback
Date: Tue,  4 Jun 2013 13:40:44 +0200
Message-Id: <1370346050-7047-8-git-send-email-juhosg@openwrt.org> (sfid-20130604_134127_272402_B8EAE73E)
In-Reply-To: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic rt2x00 code has been changed to allow the
drivers toimplement dynamic data_queue initialization.

Remove the static data queue descriptor structures
and implement the queue_init callback instead.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   60 ++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 330f1d2..260c8b4 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1186,29 +1186,43 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.sta_remove		= rt2800_sta_remove,
 };
 
-static const struct data_queue_desc rt2800pci_queue_rx = {
-	.entry_num		= 128,
-	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= RXD_DESC_SIZE,
-	.winfo_size		= RXWI_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+static void rt2800pci_queue_init(struct data_queue *queue)
+{
+	switch (queue->qid) {
+	case QID_RX:
+		queue->limit = 128;
+		queue->data_size = AGGREGATION_SIZE;
+		queue->desc_size = RXD_DESC_SIZE;
+		queue->winfo_size = RXWI_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
 
-static const struct data_queue_desc rt2800pci_queue_tx = {
-	.entry_num		= 64,
-	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= TXD_DESC_SIZE,
-	.winfo_size		= TXWI_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		queue->limit = 64;
+		queue->data_size = AGGREGATION_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->winfo_size = TXWI_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
 
-static const struct data_queue_desc rt2800pci_queue_bcn = {
-	.entry_num		= 8,
-	.data_size		= 0, /* No DMA required for beacons */
-	.desc_size		= TXD_DESC_SIZE,
-	.winfo_size		= TXWI_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+	case QID_BEACON:
+		queue->limit = 8;
+		queue->data_size = 0; /* No DMA required for beacons */
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->winfo_size = TXWI_DESC_SIZE;
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
 
 static const struct rt2x00_ops rt2800pci_ops = {
 	.name			= KBUILD_MODNAME,
@@ -1218,9 +1232,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
 	.extra_tx_headroom	= TXWI_DESC_SIZE,
-	.rx			= &rt2800pci_queue_rx,
-	.tx			= &rt2800pci_queue_tx,
-	.bcn			= &rt2800pci_queue_bcn,
+	.queue_init		= rt2800pci_queue_init,
 	.lib			= &rt2800pci_rt2x00_ops,
 	.drv			= &rt2800pci_rt2800_ops,
 	.hw			= &rt2800pci_mac80211_ops,
-- 
1.7.10

