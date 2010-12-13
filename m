Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:42514 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab0LMLkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:24 -0500
Received: by mail-ey0-f171.google.com with SMTP id 5so4064829eyg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:23 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/17] rt2x00: Reorganize queue callback functions
Date: Mon, 13 Dec 2010 12:34:54 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131234.01095.IvDoorn@gmail.com> <201012131234.23502.IvDoorn@gmail.com>
In-Reply-To: <201012131234.23502.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131234.55604.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As part of the queue refactoring, change the queue callback
function names to have 3 different actions: start, kick & stop.

We can now also remove the STATE_RADIO_RX_ON/STATE_RADIO_RX_OFF
device_state flags, and replace the usage with using the
start_queue/stop_queue callback functions.
This streamlines the RX queue handling to the
similar approach as all other queues.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |   11 +++--------
 drivers/net/wireless/rt2x00/rt2500pci.c    |   11 +++--------
 drivers/net/wireless/rt2x00/rt2500usb.c    |   11 +++--------
 drivers/net/wireless/rt2x00/rt2800pci.c    |   11 +++--------
 drivers/net/wireless/rt2x00/rt2800usb.c    |   11 +++--------
 drivers/net/wireless/rt2x00/rt2x00.h       |    9 +++++++--
 drivers/net/wireless/rt2x00/rt2x00config.c |    6 ++----
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00mac.c    |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00queue.c  |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00reg.h    |    2 --
 drivers/net/wireless/rt2x00/rt2x00usb.c    |   24 +++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2x00usb.h    |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c      |   11 +++--------
 drivers/net/wireless/rt2x00/rt73usb.c      |   11 +++--------
 15 files changed, 55 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 35d9a06..2fc6ca5 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1058,12 +1058,6 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 	case STATE_RADIO_OFF:
 		rt2400pci_disable_radio(rt2x00dev);
 		break;
-	case STATE_RADIO_RX_ON:
-		rt2400pci_start_queue(rt2x00dev->rx);
-		break;
-	case STATE_RADIO_RX_OFF:
-		rt2400pci_stop_queue(rt2x00dev->rx);
-		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
@@ -1672,10 +1666,11 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.link_stats		= rt2400pci_link_stats,
 	.reset_tuner		= rt2400pci_reset_tuner,
 	.link_tuner		= rt2400pci_link_tuner,
+	.start_queue		= rt2400pci_start_queue,
+	.kick_queue		= rt2400pci_kick_queue,
+	.stop_queue		= rt2400pci_stop_queue,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
 	.write_beacon		= rt2400pci_write_beacon,
-	.kick_tx_queue		= rt2400pci_kick_queue,
-	.kill_tx_queue		= rt2400pci_stop_queue,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
 	.config_filter		= rt2400pci_config_filter,
 	.config_intf		= rt2400pci_config_intf,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index bee7ce1..d67f911 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1213,12 +1213,6 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 	case STATE_RADIO_OFF:
 		rt2500pci_disable_radio(rt2x00dev);
 		break;
-	case STATE_RADIO_RX_ON:
-		rt2500pci_start_queue(rt2x00dev->rx);
-		break;
-	case STATE_RADIO_RX_OFF:
-		rt2500pci_stop_queue(rt2x00dev->rx);
-		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
@@ -1969,10 +1963,11 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.link_stats		= rt2500pci_link_stats,
 	.reset_tuner		= rt2500pci_reset_tuner,
 	.link_tuner		= rt2500pci_link_tuner,
+	.start_queue		= rt2500pci_start_queue,
+	.kick_queue		= rt2500pci_kick_queue,
+	.stop_queue		= rt2500pci_stop_queue,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
 	.write_beacon		= rt2500pci_write_beacon,
-	.kick_tx_queue		= rt2500pci_kick_queue,
-	.kill_tx_queue		= rt2500pci_stop_queue,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
 	.config_filter		= rt2500pci_config_filter,
 	.config_intf		= rt2500pci_config_intf,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 52bd0ed..a56b38f 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1057,12 +1057,6 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 	case STATE_RADIO_OFF:
 		rt2500usb_disable_radio(rt2x00dev);
 		break;
