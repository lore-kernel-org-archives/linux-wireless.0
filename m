Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38372 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab3FDLlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 07:41:09 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 09/13] rt2x00: rt2400pci: implement queue_init callback
Date: Tue,  4 Jun 2013 13:40:46 +0200
Message-Id: <1370346050-7047-10-git-send-email-juhosg@openwrt.org> (sfid-20130604_134129_215004_5A09AE05)
In-Reply-To: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic rt2x00 code has been changed to allow the
drivers toimplement dynamic data_queue initialization.

Remove the static data queue descriptor structures
and implement the queue_init callback instead.

Compile tested only.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   65 ++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index f714373..e1ec9a4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1767,33 +1767,45 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.config			= rt2400pci_config,
 };
 
-static const struct data_queue_desc rt2400pci_queue_rx = {
-	.entry_num		= 24,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+static void rt2400pci_queue_init(struct data_queue *queue)
+{
+	switch (queue->qid) {
+	case QID_RX:
+		queue->limit = 24;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = RXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
 
-static const struct data_queue_desc rt2400pci_queue_tx = {
-	.entry_num		= 24,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		queue->limit = 24;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
 
-static const struct data_queue_desc rt2400pci_queue_bcn = {
-	.entry_num		= 1,
-	.data_size		= MGMT_FRAME_SIZE,
-	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+	case QID_BEACON:
+		queue->limit = 1;
+		queue->data_size = MGMT_FRAME_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
 
-static const struct data_queue_desc rt2400pci_queue_atim = {
-	.entry_num		= 8,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_mmio),
-};
+	case QID_ATIM:
+		queue->limit = 8;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_mmio);
+		break;
+
+	default:
+		BUG();
+		break;
+	}
+}
 
 static const struct rt2x00_ops rt2400pci_ops = {
 	.name			= KBUILD_MODNAME,
@@ -1802,10 +1814,7 @@ static const struct rt2x00_ops rt2400pci_ops = {
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
 	.extra_tx_headroom	= 0,
-	.rx			= &rt2400pci_queue_rx,
-	.tx			= &rt2400pci_queue_tx,
-	.bcn			= &rt2400pci_queue_bcn,
-	.atim			= &rt2400pci_queue_atim,
+	.queue_init		= rt2400pci_queue_init,
 	.lib			= &rt2400pci_rt2x00_ops,
 	.hw			= &rt2400pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-- 
1.7.10

