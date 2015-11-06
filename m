Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36556 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031107AbbKFCL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/73] staging: wilc1000: replace explicit NULL comparisons with !
Date: Fri, 6 Nov 2015 11:12:31 +0900
Message-ID: <1446776014-28094-10-git-send-email-glen.lee@atmel.com> (sfid-20151106_031129_730967_11FD50FB)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch replace explicit NULL comparison with ! operator to simplify code.
Reported by checkpatch.pl for Comparison to NULL could be written "!XXX" or "XXX".

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c393e52..8ac0b1e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -137,7 +137,7 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
-	if (p->txq_head == NULL) {
+	if (!p->txq_head) {
 		tqe->next = NULL;
 		tqe->prev = NULL;
 		p->txq_head = tqe;
@@ -168,7 +168,7 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 
 	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
 
-	if (p->txq_head == NULL) {
+	if (!p->txq_head) {
 		tqe->next = NULL;
 		tqe->prev = NULL;
 		p->txq_head = tqe;
@@ -407,7 +407,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	}
 
 	tqe = kmalloc(sizeof(struct txq_entry_t), GFP_ATOMIC);
-	if (tqe == NULL) {
+	if (!tqe) {
 		PRINT_ER("Failed to allocate memory\n");
 		return 0;
 	}
@@ -438,7 +438,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 
 	tqe = kmalloc(sizeof(struct txq_entry_t), GFP_ATOMIC);
 
-	if (tqe == NULL)
+	if (!tqe)
 		return 0;
 	tqe->type = WILC_NET_PKT;
 	tqe->buffer = buffer;
@@ -467,7 +467,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 
 	tqe = kmalloc(sizeof(struct txq_entry_t), GFP_KERNEL);
 
-	if (tqe == NULL)
+	if (!tqe)
 		return 0;
 	tqe->type = WILC_MGMT_PKT;
 	tqe->buffer = buffer;
@@ -518,7 +518,7 @@ static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 		return 0;
 
 	mutex_lock(&wilc->rxq_cs);
-	if (p->rxq_head == NULL) {
+	if (!p->rxq_head) {
 		PRINT_D(RX_DBG, "Add to Queue head\n");
 		rqe->next = NULL;
 		p->rxq_head = rqe;
@@ -723,7 +723,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 		i = 0;
 		sum = 0;
 		do {
-			if ((tqe != NULL) && (i < (WILC_VMM_TBL_SIZE - 1))) {
+			if (tqe && (i < (WILC_VMM_TBL_SIZE - 1))) {
 				if (tqe->type == WILC_CFG_PKT)
 					vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
 
@@ -871,7 +871,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 		i = 0;
 		do {
 			tqe = wilc_wlan_txq_remove_from_head(dev);
-			if (tqe != NULL && (vmm_table[i] != 0)) {
+			if (tqe && (vmm_table[i] != 0)) {
 				u32 header, buffer_offset;
 
 #ifdef BIG_ENDIAN
@@ -962,7 +962,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			break;
 		}
 		rqe = wilc_wlan_rxq_remove(wilc);
-		if (rqe == NULL) {
+		if (!rqe) {
 			PRINT_D(RX_DBG, "nothing in the queue - exit 1st do-while\n");
 			break;
 		}
@@ -1110,7 +1110,7 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 
 #else
 		buffer = kmalloc(size, GFP_KERNEL);
-		if (buffer == NULL) {
+		if (!buffer) {
 			wilc_debug(N_ERR, "[wilc isr]: fail alloc host memory...drop the packets (%d)\n", size);
 			usleep_range(100 * 1000, 100 * 1000);
 			goto _end_;
@@ -1130,7 +1130,7 @@ _end_:
 			p->rx_buffer_offset = offset;
 #endif
 			rqe = kmalloc(sizeof(struct rxq_entry_t), GFP_KERNEL);
-			if (rqe != NULL) {
+			if (rqe) {
 				rqe->buffer = buffer;
 				rqe->buffer_size = size;
 				PRINT_D(RX_DBG, "rxq entery Size= %d - Address = %p\n", rqe->buffer_size, rqe->buffer);
@@ -1184,7 +1184,7 @@ int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 	blksz = BIT(12);
 
 	dma_buffer = kmalloc(blksz, GFP_KERNEL);
-	if (dma_buffer == NULL) {
+	if (!dma_buffer) {
 		ret = -5;
 		PRINT_ER("Can't allocate buffer for firmware download IO error\n ");
 		goto _fail_1;
@@ -1406,7 +1406,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	p->quit = 1;
 	do {
 		tqe = wilc_wlan_txq_remove_from_head(dev);
-		if (tqe == NULL)
+		if (!tqe)
 			break;
 		if (tqe->tx_complete_func)
 			tqe->tx_complete_func(tqe->priv, 0);
@@ -1415,7 +1415,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 	do {
 		rqe = wilc_wlan_rxq_remove(wilc);
-		if (rqe == NULL)
+		if (!rqe)
 			break;
 #ifndef MEMORY_STATIC
 		kfree(rqe->buffer);
@@ -1670,21 +1670,21 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 		goto _fail_;
 	}
 
-	if (g_wlan.tx_buffer == NULL)
+	if (!g_wlan.tx_buffer)
 		g_wlan.tx_buffer = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
 	PRINT_D(TX_DBG, "g_wlan.tx_buffer = %p\n", g_wlan.tx_buffer);
 
-	if (g_wlan.tx_buffer == NULL) {
+	if (!g_wlan.tx_buffer) {
 		ret = -105;
 		PRINT_ER("Can't allocate Tx Buffer");
 		goto _fail_;
 	}
 
 #if defined (MEMORY_STATIC)
-	if (g_wlan.rx_buffer == NULL)
+	if (!g_wlan.rx_buffer)
 		g_wlan.rx_buffer = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
 	PRINT_D(TX_DBG, "g_wlan.rx_buffer =%p\n", g_wlan.rx_buffer);
-	if (g_wlan.rx_buffer == NULL) {
+	if (!g_wlan.rx_buffer) {
 		ret = -105;
 		PRINT_ER("Can't allocate Rx Buffer");
 		goto _fail_;
-- 
1.9.1

