Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4123 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759436Ab0EMTQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 15:16:10 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/4] rt2x00: Centralize rt2800 beacon writing.
Date: Thu, 13 May 2010 21:16:06 +0200
Message-Id: <1273778166-3833-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
References: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon writing functions of rt2800pci and rt2800usb are now identical.
Move them to rt2800lib to only have one central function.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   61 ++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    2 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   63 +------------------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   63 +------------------------------
 4 files changed, 65 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 53a3257..9ee4ffa 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -378,6 +378,67 @@ void rt2800_process_rxwi(struct sk_buff *skb, struct rxdone_entry_desc *rxdesc)
 }
 EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
 
+void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
+	unsigned int beacon_base;
+	u32 reg;
+
+	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+	/*
+	 * Add space for the TXWI in front of the skb.
+	 */
+	skb_push(entry->skb, TXWI_DESC_SIZE);
+	memset(entry->skb, 0, TXWI_DESC_SIZE);
+
+	/*
+	 * Register descriptor details in skb frame descriptor.
+	 */
+	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
+	skbdesc->desc = entry->skb->data;
+	skbdesc->desc_len = TXWI_DESC_SIZE;
+
+	/*
+	 * Add the TXWI for the beacon to the skb.
+	 */
+	rt2800_write_txwi((__le32 *)entry->skb->data, txdesc);
+
+	/*
+	 * Dump beacon to userspace through debugfs.
+	 */
+	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
+
+	/*
+	 * Write entire beacon with TXWI to register.
+	 */
+	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
+	rt2800_register_multiwrite(rt2x00dev, beacon_base,
+				   entry->skb->data, entry->skb->len);
+
+	/*
+	 * Enable beaconing again.
+	 */
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
+	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+
+	/*
+	 * Clean up beacon skb.
+	 */
+	dev_kfree_skb_any(entry->skb);
+	entry->skb = NULL;
+}
+EXPORT_SYMBOL(rt2800_write_beacon);
+
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 const struct rt2x00debug rt2800_rt2x00debug = {
 	.owner	= THIS_MODULE,
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 0f0a13c..b16fd6d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -114,6 +114,8 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc);
 void rt2800_process_rxwi(struct sk_buff *skb, struct rxdone_entry_desc *txdesc);
 
+void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc);
+
 extern const struct rt2x00debug rt2800_rt2x00debug;
 
 int rt2800_rfkill_poll(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index db61a78..f271836 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -676,67 +676,6 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
-static void rt2800pci_write_beacon(struct queue_entry *entry,
-				   struct txentry_desc *txdesc)
-{
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	unsigned int beacon_base;
-	u32 reg;
-
-	/*
-	 * Disable beaconing while we are reloading the beacon data,
-	 * otherwise we might be sending out invalid data.
-	 */
-	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-	/*
-	 * Add space for the TXWI in front of the skb.
-	 */
-	skb_push(entry->skb, TXWI_DESC_SIZE);
-	memset(entry->skb, 0, TXWI_DESC_SIZE);
-
-	/*
-	 * Register descriptor details in skb frame descriptor.
-	 */
-	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
-	skbdesc->desc = entry->skb->data;
-	skbdesc->desc_len = TXWI_DESC_SIZE;
-
-	/*
-	 * Add the TXWI for the beacon to the skb.
-	 */
-	rt2800_write_txwi((__le32 *)entry->skb->data, txdesc);
-
-	/*
-	 * Dump beacon to userspace through debugfs.
-	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
-
-	/*
-	 * Write entire beacon with TXWI to register.
-	 */
-	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2800_register_multiwrite(rt2x00dev, beacon_base,
-				   entry->skb->data, entry->skb->len);
-
-	/*
-	 * Enable beaconing again.
-	 */
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-	/*
-	 * Clean up beacon skb.
-	 */
-	dev_kfree_skb_any(entry->skb);
-	entry->skb = NULL;
-}
-
 static void rt2800pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 				    const enum data_queue_qid queue_idx)
 {
@@ -1074,7 +1013,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.write_tx_desc		= rt2800pci_write_tx_desc,
 	.write_tx_data		= rt2x00pci_write_tx_data,
 	.write_tx_datadesc	= rt2800pci_write_tx_datadesc,
-	.write_beacon		= rt2800pci_write_beacon,
+	.write_beacon		= rt2800_write_beacon,
 	.kick_tx_queue		= rt2800pci_kick_tx_queue,
 	.kill_tx_queue		= rt2800pci_kill_tx_queue,
 	.fill_rxdone		= rt2800pci_fill_rxdone,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 0f0a4f5..8a15ffb 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -432,67 +432,6 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
-static void rt2800usb_write_beacon(struct queue_entry *entry,
-				   struct txentry_desc *txdesc)
-{
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
-	unsigned int beacon_base;
-	u32 reg;
-
-	/*
-	 * Disable beaconing while we are reloading the beacon data,
-	 * otherwise we might be sending out invalid data.
-	 */
-	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-	/*
-	 * Add space for the TXWI in front of the skb.
-	 */
-	skb_push(entry->skb, TXWI_DESC_SIZE);
-	memset(entry->skb, 0, TXWI_DESC_SIZE);
-
-	/*
-	 * Register descriptor details in skb frame descriptor.
-	 */
-	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
-	skbdesc->desc = entry->skb->data;
-	skbdesc->desc_len = TXWI_DESC_SIZE;
-
-	/*
-	 * Add the TXWI for the beacon to the skb.
-	 */
-	rt2800_write_txwi((__le32 *) entry->skb->data, txdesc);
-
-	/*
-	 * Dump beacon to userspace through debugfs.
-	 */
-	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
-
-	/*
-	 * Write entire beacon with descriptor to register.
-	 */
-	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
-	rt2800_register_multiwrite(rt2x00dev, beacon_base,
-				   entry->skb->data, entry->skb->len);
-
-	/*
-	 * Enable beaconing again.
-	 */
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 1);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 1);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
-
-	/*
-	 * Clean up the beacon skb.
-	 */
-	dev_kfree_skb(entry->skb);
-	entry->skb = NULL;
-}
-
 static int rt2800usb_get_tx_data_len(struct queue_entry *entry)
 {
 	int length;
@@ -674,7 +613,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
-	.write_beacon		= rt2800usb_write_beacon,
+	.write_beacon		= rt2800_write_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.kick_tx_queue		= rt2x00usb_kick_tx_queue,
 	.kill_tx_queue		= rt2x00usb_kill_tx_queue,
-- 
1.7.1

