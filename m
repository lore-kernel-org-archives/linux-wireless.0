Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7553 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbbKBIuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:50:05 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/38] staging: wilc1000: linux_wlan: remove unused defines
Date: Mon, 2 Nov 2015 17:51:01 +0900
Message-ID: <1446454281-22484-18-git-send-email-glen.lee@atmel.com> (sfid-20151102_095011_444848_3C7B13E0)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused defines from linux_wlan.c file.
 - NM73131
 - PLAT_CLM9722
Two defines are support custom feature that don't used anymore.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e7e5229..82495ce 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1540,15 +1540,9 @@ int wilc_netdev_init(struct wilc **wilc)
 		nic = netdev_priv(ndev);
 		memset(nic, 0, sizeof(perInterface_wlan_t));
 
-		if (i == 0) {
-		#if defined(NM73131)
-			strcpy(ndev->name, "wilc_eth%d");
-		#elif defined(PLAT_CLM9722)
-			strcpy(ndev->name, "eth%d");
-		#else
+		if (i == 0)
 			strcpy(ndev->name, "wlan%d");
-		#endif
-		} else
+		else
 			strcpy(ndev->name, "p2p%d");
 
 		nic->u8IfIdx = wl->vif_num;
-- 
1.9.1

