Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59324 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbbKSGzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:55:10 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/26] staging: wilc1000: rename pUserVoid in add_network_to_shadow function
Date: Thu, 19 Nov 2015 15:56:30 +0900
Message-ID: <1447916195-24851-21-git-send-email-glen.lee@atmel.com> (sfid-20151119_082251_929290_2FBF1CAB)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pUserVoid to user_void that is
second argument of add_network_to_shadow function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5a9d0e2..7905f37 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -354,9 +354,10 @@ static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo,
 	return state;
 }
 
-static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo, void *pUserVoid, void *pJoinParams)
+static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
+				  void *user_void, void *pJoinParams)
 {
-	int ap_found = is_network_in_shadow(pstrNetworkInfo, pUserVoid);
+	int ap_found = is_network_in_shadow(pstrNetworkInfo, user_void);
 	u32 ap_index = 0;
 	u8 rssi_index = 0;
 
-- 
1.9.1

