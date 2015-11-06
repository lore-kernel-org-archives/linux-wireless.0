Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47587 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032934AbbKFJj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:39:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 22/26] staging: wilc1000: linux_sdio_init: remove parameter pv
Date: Fri, 6 Nov 2015 18:40:19 +0900
Message-ID: <1446802823-22598-23-git-send-email-glen.lee@atmel.com> (sfid-20151106_110754_201814_15A11D55)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function parameter pv which is not used and modify it's
related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c | 2 +-
 drivers/staging/wilc1000/linux_wlan_sdio.h | 2 +-
 drivers/staging/wilc1000/wilc_sdio.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index bf05e22..e854d37 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -214,7 +214,7 @@ static int linux_sdio_get_speed(void)
 	return local_sdio_func->card->host->ios.clock;
 }
 
-int linux_sdio_init(void *pv)
+int linux_sdio_init(void)
 {
 
 	/**
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index 4b515f5..6f42bc7 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -3,7 +3,7 @@ extern struct sdio_driver wilc_bus;
 
 #include <linux/mmc/sdio_func.h>
 
-int linux_sdio_init(void *);
+int linux_sdio_init(void);
 void linux_sdio_deinit(void *);
 int linux_sdio_cmd52(sdio_cmd52_t *cmd);
 int linux_sdio_cmd53(sdio_cmd53_t *cmd);
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 0d88b6e..01a8e5b 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -562,7 +562,7 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	g_sdio.dPrint = func;
 	g_sdio.os_context = inp->os_context.os_private;
 
-	if (!linux_sdio_init(g_sdio.os_context)) {
+	if (!linux_sdio_init()) {
 		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
 		return 0;
 	} else {
-- 
1.9.1

