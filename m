Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4415 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbXLCLpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:14 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 15/34] iwlwifi: add comments to iwl*-base.c
Date: Mon,  3 Dec 2007 13:43:27 +0200
Message-Id: <1196682230754-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120558_738271_0443248F)
In-Reply-To: <11966822302007-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

Resend. Replace mail subject due to ML restriction for capital Triple-X
in subject.

On Thu, 2007-11-29 at 11:09 +0800, Zhu Yi wrote:
From: Cahill, Ben M <ben.m.cahill@intel.com>

Add comments to iwlXXXX-base.c

Signed-off-by: Cahill, Ben M <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  215 ++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  209 ++++++++++++++++++++++----
 2 files changed, 354 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 775f9a1..1808464 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -63,13 +63,13 @@ static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
  ******************************************************************************/
 
 /* module parameters */
-static int iwl3945_param_disable_hw_scan;
-static int iwl3945_param_debug;
-static int iwl3945_param_disable;  /* def: enable radio */
+static int iwl3945_param_disable_hw_scan; /* def: 0 = use 3945's h/w scan */
+static int iwl3945_param_debug;    /* def: 0 = minimal debug log messages */
+static int iwl3945_param_disable;  /* def: 0 = enable radio */
 static int iwl3945_param_antenna;  /* def: 0 = both antennas (use diversity) */
-int iwl3945_param_hwcrypto;        /* def: using software encryption */
-static int iwl3945_param_qos_enable = 1;
-int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES;
+int iwl3945_param_hwcrypto;        /* def: 0 = use software encryption */
+static int iwl3945_param_qos_enable = 1; /* def: 1 = use quality of service */
+int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 8 Tx queues */
 
 /*
  * module name, copyright, version, etc.
@@ -184,17 +184,24 @@ static void iwl3945_print_hex_dump(int level, void *p, u32 len)
  *
  * Theory of operation
  *
- * A queue is a circular buffers with 'Read' and 'Write' pointers.
- * 2 empty entries always kept in the buffer to protect from overflow.
+ * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
+ * of buffer descriptors, each of which points to one or more data buffers for
+ * the device to read from or fill.  Driver and device exchange status of each
+ * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
+ * entries in each circular buffer, to protect against confusing empty and full
+ * queue states.
+ *
+ * The device reads or writes the data in the queues via the device's several
+ * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
  *
  * For Tx queue, there are low mark and high mark limits. If, after queuing
  * the packet for Tx, free space become < low mark, Tx queue stopped. When
  * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
  * Tx queue resumed.
  *
- * The IWL operates with six queues, one receive queue in the device's
- * sram, one transmit queue for sending commands to the device firmware,
- * and four transmit queues for data.
+ * The 3945 operates with six queues:  One receive queue, one transmit queue
+ * (#4) for sending commands to the device firmware, and four transmit queues
+ * (#0-3) for data tx via EDCA.  An additional 2 HCCA queues are unused.
  ***************************************************/
 
 static int iwl3945_queue_space(const struct iwl3945_queue *q)
@@ -213,13 +220,21 @@ static int iwl3945_queue_space(const struct iwl3945_queue *q)
 	return s;
 }
 
-/* XXX: n_bd must be power-of-two size */
+/**
+ * iwl3945_queue_inc_wrap - increment queue index, wrap back to beginning
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
 static inline int iwl3945_queue_inc_wrap(int index, int n_bd)
 {
 	return ++index & (n_bd - 1);
 }
 
-/* XXX: n_bd must be power-of-two size */
+/**
+ * iwl3945_queue_dec_wrap - increment queue index, wrap back to end
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
 static inline int iwl3945_queue_dec_wrap(int index, int n_bd)
 {
 	return --index & (n_bd - 1);
@@ -234,12 +249,17 @@ static inline int x2_queue_used(const struct iwl3945_queue *q, int i)
 
 static inline u8 get_cmd_index(struct iwl3945_queue *q, u32 index, int is_huge)
 {
+	/* This is for scan command, the big buffer at end of command array */
 	if (is_huge)
-		return q->n_window;
+		return q->n_window;	/* must be power of 2 */
 
+	/* Otherwise, use normal size buffers */
 	return index & (q->n_window - 1);
 }
 
+/**
+ * iwl3945_queue_init - Initialize queue's high/low-water and read/write indexes
+ */
 static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl3945_queue *q,
 			  int count, int slots_num, u32 id)
 {
@@ -268,11 +288,16 @@ static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl3945_queue *q
 	return 0;
 }
 
+/**
+ * iwl3945_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
+ */
 static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
 			      struct iwl3945_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
 
+	/* Driver private data, only for Tx (not command) queues,
+	 * not shared with device. */
 	if (id != IWL_CMD_QUEUE_NUM) {
 		txq->txb = kmalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
@@ -284,6 +309,8 @@ static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
 	} else
 		txq->txb = NULL;
 
+	/* Circular buffer of transmit frame descriptors (TFDs),
+	 * shared with device */
 	txq->bd = pci_alloc_consistent(dev,
 			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
 			&txq->q.dma_addr);
@@ -306,6 +333,9 @@ static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
 	return -ENOMEM;
 }
 
