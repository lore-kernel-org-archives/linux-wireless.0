Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f193.google.com ([209.85.212.193]:35112 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbbJXWcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 18:32:04 -0400
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Punit Vara <punitvara@gmail.com>
Subject: [PATCH 2/3] Staging: wilc1000: Remove comparision of field address to NULL
Date: Sun, 25 Oct 2015 04:01:24 +0530
Message-Id: <1445725885-25995-3-git-send-email-punitvara@gmail.com> (sfid-20151025_003242_112929_35B43CF8)
In-Reply-To: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
References: <1445725885-25995-1-git-send-email-punitvara@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is patch to the linux_wlan file that fixes up following error
reported by coccicheck :

ERROR: test of a variable/field address

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b879b8b..1b0f89c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -907,7 +907,7 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 		disable_sdio_interrupt();
 		mutex_unlock(&g_linux_wlan->hif_cs);
 #endif
-		if (&g_linux_wlan->txq_event != NULL)
+		if (!(&g_linux_wlan->txq_event))
 			up(&g_linux_wlan->txq_event);
 
 		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
@@ -969,10 +969,10 @@ static int wlan_deinit_locks(struct wilc *nic)
 {
 	PRINT_D(INIT_DBG, "De-Initializing Locks\n");
 
-	if (&g_linux_wlan->hif_cs != NULL)
+	if (!(&g_linux_wlan->hif_cs))
 		mutex_destroy(&g_linux_wlan->hif_cs);
 
-	if (&g_linux_wlan->rxq_cs != NULL)
+	if (!(&g_linux_wlan->rxq_cs))
 		mutex_destroy(&g_linux_wlan->rxq_cs);
 
 	return 0;
@@ -1037,7 +1037,7 @@ static void wlan_deinitialize_threads(struct wilc *nic)
 	g_linux_wlan->close = 1;
 	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 
-	if (&g_linux_wlan->txq_event != NULL)
+	if (!(&g_linux_wlan->txq_event))
 		up(&g_linux_wlan->txq_event);
 
 	if (g_linux_wlan->txq_thread != NULL) {
-- 
2.5.3

