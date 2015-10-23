Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51900 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbJWF1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:27:06 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/28] staging: wilc1000: wilc_wlan_handle_txq: add argument and use wilc
Date: Fri, 23 Oct 2015 14:28:28 +0900
Message-ID: <1445578124-31486-12-git-send-email-glen.lee@atmel.com> (sfid-20151023_074656_755703_DF53CED1)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds argument net_device dev and use netdev private data memeber
wilc instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c |  4 ++--
 drivers/staging/wilc1000/wilc_wlan.c  | 11 ++++++++---
 drivers/staging/wilc1000/wilc_wlan.h  |  2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9c4fecb..4f9663d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -475,10 +475,10 @@ static int linux_wlan_txq_task(void *vp)
 		}
 		PRINT_D(TX_DBG, "txq_task handle the sending packet and let me go to sleep.\n");
 #if !defined USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
-		ret = wilc_wlan_handle_txq(&txq_count);
+		ret = wilc_wlan_handle_txq(dev, &txq_count);
 #else
 		do {
-			ret = wilc_wlan_handle_txq(&txq_count);
+			ret = wilc_wlan_handle_txq(dev, &txq_count);
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4fa956a..f694f2e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -814,7 +814,7 @@ void chip_sleep_manually(u32 u32SleepTime)
  *      Tx, Rx queue handle functions
  *
  ********************************************/
-int wilc_wlan_handle_txq(u32 *pu32TxqCount)
+int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int i, entries = 0;
@@ -828,13 +828,18 @@ int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 	int counter;
 	int timeout;
 	u32 vmm_table[WILC_VMM_TBL_SIZE];
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
 
 	p->txq_exit = 0;
 	do {
 		if (p->quit)
 			break;
 
-		linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+		linux_wlan_lock_timeout(&wl->txq_add_to_head_cs,
 					CFG_PKTS_TIMEOUT);
 #ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack();
@@ -1098,7 +1103,7 @@ _end_:
 		if (ret != 1)
 			break;
 	} while (0);
-	up(&g_linux_wlan->txq_add_to_head_cs);
+	up(&wl->txq_add_to_head_cs);
 
 	p->txq_exit = 1;
 	PRINT_D(TX_DBG, "THREAD: Exiting txq\n");
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index a07375b..79b35e6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -300,7 +300,7 @@ int wilc_wlan_start(void);
 int wilc_wlan_stop(void);
 int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
 			      wilc_tx_complete_func_t func);
-int wilc_wlan_handle_txq(u32 *pu32TxqCount);
+int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount);
 void wilc_handle_isr(void *wilc);
 void wilc_wlan_cleanup(void);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
-- 
1.9.1