+/**
+ * iwl3945_tx_queue_init - Allocate and initialize one tx/cmd queue
+ */
 int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
 		      struct iwl3945_tx_queue *txq, int slots_num, u32 txq_id)
 {
@@ -313,9 +343,14 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
 	int len;
 	int rc = 0;
 
-	/* allocate command space + one big command for scan since scan
-	 * command is very huge the system will not have two scan at the
-	 * same time */
+	/*
+	 * Alloc buffer array for commands (Tx or other types of commands).
+	 * For the command queue (#4), allocate command space + one big
+	 * command for scan, since scan command is very huge; the system will
+	 * not have two scans at the same time, so only one is needed.
+	 * For data Tx queues (all other queues), no super-size command
+	 * space is needed.
+	 */
 	len = sizeof(struct iwl3945_cmd) * slots_num;
 	if (txq_id == IWL_CMD_QUEUE_NUM)
 		len +=  IWL_MAX_SCAN_SIZE;
@@ -323,6 +358,7 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
 	if (!txq->cmd)
 		return -ENOMEM;
 
+	/* Alloc driver data array and TFD circular buffer */
 	rc = iwl3945_tx_queue_alloc(priv, txq, txq_id);
 	if (rc) {
 		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
@@ -334,8 +370,11 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl3945_queue_inc_wrap and iwl3945_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
+
+	/* Initialize queue high/low-water, head/tail indexes */
 	iwl3945_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
+	/* Tell device where to find queue, enable DMA channel. */
 	iwl3945_hw_tx_queue_init(priv, txq);
 
 	return 0;
@@ -346,8 +385,8 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
  * @txq: Transmit queue to deallocate.
  *
  * Empty queue by removing and destroying all BD's.
- * Free all buffers.  txq itself is not freed.
- *
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
  */
 void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
 {
@@ -367,19 +406,21 @@ void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *t
 	if (q->id == IWL_CMD_QUEUE_NUM)
 		len += IWL_MAX_SCAN_SIZE;
 
+	/* De-alloc array of command/tx buffers */
 	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
 
-	/* free buffers belonging to queue itself */
+	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
 		pci_free_consistent(dev, sizeof(struct iwl3945_tfd_frame) *
 				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
 
+	/* De-alloc array of per-TFD driver data */
 	if (txq->txb) {
 		kfree(txq->txb);
 		txq->txb = NULL;
 	}
 
-	/* 0 fill whole structure */
+	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
 }
 
@@ -392,6 +433,11 @@ const u8 iwl3945_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
 
 /**************************************************************/
 #if 0 /* temporary disable till we add real remove station */
+/**
+ * iwl3945_remove_station - Remove driver's knowledge of station.
+ *
+ * NOTE:  This does not remove station from device's station table.
+ */
 static u8 iwl3945_remove_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
@@ -428,6 +474,12 @@ out:
 	return 0;
 }
 #endif
+
+/**
+ * iwl3945_clear_stations_table - Clear the driver's station table
+ *
+ * NOTE:  This does not clear or otherwise alter the device's station table.
+ */
 static void iwl3945_clear_stations_table(struct iwl3945_priv *priv)
 {
 	unsigned long flags;
@@ -440,7 +492,9 @@ static void iwl3945_clear_stations_table(struct iwl3945_priv *priv)
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-
+/**
+ * iwl3945_add_station - Add station to station tables in driver and device
+ */
 u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8 flags)
 {
 	int i;
@@ -486,6 +540,7 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
 	station->used = 1;
 	priv->num_stations++;
 
+	/* Set up the REPLY_ADD_STA command to send to device */
 	memset(&station->sta, 0, sizeof(struct iwl3945_addsta_cmd));
 	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
 	station->sta.mode = 0;
@@ -504,6 +559,8 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
 			le16_to_cpu(station->sta.rate_n_flags);
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+
+	/* Add station to device's station table */
 	iwl3945_send_add_station(priv, &station->sta, flags);
 	return index;
 
@@ -673,6 +730,8 @@ static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_c
 		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
 
 	txq->need_update = 1;
+
+	/* Increment and update queue's write index */
 	q->write_ptr = iwl3945_queue_inc_wrap(q->write_ptr, q->n_bd);
 	ret = iwl3945_tx_queue_update_write_ptr(priv, txq);
 
@@ -1511,7 +1570,7 @@ static void get_eeprom_mac(struct iwl3945_priv *priv, u8 *mac)
 /**
  * iwl3945_eeprom_init - read EEPROM contents
  *
- * Load the EEPROM from adapter into priv->eeprom
+ * Load the EEPROM contents from adapter into priv->eeprom
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
@@ -1536,6 +1595,7 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 		return -ENOENT;
 	}
 
+	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
 	rc = iwl3945_eeprom_acquire_semaphore(priv);
 	if (rc < 0) {
 		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
@@ -2631,21 +2691,23 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
 	cmd->cmd.tx.next_frame_len = 0;
 }
 
+/**
+ * iwl3945_get_sta_id - Find station's index within station table
+ */
 static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *hdr)
 {
 	int sta_id;
 	u16 fc = le16_to_cpu(hdr->frame_control);
 
-	/* If this frame is broadcast or not data then use the broadcast
-	 * station id */
+	/* If this frame is broadcast or management, use broadcast station id */
 	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
 	    is_multicast_ether_addr(hdr->addr1))
 		return priv->hw_setting.bcast_sta_id;
 
 	switch (priv->iw_mode) {
 
-	/* If this frame is part of a BSS network (we're a station), then
-	 * we use the AP's station id */
+	/* If we are a client station in a BSS network, use the special
+	 * AP station entry (that's the only station we communicate with) */
 	case IEEE80211_IF_TYPE_STA:
 		return IWL_AP_ID;
 
@@ -2656,11 +2718,12 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
 			return sta_id;
 		return priv->hw_setting.bcast_sta_id;
 
-	/* If this frame is part of a IBSS network, then we use the
-	 * target specific station id */
+	/* If this frame is going out to an IBSS network, find the station,
+	 * or create a new station table entry */
 	case IEEE80211_IF_TYPE_IBSS: {
 		DECLARE_MAC_BUF(mac);
 
+		/* Create new station table entry */
 		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
@@ -2746,6 +2809,8 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	hdr_len = ieee80211_get_hdrlen(fc);
+
+	/* Find (or create) index into station table for destination station */
 	sta_id = iwl3945_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);
@@ -2767,30 +2832,52 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
 		seq_number += 0x10;
 	}
+
+	/* Descriptor for chosen Tx queue */
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
+	/* Set up first empty TFD within this queue's circular TFD buffer */
 	tfd = &txq->bd[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 	control_flags = (u32 *) tfd;
 	idx = get_cmd_index(q, q->write_ptr, 0);
 
+	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl3945_tx_info));
 	txq->txb[q->write_ptr].skb[0] = skb;
 	memcpy(&(txq->txb[q->write_ptr].status.control),
 	       ctl, sizeof(struct ieee80211_tx_control));
+
+	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = &txq->cmd[idx];
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
+
+	/*
+	 * Set up the Tx-command (not MAC!) header.
+	 * Store the chosen Tx queue and TFD index within the sequence field;
+	 * after Tx, uCode's Tx response will return this value so driver can
+	 * locate the frame within the tx queue and do post-tx processing.
+	 */
 	out_cmd->hdr.cmd = REPLY_TX;
 	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 				INDEX_TO_SEQ(q->write_ptr)));
