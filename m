Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46287 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758769Ab3EBMaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 08:30:12 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 07/14] rt2x00: rt2800usb: implement queue_init callback
Date: Thu,  2 May 2013 14:30:22 +0200
Message-Id: <1367497829-7672-8-git-send-email-juhosg@openwrt.org> (sfid-20130502_143056_836477_C8978759)
In-Reply-To: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic rt2x00 code has been changed to allow the
drivers toimplement dynamic data_queue initialization.

Remove the static data queue descriptor structures
and implement the queue_init callback instead.

The actual chipset is already known when the callback
is used. This allows us to use a single callback for
all supported devices.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |  100 +++++++++++++++----------------
 1 file changed, 48 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index c71a48d..b81d509 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -849,29 +849,54 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.sta_remove		= rt2800_sta_remove,
 };
 
-static const struct data_queue_desc rt2800usb_queue_rx = {
-	.entry_num		= 128,
-	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= RXINFO_DESC_SIZE,
-	.winfo_size		= RXWI_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
+static void rt2800usb_queue_init(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	unsigned short txwi_size, rxwi_size;
 
-static const struct data_queue_desc rt2800usb_queue_tx = {
-	.entry_num		= 16,
-	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= TXINFO_DESC_SIZE,
-	.winfo_size		= TXWI_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
+	if (rt2x00_rt(rt2x00dev, RT5592)) {
+		txwi_size = TXWI_DESC_SIZE_5592;
+		rxwi_size = RXWI_DESC_SIZE_5592;
+	} else {
+		txwi_size = TXWI_DESC_SIZE;
+		rxwi_size = RXWI_DESC_SIZE;
+	}
 
-static const struct data_queue_desc rt2800usb_queue_bcn = {
-	.entry_num		= 8,
-	.data_size		= MGMT_FRAME_SIZE,
-	.desc_size		= TXINFO_DESC_SIZE,
-	.winfo_size		= TXWI_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
+	switch (queue->qid) {
+	case QID_RX:
+		queue->limit = 128;
+		queue->data_size = AGGREGATION_SIZE;
+		queue->desc_size = RXINFO_DESC_SIZE;
+		queue->winfo_size = rxwi_size;
+		queue->priv_size = sizeof(struct queue_entry_priv_usb);
+		break;
+
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		queue->limit = 16;
+		queue->data_size = AGGREGATION_SIZE;
+		queue->desc_size = TXINFO_DESC_SIZE;
+		queue->winfo_size = txwi_size;
+		queue->priv_size = sizeof(struct queue_entry_priv_usb);
+		break;
+
+	case QID_BEACON:
+		queue->limit = 8;
+		queue->data_size = MGMT_FRAME_SIZE;
+		queue->desc_size = TXINFO_DESC_SIZE;
+		queue->winfo_size = txwi_size;
+		queue->priv_size = sizeof(struct queue_entry_priv_usb);
+		break;
+
+	case QID_ATIM:
+		/* fallthrough */
+	default:
+		BUG();
+		break;
+	}
+}
 
 static const struct rt2x00_ops rt2800usb_ops = {
 	.name			= KBUILD_MODNAME,
@@ -881,9 +906,7 @@ static const struct rt2x00_ops rt2800usb_ops = {
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
 	.extra_tx_headroom	= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
-	.rx			= &rt2800usb_queue_rx,
-	.tx			= &rt2800usb_queue_tx,
-	.bcn			= &rt2800usb_queue_bcn,
+	.queue_init		= rt2800usb_queue_init,
 	.lib			= &rt2800usb_rt2x00_ops,
 	.drv			= &rt2800usb_rt2800_ops,
 	.hw			= &rt2800usb_mac80211_ops,
@@ -892,31 +915,6 @@ static const struct rt2x00_ops rt2800usb_ops = {
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 };
 
-static const struct data_queue_desc rt2800usb_queue_rx_5592 = {
-	.entry_num		= 128,
-	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= RXINFO_DESC_SIZE,
-	.winfo_size		= RXWI_DESC_SIZE_5592,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
-
-static const struct data_queue_desc rt2800usb_queue_tx_5592 = {
-	.entry_num		= 16,
-	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= TXINFO_DESC_SIZE,
-	.winfo_size		= TXWI_DESC_SIZE_5592,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
-
-static const struct data_queue_desc rt2800usb_queue_bcn_5592 = {
-	.entry_num		= 8,
-	.data_size		= MGMT_FRAME_SIZE,
-	.desc_size		= TXINFO_DESC_SIZE,
-	.winfo_size		= TXWI_DESC_SIZE_5592,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
-
-
 static const struct rt2x00_ops rt2800usb_ops_5592 = {
 	.name			= KBUILD_MODNAME,
 	.drv_data_size		= sizeof(struct rt2800_drv_data),
@@ -925,9 +923,7 @@ static const struct rt2x00_ops rt2800usb_ops_5592 = {
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
 	.extra_tx_headroom	= TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592,
-	.rx			= &rt2800usb_queue_rx_5592,
-	.tx			= &rt2800usb_queue_tx_5592,
-	.bcn			= &rt2800usb_queue_bcn_5592,
+	.queue_init		= rt2800usb_queue_init,
 	.lib			= &rt2800usb_rt2x00_ops,
 	.drv			= &rt2800usb_rt2800_ops,
 	.hw			= &rt2800usb_mac80211_ops,
-- 
1.7.10

