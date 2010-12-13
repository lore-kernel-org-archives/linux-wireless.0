Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:45263 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0LMLkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:22 -0500
Received: by mail-ey0-f171.google.com with SMTP id 5so4064715eyg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:21 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/17] rt2x00: Introduce 3 queue commands in drivers (start, kick, stop).
Date: Mon, 13 Dec 2010 12:34:22 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131233.37326.IvDoorn@gmail.com> <201012131234.01095.IvDoorn@gmail.com>
In-Reply-To: <201012131234.01095.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131234.23502.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As part of the queue refactoring, we now introduce
3 queue commands: start, kick, stop.

 - Start: will enable a queue, for TX this will
   not mean anything, while for beacons and RX
   this will update the registers to enable the queue.
 - Kick: This will kick all pending frames to
   the hardware. This is needed for the TX queue
   to push all frames to the HW after the queue
   has been started
 - Stop: This will stop the queue in the hardware,
   and cancel any pending work (So this doesn't
   mean the queue is empty after a stop!).

Move all code from the drivers into the appropriate
functions, and link those calls to the old rt2x00lib
callback functions (we will fix this later when we
refactor the queue control inside rt2x00lib).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |  131 +++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2500pci.c |  131 +++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt2500usb.c |   84 +++++++++++------
 drivers/net/wireless/rt2x00/rt2800pci.c |  129 +++++++++++++++-----------
 drivers/net/wireless/rt2x00/rt2800usb.c |   84 +++++++++++------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   12 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h |    8 +-
 drivers/net/wireless/rt2x00/rt61pci.c   |  154 +++++++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt73usb.c   |   84 +++++++++++------
 9 files changed, 530 insertions(+), 287 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 6278660..35d9a06 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -633,6 +633,88 @@ static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * Queue handlers.
+ */
+static void rt2400pci_start_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+		rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 0);
+		rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+		break;
+	case QID_BEACON:
+		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
+		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
+		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
+		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt2400pci_kick_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		break;
+	case QID_AC_BK:
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		break;
+	case QID_ATIM:
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt2400pci_stop_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+	case QID_AC_BK:
+	case QID_ATIM:
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		break;
+	case QID_RX:
+		rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+		rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 1);
+		rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+		break;
+	case QID_BEACON:
+		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+		rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+/*
  * Initialization functions.
  */
 static bool rt2400pci_get_entry_state(struct queue_entry *entry)
@@ -878,17 +960,6 @@ static int rt2400pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static void rt2400pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
-				enum dev_state state)
-{
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF));
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
-}
-
 static void rt2400pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
@@ -988,8 +1059,10 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2400pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+		rt2400pci_start_queue(rt2x00dev->rx);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2400pci_toggle_rx(rt2x00dev, state);
+		rt2400pci_stop_queue(rt2x00dev->rx);
 		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
@@ -1122,36 +1195,6 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
-static void rt2400pci_kick_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue->qid == QID_AC_BE));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue->qid == QID_AC_BK));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, (queue->qid == QID_ATIM));
-	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
-}
-
-static void rt2400pci_kill_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	if (queue->qid == QID_BEACON) {
-		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
-		rt2x00_set_field32(&reg, CSR14_TBCN, 0);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
-	} else {
-		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
-		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
-	}
-}
-
 /*
  * RX control handlers
  */
@@ -1631,8 +1674,8 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.link_tuner		= rt2400pci_link_tuner,
 	.write_tx_desc		= rt2400pci_write_tx_desc,
 	.write_beacon		= rt2400pci_write_beacon,
-	.kick_tx_queue		= rt2400pci_kick_tx_queue,
-	.kill_tx_queue		= rt2400pci_kill_tx_queue,
+	.kick_tx_queue		= rt2400pci_kick_queue,
+	.kill_tx_queue		= rt2400pci_stop_queue,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
 	.config_filter		= rt2400pci_config_filter,
 	.config_intf		= rt2400pci_config_intf,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index ce9212f..bee7ce1 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -723,6 +723,88 @@ dynamic_cca_tune:
 }
 
 /*
+ * Queue handlers.
+ */
+static void rt2500pci_start_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+		rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 0);
+		rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+		break;
+	case QID_BEACON:
+		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
+		rt2x00_set_field32(&reg, CSR14_TBCN, 1);
+		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
+		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt2500pci_kick_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		break;
+	case QID_AC_BK:
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		break;
+	case QID_ATIM:
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt2500pci_stop_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+	case QID_AC_BK:
+	case QID_ATIM:
+		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
+		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
+		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
+		break;
+	case QID_RX:
+		rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
+		rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX, 1);
+		rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
+		break;
+	case QID_BEACON:
+		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+		rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+/*
  * Initialization functions.
  */
 static bool rt2500pci_get_entry_state(struct queue_entry *entry)
