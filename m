Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36444 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031112AbbKFCK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:10:57 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/73] staging: wilc1000: fixes please don't use multiple blank lines
Date: Fri, 6 Nov 2015 11:12:26 +0900
Message-ID: <1446776014-28094-5-git-send-email-glen.lee@atmel.com> (sfid-20151106_031100_025209_8BE074BC)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for Please don't use multiple blank lines.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 48 ------------------------------------
 1 file changed, 48 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7aaad0f..5db87c0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -6,8 +6,6 @@ extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
 u32 wilc_get_chipid(u8 update);
 
-
-
 typedef struct {
 	int quit;
 	wilc_wlan_io_func_t io_func;
@@ -35,8 +33,6 @@ typedef struct {
 	struct rxq_entry_t *rxq_tail;
 	int rxq_entries;
 	int rxq_exit;
-
-
 } wilc_wlan_dev_t;
 
 static wilc_wlan_dev_t g_wlan;
@@ -92,8 +88,6 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 		p->txq_head = tqe->next;
 		if (p->txq_head)
 			p->txq_head->prev = NULL;
-
-
 	} else if (tqe == p->txq_tail)	    {
 		p->txq_tail = (tqe->prev);
 		if (p->txq_tail)
@@ -126,10 +120,6 @@ wilc_wlan_txq_remove_from_head(struct net_device *dev)
 			p->txq_head->prev = NULL;
 
 		p->txq_entries -= 1;
-
-
-
-
 	} else {
 		tqe = NULL;
 	}
@@ -222,9 +212,6 @@ typedef struct {
 	struct txq_entry_t  *txqe;
 } Pending_Acks_info_t;
 
-
-
-
 struct Ack_session_info *Free_head;
 struct Ack_session_info *Alloc_head;
 
@@ -239,8 +226,6 @@ u32 PendingAcks_arrBase;
 u32 Opened_TCP_session;
 u32 Pending_Acks;
 
-
-
 static inline int Init_TCP_tracking(void)
 {
 
@@ -319,7 +304,6 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 		ip_hdr_ptr = &buffer[ETHERNET_HDR_LEN];
 		protocol = ip_hdr_ptr[9];
 
-
 		if (protocol == 0x06) {
 			u8 *tcp_hdr_ptr;
 			u32 IHL, Total_Length, Data_offset;
@@ -335,7 +319,6 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 				Ack_no	= (((u32)tcp_hdr_ptr[8]) << 24) + (((u32)tcp_hdr_ptr[9]) << 16) + (((u32)tcp_hdr_ptr[10]) << 8) + ((u32)tcp_hdr_ptr[11]);
 
-
 				for (i = 0; i < Opened_TCP_session; i++) {
 					if (Acks_keep_track_info[i].Ack_seq_num == seq_no) {
 						Update_TCP_track_session(i, Ack_no);
@@ -346,8 +329,6 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 					add_TCP_track_session(0, 0, seq_no);
 
 				add_TCP_Pending_Ack(Ack_no, i, tqe);
-
-
 			}
 
 		} else {
@@ -360,7 +341,6 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 	return ret;
 }
 
-
 static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
 	perInterface_wlan_t *nic;
@@ -398,7 +378,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	else
 		PendingAcks_arrBase = 0;
 
-
 	spin_unlock_irqrestore(&wilc->txq_spinlock, p->txq_spinlock_flags);
 
 	while (Dropped > 0) {
@@ -523,7 +502,6 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(struct wilc *wilc)
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
-
 	return tqe;
 }
 
@@ -536,7 +514,6 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct wilc *wilc,
 	tqe = tqe->next;
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
-
 	return tqe;
 }
 
@@ -637,7 +614,6 @@ static inline void chip_wakeup(void)
 		} while ((clk_status_reg & 0x1) == 0);
 	}
 
-
 	if (genuChipPSstate == CHIP_SLEEPING_MANUAL) {
 		g_wlan.hif_func.hif_read_reg(0x1C0C, &reg);
 		reg &= ~BIT(0);
@@ -990,9 +966,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 	p->rxq_exit = 0;
 
-
-
-
 	do {
 		if (p->quit) {
 			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function\n");
@@ -1009,8 +982,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 		PRINT_D(RX_DBG, "rxQ entery Size = %d - Address = %p\n", size, buffer);
 		offset = 0;
 
-
-
 		do {
 			u32 header;
 			u32 pkt_len, pkt_offset, tp_len;
@@ -1023,8 +994,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 #endif
 			PRINT_D(RX_DBG, "Header = %04x - Offset = %d\n", header, offset);
 
-
-
 			is_cfg_packet = (header >> 31) & 0x1;
 			pkt_offset = (header >> 22) & 0x1ff;
 			tp_len = (header >> 11) & 0x7ff;
@@ -1039,7 +1008,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			#define IS_MANAGMEMENT_CALLBACK			0x080
 			#define IS_MGMT_STATUS_SUCCES			0x040
 
-
 			if (pkt_offset & IS_MANAGMEMENT) {
 				pkt_offset &= ~(IS_MANAGMEMENT | IS_MANAGMEMENT_CALLBACK | IS_MGMT_STATUS_SUCCES);
 
@@ -1059,8 +1027,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 				} else {
 					wilc_cfg_rsp_t rsp;
 
-
-
 					wilc_wlan_cfg_indicate_rx(&buffer[pkt_offset + offset], pkt_len, &rsp);
 					if (rsp.type == WILC_CFG_RSP) {
 						PRINT_D(RX_DBG, "p->cfg_seq_no = %d - rsp.seq_no = %d\n", p->cfg_seq_no, rsp.seq_no);
@@ -1078,8 +1044,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			if (offset >= size)
 				break;
 		} while (1);
-
-
 #ifndef MEMORY_STATIC
 		kfree(buffer);
 #endif
@@ -1173,8 +1137,6 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 			goto _end_;
 		}
 _end_:
-
-
 		if (ret) {
 #ifdef MEMORY_STATIC
 			offset += size;
@@ -1394,8 +1356,6 @@ int wilc_wlan_stop(void)
 	}
 
 	reg &= ~BIT(10);
-
-
 	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
@@ -1403,8 +1363,6 @@ int wilc_wlan_stop(void)
 		return ret;
 	}
 
-
-
 	do {
 		ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 		if (!ret) {
@@ -1486,7 +1444,6 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 	acquire_bus(ACQUIRE_AND_WAKEUP);
 
-
 	ret = p->hif_func.hif_read_reg(WILC_GP_REG_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
@@ -1538,7 +1495,6 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 	u32 offset;
 	int ret_size;
 
-
 	if (p->cfg_frame_in_use)
 		return 0;
 
@@ -1578,7 +1534,6 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 	u32 offset;
 	int ret_size;
 
-
 	if (p->cfg_frame_in_use)
 		return 0;
 
@@ -1596,7 +1551,6 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 		if (wilc_wlan_cfg_commit(WILC_CFG_QUERY, drvHandler))
 			ret_size = 0;
 
-
 		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Get Timed Out\n");
@@ -1638,8 +1592,6 @@ u32 init_chip(struct net_device *dev)
 
 	chipid = wilc_get_chipid(true);
 
-
-
 	if ((chipid & 0xfff) != 0xa0) {
 		ret = g_wlan.hif_func.hif_read_reg(0x1118, &reg);
 		if (!ret) {
-- 
1.9.1

