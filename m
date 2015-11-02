Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7446 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbbKBItk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:49:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/38] staging: wilc1000: rename pstrWFIDrv of function mac_close
Date: Mon, 2 Nov 2015 17:50:57 +0900
Message-ID: <1446454281-22484-14-git-send-email-glen.lee@atmel.com> (sfid-20151102_094943_595487_07336A57)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrWFIDrv of function mac_close to hif_drv
to avoid CamelCase naming convention.
And, some debug print modification that has been included name 'pstrWFIDrv'.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4dffae5..9811949 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1434,7 +1434,7 @@ int mac_close(struct net_device *ndev)
 {
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *hif_drv;
 	struct wilc *wl;
 
 	nic = netdev_priv(ndev);
@@ -1453,7 +1453,7 @@ int mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	PRINT_D(GENERIC_DBG, "Mac close\n");
 
@@ -1462,8 +1462,8 @@ int mac_close(struct net_device *ndev)
 		return 0;
 	}
 
-	if (!pstrWFIDrv) {
-		PRINT_ER("pstrWFIDrv = NULL\n");
+	if (!hif_drv) {
+		PRINT_ER("hif_drv = NULL\n");
 		return 0;
 	}
 
-- 
1.9.1

