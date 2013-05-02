Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46304 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842Ab3EBMaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 08:30:12 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 13/14] rt2x00: rt2500usb: implement queue_init callback
Date: Thu,  2 May 2013 14:30:28 +0200
Message-Id: <1367497829-7672-14-git-send-email-juhosg@openwrt.org> (sfid-20130502_143036_160285_B98C4941)
In-Reply-To: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic rt2x00 code has been changed to allow the
drivers toimplement dynamic data_queue initialization.

Remove the static data queue descriptor structures
and implement the queue_init callback instead.

Compile tested only.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   65 ++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index a7f7b36..e5e5479 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1867,33 +1867,45 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.config			= rt2500usb_config,
 };
 
-static const struct data_queue_desc rt2500usb_queue_rx = {
-	.entry_num		= 32,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
+static void rt2500usb_queue_init(struct data_queue *queue)
+{
+	switch (queue->qid) {
+	case QID_RX:
+		queue->limit = 32;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = RXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_usb);
+		break;
 
-static const struct data_queue_desc rt2500usb_queue_tx = {
-	.entry_num		= 32,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
+	case QID_AC_VO:
+	case QID_AC_VI:
+	case QID_AC_BE:
+	case QID_AC_BK:
+		queue->limit = 32;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_usb);
+		break;
 
-static const struct data_queue_desc rt2500usb_queue_bcn = {
-	.entry_num		= 1,
-	.data_size		= MGMT_FRAME_SIZE,
-	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb_bcn),
-};
+	case QID_BEACON:
+		queue->limit = 1;
+		queue->data_size = MGMT_FRAME_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_usb_bcn);
+		break;
 
-static const struct data_queue_desc rt2500usb_queue_atim = {
-	.entry_num		= 8,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= TXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
+	case QID_ATIM:
+		queue->limit = 8;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = TXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_usb);
+		break;
+
+	default:
+		BUG();
+		break;
+	}
+}
 
 static const struct rt2x00_ops rt2500usb_ops = {
 	.name			= KBUILD_MODNAME,
@@ -1902,10 +1914,7 @@ static const struct rt2x00_ops rt2500usb_ops = {
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
 	.extra_tx_headroom	= TXD_DESC_SIZE,
-	.rx			= &rt2500usb_queue_rx,
-	.tx			= &rt2500usb_queue_tx,
-	.bcn			= &rt2500usb_queue_bcn,
-	.atim			= &rt2500usb_queue_atim,
+	.queue_init		= rt2500usb_queue_init,
 	.lib			= &rt2500usb_rt2x00_ops,
 	.hw			= &rt2500usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-- 
1.7.10

