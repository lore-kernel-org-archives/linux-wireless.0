Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46296 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758822Ab3EBMaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 08:30:12 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 09/14] rt2x00: rt73usb: implement queue_init callback
Date: Thu,  2 May 2013 14:30:24 +0200
Message-Id: <1367497829-7672-10-git-send-email-juhosg@openwrt.org> (sfid-20130502_143025_819113_54C39281)
In-Reply-To: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
References: <1367497829-7672-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The generic rt2x00 code has been changed to allow the
drivers toimplement dynamic data_queue initialization.

Remove the static data queue descriptor structures
and implement the queue_init callback instead.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt73usb.c |   54 ++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 377e09b..b2e346a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2359,26 +2359,40 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.config			= rt73usb_config,
 };
 
-static const struct data_queue_desc rt73usb_queue_rx = {
-	.entry_num		= 32,
-	.data_size		= DATA_FRAME_SIZE,
-	.desc_size		= RXD_DESC_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
+static void rt73usb_queue_init(struct data_queue *queue)
+{
+	switch (queue->qid) {
+	case QID_RX:
+		queue->limit = 32;
+		queue->data_size = DATA_FRAME_SIZE;
+		queue->desc_size = RXD_DESC_SIZE;
+		queue->priv_size = sizeof(struct queue_entry_priv_usb);
+		break;
 
-static const struct data_queue_desc rt73usb_queue_tx = {
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
 
-static const struct data_queue_desc rt73usb_queue_bcn = {
-	.entry_num		= 4,
-	.data_size		= MGMT_FRAME_SIZE,
-	.desc_size		= TXINFO_SIZE,
-	.priv_size		= sizeof(struct queue_entry_priv_usb),
-};
+	case QID_BEACON:
+		queue->limit = 4;
+		queue->data_size = MGMT_FRAME_SIZE;
+		queue->desc_size = TXINFO_SIZE;
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
 
 static const struct rt2x00_ops rt73usb_ops = {
 	.name			= KBUILD_MODNAME,
@@ -2387,9 +2401,7 @@ static const struct rt2x00_ops rt73usb_ops = {
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
 	.extra_tx_headroom	= TXD_DESC_SIZE,
-	.rx			= &rt73usb_queue_rx,
-	.tx			= &rt73usb_queue_tx,
-	.bcn			= &rt73usb_queue_bcn,
+	.queue_init		= rt73usb_queue_init,
 	.lib			= &rt73usb_rt2x00_ops,
 	.hw			= &rt73usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-- 
1.7.10

