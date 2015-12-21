Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11260 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbbLUFPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:15:53 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 08/46] staging: wilc1000: move all of wilc_wlan_dev_t to struct wilc
Date: Mon, 21 Dec 2015 14:18:12 +0900
Message-ID: <1450675130-17866-9-git-send-email-glen.lee@atmel.com> (sfid-20151221_061556_273206_2599C12D)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux_wlan.c and wilc_wlan.c was separated into two part at the beginning
to support various platforms. They are in charge of send/receive control and
packet data, so they will be merged into one file wlan.c later.
First of all, wilc_wlan_dev_t which is used as global variable of wilc_wlan.c
will be moved into struct wilc.
This patch moves all members of wilc_wlan_dev_t to struct wilc and use wilc
instead of g_wlan. Finally remove wilc_wlan_dev_t and g_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  22 +++
 drivers/staging/wilc1000/wilc_wlan.c          | 271 +++++++++++---------------
 2 files changed, 139 insertions(+), 154 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index b593b64..68a159f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -181,6 +181,28 @@ struct wilc {
 
 	struct task_struct *txq_thread;
 
+	int quit;
+	int cfg_frame_in_use;
+	struct wilc_cfg_frame cfg_frame;
+	u32 cfg_frame_offset;
+	int cfg_seq_no;
+
+	u8 *rx_buffer;
+	u32 rx_buffer_offset;
+	u8 *tx_buffer;
+
+	unsigned long txq_spinlock_flags;
+
+	struct txq_entry_t *txq_head;
+	struct txq_entry_t *txq_tail;
+	int txq_entries;
+	int txq_exit;
+
+	struct rxq_entry_t *rxq_head;
+	struct rxq_entry_t *rxq_tail;
+	int rxq_entries;
+	int rxq_exit;
+
 	unsigned char eth_src_address[NUM_CONCURRENT_IFC][6];
 
 	const struct firmware *firmware;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 502b499..0427349 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -3,32 +3,6 @@
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
-typedef struct {
-	int quit;
-	int cfg_frame_in_use;
-	struct wilc_cfg_frame cfg_frame;
-	u32 cfg_frame_offset;
-	int cfg_seq_no;
-
-	u8 *rx_buffer;
-	u32 rx_buffer_offset;
-	u8 *tx_buffer;
-
-	unsigned long txq_spinlock_flags;
-
-	struct txq_entry_t *txq_head;
-	struct txq_entry_t *txq_tail;
-	int txq_entries;
-	int txq_exit;
-
-	struct rxq_entry_t *rxq_head;
-	struct rxq_entry_t *rxq_tail;
-	int rxq_entries;
-	int rxq_exit;
-} wilc_wlan_dev_t;
-
-static wilc_wlan_dev_t g_wlan;
-
 #ifdef WILC_OPTIMIZE_SLEEP_INT
 static inline void chip_allow_sleep(struct wilc *wilc);
 #endif
@@ -76,21 +50,20 @@ static inline void release_bus(struct wilc *wilc, BUS_RELEASE_T release)
 #ifdef TCP_ACK_FILTER
 static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
-
-	if (tqe == p->txq_head)	{
-		p->txq_head = tqe->next;
-		if (p->txq_head)
-			p->txq_head->prev = NULL;
-	} else if (tqe == p->txq_tail)	    {
-		p->txq_tail = (tqe->prev);
-		if (p->txq_tail)
-			p->txq_tail->next = NULL;
+
+	if (tqe == wilc->txq_head) {
+		wilc->txq_head = tqe->next;
+		if (wilc->txq_head)
+			wilc->txq_head->prev = NULL;
+	} else if (tqe == wilc->txq_tail) {
+		wilc->txq_tail = (tqe->prev);
+		if (wilc->txq_tail)
+			wilc->txq_tail->next = NULL;
 	} else {
 		tqe->prev->next = tqe->next;
 		tqe->next->prev = tqe->prev;
 	}
-	p->txq_entries -= 1;
+	wilc->txq_entries -= 1;
 }
 #endif
 
@@ -98,7 +71,6 @@ static struct txq_entry_t *
 wilc_wlan_txq_remove_from_head(struct net_device *dev)
 {
 	struct txq_entry_t *tqe;
-	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
@@ -107,13 +79,13 @@ wilc_wlan_txq_remove_from_head(struct net_device *dev)
 	wilc = nic->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
-	if (p->txq_head) {
-		tqe = p->txq_head;
-		p->txq_head = tqe->next;
-		if (p->txq_head)
-			p->txq_head->prev = NULL;
+	if (wilc->txq_head) {
+		tqe = wilc->txq_head;
+		wilc->txq_head = tqe->next;
+		if (wilc->txq_head)
+			wilc->txq_head->prev = NULL;
 
-		p->txq_entries -= 1;
+		wilc->txq_entries -= 1;
 	} else {
 		tqe = NULL;
 	}
@@ -124,7 +96,6 @@ wilc_wlan_txq_remove_from_head(struct net_device *dev)
 static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 				      struct txq_entry_t *tqe)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
@@ -134,19 +105,19 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	if (!p->txq_head) {
+	if (!wilc->txq_head) {
 		tqe->next = NULL;
 		tqe->prev = NULL;
-		p->txq_head = tqe;
-		p->txq_tail = tqe;
+		wilc->txq_head = tqe;
+		wilc->txq_tail = tqe;
 	} else {
 		tqe->next = NULL;
-		tqe->prev = p->txq_tail;
-		p->txq_tail->next = tqe;
-		p->txq_tail = tqe;
+		tqe->prev = wilc->txq_tail;
+		wilc->txq_tail->next = tqe;
+		wilc->txq_tail = tqe;
 	}
-	p->txq_entries += 1;
-	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
+	wilc->txq_entries += 1;
+	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", wilc->txq_entries);
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
@@ -157,7 +128,6 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 
 static int wilc_wlan_txq_add_to_head(struct wilc *wilc, struct txq_entry_t *tqe)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 	if (wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
 				    CFG_PKTS_TIMEOUT))
@@ -165,19 +135,19 @@ static int wilc_wlan_txq_add_to_head(struct wilc *wilc, struct txq_entry_t *tqe)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	if (!p->txq_head) {
+	if (!wilc->txq_head) {
 		tqe->next = NULL;
 		tqe->prev = NULL;
-		p->txq_head = tqe;
-		p->txq_tail = tqe;
+		wilc->txq_head = tqe;
+		wilc->txq_tail = tqe;
 	} else {
-		tqe->next = p->txq_head;
+		tqe->next = wilc->txq_head;
 		tqe->prev = NULL;
-		p->txq_head->prev = tqe;
-		p->txq_head = tqe;
+		wilc->txq_head->prev = tqe;
+		wilc->txq_head = tqe;
 	}
-	p->txq_entries += 1;
-	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
+	wilc->txq_entries += 1;
+	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", wilc->txq_entries);
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	up(&wilc->txq_add_to_head_cs);
@@ -253,7 +223,6 @@ static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 }
 static inline int remove_TCP_related(struct wilc *wilc)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
@@ -269,7 +238,6 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	u8 *buffer = tqe->buffer;
 	unsigned short h_proto;
 	int i;
-	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
 	perInterface_wlan_t *nic;
 	struct wilc *wilc;
@@ -337,12 +305,11 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	struct wilc *wilc;
 	u32 i = 0;
 	u32 dropped = 0;
-	wilc_wlan_dev_t *p = &g_wlan;
 
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
 
-	spin_lock_irqsave(&wilc->txq_spinlock, p->txq_spinlock_flags);
+	spin_lock_irqsave(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
 	for (i = pending_base; i < (pending_base + pending_acks); i++) {
 		if (pending_acks_info[i].ack_num < ack_session_info[pending_acks_info[i].session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
@@ -369,7 +336,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	else
 		pending_base = 0;
 
-	spin_unlock_irqrestore(&wilc->txq_spinlock, p->txq_spinlock_flags);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, wilc->txq_spinlock_flags);
 
 	while (dropped > 0) {
 		wilc_lock_timeout(wilc, &wilc->txq_event, 1);
@@ -396,11 +363,10 @@ static bool is_tcp_ack_filter_enabled(void)
 
 static int wilc_wlan_txq_add_cfg_pkt(struct wilc *wilc, u8 *buffer, u32 buffer_size)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
 
 	PRINT_D(TX_DBG, "Adding config packet ...\n");
-	if (p->quit) {
+	if (wilc->quit) {
 		PRINT_D(TX_DBG, "Return due to clear function\n");
 		up(&wilc->cfg_event);
 		return 0;
@@ -430,10 +396,13 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc *wilc, u8 *buffer, u32 buffer_s
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			      u32 buffer_size, wilc_tx_complete_func_t func)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
 
-	if (p->quit)
+	if (wilc->quit)
 		return 0;
 
 	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
@@ -453,16 +422,19 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 		tcp_process(dev, tqe);
 #endif
 	wilc_wlan_txq_add_to_tail(dev, tqe);
-	return p->txq_entries;
+	return wilc->txq_entries;
 }
 
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
+
+	wilc = nic->wilc;
 
-	if (p->quit)
+	if (wilc->quit)
 		return 0;
 
 	tqe = kmalloc(sizeof(*tqe), GFP_KERNEL);
@@ -484,13 +456,12 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 
 static struct txq_entry_t *wilc_wlan_txq_get_first(struct wilc *wilc)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
 	unsigned long flags;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	tqe = p->txq_head;
+	tqe = wilc->txq_head;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
@@ -512,41 +483,39 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct wilc *wilc,
 
 static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 
-	if (p->quit)
+	if (wilc->quit)
 		return 0;
 
 	mutex_lock(&wilc->rxq_cs);
-	if (!p->rxq_head) {
+	if (!wilc->rxq_head) {
 		PRINT_D(RX_DBG, "Add to Queue head\n");
 		rqe->next = NULL;
-		p->rxq_head = rqe;
-		p->rxq_tail = rqe;
+		wilc->rxq_head = rqe;
+		wilc->rxq_tail = rqe;
 	} else {
 		PRINT_D(RX_DBG, "Add to Queue tail\n");
-		p->rxq_tail->next = rqe;
+		wilc->rxq_tail->next = rqe;
 		rqe->next = NULL;
-		p->rxq_tail = rqe;
+		wilc->rxq_tail = rqe;
 	}
-	p->rxq_entries += 1;
-	PRINT_D(RX_DBG, "Number of queue entries: %d\n", p->rxq_entries);
+	wilc->rxq_entries += 1;
+	PRINT_D(RX_DBG, "Number of queue entries: %d\n", wilc->rxq_entries);
 	mutex_unlock(&wilc->rxq_cs);
-	return p->rxq_entries;
+	return wilc->rxq_entries;
 }
 
 static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 
 	PRINT_D(RX_DBG, "Getting rxQ element\n");
-	if (p->rxq_head) {
+	if (wilc->rxq_head) {
 		struct rxq_entry_t *rqe;
 
 		mutex_lock(&wilc->rxq_cs);
-		rqe = p->rxq_head;
-		p->rxq_head = p->rxq_head->next;
-		p->rxq_entries -= 1;
+		rqe = wilc->rxq_head;
+		wilc->rxq_head = wilc->rxq_head->next;
+		wilc->rxq_entries -= 1;
 		PRINT_D(RX_DBG, "RXQ entries decreased\n");
 		mutex_unlock(&wilc->rxq_cs);
 		return rqe;
@@ -696,11 +665,10 @@ void wilc_chip_sleep_manually(struct wilc *wilc)
 
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 {
-	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int i, entries = 0;
 	u32 sum;
 	u32 reg;
-	u8 *txb = p->tx_buffer;
+	u8 *txb;
 	u32 offset = 0;
 	int vmm_sz = 0;
 	struct txq_entry_t *tqe;
@@ -714,9 +682,10 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
 
-	p->txq_exit = 0;
+	txb = wilc->tx_buffer;
+	wilc->txq_exit = 0;
 	do {
-		if (p->quit)
+		if (wilc->quit)
 			break;
 
 		wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
@@ -800,7 +769,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				usleep_range(3000, 3000);
 				acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 			}
-		} while (!p->quit);
+		} while (!wilc->quit);
 
 		if (!ret)
 			goto _end_;
@@ -945,23 +914,22 @@ _end_:
 	} while (0);
 	up(&wilc->txq_add_to_head_cs);
 
-	p->txq_exit = 1;
+	wilc->txq_exit = 1;
 	PRINT_D(TX_DBG, "THREAD: Exiting txq\n");
-	*txq_count = p->txq_entries;
+	*txq_count = wilc->txq_entries;
 	return ret;
 }
 
 static void wilc_wlan_handle_rxq(struct wilc *wilc)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	int offset = 0, size, has_packet = 0;
 	u8 *buffer;
 	struct rxq_entry_t *rqe;
 
-	p->rxq_exit = 0;
+	wilc->rxq_exit = 0;
 
 	do {
-		if (p->quit) {
+		if (wilc->quit) {
 			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function\n");
 			up(&wilc->cfg_event);
 			break;
@@ -1022,8 +990,8 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 					wilc_wlan_cfg_indicate_rx(&buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
-						PRINT_D(RX_DBG, "p->cfg_seq_no = %d - rsp.seq_no = %d\n", p->cfg_seq_no, rsp.seq_no);
-						if (p->cfg_seq_no == rsp.seq_no)
+						PRINT_D(RX_DBG, "wilc->cfg_seq_no = %d - rsp.seq_no = %d\n", wilc->cfg_seq_no, rsp.seq_no);
+						if (wilc->cfg_seq_no == rsp.seq_no)
 							up(&wilc->cfg_event);
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
 						wilc_mac_indicate(wilc, WILC_MAC_INDICATE_STATUS);
@@ -1044,7 +1012,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 	} while (1);
 
-	p->rxq_exit = 1;
+	wilc->rxq_exit = 1;
 	PRINT_D(RX_DBG, "THREAD: Exiting RX thread\n");
 }
 
@@ -1080,8 +1048,7 @@ static void wilc_sleeptimer_isr_ext(struct wilc *wilc, u32 int_stats1)
 
 static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
-	u32 offset = p->rx_buffer_offset;
+	u32 offset = wilc->rx_buffer_offset;
 	u8 *buffer = NULL;
 	u32 size;
 	u32 retries = 0;
@@ -1103,8 +1070,8 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		if (LINUX_RX_SIZE - offset < size)
 			offset = 0;
 
-		if (p->rx_buffer) {
-			buffer = &p->rx_buffer[offset];
+		if (wilc->rx_buffer) {
+			buffer = &wilc->rx_buffer[offset];
 		} else {
 			wilc_debug(N_ERR, "[wilc isr]: fail Rx Buffer is NULL...drop the packets (%d)\n", size);
 			goto _end_;
@@ -1121,7 +1088,7 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 _end_:
 		if (ret) {
 			offset += size;
-			p->rx_buffer_offset = offset;
+			wilc->rx_buffer_offset = offset;
 			rqe = kmalloc(sizeof(*rqe), GFP_KERNEL);
 			if (rqe) {
 				rqe->buffer = buffer;
@@ -1377,7 +1344,6 @@ int wilc_wlan_stop(struct wilc *wilc)
 
 void wilc_wlan_cleanup(struct net_device *dev)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
 	struct rxq_entry_t *rqe;
 	u32 reg = 0;
@@ -1388,7 +1354,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	nic = netdev_priv(dev);
 	wilc = nic->wilc;
 
-	p->quit = 1;
+	wilc->quit = 1;
 	do {
 		tqe = wilc_wlan_txq_remove_from_head(dev);
 		if (!tqe)
@@ -1405,9 +1371,9 @@ void wilc_wlan_cleanup(struct net_device *dev)
 		kfree(rqe);
 	} while (1);
 
-	kfree(p->rx_buffer);
-	p->rx_buffer = NULL;
-	kfree(p->tx_buffer);
+	kfree(wilc->rx_buffer);
+	wilc->rx_buffer = NULL;
+	kfree(wilc->tx_buffer);
 
 	acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
@@ -1429,10 +1395,9 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 static int wilc_wlan_cfg_commit(struct wilc *wilc, int type, u32 drv_handler)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
-	struct wilc_cfg_frame *cfg = &p->cfg_frame;
-	int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
-	int seq_no = p->cfg_seq_no % 256;
+	struct wilc_cfg_frame *cfg = &wilc->cfg_frame;
+	int total_len = wilc->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
+	int seq_no = wilc->cfg_seq_no % 256;
 	int driver_handler = (u32)drv_handler;
 
 	if (type == WILC_CFG_SET)
@@ -1446,7 +1411,7 @@ static int wilc_wlan_cfg_commit(struct wilc *wilc, int type, u32 drv_handler)
 	cfg->wid_header[5] = (u8)(driver_handler >> 8);
 	cfg->wid_header[6] = (u8)(driver_handler >> 16);
 	cfg->wid_header[7] = (u8)(driver_handler >> 24);
-	p->cfg_seq_no = seq_no;
+	wilc->cfg_seq_no = seq_no;
 
 	if (!wilc_wlan_txq_add_cfg_pkt(wilc, &cfg->wid_header[0], total_len))
 		return -1;
@@ -1457,27 +1422,26 @@ static int wilc_wlan_cfg_commit(struct wilc *wilc, int type, u32 drv_handler)
 int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	u32 offset;
 	int ret_size;
 
-	if (p->cfg_frame_in_use)
+	if (wilc->cfg_frame_in_use)
 		return 0;
 
 	if (start)
-		p->cfg_frame_offset = 0;
+		wilc->cfg_frame_offset = 0;
 
-	offset = p->cfg_frame_offset;
-	ret_size = wilc_wlan_cfg_set_wid(p->cfg_frame.frame, offset, (u16)wid,
-					 buffer, buffer_size);
+	offset = wilc->cfg_frame_offset;
+	ret_size = wilc_wlan_cfg_set_wid(wilc->cfg_frame.frame, offset,
+					 (u16)wid, buffer, buffer_size);
 	offset += ret_size;
-	p->cfg_frame_offset = offset;
+	wilc->cfg_frame_offset = offset;
 
 	if (commit) {
 		PRINT_D(TX_DBG, "[WILC]PACKET Commit with sequence number %d\n",
-			p->cfg_seq_no);
+			wilc->cfg_seq_no);
 		PRINT_D(RX_DBG, "Processing cfg_set()\n");
-		p->cfg_frame_in_use = 1;
+		wilc->cfg_frame_in_use = 1;
 
 		if (wilc_wlan_cfg_commit(wilc, WILC_CFG_SET, drv_handler))
 			ret_size = 0;
@@ -1487,9 +1451,9 @@ int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
 			PRINT_D(TX_DBG, "Set Timed Out\n");
 			ret_size = 0;
 		}
-		p->cfg_frame_in_use = 0;
-		p->cfg_frame_offset = 0;
-		p->cfg_seq_no += 1;
+		wilc->cfg_frame_in_use = 0;
+		wilc->cfg_frame_offset = 0;
+		wilc->cfg_seq_no += 1;
 	}
 
 	return ret_size;
@@ -1498,23 +1462,23 @@ int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
 int wilc_wlan_cfg_get(struct wilc *wilc, int start, u32 wid, int commit,
 		      u32 drv_handler)
 {
-	wilc_wlan_dev_t *p = &g_wlan;
 	u32 offset;
 	int ret_size;
 
-	if (p->cfg_frame_in_use)
+	if (wilc->cfg_frame_in_use)
 		return 0;
 
 	if (start)
-		p->cfg_frame_offset = 0;
+		wilc->cfg_frame_offset = 0;
 
-	offset = p->cfg_frame_offset;
-	ret_size = wilc_wlan_cfg_get_wid(p->cfg_frame.frame, offset, (u16)wid);
+	offset = wilc->cfg_frame_offset;
+	ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_frame.frame, offset,
+					 (u16)wid);
 	offset += ret_size;
-	p->cfg_frame_offset = offset;
+	wilc->cfg_frame_offset = offset;
 
 	if (commit) {
-		p->cfg_frame_in_use = 1;
+		wilc->cfg_frame_in_use = 1;
 
 		if (wilc_wlan_cfg_commit(wilc, WILC_CFG_QUERY, drv_handler))
 			ret_size = 0;
@@ -1525,9 +1489,9 @@ int wilc_wlan_cfg_get(struct wilc *wilc, int start, u32 wid, int commit,
 			ret_size = 0;
 		}
 		PRINT_D(GENERIC_DBG, "[WILC]Get Response received\n");
-		p->cfg_frame_in_use = 0;
-		p->cfg_frame_offset = 0;
-		p->cfg_seq_no += 1;
+		wilc->cfg_frame_in_use = 0;
+		wilc->cfg_frame_offset = 0;
+		wilc->cfg_seq_no += 1;
 	}
 
 	return ret_size;
@@ -1623,7 +1587,6 @@ int wilc_wlan_init(struct net_device *dev)
 
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
 
-	memset((void *)&g_wlan, 0, sizeof(wilc_wlan_dev_t));
 	if (!wilc->hif_func->hif_init(wilc, wilc_debug)) {
 		ret = -EIO;
 		goto _fail_;
@@ -1634,20 +1597,20 @@ int wilc_wlan_init(struct net_device *dev)
 		goto _fail_;
 	}
 
-	if (!g_wlan.tx_buffer)
-		g_wlan.tx_buffer = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
-	PRINT_D(TX_DBG, "g_wlan.tx_buffer = %p\n", g_wlan.tx_buffer);
+	if (!wilc->tx_buffer)
+		wilc->tx_buffer = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
+	PRINT_D(TX_DBG, "wilc->tx_buffer = %p\n", wilc->tx_buffer);
 
-	if (!g_wlan.tx_buffer) {
+	if (!wilc->tx_buffer) {
 		ret = -ENOBUFS;
 		PRINT_ER("Can't allocate Tx Buffer");
 		goto _fail_;
 	}
 
-	if (!g_wlan.rx_buffer)
-		g_wlan.rx_buffer = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
-	PRINT_D(TX_DBG, "g_wlan.rx_buffer =%p\n", g_wlan.rx_buffer);
-	if (!g_wlan.rx_buffer) {
+	if (!wilc->rx_buffer)
+		wilc->rx_buffer = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
+	PRINT_D(TX_DBG, "wilc->rx_buffer =%p\n", wilc->rx_buffer);
+	if (!wilc->rx_buffer) {
 		ret = -ENOBUFS;
 		PRINT_ER("Can't allocate Rx Buffer");
 		goto _fail_;
@@ -1665,10 +1628,10 @@ int wilc_wlan_init(struct net_device *dev)
 
 _fail_:
 
-	kfree(g_wlan.rx_buffer);
-	g_wlan.rx_buffer = NULL;
-	kfree(g_wlan.tx_buffer);
-	g_wlan.tx_buffer = NULL;
+	kfree(wilc->rx_buffer);
+	wilc->rx_buffer = NULL;
+	kfree(wilc->tx_buffer);
+	wilc->tx_buffer = NULL;
 
 	return ret;
 }
-- 
1.9.1