-	/* copy frags header */
+
+	/* Copy MAC header from skb into command buffer */
 	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
 
-	/* hdr = (struct ieee80211_hdr *)out_cmd->cmd.tx.hdr; */
+	/*
+	 * Use the first empty entry in this queue's command buffer array
+	 * to contain the Tx command and MAC header concatenated together
+	 * (payload data will be in another buffer).
+	 * Size of this varies, due to varying MAC header length.
+	 * If end is not dword aligned, we'll have 2 extra bytes at the end
+	 * of the MAC header (device reads on dword boundaries).
+	 * We'll tell device about this padding later.
+	 */
 	len = priv->hw_setting.tx_cmd_len +
 		sizeof(struct iwl3945_cmd_header) + hdr_len;
 
@@ -2802,15 +2889,20 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 	else
 		len_org = 0;
 
+	/* Physical address of this Tx command's header (not MAC header!),
+	 * within command buffer array. */
 	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl3945_cmd) * idx +
 		     offsetof(struct iwl3945_cmd, hdr);
 
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
 	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
 	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		iwl3945_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
 
-	/* 802.11 null functions have no payload... */
+	/* Set up TFD's 2nd entry to point directly to remainder of skb,
+	 * if any (802.11 null frames have no payload). */
 	len = skb->len - hdr_len;
 	if (len) {
 		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
@@ -2818,13 +2910,16 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 		iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
 	}
 
-	/* If there is no payload, then only one TFD is used */
 	if (!len)
+		/* If there is no payload, then we use only one Tx buffer */
 		*control_flags = TFD_CTL_COUNT_SET(1);
 	else
+		/* Else use 2 buffers.
+		 * Tell 3945 about any padding after MAC header */
 		*control_flags = TFD_CTL_COUNT_SET(2) |
 			TFD_CTL_PAD_SET(U32_PAD(len));
 
+	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
 	out_cmd->cmd.tx.len = cpu_to_le16(len);
 
@@ -2854,6 +2949,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
 	iwl3945_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
 			   ieee80211_get_hdrlen(fc));
 
+	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl3945_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl3945_tx_queue_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -3329,11 +3425,11 @@ static void iwl3945_txstatus_to_ieee(struct iwl3945_priv *priv,
 }
 
 /**
- * iwl3945_tx_queue_reclaim - Reclaim Tx queue entries no more used by NIC.
+ * iwl3945_tx_queue_reclaim - Reclaim Tx queue entries already Tx'd
  *
- * When FW advances 'R' index, all entries between old and
- * new 'R' index need to be reclaimed. As result, some free space
- * forms. If there is enough free space (> low mark), wake Tx queue.
+ * When FW advances 'R' index, all entries between old and new 'R' index
+ * need to be reclaimed. As result, some free space forms. If there is
+ * enough free space (> low mark), wake the stack that feeds us.
  */
 static int iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv, int txq_id, int index)
 {
@@ -3382,6 +3478,9 @@ static int iwl3945_is_tx_success(u32 status)
  * Generic RX handler implementations
  *
  ******************************************************************************/
+/**
+ * iwl3945_rx_reply_tx - Handle Tx response
+ */
 static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
 			    struct iwl3945_rx_mem_buffer *rxb)
 {
@@ -3917,6 +4016,7 @@ int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_
 	if (q->need_update == 0)
 		goto exit_unlock;
 
+	/* If power-saving is in use, make sure device is awake */
 	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
 		reg = iwl3945_read32(priv, CSR_UCODE_DRV_GP1);
 
@@ -3930,10 +4030,14 @@ int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_
 		if (rc)
 			goto exit_unlock;
 
+		/* Device expects a multiple of 8 */
 		iwl3945_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
 				     q->write & ~0x7);
 		iwl3945_release_nic_access(priv);
+
+	/* Else device is assumed to be awake */
 	} else
+		/* Device expects a multiple of 8 */
 		iwl3945_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
 
 
