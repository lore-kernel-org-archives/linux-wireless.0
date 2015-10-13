Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2974 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbbJMKxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/54] staging: wilc1000: remove duplicate copy routine
Date: Tue, 13 Oct 2015 19:49:48 +0900
Message-ID: <1444733419-17679-23-git-send-email-tony.cho@atmel.com> (sfid-20151013_125310_331263_720C74FD)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove the duplicate bssid copy routine.
Already ahead bssid copy routine execute.
Therefore do not necessary in this routine.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0296bd9..91ea327 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1152,10 +1152,6 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
 	pu8CurrByte += 6;
 
-	if (pstrHostIFconnectAttr->pu8bssid != NULL)
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
-	pu8CurrByte += 6;
-
 	*(pu8CurrByte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
 	*(pu8CurrByte++)  = ((ptstrJoinBssParam->beacon_period) >> 8) & 0xFF;
 	PRINT_D(HOSTINF_DBG, "* Beacon Period %d*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
-- 
1.9.1

