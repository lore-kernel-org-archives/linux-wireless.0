Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59109 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbbKSGyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:24 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/26] staging: wilc1000: clear_shadow_scan: remove unused argument
Date: Thu, 19 Nov 2015 15:56:22 +0900
Message-ID: <1447916195-24851-13-git-send-email-glen.lee@atmel.com> (sfid-20151119_082252_252379_27C46C04)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes pUserVoid that is first argument of
clear_shadow_scan function because it is not used in this function.
Remove argument in the function call also.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 718b060..e72608b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -202,7 +202,7 @@ static bool g_wep_keys_saved;
 #define AGING_TIME	(9 * 1000)
 #define during_ip_time	15000
 
-static void clear_shadow_scan(void *pUserVoid)
+static void clear_shadow_scan(void)
 {
 	int i;
 
@@ -3523,7 +3523,7 @@ int wilc_deinit_host_int(struct net_device *net)
 	s32Error = wilc_deinit(priv->hWILCWFIDrv);
 
 	/* Clear the Shadow scan */
-	clear_shadow_scan(priv);
+	clear_shadow_scan();
 	if (op_ifcs == 0) {
 		PRINT_D(CORECONFIG_DBG, "destroy during ip\n");
 		del_timer_sync(&wilc_during_ip_timer);
-- 
1.9.1

