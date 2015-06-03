Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0141.outbound.protection.outlook.com ([157.56.112.141]:11424
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757538AbbFCMZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 08:25:56 -0400
From: "Sharma, Abhishek (A.)" <asharm14@visteon.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	"Dean Lee" <dean.lee@atmel.com>, Chris Park <chris.park@atmel.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] staging: wilc1000: Remove commented code lines
Date: Wed, 3 Jun 2015 12:25:50 +0000
Message-ID: <20150603122537.GA26703@jarvis.asia.jci.com> (sfid-20150603_142752_677934_A18D0868)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhishek Sharma <asharm14@visteon.com>

Removing the commented code lines.

Signed-off-by: Abhishek Sharma <asharm14@visteon.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 65 ------------------------------------
 1 file changed, 65 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e1d9755..9edc851 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -170,7 +170,6 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	/* unsigned long flags; */
-	/* p->os_func.os_spin_lock(p->txq_spinlock, &flags); */
 	if (tqe == p->txq_head)	{
 
 		p->txq_head = tqe->next;
@@ -187,7 +186,6 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 		tqe->next->prev = tqe->prev;
 	}
 	p->txq_entries -= 1;
-	/* p->os_func.os_spin_unlock(p->txq_spinlock, &flags); */
 
 }
 
@@ -198,7 +196,6 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	unsigned long flags;
 	p->os_func.os_spin_lock(p->txq_spinlock, &flags);
 	if (p->txq_head) {
-		/* p->os_func.os_enter_cs(p->txq_lock); */
 		tqe = p->txq_head;
 		p->txq_head = tqe->next;
 		if (p->txq_head) {
@@ -209,7 +206,6 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 		/*Added by Amr - BugID_4720*/
 
 
-		/* p->os_func.os_leave_cs(p->txq_lock); */
 
 	} else {
 		tqe = NULL;
@@ -225,13 +221,11 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 	/*Added by Amr - BugID_4720*/
 	p->os_func.os_spin_lock(p->txq_spinlock, &flags);
 
-/*	p->os_func.os_enter_cs(p->txq_lock); */
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
 		tqe->prev = NULL;
 		p->txq_head = tqe;
 		p->txq_tail = tqe;
-		/* p->os_func.os_signal(p->txq_wait); */
 	} else {
 		tqe->next = NULL;
 		tqe->prev = p->txq_tail;
@@ -240,7 +234,6 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 	}
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
-/*	p->os_func.os_leave_cs(p->txq_lock); */
 
 	/*Added by Amr - BugID_4720*/
 	p->os_func.os_spin_unlock(p->txq_spinlock, &flags);
@@ -265,7 +258,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 
 	p->os_func.os_spin_lock(p->txq_spinlock, &flags);
 
-	/* p->os_func.os_enter_cs(p->txq_lock); */
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
 		tqe->prev = NULL;
@@ -279,7 +271,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	}
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
-	/* p->os_func.os_leave_cs(p->txq_lock); */
 
 	/*Added by Amr - BugID_4720*/
 	p->os_func.os_spin_unlock(p->txq_spinlock, &flags);
@@ -291,7 +282,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	 **/
 	p->os_func.os_signal(p->txq_wait);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
-/*	complete(p->txq_wait); */
 
 	/*Added by Amr - BugID_4720*/
 	return 0;
@@ -308,19 +298,12 @@ typedef struct Ack_session_info {
 	uint16_t src_port;
 	uint16_t dst_port;
 	uint16_t status;
-	/* struct Ack_session_info * next; */
-	/* struct Ack_session_info * prev; */
 } Ack_session_info_t;
 
 typedef struct {
 	uint32_t ack_num;
-	/* uint32_t seq_num; */
-	/* uint16_t src_port; */
-	/* uint16_t dst_port; */
-	/* uint32_t dst_ip_addr; */
 	uint32_t Session_index;
 	struct txq_entry_t  *txqe;
-	/* Ack_session_info * Ack_session; */
 } Pending_Acks_info_t /*Ack_info_t*/;
 
 
@@ -348,17 +331,6 @@ uint32_t Pending_Acks;
 static __inline int Init_TCP_tracking(void)
 {
 
-	/*uint32_t i;
-	 * Free_head=&Acks_keep_track_info[0];
-	 * i=1;
-	 * Acks_keep_track_info[0].next=&Acks_keep_track_info[1];
-	 * for(i=1<;i<MAX_TCP_SESSION-1;i++)
-	 * {
-	 *      Acks_keep_track_info[i].next=&Acks_keep_track_info[i+1];
-	 *      Acks_keep_track_info[i].prev=&Acks_keep_track_info[i-1];
-	 * }
-	 * Acks_keep_track_info[49].prev=&Acks_keep_track_info[48];
-	 */
 	return 0;
 
 }
@@ -489,7 +461,6 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 					tqe->tx_complete_func(tqe->priv, tqe->status);
 				p->os_func.os_free(tqe);
 				Dropped++;
-				/* p->txq_entries -= 1; */
 			}
 		}
 	}
@@ -563,7 +534,6 @@ static int wilc_wlan_txq_add_cfg_pkt(uint8_t *buffer, uint32_t buffer_size)
 	/*Edited by Amr - BugID_4720*/
 	if (wilc_wlan_txq_add_to_head(tqe))
 		return 0;
-	/* wilc_wlan_txq_add_to_tail(tqe); */
 	return 1;
 }
 