@@ -3975,9 +4079,12 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write & ~0x7;
 	while ((iwl3945_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
 		rxb = list_entry(element, struct iwl3945_rx_mem_buffer, list);
 		list_del(element);
+
+		/* Point to Rx buffer via next RBD in circular buffer */
 		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->dma_addr);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
@@ -3990,7 +4097,8 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
 		queue_work(priv->workqueue, &priv->rx_replenish);
 
 
-	/* If we've added more space for the firmware to place data, tell it */
+	/* If we've added more space for the firmware to place data, tell it.
+	 * Increment device's write pointer in multiples of 8. */
 	if ((write != (rxq->write & ~0x7))
 	    || (abs(rxq->write - rxq->read) > 7)) {
 		spin_lock_irqsave(&rxq->lock, flags);
@@ -4023,6 +4131,8 @@ void iwl3945_rx_replenish(void *data)
 	while (!list_empty(&rxq->rx_used)) {
 		element = rxq->rx_used.next;
 		rxb = list_entry(element, struct iwl3945_rx_mem_buffer, list);
+
+		/* Alloc a new receive buffer */
 		rxb->skb =
 		    alloc_skb(IWL_RX_BUF_SIZE, __GFP_NOWARN | GFP_ATOMIC);
 		if (!rxb->skb) {
@@ -4036,6 +4146,8 @@ void iwl3945_rx_replenish(void *data)
 		}
 		priv->alloc_rxb_skb++;
 		list_del(element);
+
+		/* Get physical address of RB/SKB */
 		rxb->dma_addr =
 		    pci_map_single(priv->pci_dev, rxb->skb->data,
 				   IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
@@ -4080,12 +4192,16 @@ int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv)
 	spin_lock_init(&rxq->lock);
 	INIT_LIST_HEAD(&rxq->rx_free);
 	INIT_LIST_HEAD(&rxq->rx_used);
+
+	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
 	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
 	if (!rxq->bd)
 		return -ENOMEM;
+
 	/* Fill the rx_used queue with _all_ of the Rx buffers */
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+
 	/* Set us so that we have processed and used all buffers, but have
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
@@ -4217,6 +4333,8 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 	int reclaim;
 	unsigned long flags;
 
+	/* uCode's read index (stored in shared DRAM) indicates the last Rx
+	 * buffer that the driver may process (last buffer filled by ucode). */
 	r = iwl3945_hw_get_rx_read(priv);
 	i = rxq->read;
 
@@ -4297,6 +4415,9 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
 	iwl3945_rx_queue_restock(priv);
 }
 
+/**
+ * iwl3945_tx_queue_update_write_ptr - Send new write index to hardware
+ */
 static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
 				  struct iwl3945_tx_queue *txq)
 {
@@ -4924,6 +5045,11 @@ static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int ban
 	}
 }
 
