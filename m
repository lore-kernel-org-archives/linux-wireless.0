Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26727 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030656AbbKEFfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:35:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 18/38] staging: wilc1000: linux_wlan: remove unused defines
Date: Thu, 5 Nov 2015 14:36:19 +0900
Message-ID: <1446701799-24870-18-git-send-email-glen.lee@atmel.com> (sfid-20151105_063801_601752_A30B010D)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
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
index 105dbc8..432f0be 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1534,15 +1534,9 @@ int wilc_netdev_init(struct wilc **wilc)
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
 
 		nic->u8IfIdx = g_linux_wlan->vif_num;
-- 
1.9.1