-	case STATE_RADIO_RX_ON:
-		rt2500usb_start_queue(rt2x00dev->rx);
-		break;
-	case STATE_RADIO_RX_OFF:
-		rt2500usb_stop_queue(rt2x00dev->rx);
-		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
@@ -1845,11 +1839,12 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.link_stats		= rt2500usb_link_stats,
 	.reset_tuner		= rt2500usb_reset_tuner,
 	.watchdog		= rt2x00usb_watchdog,
+	.start_queue		= rt2500usb_start_queue,
+	.kick_queue		= rt2x00usb_kick_queue,
+	.stop_queue		= rt2500usb_stop_queue,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
 	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
-	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt2500usb_stop_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_shared_key	= rt2500usb_config_key,
 	.config_pairwise_key	= rt2500usb_config_key,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 08b55b5..195f0be3 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -537,12 +537,6 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800pci_disable_radio(rt2x00dev);
 		rt2800pci_set_state(rt2x00dev, STATE_SLEEP);
 		break;
-	case STATE_RADIO_RX_ON:
-		rt2800pci_start_queue(rt2x00dev->rx);
-		break;
-	case STATE_RADIO_RX_OFF:
-		rt2800pci_stop_queue(rt2x00dev->rx);
-		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
@@ -1003,11 +997,12 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.link_stats		= rt2800_link_stats,
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
+	.start_queue		= rt2800pci_start_queue,
+	.kick_queue		= rt2800pci_kick_queue,
+	.stop_queue		= rt2800pci_stop_queue,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
-	.kick_tx_queue		= rt2800pci_kick_queue,
-	.kill_tx_queue		= rt2800pci_stop_queue,
 	.fill_rxdone		= rt2800pci_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
 	.config_pairwise_key	= rt2800_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index ee51936..60b5503 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -254,12 +254,6 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800usb_disable_radio(rt2x00dev);
 		rt2800usb_set_state(rt2x00dev, STATE_SLEEP);
 		break;
-	case STATE_RADIO_RX_ON:
-		rt2800usb_start_queue(rt2x00dev->rx);
-		break;
-	case STATE_RADIO_RX_OFF:
-		rt2800usb_stop_queue(rt2x00dev->rx);
-		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
@@ -626,12 +620,13 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.watchdog		= rt2800usb_watchdog,
+	.start_queue		= rt2800usb_start_queue,
+	.kick_queue		= rt2x00usb_kick_queue,
+	.stop_queue		= rt2800usb_stop_queue,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
 	.write_tx_data		= rt2800usb_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
-	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt2800usb_stop_queue,
 	.fill_rxdone		= rt2800usb_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
 	.config_pairwise_key	= rt2800_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 0a55eef..617d68f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -567,7 +567,14 @@ struct rt2x00lib_ops {
 			     struct link_qual *qual);
 	void (*link_tuner) (struct rt2x00_dev *rt2x00dev,
 			    struct link_qual *qual, const u32 count);
+
+	/*
+	 * Data queue handlers.
+	 */
 	void (*watchdog) (struct rt2x00_dev *rt2x00dev);
+	void (*start_queue) (struct data_queue *queue);
+	void (*kick_queue) (struct data_queue *queue);
+	void (*stop_queue) (struct data_queue *queue);
 
 	/*
 	 * TX control handlers
@@ -579,8 +586,6 @@ struct rt2x00lib_ops {
 	void (*write_beacon) (struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
 	int (*get_tx_data_len) (struct queue_entry *entry);
-	void (*kick_tx_queue) (struct data_queue *queue);
-	void (*kill_tx_queue) (struct data_queue *queue);
 
 	/*
 	 * RX control handlers
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index a238e90..d2f1f0a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -146,8 +146,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	 * else the changes will be ignored by the device.
 	 */
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-						      STATE_RADIO_RX_OFF);
+		rt2x00dev->ops->lib->stop_queue(rt2x00dev->rx);
 
 	/*
 	 * Write new antenna setup to device and reset the link tuner.
@@ -161,8 +160,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	memcpy(active, &config, sizeof(config));
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		rt2x00dev->ops->lib->set_device_state(rt2x00dev,
-						      STATE_RADIO_RX_ON);
+		rt2x00dev->ops->lib->start_queue(rt2x00dev->rx);
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index c879f9a..8d864b6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -68,7 +68,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Enable RX.
 	 */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_RX_ON);
