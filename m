Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25506 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbIXJNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:13:37 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/15] staging: wilc1000: remove pointer varialbe cfg_wait and cfg_wait_event
Date: Thu, 24 Sep 2015 18:14:59 +0900
Message-ID: <1443086106-20482-8-git-send-email-glen.lee@atmel.com> (sfid-20150924_111342_257231_FC5B5724)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes cfg_wait and cfg_wait_event which are pointer of
g_linux_wlan->cfg_event. No need to have pointer varialbe of it. Just use
g_linux_wlan->cfg_event.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   |  2 --
 drivers/staging/wilc1000/wilc_wlan.c    | 14 +++++++-------
 drivers/staging/wilc1000/wilc_wlan_if.h |  2 --
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5bec7f2..2893776 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1065,8 +1065,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 #if defined(MEMORY_STATIC)
 	nwi->os_context.rx_buffer_size = LINUX_RX_SIZE;
 #endif
-	nwi->os_context.cfg_wait_event = (void *)&g_linux_wlan->cfg_event;
-
 	nwi->os_func.os_wait = linux_wlan_lock_timeout;
 
 #ifdef WILC_SDIO
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e70c367..5bca997 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -47,7 +47,6 @@ typedef struct {
 	wilc_cfg_frame_t cfg_frame;
 	u32 cfg_frame_offset;
 	int cfg_seq_no;
-	void *cfg_wait;
 
 	/**
 	 *      RX buffer
@@ -485,7 +484,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	PRINT_D(TX_DBG, "Adding config packet ...\n");
 	if (p->quit) {
 		PRINT_D(TX_DBG, "Return due to clear function\n");
-		up(p->cfg_wait);
+		up(&g_linux_wlan->cfg_event);
 		return 0;
 	}
 
@@ -1137,7 +1136,7 @@ static void wilc_wlan_handle_rxq(void)
 	do {
 		if (p->quit) {
 			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function\n");
-			up(p->cfg_wait);
+			up(&g_linux_wlan->cfg_event);
 			break;
 		}
 		rqe = wilc_wlan_rxq_remove();
@@ -1211,7 +1210,7 @@ static void wilc_wlan_handle_rxq(void)
 						 **/
 						PRINT_D(RX_DBG, "p->cfg_seq_no = %d - rsp.seq_no = %d\n", p->cfg_seq_no, rsp.seq_no);
 						if (p->cfg_seq_no == rsp.seq_no) {
-							up(p->cfg_wait);
+							up(&g_linux_wlan->cfg_event);
 						}
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
 						/**
@@ -1781,7 +1780,8 @@ static int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size, in
 		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
 			ret_size = 0;
 
-		if (p->os_func.os_wait(p->cfg_wait, CFG_PKTS_TIMEOUT)) {
+		if (p->os_func.os_wait(&g_linux_wlan->cfg_event,
+				       CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Set Timed Out\n");
 			ret_size = 0;
 		}
@@ -1818,7 +1818,8 @@ static int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 			ret_size = 0;
 
 
-		if (p->os_func.os_wait(p->cfg_wait, CFG_PKTS_TIMEOUT)) {
+		if (p->os_func.os_wait(&g_linux_wlan->cfg_event,
+				       CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Get Timed Out\n");
 			ret_size = 0;
 		}
@@ -1972,7 +1973,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 
 	g_wlan.txq_add_to_head_lock = inp->os_context.txq_add_to_head_critical_section;
 
-	g_wlan.cfg_wait = inp->os_context.cfg_wait_event;
 	g_wlan.tx_buffer_size = inp->os_context.tx_buffer_size;
 #if defined (MEMORY_STATIC)
 	g_wlan.rx_buffer_size = inp->os_context.rx_buffer_size;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 1a0bfdb..f761347 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -118,8 +118,6 @@ typedef struct {
 #if defined(MEMORY_STATIC)
 	u32 rx_buffer_size;
 #endif
-
-	struct semaphore *cfg_wait_event;
 } wilc_wlan_os_context_t;
 
 typedef struct {
-- 
1.9.1