@@ -1033,17 +1115,6 @@ static int rt2500pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static void rt2500pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
-				enum dev_state state)
-{
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, RXCSR0, &reg);
-	rt2x00_set_field32(&reg, RXCSR0_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF));
-	rt2x00pci_register_write(rt2x00dev, RXCSR0, reg);
-}
-
 static void rt2500pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
@@ -1143,8 +1214,10 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+		rt2500pci_start_queue(rt2x00dev->rx);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2500pci_toggle_rx(rt2x00dev, state);
+		rt2500pci_stop_queue(rt2x00dev->rx);
 		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
@@ -1276,36 +1349,6 @@ static void rt2500pci_write_beacon(struct queue_entry *entry,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
-static void rt2500pci_kick_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-	rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, (queue->qid == QID_AC_BE));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_TX, (queue->qid == QID_AC_BK));
-	rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM, (queue->qid == QID_ATIM));
-	rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
-}
-
-static void rt2500pci_kill_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	if (queue->qid == QID_BEACON) {
-		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
-		rt2x00_set_field32(&reg, CSR14_TBCN, 0);
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
-		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
-	} else {
-		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
-		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
-		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
-	}
-}
-
 /*
  * RX control handlers
  */
@@ -1928,8 +1971,8 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.link_tuner		= rt2500pci_link_tuner,
 	.write_tx_desc		= rt2500pci_write_tx_desc,
 	.write_beacon		= rt2500pci_write_beacon,
-	.kick_tx_queue		= rt2500pci_kick_tx_queue,
-	.kill_tx_queue		= rt2500pci_kill_tx_queue,
+	.kick_tx_queue		= rt2500pci_kick_queue,
+	.kill_tx_queue		= rt2500pci_stop_queue,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
 	.config_filter		= rt2500pci_config_filter,
 	.config_intf		= rt2500pci_config_intf,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index bbfa671..52bd0ed 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -739,6 +739,57 @@ static void rt2500usb_reset_tuner(struct rt2x00_dev *rt2x00dev,
 }
 
 /*
+ * Queue handlers.
+ */
+static void rt2500usb_start_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u16 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
+		rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX, 0);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
+		break;
+	case QID_BEACON:
+		rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
+		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 1);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt2500usb_stop_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u16 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
+		rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX, 1);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
+		break;
+	case QID_BEACON:
+		rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 0);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 0);
+		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+		break;
+	default:
+		break;
+	}
+
+	rt2x00usb_stop_queue(queue);
+}
+
+/*
  * Initialization functions.
  */
 static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
@@ -931,17 +982,6 @@ static int rt2500usb_init_bbp(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static void rt2500usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
-				enum dev_state state)
-{
-	u16 reg;
-
-	rt2500usb_register_read(rt2x00dev, TXRX_CSR2, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR2_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF));
-	rt2500usb_register_write(rt2x00dev, TXRX_CSR2, reg);
-}
-
 static int rt2500usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	/*
@@ -1018,8 +1058,10 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+		rt2500usb_start_queue(rt2x00dev->rx);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2500usb_toggle_rx(rt2x00dev, state);
+		rt2500usb_stop_queue(rt2x00dev->rx);
 		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
@@ -1203,22 +1245,6 @@ static int rt2500usb_get_tx_data_len(struct queue_entry *entry)
 	return length;
 }
 
-static void rt2500usb_kill_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u16 reg;
-
-	if (queue->qid == QID_BEACON) {
-		rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 0);
-		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
-	}
-
-	rt2x00usb_kill_tx_queue(queue);
-}
-
 /*
  * RX control handlers
  */
@@ -1823,7 +1849,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.write_beacon		= rt2500usb_write_beacon,
 	.get_tx_data_len	= rt2500usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt2500usb_kill_tx_queue,
