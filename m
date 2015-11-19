Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59478 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbbKSGzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:55:39 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 26/26] staging: wilc1000: rename pstrNetworkInfo in get_rssi_avg function
Date: Thu, 19 Nov 2015 15:56:35 +0900
Message-ID: <1447916195-24851-26-git-send-email-glen.lee@atmel.com> (sfid-20151119_082254_778821_E16BE62F)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrNetworkInfo to network_info that is
first argument of get_rssi_avg function to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a429167..bcfddbf 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -224,14 +224,14 @@ static void clear_shadow_scan(void)
 
 }
 
-static u32 get_rssi_avg(tstrNetworkInfo *pstrNetworkInfo)
+static u32 get_rssi_avg(tstrNetworkInfo *network_info)
 {
 	u8 i;
 	int rssi_v = 0;
-	u8 num_rssi = (pstrNetworkInfo->strRssi.u8Full) ? NUM_RSSI : (pstrNetworkInfo->strRssi.u8Index);
+	u8 num_rssi = (network_info->strRssi.u8Full) ? NUM_RSSI : (network_info->strRssi.u8Index);
 
 	for (i = 0; i < num_rssi; i++)
-		rssi_v += pstrNetworkInfo->strRssi.as8RSSI[i];
+		rssi_v += network_info->strRssi.as8RSSI[i];
 
 	rssi_v /= num_rssi;
 	return rssi_v;
-- 
1.9.1

