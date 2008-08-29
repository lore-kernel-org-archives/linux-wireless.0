Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:61799 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbYH2TIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 15:08:02 -0400
Received: by ey-out-2122.google.com with SMTP id 6so320107eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 12:08:01 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 4/7] rt2x00: Initialize txop during conf_tx() callback
Date: Fri, 29 Aug 2008 21:05:45 +0200
Cc: "rt2400-devel" <rt2400-devel@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <200808292103.53179.IvDoorn@gmail.com> <200808292104.50501.IvDoorn@gmail.com> <200808292105.21378.IvDoorn@gmail.com>
In-Reply-To: <200808292105.21378.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808292105.45380.IvDoorn@gmail.com> (sfid-20080829_210808_281138_4ED27F1E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The txop parameter is supported by rt61pci and rt73usb,
and thus should be written to the register instead
of using the fixed value set during initialization.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    5 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 +
 drivers/net/wireless/rt2x00/rt61pci.c     |   69 ++++++++++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt73usb.c     |   69 ++++++++++++++++++++++++-----
 5 files changed, 122 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 64292c2..56829fa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -666,10 +666,11 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 		queue->cw_max = 10; /* cw_min: 2^10 = 1024. */
 
 	queue->aifs = params->aifs;
+	queue->txop = params->txop;
 
 	INFO(rt2x00dev,
-	     "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d.\n",
-	     queue_idx, queue->cw_min, queue->cw_max, queue->aifs);
+	     "Configured TX queue %d - CWmin: %d, CWmax: %d, Aifs: %d, TXop: %d.\n",
+	     queue_idx, queue->cw_min, queue->cw_max, queue->aifs, queue->txop);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2822684..a5e9650 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -736,6 +736,7 @@ static void rt2x00queue_init(struct rt2x00_dev *rt2x00dev,
 
 	queue->rt2x00dev = rt2x00dev;
 	queue->qid = qid;
+	queue->txop = 0;
 	queue->aifs = 2;
 	queue->cw_min = 5;
 	queue->cw_max = 10;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 37f3f98..654fa0c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -368,6 +368,7 @@ enum queue_index {
  * @length: Number of frames in queue.
  * @index: Index pointers to entry positions in the queue,
  *	use &enum queue_index to get a specific index field.
+ * @txop: maximum burst time.
  * @aifs: The aifs value for outgoing frames (field ignored in RX queue).
  * @cw_min: The cw min value for outgoing frames (field ignored in RX queue).
  * @cw_max: The cw max value for outgoing frames (field ignored in RX queue).
@@ -387,6 +388,7 @@ struct data_queue {
 	unsigned short length;
 	unsigned short index[Q_INDEX_MAX];
 
+	unsigned short txop;
 	unsigned short aifs;
 	unsigned short cw_min;
 	unsigned short cw_max;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 9d27ce0..5253710 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1478,16 +1478,6 @@ static int rt61pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00pci_register_write(rt2x00dev, M2H_CMD_DONE_CSR, 0xffffffff);
 
-	rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR0, &reg);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR0_AC0_TX_OP, 0);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR0_AC1_TX_OP, 0);
-	rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR0, reg);
-
-	rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR1, &reg);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR1_AC2_TX_OP, 192);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR1_AC3_TX_OP, 48);
-	rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR1, reg);
-
 	/*
 	 * Clear all beacons
 	 * For the Beacon base registers we only need to clear
@@ -2652,6 +2642,63 @@ static int rt61pci_set_retry_limit(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int rt61pci_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+			   const struct ieee80211_tx_queue_params *params)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_queue *queue;
+	struct rt2x00_field32 field;
+	int retval;
+	u32 reg;
+
+	/*
+	 * First pass the configuration through rt2x00lib, that will
+	 * update the queue settings and validate the input. After that
+	 * we are free to update the registers based on the value
+	 * in the queue parameter.
+	 */
+	retval = rt2x00mac_conf_tx(hw, queue_idx, params);
+	if (retval)
+		return retval;
+
+	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+
+	/* Update WMM TXOP register */
+	if (queue_idx < 2) {
+		field.bit_offset = queue_idx * 16;
+		field.bit_mask = 0xffff << field.bit_offset;
+
+		rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR0, &reg);
+		rt2x00_set_field32(&reg, field, queue->txop);
+		rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR0, reg);
+	} else if (queue_idx < 4) {
+		field.bit_offset = (queue_idx - 2) * 16;
+		field.bit_mask = 0xffff << field.bit_offset;
+
+		rt2x00pci_register_read(rt2x00dev, AC_TXOP_CSR1, &reg);
+		rt2x00_set_field32(&reg, field, queue->txop);
+		rt2x00pci_register_write(rt2x00dev, AC_TXOP_CSR1, reg);
+	}
+
+	/* Update WMM registers */
+	field.bit_offset = queue_idx * 4;
+	field.bit_mask = 0xf << field.bit_offset;
+
+	rt2x00pci_register_read(rt2x00dev, AIFSN_CSR, &reg);
+	rt2x00_set_field32(&reg, field, queue->aifs);
+	rt2x00pci_register_write(rt2x00dev, AIFSN_CSR, reg);
+
+	rt2x00pci_register_read(rt2x00dev, CWMIN_CSR, &reg);
+	rt2x00_set_field32(&reg, field, queue->cw_min);
+	rt2x00pci_register_write(rt2x00dev, CWMIN_CSR, reg);
+
+	rt2x00pci_register_read(rt2x00dev, CWMAX_CSR, &reg);
+	rt2x00_set_field32(&reg, field, queue->cw_max);
+	rt2x00pci_register_write(rt2x00dev, CWMAX_CSR, reg);
+
+	return 0;
+}
+
 static u64 rt61pci_get_tsf(struct ieee80211_hw *hw)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -2679,7 +2726,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt61pci_set_retry_limit,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