+	.kill_tx_queue		= rt2500usb_stop_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_shared_key	= rt2500usb_config_key,
 	.config_pairwise_key	= rt2500usb_config_key,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 2b68009..08b55b5 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -186,6 +186,77 @@ static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 #endif /* CONFIG_PCI */
 
 /*
+ * Queue handlers.
+ */
+static void rt2800pci_start_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
+		rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		break;
+	case QID_BEACON:
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		break;
+	default:
+		break;
+	};
+}
+
+static void rt2800pci_kick_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	struct queue_entry *entry;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+	case QID_AC_BK:
+	case QID_AC_VI:
+	case QID_AC_VO:
+		entry = rt2x00queue_get_entry(queue, Q_INDEX);
+		rt2800_register_write(rt2x00dev, TX_CTX_IDX(queue->qid), entry->entry_idx);
+		break;
+	case QID_MGMT:
+		entry = rt2x00queue_get_entry(queue, Q_INDEX);
+		rt2800_register_write(rt2x00dev, TX_CTX_IDX(5), entry->entry_idx);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt2800pci_stop_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
+		rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		break;
+	case QID_BEACON:
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+/*
  * Firmware functions
  */
 static char *rt2800pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
@@ -323,17 +394,6 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static void rt2800pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
-				enum dev_state state)
-{
-	u32 reg;
-
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX,
-			   (state == STATE_RADIO_RX_ON));
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-}
-
 static void rt2800pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 				 enum dev_state state)
 {
@@ -478,8 +538,10 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800pci_set_state(rt2x00dev, STATE_SLEEP);
 		break;
 	case STATE_RADIO_RX_ON:
+		rt2800pci_start_queue(rt2x00dev->rx);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2800pci_toggle_rx(rt2x00dev, state);
+		rt2800pci_stop_queue(rt2x00dev->rx);
 		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
@@ -566,45 +628,6 @@ static void rt2800pci_write_tx_desc(struct queue_entry *entry,
 }
 
 /*
- * TX data initialization
- */
-static void rt2800pci_kick_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
-	unsigned int qidx;
-
-	if (queue->qid == QID_MGMT)
-		qidx = 5;
-	else
-		qidx = queue->qid;
-
-	rt2800_register_write(rt2x00dev, TX_CTX_IDX(qidx), entry->entry_idx);
-}
-
-static void rt2800pci_kill_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	if (queue->qid == QID_BEACON) {
-		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-		return;
-	}
-
-	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, (queue->qid == QID_AC_BE));
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, (queue->qid == QID_AC_BK));
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, (queue->qid == QID_AC_VI));
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, (queue->qid == QID_AC_VO));
-	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
-}
-
-/*
  * RX control handlers
  */
 static void rt2800pci_fill_rxdone(struct queue_entry *entry,
@@ -983,8 +1006,8 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.write_tx_desc		= rt2800pci_write_tx_desc,
 	.write_tx_data		= rt2800_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
-	.kick_tx_queue		= rt2800pci_kick_tx_queue,
-	.kill_tx_queue		= rt2800pci_kill_tx_queue,
+	.kick_tx_queue		= rt2800pci_kick_queue,
+	.kill_tx_queue		= rt2800pci_stop_queue,
 	.fill_rxdone		= rt2800pci_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
 	.config_pairwise_key	= rt2800_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 1dfa59d..ee51936 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -50,6 +50,57 @@ module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 /*
+ * Queue handlers.
+ */
+static void rt2800usb_start_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 1);
+		rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		break;
+	case QID_BEACON:
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt2800usb_stop_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
+		rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		break;
+	case QID_BEACON:
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+		break;
+	default:
+		break;
+	}
+
+	rt2x00usb_stop_queue(queue);
+}
+
+/*
  * Firmware functions
  */
 static char *rt2800usb_get_firmware_name(struct rt2x00_dev *rt2x00dev)
@@ -107,17 +158,6 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 /*
  * Device state switch handlers.
  */
-static void rt2800usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
-				enum dev_state state)
-{
-	u32 reg;
-
-	rt2800_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
-	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX,
-			   (state == STATE_RADIO_RX_ON));
-	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-}
-
 static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -215,8 +255,10 @@ static int rt2800usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt2800usb_set_state(rt2x00dev, STATE_SLEEP);
 		break;
 	case STATE_RADIO_RX_ON:
+		rt2800usb_start_queue(rt2x00dev->rx);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt2800usb_toggle_rx(rt2x00dev, state);
+		rt2800usb_stop_queue(rt2x00dev->rx);
 		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
