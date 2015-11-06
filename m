Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36467 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031107AbbKFCLD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:03 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/73] staging: wilc1000: fixes blank lines aren't necessary brace
Date: Fri, 6 Nov 2015 11:12:27 +0900
Message-ID: <1446776014-28094-6-git-send-email-glen.lee@atmel.com> (sfid-20151106_031107_995168_8B379D8C)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the checks reported by checkpatch.pl
for Blank lines aren't necessary after an open brace '{' and
Blank lines aren't necessary before a close brace '}'.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5db87c0..603541c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -59,7 +59,6 @@ static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
 
 static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 {
-
 	mutex_lock(&g_linux_wlan->hif_cs);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
 	if (genuChipPSstate != CHIP_WAKEDUP)
@@ -68,7 +67,6 @@ static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 		if (acquire == ACQUIRE_AND_WAKEUP)
 			chip_wakeup();
 	}
-
 }
 static inline void release_bus(BUS_RELEASE_T release)
 {
@@ -81,10 +79,8 @@ static inline void release_bus(BUS_RELEASE_T release)
 
 static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 {
-
 	wilc_wlan_dev_t *p = &g_wlan;
 	if (tqe == p->txq_head)	{
-
 		p->txq_head = tqe->next;
 		if (p->txq_head)
 			p->txq_head->prev = NULL;
@@ -97,7 +93,6 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 		tqe->next->prev = tqe->prev;
 	}
 	p->txq_entries -= 1;
-
 }
 
 static struct txq_entry_t *
@@ -191,7 +186,6 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
 	return 0;
-
 }
 
 u32 Statisitcs_totalAcks = 0, Statisitcs_DroppedAcks = 0;
@@ -228,9 +222,7 @@ u32 Pending_Acks;
 
 static inline int Init_TCP_tracking(void)
 {
-
 	return 0;
-
 }
 static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
@@ -246,11 +238,9 @@ static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 
 static inline int Update_TCP_track_session(u32 index, u32 Ack)
 {
-
 	if (Ack > Acks_keep_track_info[index].Bigger_Ack_num)
 		Acks_keep_track_info[index].Bigger_Ack_num = Ack;
 	return 0;
-
 }
 static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_entry_t  *txqe)
 {
@@ -261,7 +251,6 @@ static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_ent
 		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].Session_index = Session_index;
 		txqe->tcp_PendingAck_index = PendingAcks_arrBase + Pending_Acks;
 		Pending_Acks++;
-
 	} else {
 
 	}
@@ -466,7 +455,6 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func)
 {
-
 	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
 
@@ -605,7 +593,6 @@ static inline void chip_wakeup(void)
 
 				if ((clk_status_reg & 0x1) == 0)
 					wilc_debug(N_ERR, "clocks still OFF. Wake up failed\n");
-
 			}
 			if ((clk_status_reg & 0x1) == 0) {
 				g_wlan.hif_func.hif_write_reg(0xf0, reg &
@@ -694,7 +681,6 @@ void chip_sleep_manually(u32 u32SleepTime)
 
 	genuChipPSstate = CHIP_SLEEPING_MANUAL;
 	release_bus(RELEASE_ONLY);
-
 }
 
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
@@ -733,7 +719,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 		sum = 0;
 		do {
 			if ((tqe != NULL) && (i < (WILC_VMM_TBL_SIZE - 1))) {
-
 				if (tqe->type == WILC_CFG_PKT)
 					vmm_sz = ETH_CONFIG_PKT_HDR_OFFSET;
 
@@ -782,7 +767,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 		acquire_bus(ACQUIRE_AND_WAKEUP);
 		counter = 0;
 		do {
-
 			ret = p->hif_func.hif_read_reg(WILC_HOST_TX_CTRL, &reg);
 			if (!ret) {
 				wilc_debug(N_ERR, "[wilc txq]: fail can't read reg vmm_tbl_entry..\n");
@@ -1015,7 +999,6 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			}
 			else
 			{
-
 				if (!is_cfg_packet) {
 					if (pkt_len > 0) {
 						frmw_to_linux(wilc,
@@ -1064,7 +1047,6 @@ static void wilc_unknown_isr_ext(void)
 }
 static void wilc_pllupdate_isr_ext(u32 int_stats)
 {
-
 	int trials = 10;
 
 	g_wlan.hif_func.hif_clear_int_ext(PLL_INT_CLR);
@@ -1106,7 +1088,6 @@ static void wilc_wlan_handle_isr_ext(struct wilc *wilc, u32 int_status)
 		p->hif_func.hif_read_size(&size);
 		size = ((size & 0x7fff) << 2);
 		retries++;
-
 	}
 
 	if (size > 0) {
@@ -1457,7 +1438,6 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	}
 	release_bus(RELEASE_ALLOW_SLEEP);
 	p->hif_func.hif_deinit(NULL);
-
 }
 
 static int wilc_wlan_cfg_commit(int type, u32 drvHandler)
@@ -1523,7 +1503,6 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		p->cfg_frame_in_use = 0;
 		p->cfg_frame_offset = 0;
 		p->cfg_seq_no += 1;
-
 	}
 
 	return ret_size;
@@ -1614,7 +1593,6 @@ u32 init_chip(struct net_device *dev)
 	release_bus(RELEASE_ONLY);
 
 	return ret;
-
 }
 
 u32 wilc_get_chipid(u8 update)
@@ -1653,7 +1631,6 @@ _fail_:
 
 int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 {
-
 	int ret = 0;
 
 	PRINT_D(INIT_DBG, "Initializing WILC_Wlan ...\n");
@@ -1726,7 +1703,6 @@ _fail_:
 	g_wlan.tx_buffer = NULL;
 
 	return ret;
-
 }
 
 u16 set_machw_change_vir_if(struct net_device *dev, bool bValue)
-- 
1.9.1

