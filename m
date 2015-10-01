Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3463 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbbJAHEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:04:25 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/12] staging: wilc1000: remove function pointer wlan_handle_tx_que
Date: Thu, 1 Oct 2015 16:03:36 +0900
Message-ID: <1443683023-6498-5-git-send-email-tony.cho@atmel.com> (sfid-20151001_090428_219211_7ED9BC51)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_handle_tx_que and just call
the function wilc_wlan_handle_txq. Remove static from the function also.
There is one function call wlan_handle_tx_que which does not have an argument
and return value. So put txq_count as argument and ret for return value.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c    | 3 +--
 drivers/staging/wilc1000/wilc_wlan.h    | 1 +
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e40ee8c..c2c9f3a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -517,10 +517,10 @@ static int linux_wlan_txq_task(void *vp)
 		}
 		PRINT_D(TX_DBG, "txq_task handle the sending packet and let me go to sleep.\n");
 #if !defined USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
-		g_linux_wlan->oup.wlan_handle_tx_que();
+		ret = wilc_wlan_handle_txq(&txq_count);
 #else
 		do {
-			ret = g_linux_wlan->oup.wlan_handle_tx_que(&txq_count);
+			ret = wilc_wlan_handle_txq(&txq_count);
 			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD /* && netif_queue_stopped(pd->wilc_netdev)*/) {
 				PRINT_D(TX_DBG, "Waking up queue\n");
 				/* netif_wake_queue(pd->wilc_netdev); */
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index fcc4155..32045a9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -816,7 +816,7 @@ void chip_sleep_manually(u32 u32SleepTime)
  *      Tx, Rx queue handle functions
  *
  ********************************************/
-static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
+int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	int i, entries = 0;
@@ -2028,7 +2028,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_handle_tx_que = wilc_wlan_handle_txq;
 	oup->wlan_handle_rx_isr = wilc_handle_isr;
 	oup->wlan_cleanup = wilc_wlan_cleanup;
 	oup->wlan_cfg_set = wilc_wlan_cfg_set;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2af027c..7a395cf 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -310,4 +310,5 @@ int wilc_wlan_start(void);
 int wilc_wlan_stop(void);
 int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
 			      wilc_tx_complete_func_t func);
+int wilc_wlan_handle_txq(u32 *pu32TxqCount);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 25d9d90..d41a1d4 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	int (*wlan_handle_tx_que)(u32 *);
 	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
 	int (*wlan_cfg_set)(int, u32, u8 *, u32, int, u32);
-- 
1.9.1