@@ -389,22 +431,6 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 	}
 }
 
-static void rt2800usb_kill_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	if (queue->qid == QID_BEACON) {
-		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
-		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-	}
-
-	rt2x00usb_kill_tx_queue(queue);
-}
-
 /*
  * RX control handlers
  */
@@ -605,7 +631,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.write_beacon		= rt2800_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt2800usb_kill_tx_queue,
+	.kill_tx_queue		= rt2800usb_stop_queue,
 	.fill_rxdone		= rt2800usb_fill_rxdone,
 	.config_shared_key	= rt2800_config_shared_key,
 	.config_pairwise_key	= rt2800_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 608200e..12958a4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -268,7 +268,7 @@ void rt2x00usb_kick_tx_queue(struct data_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_kick_tx_queue);
 
-static void rt2x00usb_kill_tx_entry(struct queue_entry *entry)
+static void rt2x00usb_kill_entry(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
@@ -287,12 +287,12 @@ static void rt2x00usb_kill_tx_entry(struct queue_entry *entry)
 		usb_kill_urb(bcn_priv->guardian_urb);
 }
 
-void rt2x00usb_kill_tx_queue(struct data_queue *queue)
+void rt2x00usb_stop_queue(struct data_queue *queue)
 {
 	rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
-				   rt2x00usb_kill_tx_entry);
+				   rt2x00usb_kill_entry);
 }
-EXPORT_SYMBOL_GPL(rt2x00usb_kill_tx_queue);
+EXPORT_SYMBOL_GPL(rt2x00usb_stop_queue);
 
 static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 {
@@ -316,7 +316,7 @@ static void rt2x00usb_watchdog_tx_dma(struct data_queue *queue)
 	 * Kill all entries in the queue, afterwards we need to
 	 * wait a bit for all URBs to be cancelled.
 	 */
-	rt2x00usb_kill_tx_queue(queue);
+	rt2x00usb_stop_queue(queue);
 
 	/*
 	 * In case that a driver has overriden the txdone_work
@@ -423,7 +423,7 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 				    REGISTER_TIMEOUT);
 
 	/*
-	 * The USB version of kill_tx_queue also works
+	 * The USB version of also works
 	 * on the RX queue.
 	 */
 	rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev->rx);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index c2d997f..656a35f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -387,13 +387,13 @@ struct queue_entry_priv_usb_bcn {
 void rt2x00usb_kick_tx_queue(struct data_queue *queue);
 
 /**
- * rt2x00usb_kill_tx_queue - Kill data queue
- * @queue: Data queue to kill
+ * rt2x00usb_stop_queue - Stop data queue
+ * @queue: Data queue to stop
  *
  * This will walk through all entries of the queue and kill all
- * previously kicked frames before they can be send.
+ * URB's which were send to the device.
  */
-void rt2x00usb_kill_tx_queue(struct data_queue *queue);
+void rt2x00usb_stop_queue(struct data_queue *queue);
 
 /**
  * rt2x00usb_watchdog - Watchdog for USB communication
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 6ad0c1c..044f500 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1140,6 +1140,106 @@ dynamic_cca_tune:
 }
 
 /*
+ * Queue handlers.
+ */
+static void rt61pci_start_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+		break;
+	case QID_BEACON:
+		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt61pci_kick_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, 1);
+		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		break;
+	case QID_AC_BK:
+		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, 1);
+		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		break;
+	case QID_AC_VI:
+		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, 1);
+		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		break;
+	case QID_AC_VO:
+		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, 1);
+		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt61pci_stop_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_AC_BE:
+		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC0, 1);
+		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		break;
+	case QID_AC_BK:
+		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, 1);
+		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		break;
+	case QID_AC_VI:
+		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, 1);
+		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		break;
+	case QID_AC_VO:
+		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
+		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, 1);
+		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
+		break;
+	case QID_RX:
+		rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 1);
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
+		break;
+	case QID_BEACON:
+		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+/*
  * Firmware functions
  */
 static char *rt61pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
@@ -1616,17 +1716,6 @@ static int rt61pci_init_bbp(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static void rt61pci_toggle_rx(struct rt2x00_dev *rt2x00dev,
-			      enum dev_state state)
-{
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF));
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
-}
-
 static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
