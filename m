Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7659 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbbKBIue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:50:34 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/38] staging: wilc1000: rename function GetIfHandler
Date: Mon, 2 Nov 2015 17:51:06 +0900
Message-ID: <1446454281-22484-23-git-send-email-glen.lee@atmel.com> (sfid-20151102_095036_488879_C05DC40D)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
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
index 753405e..8321b76 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -332,7 +332,7 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag)
 	}
 }
 
-struct net_device *GetIfHandler(struct wilc *wilc, u8 *pMacHeader)
+struct net_device *get_if_handler(struct wilc *wilc, u8 *pMacHeader)
 {
 	u8 *Bssid, *Bssid1;
 	int i = 0;
@@ -1427,7 +1427,7 @@ void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset)
 	struct net_device *wilc_netdev;
 	perInterface_wlan_t *nic;
 
-	wilc_netdev = GetIfHandler(wilc, buff);
+	wilc_netdev = get_if_handler(wilc, buff);
 	if (!wilc_netdev)
 		return;
 
-- 
1.9.1

