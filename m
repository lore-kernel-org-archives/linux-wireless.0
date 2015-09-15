Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34292 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbbIOJi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 05:38:57 -0400
From: Ronit Halder <ronit.crj@gmail.com>
To: johnny.kim@atmel.com
Cc: rachel.kim@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Ronit Halder <ronit.crj@gmail.com>
Subject: [PATCH 2/2] Staging: wilc1000: fix NULL comparison style
Date: Tue, 15 Sep 2015 15:08:15 +0530
Message-Id: <1442309895-12563-1-git-send-email-ronit.crj@gmail.com> (sfid-20150915_113922_775908_D2847780)
In-Reply-To: <1442309698-12393-1-git-send-email-ronit.crj@gmail.com>
References: <1442309698-12393-1-git-send-email-ronit.crj@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed NULL comparison style as suggested by checkpatch.pl with --strict option.

Signed-off-by: Ronit halder <ronit.crj@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 drivers/staging/wilc1000/linux_wlan.c       | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 8164a33..872400a 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -670,7 +670,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
 
 		/* Get DTIM Period */
 		pu8TimElm = get_tim_elm(pu8msa, (u16RxLen + FCS_LEN), u8index);
-		if (pu8TimElm != NULL)
+		if (pu8TimElm)
 			pstrNetworkInfo->u8DtimPeriod = pu8TimElm[3];
 		pu8IEs = &pu8msa[MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN];
 		u16IEsLen = u16RxLen - (MAC_HDR_LEN + TIME_STAMP_LEN + BEACON_INTERVAL_LEN + CAP_INFO_LEN);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d8f17c6..d2b0ce6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -412,7 +412,7 @@ static int isr_bh_routine(void *vp)
 			break;
 		}
 		PRINT_D(INT_DBG, "Interrupt received BH\n");
-		if (g_linux_wlan->oup.wlan_handle_rx_isr != NULL)
+		if (g_linux_wlan->oup.wlan_handle_rx_isr)
 			g_linux_wlan->oup.wlan_handle_rx_isr();
 		else
 			PRINT_ER("wlan_handle_rx_isr() hasn't been initialized\n");
@@ -1284,7 +1284,7 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
 #elif (RX_BH_TYPE == RX_BH_KTHREAD)
 	PRINT_D(INIT_DBG, "Creating kthread for Rxq BH\n");
 	g_linux_wlan->rx_bh_thread = kthread_run(isr_bh_routine, (void *)g_linux_wlan, "K_RXQ_BH");
-	if (g_linux_wlan->rx_bh_thread == NULL) {
+	if (!g_linux_wlan->rx_bh_thread) {
 		PRINT_ER("couldn't create RX BH thread\n");
 		ret = -ENOBUFS;
 		goto _fail_;
@@ -1309,7 +1309,7 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
 	/* create tx task */
 	PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
 	g_linux_wlan->txq_thread = kthread_run(linux_wlan_txq_task, (void *)g_linux_wlan, "K_TXQ_TASK");
-	if (g_linux_wlan->txq_thread == NULL) {
+	if (!g_linux_wlan->txq_thread) {
 		PRINT_ER("couldn't create TXQ thread\n");
 		ret = -ENOBUFS;
 		goto _fail_2;
-- 
2.4.0.GIT

