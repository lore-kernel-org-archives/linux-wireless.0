Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26854 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483AbbKEFfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:35:43 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 23/38] staging: wilc1000: rename function GetIfHandler
Date: Thu, 5 Nov 2015 14:36:24 +0900
Message-ID: <1446701799-24870-23-git-send-email-glen.lee@atmel.com> (sfid-20151105_063756_062689_D2B08BFF)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames GetIfHandler function name to get_if_handler
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 94efb4a..3da80cd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -331,7 +331,7 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 	}
 }
 
-struct net_device *GetIfHandler(struct wilc *wilc, u8 *pMacHeader)
+struct net_device *get_if_handler(struct wilc *wilc, u8 *pMacHeader)
 {
 	u8 *Bssid, *Bssid1;
 	int i = 0;
@@ -1422,7 +1422,7 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 	struct net_device *wilc_netdev;
 	perInterface_wlan_t *nic;
 
-	wilc_netdev = GetIfHandler(wilc, buff);
+	wilc_netdev = get_if_handler(wilc, buff);
 	if (!wilc_netdev)
 		return;
 
-- 
1.9.1

