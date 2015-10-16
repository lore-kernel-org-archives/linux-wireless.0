Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:34524 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbbJPJXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 05:23:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/13] staging: wilc1000: chage_virtual_intf: use netdev private wilc
Date: Fri, 16 Oct 2015 18:23:02 +0900
Message-ID: <1444987389-14151-6-git-send-email-tony.cho@atmel.com> (sfid-20151016_112357_697617_F22FAF27)
In-Reply-To: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
References: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

Use netdev private data member wilc instead of global variable wl.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index ebba9d4..b34b7d0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2533,9 +2533,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	u8 interface_type;
 	u16 TID = 0;
 	u8 i;
+	struct wilc *wl;
 
 	nic = netdev_priv(dev);
 	priv = wiphy_priv(wiphy);
+	wl = nic->wilc;
 
 	PRINT_D(HOSTAPD_DBG, "In Change virtual interface function\n");
 	PRINT_D(HOSTAPD_DBG, "Wireless interface name =%s\n", dev->name);
-- 
1.9.1