-	.conf_tx		= rt2x00mac_conf_tx,
+	.conf_tx		= rt61pci_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt61pci_get_tsf,
 };
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index f58fd05..636b4e0 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1277,16 +1277,6 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt73usb_register_write(rt2x00dev, PHY_CSR6, 0x00080606);
 	rt73usb_register_write(rt2x00dev, PHY_CSR7, 0x00000408);
 
-	rt73usb_register_read(rt2x00dev, AC_TXOP_CSR0, &reg);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR0_AC0_TX_OP, 0);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR0_AC1_TX_OP, 0);
-	rt73usb_register_write(rt2x00dev, AC_TXOP_CSR0, reg);
-
-	rt73usb_register_read(rt2x00dev, AC_TXOP_CSR1, &reg);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR1_AC2_TX_OP, 192);
-	rt2x00_set_field32(&reg, AC_TXOP_CSR1_AC3_TX_OP, 48);
-	rt73usb_register_write(rt2x00dev, AC_TXOP_CSR1, reg);
-
 	rt73usb_register_read(rt2x00dev, MAC_CSR9, &reg);
 	rt2x00_set_field32(&reg, MAC_CSR9_CW_SELECT, 0);
 	rt73usb_register_write(rt2x00dev, MAC_CSR9, reg);
@@ -2246,6 +2236,63 @@ static int rt73usb_set_retry_limit(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int rt73usb_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
+			   const struct ieee80211_tx_queue_params *params)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_queue *queue;
+	struct rt2x00_field32 field;
+	int retval;
+	u32 reg;
+
+	/*
+	 * First pass the configuration through rt2x00lib, that will
+	 * update the queue settings and validate the input. After that
+	 * we are free to update the registers based on the value
+	 * in the queue parameter.
+	 */
+	retval = rt2x00mac_conf_tx(hw, queue_idx, params);
+	if (retval)
+		return retval;
+
+	queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
+
+	/* Update WMM TXOP register */
+	if (queue_idx < 2) {
+		field.bit_offset = queue_idx * 16;
+		field.bit_mask = 0xffff << field.bit_offset;
+
+		rt73usb_register_read(rt2x00dev, AC_TXOP_CSR0, &reg);
+		rt2x00_set_field32(&reg, field, queue->txop);
+		rt73usb_register_write(rt2x00dev, AC_TXOP_CSR0, reg);
+	} else if (queue_idx < 4) {
+		field.bit_offset = (queue_idx - 2) * 16;
+		field.bit_mask = 0xffff << field.bit_offset;
+
+		rt73usb_register_read(rt2x00dev, AC_TXOP_CSR1, &reg);
+		rt2x00_set_field32(&reg, field, queue->txop);
+		rt73usb_register_write(rt2x00dev, AC_TXOP_CSR1, reg);
+	}
+
+	/* Update WMM registers */
+	field.bit_offset = queue_idx * 4;
+	field.bit_mask = 0xf << field.bit_offset;
+
+	rt73usb_register_read(rt2x00dev, AIFSN_CSR, &reg);
+	rt2x00_set_field32(&reg, field, queue->aifs);
+	rt73usb_register_write(rt2x00dev, AIFSN_CSR, reg);
+
+	rt73usb_register_read(rt2x00dev, CWMIN_CSR, &reg);
+	rt2x00_set_field32(&reg, field, queue->cw_min);
+	rt73usb_register_write(rt2x00dev, CWMIN_CSR, reg);
+
+	rt73usb_register_read(rt2x00dev, CWMAX_CSR, &reg);
+	rt2x00_set_field32(&reg, field, queue->cw_max);
+	rt73usb_register_write(rt2x00dev, CWMAX_CSR, reg);
+
+	return 0;
+}
+
 #if 0
 /*
  * Mac80211 demands get_tsf must be atomic.
@@ -2283,7 +2330,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.set_retry_limit	= rt73usb_set_retry_limit,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
-	.conf_tx		= rt2x00mac_conf_tx,
+	.conf_tx		= rt73usb_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt73usb_get_tsf,
 };
-- 
1.5.6.1

