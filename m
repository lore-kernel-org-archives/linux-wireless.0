Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62449 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0H3TQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 15:16:37 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so3413183ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Aug 2010 12:16:36 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/10] rt2x00: Correctly kill beacon queue
Date: Mon, 30 Aug 2010 21:14:56 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008302112.25578.IvDoorn@gmail.com> <201008302114.16125.IvDoorn@gmail.com> <201008302114.38933.IvDoorn@gmail.com>
In-Reply-To: <201008302114.38933.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008302114.56989.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USB devices upload their beacon and then automatically send
it out every beacon interval. However when killing a TX queue
we only kill the URB and not the actual transmission of the beacon.

This will reset the Beacon register to prevent any beacons from
being transmitted.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |   10 +++++++++-
 drivers/net/wireless/rt2x00/rt2800usb.c |   10 +++++++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |   10 +++++++++-
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 63b363c..db64df4 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1196,6 +1196,14 @@ static int rt2500usb_get_tx_data_len(struct queue_entry *entry)
 	return length;
 }
 
+static void rt2500usb_kill_tx_queue(struct data_queue *queue)
+{
+	if (queue->qid == QID_BEACON)
+		rt2500usb_register_write(queue->rt2x00dev, TXRX_CSR19, 0);
+
+	rt2x00usb_kill_tx_queue(queue);
+}
+
 /*
  * RX control handlers
  */
@@ -1794,7 +1802,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
+	.kill_tx_queue		= rt2500usb_kill_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_shared_key	= rt2500usb_config_key,
 	.config_pairwise_key	= rt2500usb_config_key,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index d275549..3dff56e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -335,6 +335,14 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 	}
 }
 
+static void rt2800usb_kill_tx_queue(struct data_queue *queue)
+{
+	if (queue->qid == QID_BEACON)
+		rt2x00usb_register_write(queue->rt2x00dev, BCN_TIME_CFG, 0);
+
+	rt2x00usb_kill_tx_queue(queue);
+}
+
 /*
  * RX control handlers
  */
@@ -533,7 +541,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.write_beacon		= rt2800_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
+	.kill_tx_queue		= rt2800usb_kill_tx_queue,
 	.fill_rxdone		= rt2800usb_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
 	.config_pairwise_key	= rt2800_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index b9dfa7b..87fb220 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1573,6 +1573,14 @@ static int rt73usb_get_tx_data_len(struct queue_entry *entry)
 	return length;
 }
 
+static void rt73usb_kill_tx_queue(struct data_queue *queue)
+{
+	if (queue->qid == QID_BEACON)
+		rt2x00usb_register_write(queue->rt2x00dev, TXRX_CSR9, 0);
+
+	rt2x00usb_kill_tx_queue(queue);
+}
+
 /*
  * RX control handlers
  */
@@ -2262,7 +2270,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
+	.kill_tx_queue		= rt73usb_kill_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_shared_key	= rt73usb_config_shared_key,
 	.config_pairwise_key	= rt73usb_config_pairwise_key,
-- 
1.7.2.2