@@ -659,13 +629,11 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 	/*Added by Amr - BugID_4720*/
 	p->os_func.os_spin_lock(p->txq_spinlock, &flags);
 
-	/* p->os_func.os_enter_cs(p->txq_lock); */
 	tqe = p->txq_head;
 
 	/*Added by Amr - BugID_4720*/
 	p->os_func.os_spin_unlock(p->txq_spinlock, &flags);
 
-	/* p->os_func.os_leave_cs(p->txq_lock); */
 
 	return tqe;
 }
@@ -677,13 +645,10 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct txq_entry_t *tqe)
 	/*Added by Amr - BugID_4720*/
 	p->os_func.os_spin_lock(p->txq_spinlock, &flags);
 
-	/* p->os_func.os_enter_cs(p->txq_lock); */
 	tqe = tqe->next;
-
 	/*Added by Amr - BugID_4720*/
 	p->os_func.os_spin_unlock(p->txq_spinlock, &flags);
 
-	/* p->os_func.os_leave_cs(p->txq_lock); */
 
 	return tqe;
 }
@@ -856,7 +821,6 @@ INLINE void chip_wakeup(void)
 
 		do {
 			/* Wait for the chip to stabilize*/
-/*			WILC_Sleep(2); */
 			mdelay(3);
 
 			/* Make sure chip is awake. This is an extra step that can be removed */
@@ -988,9 +952,7 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 #ifdef BIG_ENDIAN
 				vmm_table[i] = BYTE_SWAP(vmm_table[i]);
 #endif
-				/* p->hif_func.hif_write_reg(0x1160,vmm_table[0]); */
 
-				/* wilc_debug(N_TXQ, "[wilc txq]: vmm table[%d] = %08x\n", i, vmm_table[i]); */
 				i++;
 				sum += vmm_sz;
 				PRINT_D(TX_DBG, "sum = %d\n", sum);
@@ -1158,11 +1120,6 @@ static int wilc_wlan_handle_txq(uint32_t *pu32TxqCount)
 					header &= ~(1 << 30);
 				}
 #endif
-				/*else if(tqe->type == WILC_DATA_PKT_MAC_HDR)
-				 * {
-				 *      header |= (1<< 29);
-				 * }*/
-				/* wilc_debug(N_TXQ, "[wilc txq]: header (%08x), real size (%d), vmm size (%d)\n", header, tqe->buffer_size, vmm_sz); */
 
 #ifdef BIG_ENDIAN
 				header = BYTE_SWAP(header);
@@ -1232,7 +1189,6 @@ _end_:
 		if (ret != 1)
 			break;
 	} while (0);
-	/* remove_TCP_related(); */
 	/*Added by Amr - BugID_4720*/
 	p->os_func.os_signal(p->txq_add_to_head_lock);
 
@@ -1317,7 +1273,6 @@ static void wilc_wlan_handle_rxq(void)
 			else
 			#endif
 			{
-				/* wilc_debug(N_RXQ, "[wilc rxq]: packet, tp len(%d), len (%d), offset (%d), cfg (%d)\n", tp_len, pkt_len, pkt_offset, is_cfg_packet); */
 
 				if (!is_cfg_packet) {
 
@@ -1341,7 +1296,6 @@ static void wilc_wlan_handle_rxq(void)
 						if (p->cfg_seq_no == rsp.seq_no) {
 							p->os_func.os_signal(p->cfg_wait);
 						}
-						/* p->os_func.os_signal(p->cfg_wait); */
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
 						/**
 						 *      Call back to indicate status...
@@ -1741,7 +1695,6 @@ static int wilc_wlan_start(void)
 	 *      Go...
 	 **/
 
-	/* p->hif_func.hif_write_reg(0x150014, reg); */
 
 	p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 	if ((reg & (1ul << 10)) == (1ul << 10)) {
@@ -1850,22 +1803,6 @@ static void wilc_wlan_cleanup(void)
 	int ret;
 
 	p->quit = 1;
-	/**
-	 *      wait for queue end
-	 **/
-	/* p->os_func.os_signal(p->txq_wait); */
-	/* p->os_func.os_signal(p->rxq_wait); */
-
-	/* complete(p->txq_wait); */
-	/* complete(p->rxq_wait); */
-	/*do {
-	 *      if (p->txq_exit && p->rxq_exit)
-	 *              break;
-	 * } while (1);*/
-
-	/**
-	 *      clean up the queue
-	 **/
 	do {
 		tqe = wilc_wlan_txq_remove_from_head();
 		if (tqe == NULL)
@@ -2231,7 +2168,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 #if defined (MEMORY_STATIC)
 	g_wlan.rx_buffer_size = inp->os_context.rx_buffer_size;
 #endif
-	/* g_wlan.os_func.os_lock(g_wlan.cfg_wait); */
 	/***
 	 *      host interface init
 	 **/
@@ -2331,7 +2267,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	oup->wlan_add_to_tx_que = wilc_wlan_txq_add_net_pkt;
 	oup->wlan_handle_tx_que = wilc_wlan_handle_txq;
 	oup->wlan_handle_rx_que = wilc_wlan_handle_rxq;
-	/* oup->wlan_handle_rx_isr = wilc_wlan_handle_isr; */
 	oup->wlan_handle_rx_isr = wilc_handle_isr;
 	oup->wlan_cleanup = wilc_wlan_cleanup;
 	oup->wlan_cfg_set = wilc_wlan_cfg_set;
-- 
2.1.4
