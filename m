Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47274 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044AbbKFJiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:38:16 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/26] staging: wilc1000: call linux_sdio_init instead of io_init
Date: Fri, 6 Nov 2015 18:40:07 +0900
Message-ID: <1446802823-22598-11-git-send-email-glen.lee@atmel.com> (sfid-20151106_103825_856817_A2ABA108)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just call linux_sdio_init instead of io_init function pointer.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 6f48839..0d88b6e 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -562,11 +562,9 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 	g_sdio.dPrint = func;
 	g_sdio.os_context = inp->os_context.os_private;
 
-	if (inp->io_func.io_init) {
-		if (!inp->io_func.io_init(g_sdio.os_context)) {
-			g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
-			return 0;
-		}
+	if (!linux_sdio_init(g_sdio.os_context)) {
+		g_sdio.dPrint(N_ERR, "[wilc sdio]: Failed io init bus...\n");
+		return 0;
 	} else {
 		return 0;
 	}
-- 
1.9.1

