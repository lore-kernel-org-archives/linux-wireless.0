Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:45263 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0LMLkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 06:40:18 -0500
Received: by mail-ey0-f171.google.com with SMTP id 5so4064715eyg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 03:40:17 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/17] rt2x00: Don't frequently reset beacon interval in AdHoc mode
Date: Mon, 13 Dec 2010 12:33:36 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131232.50201.IvDoorn@gmail.com> <201012131233.13651.IvDoorn@gmail.com>
In-Reply-To: <201012131233.13651.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012131233.37326.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Commit 0204464329c17ba6d293e1899f71223599a0e582 "Check for specific changed
flags when updating the erp config" changed the way in which a new beacon
interval gets handled. However, due to a bug in rt2800usb and rt2800pci the
beacon interval was reset during each scan, thus causing problems in AdHoc
mode.

Fix this by not cleaning up the beacon interval when killing the beacon queue
but just prevent the device from sending out beacons.

Reported-by: Wolfgang Kufner <wolfgang.kufner@gmail.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    6 +++++-
 drivers/net/wireless/rt2x00/rt2500pci.c |    6 +++++-
 drivers/net/wireless/rt2x00/rt2500usb.c |   12 ++++++++++--
 drivers/net/wireless/rt2x00/rt2800pci.c |    6 +++++-
 drivers/net/wireless/rt2x00/rt2800usb.c |   12 ++++++++++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    6 +++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |   12 ++++++++++--
 7 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 9ec6691..6278660 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1140,7 +1140,11 @@ static void rt2400pci_kill_tx_queue(struct data_queue *queue)
 	u32 reg;
 
 	if (queue->qid == QID_BEACON) {
-		rt2x00pci_register_write(rt2x00dev, CSR14, 0);
+		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+		rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	} else {
 		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
 		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3e7f203..ce9212f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1294,7 +1294,11 @@ static void rt2500pci_kill_tx_queue(struct data_queue *queue)
 	u32 reg;
 
 	if (queue->qid == QID_BEACON) {
-		rt2x00pci_register_write(rt2x00dev, CSR14, 0);
+		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+		rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	} else {
 		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
 		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 8152fec..bbfa671 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1205,8 +1205,16 @@ static int rt2500usb_get_tx_data_len(struct queue_entry *entry)
 
 static void rt2500usb_kill_tx_queue(struct data_queue *queue)
 {
-	if (queue->qid == QID_BEACON)
-		rt2500usb_register_write(queue->rt2x00dev, TXRX_CSR19, 0);
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u16 reg;
+
+	if (queue->qid == QID_BEACON) {
+		rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 0);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 0);
+		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+	}
 
 	rt2x00usb_kill_tx_queue(queue);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 3a1468a..bea8352 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -588,7 +588,11 @@ static void rt2800pci_kill_tx_queue(struct data_queue *queue)
 	u32 reg;
 
 	if (queue->qid == QID_BEACON) {
-		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, 0);
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 		return;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 042e47d..a150fcc 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -391,8 +391,16 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 
 static void rt2800usb_kill_tx_queue(struct data_queue *queue)
 {
-	if (queue->qid == QID_BEACON)
-		rt2x00usb_register_write(queue->rt2x00dev, BCN_TIME_CFG, 0);
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	if (queue->qid == QID_BEACON) {
+		rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	}
 
 	rt2x00usb_kill_tx_queue(queue);
 }
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 6b09b01..6ad0c1c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1944,7 +1944,11 @@ static void rt61pci_kill_tx_queue(struct data_queue *queue)
 	u32 reg;
 
 	if (queue->qid == QID_BEACON) {
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, 0);
+		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 		return;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 6f04552..3934dad 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1581,8 +1581,16 @@ static int rt73usb_get_tx_data_len(struct queue_entry *entry)
 
 static void rt73usb_kill_tx_queue(struct data_queue *queue)
 {
-	if (queue->qid == QID_BEACON)
-		rt2x00usb_register_write(queue->rt2x00dev, TXRX_CSR9, 0);
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
+	u32 reg;
+
+	if (queue->qid == QID_BEACON) {
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+	}
 
 	rt2x00usb_kill_tx_queue(queue);
 }
-- 
1.7.2.3