+	rt2x00dev->ops->lib->start_queue(rt2x00dev->rx);
 	rt2x00link_start_tuner(rt2x00dev);
 
 	/*
@@ -104,7 +104,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	 * Disable RX.
 	 */
 	rt2x00link_stop_tuner(rt2x00dev);
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_RX_OFF);
+	rt2x00dev->ops->lib->stop_queue(rt2x00dev->rx);
 
 	/*
 	 * Disable radio.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 7ad4b27..6713f1a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -352,7 +352,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	 * if for any reason the link tuner must be reset, this will be
 	 * handled by rt2x00lib_config().
 	 */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_RX_OFF);
+	rt2x00dev->ops->lib->stop_queue(rt2x00dev->rx);
 
 	/*
 	 * When we've just turned on the radio, we want to reprogram
@@ -370,7 +370,7 @@ int rt2x00mac_config(struct ieee80211_hw *hw, u32 changed)
 	rt2x00lib_config_antenna(rt2x00dev, rt2x00dev->default_ant);
 
 	/* Turn RX back on */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_RX_ON);
+	rt2x00dev->ops->lib->start_queue(rt2x00dev->rx);
 
 	return 0;
 }
@@ -727,7 +727,7 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop)
 	 * any pending frames to be transmitted.
 	 */
 	tx_queue_for_each(rt2x00dev, queue) {
-		rt2x00dev->ops->lib->kick_tx_queue(queue);
+		rt2x00dev->ops->lib->kick_queue(queue);
 	}
 
 	/**
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 35133d8..2af6cea 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -471,7 +471,7 @@ static void rt2x00queue_kick_tx_queue(struct data_queue *queue,
 	 */
 	if (rt2x00queue_threshold(queue) ||
 	    !test_bit(ENTRY_TXD_BURST, &txdesc->flags))
-		queue->rt2x00dev->ops->lib->kick_tx_queue(queue);
+		queue->rt2x00dev->ops->lib->kick_queue(queue);
 }
 
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
@@ -585,7 +585,7 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	rt2x00queue_free_skb(intf->beacon);
 
 	if (!enable_beacon) {
-		rt2x00dev->ops->lib->kill_tx_queue(intf->beacon->queue);
+		rt2x00dev->ops->lib->stop_queue(intf->beacon->queue);
 		mutex_unlock(&intf->beacon_skb_mutex);
 		return 0;
 	}
@@ -761,7 +761,7 @@ void rt2x00queue_stop_queues(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 
 	txall_queue_for_each(rt2x00dev, queue)
-		rt2x00dev->ops->lib->kill_tx_queue(queue);
+		rt2x00dev->ops->lib->stop_queue(queue);
 }
 
 void rt2x00queue_init_queues(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index ed71be9..e8259ae 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -83,8 +83,6 @@ enum dev_state {
  */
 	STATE_RADIO_ON,
 	STATE_RADIO_OFF,
-	STATE_RADIO_RX_ON,
-	STATE_RADIO_RX_OFF,
 	STATE_RADIO_IRQ_ON,
 	STATE_RADIO_IRQ_OFF,
 	STATE_RADIO_IRQ_ON_ISR,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 12958a4..d4361dc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -261,12 +261,22 @@ static void rt2x00usb_kick_tx_entry(struct queue_entry *entry)
 	}
 }
 
