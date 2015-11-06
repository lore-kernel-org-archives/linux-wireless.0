Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47715 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032934AbbKFJju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:50 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 26/26] staging: wilc1000: remove os_private
Date: Fri, 6 Nov 2015 18:40:23 +0900
Message-ID: <1446802823-22598-27-git-send-email-glen.lee@atmel.com> (sfid-20151106_110753_898528_37BC615E)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused variable os_private and delete
struct wilc_wlan_os_context_t since there is no members in it. Remove it's
related code also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 --
 drivers/staging/wilc1000/wilc_wlan_if.h | 5 -----
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index fcc669c..086f1db 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -888,8 +888,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, struct wilc *nic)
 {
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
 
-	nwi->os_context.os_private = (void *)nic;
-
 #ifdef WILC_SDIO
 	nwi->io_func.io_type = HIF_SDIO;
 #else
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index b43e439..5980ece 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -84,11 +84,6 @@ typedef struct {
 #define WILC_MAC_INDICATE_SCAN		0x2
 
 typedef struct {
-	void *os_private;
-} wilc_wlan_os_context_t;
-
-typedef struct {
-	wilc_wlan_os_context_t os_context;
 	wilc_wlan_io_func_t io_func;
 } wilc_wlan_inp_t;
 
-- 
1.9.1