@@ -1744,8 +1833,10 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt61pci_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+		rt61pci_start_queue(rt2x00dev->rx);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt61pci_toggle_rx(rt2x00dev, state);
+		rt61pci_stop_queue(rt2x00dev->rx);
 		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
@@ -1925,41 +2016,6 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 	entry->skb = NULL;
 }
 
-static void rt61pci_kick_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, (queue->qid == QID_AC_BE));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, (queue->qid == QID_AC_BK));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, (queue->qid == QID_AC_VI));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, (queue->qid == QID_AC_VO));
-	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
-}
-
-static void rt61pci_kill_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	if (queue->qid == QID_BEACON) {
-		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
-		return;
-	}
-
-	rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC0, (queue->qid == QID_AC_BE));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, (queue->qid == QID_AC_BK));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, (queue->qid == QID_AC_VI));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, (queue->qid == QID_AC_VO));
-	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
-}
-
 /*
  * RX control handlers
  */
@@ -2846,8 +2902,8 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.link_tuner		= rt61pci_link_tuner,
 	.write_tx_desc		= rt61pci_write_tx_desc,
 	.write_beacon		= rt61pci_write_beacon,
-	.kick_tx_queue		= rt61pci_kick_tx_queue,
-	.kill_tx_queue		= rt61pci_kill_tx_queue,
+	.kick_tx_queue		= rt61pci_kick_queue,
+	.kill_tx_queue		= rt61pci_stop_queue,
 	.fill_rxdone		= rt61pci_fill_rxdone,
 	.config_shared_key	= rt61pci_config_shared_key,
 	.config_pairwise_key	= rt61pci_config_pairwise_key,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 3934dad..e9b1e3d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1031,6 +1031,57 @@ dynamic_cca_tune:
 }
 
 /*
+ * Queue handlers.
+ */
+static void rt73usb_start_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 0);
+		rt2x00usb_register_write(rt2x00dev, TXRX_CSR0, reg);
+		break;
+	case QID_BEACON:
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
+		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rt73usb_stop_queue(struct data_queue *queue)
+{
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	switch (queue->qid) {
+	case QID_RX:
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX, 1);
+		rt2x00usb_register_write(rt2x00dev, TXRX_CSR0, reg);
+		break;
+	case QID_BEACON:
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+		break;
+	default:
+		break;
+	}
+
+	rt2x00usb_stop_queue(queue);
+}
+
+/*
  * Firmware functions
  */
 static char *rt73usb_get_firmware_name(struct rt2x00_dev *rt2x00dev)
@@ -1324,17 +1375,6 @@ static int rt73usb_init_bbp(struct rt2x00_dev *rt2x00dev)
 /*
  * Device state switch handlers.
  */
-static void rt73usb_toggle_rx(struct rt2x00_dev *rt2x00dev,
-			      enum dev_state state)
-{
-	u32 reg;
-
-	rt2x00usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_DISABLE_RX,
-			   (state == STATE_RADIO_RX_OFF));
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR0, reg);
-}
-
 static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	/*
@@ -1402,8 +1442,10 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
 		rt73usb_disable_radio(rt2x00dev);
 		break;
 	case STATE_RADIO_RX_ON:
+		rt73usb_start_queue(rt2x00dev->rx);
+		break;
 	case STATE_RADIO_RX_OFF:
-		rt73usb_toggle_rx(rt2x00dev, state);
+		rt73usb_stop_queue(rt2x00dev->rx);
 		break;
 	case STATE_RADIO_IRQ_ON:
 	case STATE_RADIO_IRQ_ON_ISR:
@@ -1579,22 +1621,6 @@ static int rt73usb_get_tx_data_len(struct queue_entry *entry)
 	return length;
 }
 
-static void rt73usb_kill_tx_queue(struct data_queue *queue)
-{
-	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
-	u32 reg;
-
-	if (queue->qid == QID_BEACON) {
-		rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
-		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
-	}
-
-	rt2x00usb_kill_tx_queue(queue);
-}
-
 /*
  * RX control handlers
  */
@@ -2290,7 +2316,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.write_beacon		= rt73usb_write_beacon,
 	.get_tx_data_len	= rt73usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
-	.kill_tx_queue		= rt73usb_kill_tx_queue,
+	.kill_tx_queue		= rt73usb_stop_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_shared_key	= rt73usb_config_shared_key,
 	.config_pairwise_key	= rt73usb_config_pairwise_key,
-- 
1.7.2.3