-void rt2x00usb_kick_tx_queue(struct data_queue *queue)
+void rt2x00usb_kick_queue(struct data_queue *queue)
 {
-	rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
-				   rt2x00usb_kick_tx_entry);
+	switch (queue->qid) {
+	case QID_AC_BE:
+	case QID_AC_BK:
+	case QID_AC_VI:
+	case QID_AC_VO:
+		if (!rt2x00queue_empty(queue))
+			rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
+						   rt2x00usb_kick_tx_entry);
+		break;
+	default:
+		break;
+	}
 }
-EXPORT_SYMBOL_GPL(rt2x00usb_kick_tx_queue);
+EXPORT_SYMBOL_GPL(rt2x00usb_kick_queue);
 
 static void rt2x00usb_kill_entry(struct queue_entry *entry)
 {
@@ -422,11 +432,7 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_RX_CONTROL, 0, 0,
 				    REGISTER_TIMEOUT);
 
-	/*
-	 * The USB version of also works
-	 * on the RX queue.
-	 */
-	rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev->rx);
+	rt2x00dev->ops->lib->stop_queue(rt2x00dev->rx);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 656a35f..05a5424 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -378,13 +378,13 @@ struct queue_entry_priv_usb_bcn {
 };
 
 /**
- * rt2x00usb_kick_tx_queue - Kick data queue
+ * rt2x00usb_kick_queue - Kick data queue
  * @queue: Data queue to kick
  *
  * This will walk through all entries of the queue and push all pending
  * frames to the hardware as a single burst.
  */
-void rt2x00usb_kick_tx_queue(struct data_queue *queue);
+void rt2x00usb_kick_queue(struct data_queue *queue);
 
 /**
  * rt2x00usb_stop_queue - Stop data queue
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 044f500..7156b78 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1832,12 +1832,6 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 	case STATE_RADIO_OFF:
 		rt61pci_disable_radio(rt2x00dev);
 		break;
-	case STATE_RADIO_RX_ON:
-		rt61pci_start_queue(rt2x00dev->rx);
-		break;
-	case STATE_RADIO_RX_OFF:
-		rt61pci_stop_queue(rt2x00dev->rx);
-		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
@@ -2900,10 +2894,11 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.link_stats		= rt61pci_link_stats,
 	.reset_tuner		= rt61pci_reset_tuner,
 	.link_tuner		= rt61pci_link_tuner,
+	.start_queue		= rt61pci_start_queue,
+	.kick_queue		= rt61pci_kick_queue,
+	.stop_queue		= rt61pci_stop_queue,
 	.write_tx_desc		= rt61pci_write_tx_desc,
 	.write_beacon		= rt61pci_write_beacon,
-	.kick_tx_queue		= rt61pci_kick_queue,
-	.kill_tx_queue		= rt61pci_stop_queue,
 	.fill_rxdone		= rt61pci_fill_rxdone,
 	.config_shared_key	= rt61pci_config_shared_key,
 	.config_pairwise_key	= rt61pci_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e9b1e3d..f55e74e 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1441,12 +1441,6 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 	case STATE_RADIO_OFF:
 		rt73usb_disable_radio(rt2x00dev);
 		break;
-	case STATE_RADIO_RX_ON:
-		rt73usb_start_queue(rt2x00dev->rx);
-		break;
-	case STATE_RADIO_RX_OFF:
-		rt73usb_stop_queue(rt2x00dev->rx);
-		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
 	case STATE_RADIO_IRQ_OFF:
@@ -2312,11 +2306,12 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.reset_tuner		= rt73usb_reset_tuner,
 	.link_tuner		= rt73usb_link_tuner,
 	.watchdog		= rt2x00usb_watchdog,
+	.start_queue		= rt73usb_start_queue,
+	.kick_queue		= rt2x00usb_kick_queue,
+	.stop_queue		= rt73usb_stop_queue,
 	.write_tx_desc		= rt73usb_write_tx_desc,
 	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
-	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt73usb_stop_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_shared_key	= rt73usb_config_shared_key,
 	.config_pairwise_key	= rt73usb_config_pairwise_key,
-- 
1.7.2.3

