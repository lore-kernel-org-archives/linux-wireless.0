Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59057 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747AbbKSGyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:12 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/26] staging: wilc1000: rename duringIP_TIME variable
Date: Thu, 19 Nov 2015 15:56:20 +0900
Message-ID: <1447916195-24851-11-git-send-email-glen.lee@atmel.com> (sfid-20151119_082253_089289_DDD691FB)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames duringIP_TIME variable to during_ip_time
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 24e1e15..c49b989 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -200,7 +200,7 @@ static bool g_gtk_keys_saved;
 static bool g_wep_keys_saved;
 
 #define AGING_TIME	(9 * 1000)
-#define duringIP_TIME 15000
+#define during_ip_time	15000
 
 static void clear_shadow_scan(void *pUserVoid)
 {
@@ -2772,7 +2772,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(GENERIC_DBG, "start duringIP timer\n");
 
 		wilc_optaining_ip = true;
-		mod_timer(&wilc_during_ip_timer, jiffies + msecs_to_jiffies(duringIP_TIME));
+		mod_timer(&wilc_during_ip_timer,
+			  jiffies + msecs_to_jiffies(during_ip_time));
 		wilc_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
 		/*Delete block ack has to be the latest config packet*/
 		/*sent before downloading new FW. This is because it blocks on*/
-- 
1.9.1

