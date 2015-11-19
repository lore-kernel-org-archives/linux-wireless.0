Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59297 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbKSGzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:55:04 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/26] staging: wilc1000: rename pUserVoid in is_network_in_shadow function
Date: Thu, 19 Nov 2015 15:56:29 +0900
Message-ID: <1447916195-24851-20-git-send-email-glen.lee@atmel.com> (sfid-20151119_082254_530253_DBC378D1)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pUserVoid to user_void that is
second argument of is_network_in_shadow function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 56005f6..5a9d0e2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -330,14 +330,15 @@ static void clear_duringIP(unsigned long arg)
 	wilc_optaining_ip = false;
 }
 
-static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid)
+static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo,
+				void *user_void)
 {
 	int state = -1;
 	int i;
 
 	if (last_scanned_cnt == 0) {
 		PRINT_D(CFG80211_DBG, "Starting Aging timer\n");
-		hAgingTimer.data = (unsigned long)pUserVoid;
+		hAgingTimer.data = (unsigned long)user_void;
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
 		state = -1;
 	} else {
-- 
1.9.1

