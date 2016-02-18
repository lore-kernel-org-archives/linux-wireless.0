Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40025 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933423AbcBRHaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 02:30:22 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/24] staging: wilc1000: linux_mon.c: replaces PRINT_ER with netdev_err
Date: Thu, 18 Feb 2016 16:27:14 +0900
Message-ID: <1455780455-21365-3-git-send-email-leo.kim@atmel.com> (sfid-20160218_083033_013939_837648D1)
In-Reply-To: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
References: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches replaces PRINT_ER with netdev_err.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 9edc6e9..3048e88 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -308,7 +308,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 
 	ret = register_netdevice(wilc_wfi_mon);
 	if (ret) {
-		PRINT_ER(" register_netdevice failed (%d)\n", ret);
+		netdev_err(real_dev, "register_netdevice failed\n");
 		return NULL;
 	}
 	priv = netdev_priv(wilc_wfi_mon);
-- 
1.9.1