+/**
+ * iwl3945_get_channel_info - Find driver's private channel info
+ *
+ * Based on band and channel number.
+ */
 const struct iwl3945_channel_info *iwl3945_get_channel_info(const struct iwl3945_priv *priv,
 						    int phymode, u16 channel)
 {
@@ -4951,6 +5077,9 @@ const struct iwl3945_channel_info *iwl3945_get_channel_info(const struct iwl3945
 #define CHECK_AND_PRINT(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
 
+/**
+ * iwl3945_init_channel_map - Set up driver's info for all possible channels
+ */
 static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 {
 	int eeprom_ch_count = 0;
@@ -5060,6 +5189,7 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 		}
 	}
 
+	/* Set up txpower settings in driver for all channels */
 	if (iwl3945_txpower_set_from_eeprom(priv))
 		return -EIO;
 
@@ -8303,6 +8433,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	struct ieee80211_hw *hw;
 	int i;
 
+	/* Disabling hardware scan means that mac80211 will perform scans
+	 * "the hard way", rather than using device's scan. */
 	if (iwl3945_param_disable_hw_scan) {
 		IWL_DEBUG_INFO("Disabling hw_scan\n");
 		iwl3945_hw_ops.hw_scan = NULL;
@@ -8333,6 +8465,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->hw = hw;
 
 	priv->pci_dev = pdev;
+
+	/* Select antenna (may be helpful if only one antenna is connected) */
 	priv->antenna = (enum iwl3945_antenna)iwl3945_param_antenna;
 #ifdef CONFIG_IWL3945_DEBUG
 	iwl3945_debug_level = iwl3945_param_debug;
@@ -8354,6 +8488,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Tell mac80211 our Tx characteristics */
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
 
+	/* 4 EDCA QOS priorities */
 	hw->queues = 4;
 
 	spin_lock_init(&priv->lock);
@@ -8374,6 +8509,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_set_master(pdev);
 
+	/* Clear the driver's (not device's) station table */
 	iwl3945_clear_stations_table(priv);
 
 	priv->data_retry_limit = -1;
@@ -8393,9 +8529,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err)
 		goto out_pci_disable_device;
+
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, 0x41, 0x00);
+
 	priv->hw_base = pci_iomap(pdev, 0, 0);
 	if (!priv->hw_base) {
 		err = -ENODEV;
@@ -8408,6 +8546,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* Initialize module parameter values here */
 
+	/* Disable radio (SW RF KILL) via parameter when loading driver */
 	if (iwl3945_param_disable) {
 		set_bit(STATUS_RF_KILL_SW, &priv->status);
 		IWL_DEBUG_INFO("Radio disabled.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 03c3af8..ddeedf6 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -63,13 +63,13 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
  ******************************************************************************/
 
 /* module parameters */
-static int iwl4965_param_disable_hw_scan;
-static int iwl4965_param_debug;
+static int iwl4965_param_disable_hw_scan; /* def: 0 = use 4965's h/w scan */
+static int iwl4965_param_debug;    /* def: 0 = minimal debug log messages */
 static int iwl4965_param_disable;  /* def: enable radio */
 static int iwl4965_param_antenna;  /* def: 0 = both antennas (use diversity) */
 int iwl4965_param_hwcrypto;        /* def: using software encryption */
-static int iwl4965_param_qos_enable = 1;
-int iwl4965_param_queues_num = IWL_MAX_NUM_QUEUES;
+static int iwl4965_param_qos_enable = 1; /* def: 1 = use quality of service */
+int iwl4965_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 16 Tx queues */
 int iwl4965_param_amsdu_size_8K; /* def: enable 8K amsdu size */
 
 /*
@@ -184,17 +184,24 @@ static void iwl4965_print_hex_dump(int level, void *p, u32 len)
  *
  * Theory of operation
  *
- * A queue is a circular buffers with 'Read' and 'Write' pointers.
- * 2 empty entries always kept in the buffer to protect from overflow.
+ * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
+ * of buffer descriptors, each of which points to one or more data buffers for
+ * the device to read from or fill.  Driver and device exchange status of each
+ * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
+ * entries in each circular buffer, to protect against confusing empty and full
+ * queue states.
+ *
+ * The device reads or writes the data in the queues via the device's several
+ * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
  *
  * For Tx queue, there are low mark and high mark limits. If, after queuing
  * the packet for Tx, free space become < low mark, Tx queue stopped. When
  * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
  * Tx queue resumed.
  *
- * The IWL operates with six queues, one receive queue in the device's
- * sram, one transmit queue for sending commands to the device firmware,
- * and four transmit queues for data.
+ * The 4965 operates with up to 17 queues:  One receive queue, one transmit
+ * queue (#4) for sending commands to the device firmware, and 15 other
+ * Tx queues that may be mapped to prioritized Tx DMA/FIFO channels.
  ***************************************************/
 
 static int iwl4965_queue_space(const struct iwl4965_queue *q)
@@ -213,13 +220,21 @@ static int iwl4965_queue_space(const struct iwl4965_queue *q)
 	return s;
 }
 
-/* XXX: n_bd must be power-of-two size */
+/**
+ * iwl4965_queue_inc_wrap - increment queue index, wrap back to beginning
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
 static inline int iwl4965_queue_inc_wrap(int index, int n_bd)
 {
 	return ++index & (n_bd - 1);
 }
 
-/* XXX: n_bd must be power-of-two size */
+/**
+ * iwl4965_queue_dec_wrap - decrement queue index, wrap back to end
+ * @index -- current index
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
 static inline int iwl4965_queue_dec_wrap(int index, int n_bd)
 {
 	return --index & (n_bd - 1);
@@ -234,12 +249,17 @@ static inline int x2_queue_used(const struct iwl4965_queue *q, int i)
 
 static inline u8 get_cmd_index(struct iwl4965_queue *q, u32 index, int is_huge)
 {
+	/* This is for scan command, the big buffer at end of command array */
 	if (is_huge)
-		return q->n_window;
+		return q->n_window;	/* must be power of 2 */
 
+	/* Otherwise, use normal size buffers */
 	return index & (q->n_window - 1);
 }
 
+/**
+ * iwl4965_queue_init - Initialize queue's high/low-water and read/write indexes
+ */
 static int iwl4965_queue_init(struct iwl4965_priv *priv, struct iwl4965_queue *q,
 			  int count, int slots_num, u32 id)
 {
@@ -268,11 +288,16 @@ static int iwl4965_queue_init(struct iwl4965_priv *priv, struct iwl4965_queue *q
 	return 0;
 }
 
+/**
+ * iwl4965_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
+ */
 static int iwl4965_tx_queue_alloc(struct iwl4965_priv *priv,
 			      struct iwl4965_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
 
+	/* Driver private data, only for Tx (not command) queues,
+	 * not shared with device. */
 	if (id != IWL_CMD_QUEUE_NUM) {
 		txq->txb = kmalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
@@ -284,6 +309,8 @@ static int iwl4965_tx_queue_alloc(struct iwl4965_priv *priv,
 	} else
 		txq->txb = NULL;
 
+	/* Circular buffer of transmit frame descriptors (TFDs),
+	 * shared with device */
 	txq->bd = pci_alloc_consistent(dev,
 			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
 			&txq->q.dma_addr);
@@ -358,8 +385,8 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
  * @txq: Transmit queue to deallocate.
  *
  * Empty queue by removing and destroying all BD's.
- * Free all buffers.  txq itself is not freed.
- *
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
  */
 void iwl4965_tx_queue_free(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq)
 {
@@ -379,19 +406,21 @@ void iwl4965_tx_queue_free(struct iwl4965_priv *priv, struct iwl4965_tx_queue *t
 	if (q->id == IWL_CMD_QUEUE_NUM)
 		len += IWL_MAX_SCAN_SIZE;
 
+	/* De-alloc array of command/tx buffers */
 	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
 
-	/* free buffers belonging to queue itself */
+	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
 		pci_free_consistent(dev, sizeof(struct iwl4965_tfd_frame) *
 				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
 
+	/* De-alloc array of per-TFD driver data */
 	if (txq->txb) {
 		kfree(txq->txb);
 		txq->txb = NULL;
 	}
 
-	/* 0 fill whole structure */
+	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
 }
 
@@ -405,6 +434,11 @@ const u8 iwl4965_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
 /**************************************************************/
 
 #if 0 /* temporary disable till we add real remove station */
+/**
+ * iwl4965_remove_station - Remove driver's knowledge of station.
+ *
+ * NOTE:  This does not remove station from device's station table.
+ */
 static u8 iwl4965_remove_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
@@ -442,6 +476,11 @@ out:
 }
 #endif
 
+/**
+ * iwl4965_clear_stations_table - Clear the driver's station table
+ *
+ * NOTE:  This does not clear or otherwise alter the device's station table.
+ */
 static void iwl4965_clear_stations_table(struct iwl4965_priv *priv)
 {
 	unsigned long flags;
@@ -454,6 +493,9 @@ static void iwl4965_clear_stations_table(struct iwl4965_priv *priv)
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
+/**
+ * iwl4965_add_station_flags - Add station to tables in driver and device
+ */
 u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
 				int is_ap, u8 flags, void *ht_data)
 {
@@ -501,6 +543,7 @@ u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
 	station->used = 1;
 	priv->num_stations++;
 
+	/* Set up the REPLY_ADD_STA command to send to device */
 	memset(&station->sta, 0, sizeof(struct iwl4965_addsta_cmd));
 	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
 	station->sta.mode = 0;
@@ -516,6 +559,8 @@ u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
 #endif /*CONFIG_IWL4965_HT*/
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+
+	/* Add station to device's station table */
 	iwl4965_send_add_station(priv, &station->sta, flags);
 	return index;
 
@@ -685,7 +730,11 @@ static int iwl4965_enqueue_hcmd(struct iwl4965_priv *priv, struct iwl4965_host_c
 		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
 
 	txq->need_update = 1;
+
+	/* Set up entry in queue's byte count circular buffer */
 	ret = iwl4965_tx_queue_update_wr_ptr(priv, txq, 0);
+
+	/* Increment and update queue's write index */
 	q->write_ptr = iwl4965_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl4965_tx_queue_update_write_ptr(priv, txq);
 
@@ -862,9 +911,11 @@ static int iwl4965_rxon_add_station(struct iwl4965_priv *priv,
 						   0, cur_ht_config);
 	else
 #endif /* CONFIG_IWL4965_HT */
+		/* Add station to device's station table */
 		sta_id = iwl4965_add_station_flags(priv, addr, is_ap,
 						   0, NULL);
 
+	/* Set up default rate scaling table in device's station table */
 	iwl4965_add_station(priv, addr, is_ap);
 
 	return sta_id;
@@ -1590,7 +1641,7 @@ static void get_eeprom_mac(struct iwl4965_priv *priv, u8 *mac)
 /**
  * iwl4965_eeprom_init - read EEPROM contents
  *
- * Load the EEPROM from adapter into priv->eeprom
+ * Load the EEPROM contents from adapter into priv->eeprom
  *
  * NOTE:  This routine uses the non-debug IO access functions.
  */
@@ -1615,6 +1666,7 @@ int iwl4965_eeprom_init(struct iwl4965_priv *priv)
 		return -ENOENT;
 	}
 
+	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
 	rc = iwl4965_eeprom_acquire_semaphore(priv);
 	if (rc < 0) {
 		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
@@ -2755,6 +2807,11 @@ static void iwl4965_build_tx_cmd_basic(struct iwl4965_priv *priv,
 	cmd->cmd.tx.next_frame_len = 0;
 }
 
+/**
+ * iwl4965_get_sta_id - Find station's index within station table
+ *
+ * If new IBSS station, create new entry in station table
+ */
 static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
 				struct ieee80211_hdr *hdr)
 {
@@ -2762,16 +2819,15 @@ static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	DECLARE_MAC_BUF(mac);
 
-	/* If this frame is broadcast or not data then use the broadcast
-	 * station id */
+	/* If this frame is broadcast or management, use broadcast station id */
 	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
 	    is_multicast_ether_addr(hdr->addr1))
 		return priv->hw_setting.bcast_sta_id;
 
 	switch (priv->iw_mode) {
 
-	/* If this frame is part of a BSS network (we're a station), then
-	 * we use the AP's station id */
+	/* If we are a client station in a BSS network, use the special
+	 * AP station entry (that's the only station we communicate with) */
 	case IEEE80211_IF_TYPE_STA:
 		return IWL_AP_ID;
 
@@ -2782,13 +2838,14 @@ static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
 			return sta_id;
 		return priv->hw_setting.bcast_sta_id;
 
-	/* If this frame is part of a IBSS network, then we use the
-	 * target specific station id */
+	/* If this frame is going out to an IBSS network, find the station,
+	 * or create a new station table entry */
 	case IEEE80211_IF_TYPE_IBSS:
 		sta_id = iwl4965_hw_find_station(priv, hdr->addr1);
 		if (sta_id != IWL_INVALID_STATION)
 			return sta_id;
 
+		/* Create new station table entry */
 		sta_id = iwl4965_add_station_flags(priv, hdr->addr1,
 						   0, CMD_ASYNC, NULL);
 
@@ -2871,6 +2928,8 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	hdr_len = ieee80211_get_hdrlen(fc);
+
+	/* Find (or create) index into station table for destination station */
 	sta_id = iwl4965_get_sta_id(priv, hdr);
 	if (sta_id == IWL_INVALID_STATION) {
 		DECLARE_MAC_BUF(mac);
@@ -2899,30 +2958,52 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 #endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
 	}
+
+	/* Descriptor for chosen Tx queue */
 	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
+	/* Set up first empty TFD within this queue's circular TFD buffer */
 	tfd = &txq->bd[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 	control_flags = (u32 *) tfd;
 	idx = get_cmd_index(q, q->write_ptr, 0);
 
+	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl4965_tx_info));
 	txq->txb[q->write_ptr].skb[0] = skb;
 	memcpy(&(txq->txb[q->write_ptr].status.control),
 	       ctl, sizeof(struct ieee80211_tx_control));
+
+	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = &txq->cmd[idx];
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
+
+	/*
+	 * Set up the Tx-command (not MAC!) header.
+	 * Store the chosen Tx queue and TFD index within the sequence field;
+	 * after Tx, uCode's Tx response will return this value so driver can
+	 * locate the frame within the tx queue and do post-tx processing.
+	 */
 	out_cmd->hdr.cmd = REPLY_TX;
 	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 				INDEX_TO_SEQ(q->write_ptr)));
-	/* copy frags header */
+
+	/* Copy MAC header from skb into command buffer */
 	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
 
-	/* hdr = (struct ieee80211_hdr *)out_cmd->cmd.tx.hdr; */
+	/*
+	 * Use the first empty entry in this queue's command buffer array
+	 * to contain the Tx command and MAC header concatenated together
+	 * (payload data will be in another buffer).
+	 * Size of this varies, due to varying MAC header length.
+	 * If end is not dword aligned, we'll have 2 extra bytes at the end
+	 * of the MAC header (device reads on dword boundaries).
+	 * We'll tell device about this padding later.
+	 */
 	len = priv->hw_setting.tx_cmd_len +
 		sizeof(struct iwl4965_cmd_header) + hdr_len;
 
@@ -2934,15 +3015,20 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	else
 		len_org = 0;
 
+	/* Physical address of this Tx command's header (not MAC header!),
+	 * within command buffer array. */
 	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl4965_cmd) * idx +
 		     offsetof(struct iwl4965_cmd, hdr);
 
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
 	iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
 	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		iwl4965_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
 
-	/* 802.11 null functions have no payload... */
+	/* Set up TFD's 2nd entry to point directly to remainder of skb,
+	 * if any (802.11 null frames have no payload). */
 	len = skb->len - hdr_len;
 	if (len) {
 		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
@@ -2950,9 +3036,11 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 		iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
 	}
 
+	/* Tell 4965 about any 2-byte padding after MAC header */
 	if (len_org)
 		out_cmd->cmd.tx.tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
 
+	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
 	out_cmd->cmd.tx.len = cpu_to_le16(len);
 
@@ -2982,8 +3070,10 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
 	iwl4965_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
 			   ieee80211_get_hdrlen(fc));
 
+	/* Set up entry for this TFD in Tx byte-count array */
 	iwl4965_tx_queue_update_wr_ptr(priv, txq, len);
 
+	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl4965_queue_inc_wrap(q->write_ptr, q->n_bd);
 	rc = iwl4965_tx_queue_update_write_ptr(priv, txq);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -3460,11 +3550,11 @@ static void iwl4965_txstatus_to_ieee(struct iwl4965_priv *priv,
 }
 
 /**
- * iwl4965_tx_queue_reclaim - Reclaim Tx queue entries no more used by NIC.
+ * iwl4965_tx_queue_reclaim - Reclaim Tx queue entries already Tx'd
  *
- * When FW advances 'R' index, all entries between old and
- * new 'R' index need to be reclaimed. As result, some free space
- * forms. If there is enough free space (> low mark), wake Tx queue.
+ * When FW advances 'R' index, all entries between old and new 'R' index
+ * need to be reclaimed. As result, some free space forms.  If there is
+ * enough free space (> low mark), wake the stack that feeds us.
  */
 int iwl4965_tx_queue_reclaim(struct iwl4965_priv *priv, int txq_id, int index)
 {
@@ -3545,6 +3635,10 @@ static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
 	return le32_to_cpu(*scd_ssn) & MAX_SN;
 
 }
+
+/**
+ * iwl4965_tx_status_reply_tx - Handle Tx rspnse for frames in aggregation queue
+ */
 static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 				      struct iwl4965_ht_agg *agg,
 				      struct iwl4965_tx_resp *tx_resp,
@@ -3559,14 +3653,16 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 	u16 seq;
 
 	if (agg->wait_for_ba)
-		IWL_DEBUG_TX_REPLY("got tx repsons w/o back\n");
+		IWL_DEBUG_TX_REPLY("got tx response w/o block-ack\n");
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
 	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 	agg->bitmap0 = agg->bitmap1 = 0;
 
+	/* # frames attempted by Tx command */
 	if (agg->frame_count == 1) {
+		/* Only one frame was attempted; no block-ack will arrive */
 		struct iwl4965_tx_queue *txq ;
 		status = le32_to_cpu(frame_status[0]);
 
@@ -3595,9 +3691,11 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 
 		agg->wait_for_ba = 0;
 	} else {
+		/* Two or more frames were attempted; expect block-ack */
 		u64 bitmap = 0;
 		int start = agg->start_idx;
 
+		/* Construct bit-map of pending frames within Tx window */
 		for (i = 0; i < agg->frame_count; i++) {
 			u16 sc;
 			status = le32_to_cpu(frame_status[i]);
@@ -3661,6 +3759,9 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
 #endif
 #endif
 
+/**
+ * iwl4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
+ */
 static void iwl4965_rx_reply_tx(struct iwl4965_priv *priv,
 			    struct iwl4965_rx_mem_buffer *rxb)
 {
@@ -4282,6 +4383,7 @@ int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv, struct iwl4965_
 	if (q->need_update == 0)
 		goto exit_unlock;
 
+	/* If power-saving is in use, make sure device is awake */
 	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
 		reg = iwl4965_read32(priv, CSR_UCODE_DRV_GP1);
 
@@ -4295,10 +4397,14 @@ int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv, struct iwl4965_
 		if (rc)
 			goto exit_unlock;
 
+		/* Device expects a multiple of 8 */
 		iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
 				     q->write & ~0x7);
 		iwl4965_release_nic_access(priv);
+
+	/* Else device is assumed to be awake */
 	} else
+		/* Device expects a multiple of 8 */
 		iwl4965_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
 
 
@@ -4341,9 +4447,12 @@ static int iwl4965_rx_queue_restock(struct iwl4965_priv *priv)
 	spin_lock_irqsave(&rxq->lock, flags);
 	write = rxq->write & ~0x7;
 	while ((iwl4965_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
+		/* Get next free Rx buffer, remove from free list */
 		element = rxq->rx_free.next;
 		rxb = list_entry(element, struct iwl4965_rx_mem_buffer, list);
 		list_del(element);
+
+		/* Point to Rx buffer via next RBD in circular buffer */
 		rxq->bd[rxq->write] = iwl4965_dma_addr2rbd_ptr(priv, rxb->dma_addr);
 		rxq->queue[rxq->write] = rxb;
 		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
@@ -4356,7 +4465,8 @@ static int iwl4965_rx_queue_restock(struct iwl4965_priv *priv)
 		queue_work(priv->workqueue, &priv->rx_replenish);
 
 
-	/* If we've added more space for the firmware to place data, tell it */
+	/* If we've added more space for the firmware to place data, tell it.
+	 * Increment device's write pointer in multiples of 8. */
 	if ((write != (rxq->write & ~0x7))
 	    || (abs(rxq->write - rxq->read) > 7)) {
 		spin_lock_irqsave(&rxq->lock, flags);
@@ -4389,6 +4499,8 @@ void iwl4965_rx_replenish(void *data)
 	while (!list_empty(&rxq->rx_used)) {
 		element = rxq->rx_used.next;
 		rxb = list_entry(element, struct iwl4965_rx_mem_buffer, list);
+
+		/* Alloc a new receive buffer */
 		rxb->skb =
 		    alloc_skb(priv->hw_setting.rx_buf_size,
 				__GFP_NOWARN | GFP_ATOMIC);
@@ -4403,6 +4515,8 @@ void iwl4965_rx_replenish(void *data)
 		}
 		priv->alloc_rxb_skb++;
 		list_del(element);
+
+		/* Get physical address of RB/SKB */
 		rxb->dma_addr =
 		    pci_map_single(priv->pci_dev, rxb->skb->data,
 			   priv->hw_setting.rx_buf_size, PCI_DMA_FROMDEVICE);
@@ -4448,12 +4562,16 @@ int iwl4965_rx_queue_alloc(struct iwl4965_priv *priv)
 	spin_lock_init(&rxq->lock);
 	INIT_LIST_HEAD(&rxq->rx_free);
 	INIT_LIST_HEAD(&rxq->rx_used);
+
+	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
 	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
 	if (!rxq->bd)
 		return -ENOMEM;
+
 	/* Fill the rx_used queue with _all_ of the Rx buffers */
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+
 	/* Set us so that we have processed and used all buffers, but have
 	 * not restocked the Rx queue with fresh buffers */
 	rxq->read = rxq->write = 0;
@@ -4586,6 +4704,8 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 	int reclaim;
 	unsigned long flags;
 
+	/* uCode's read index (stored in shared DRAM) indicates the last Rx
+	 * buffer that the driver may process (last buffer filled by ucode). */
 	r = iwl4965_hw_get_rx_read(priv);
 	i = rxq->read;
 
@@ -4670,6 +4790,9 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
 	iwl4965_rx_queue_restock(priv);
 }
 
+/**
+ * iwl4965_tx_queue_update_write_ptr - Send new write index to hardware
+ */
 static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
 				  struct iwl4965_tx_queue *txq)
 {
@@ -5301,6 +5424,11 @@ static void iwl4965_init_band_reference(const struct iwl4965_priv *priv,
 	}
 }
 
+/**
+ * iwl4965_get_channel_info - Find driver's private channel info
+ *
+ * Based on band and channel number.
+ */
 const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl4965_priv *priv,
 						    int phymode, u16 channel)
 {
@@ -5328,6 +5456,9 @@ const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl4965
 #define CHECK_AND_PRINT(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
 
+/**
+ * iwl4965_init_channel_map - Set up driver's info for all possible channels
+ */
 static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
 {
 	int eeprom_ch_count = 0;
@@ -5437,6 +5568,7 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
 		}
 	}
 
+	/* Two additional EEPROM bands for 2.4 and 5 GHz FAT channels */
 	for (band = 6; band <= 7; band++) {
 		int phymode;
 		u8 fat_extension_chan;
@@ -5444,7 +5576,9 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
 		iwl4965_init_band_reference(priv, band, &eeprom_ch_count,
 					&eeprom_ch_info, &eeprom_ch_index);
 
+		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
 		phymode = (band == 6) ? MODE_IEEE80211B : MODE_IEEE80211A;
+
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
 
@@ -5456,11 +5590,13 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
 			else
 				fat_extension_chan = HT_IE_EXT_CHANNEL_ABOVE;
 
+			/* Set up driver's info for lower half */
 			iwl4965_set_fat_chan_info(priv, phymode,
 						  eeprom_ch_index[ch],
 						  &(eeprom_ch_info[ch]),
 						  fat_extension_chan);
 
+			/* Set up driver's info for upper half */
 			iwl4965_set_fat_chan_info(priv, phymode,
 						  (eeprom_ch_index[ch] + 4),
 						  &(eeprom_ch_info[ch]),
@@ -8874,6 +9010,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	struct ieee80211_hw *hw;
 	int i;
 
+	/* Disabling hardware scan means that mac80211 will perform scans
+	 * "the hard way", rather than using device's scan. */
 	if (iwl4965_param_disable_hw_scan) {
 		IWL_DEBUG_INFO("Disabling hw_scan\n");
 		iwl4965_hw_ops.hw_scan = NULL;
@@ -8925,9 +9063,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	/* Tell mac80211 our Tx characteristics */
 	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
 
+	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
 #ifdef CONFIG_IWL4965_HT
 #ifdef CONFIG_IWL4965_HT_AGG
+	/* Enhanced value; more queues, to support 11n aggregation */
 	hw->queues = 16;
 #endif /* CONFIG_IWL4965_HT_AGG */
 #endif /* CONFIG_IWL4965_HT */
@@ -8951,6 +9091,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	pci_set_master(pdev);
 
+	/* Clear the driver's (not device's) station table */
 	iwl4965_clear_stations_table(priv);
 
 	priv->data_retry_limit = -1;
@@ -8970,9 +9111,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err)
 		goto out_pci_disable_device;
+
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, 0x41, 0x00);
+
 	priv->hw_base = pci_iomap(pdev, 0, 0);
 	if (!priv->hw_base) {
 		err = -ENODEV;
@@ -8985,6 +9128,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	/* Initialize module parameter values here */
 
+	/* Disable radio (SW RF KILL) via parameter when loading driver */
 	if (iwl4965_param_disable) {
 		set_bit(STATUS_RF_KILL_SW, &priv->status);
 		IWL_DEBUG_INFO("Radio disabled.\n");
@@ -8997,6 +9141,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->valid_antenna = 0x7;	/* assume all 3 connected */
 	priv->ps_mode = IWL_MIMO_PS_NONE;
 
+	/* Choose which receivers/antennas to use */
 	iwl4965_set_rxon_chain(priv);
 
 	printk(KERN_INFO DRV_NAME
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
