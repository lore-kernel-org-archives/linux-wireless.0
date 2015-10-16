Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:34500 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbbJPJXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 05:23:49 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/13] staging: wilc1000: mac_close: use netdev private wilc instead of wl
Date: Fri, 16 Oct 2015 18:23:01 +0900
Message-ID: <1444987389-14151-5-git-send-email-tony.cho@atmel.com> (sfid-20151016_112353_516125_DC084A5B)
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
 drivers/staging/wilc1000/linux_wlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4450658..8c98a0c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1377,6 +1377,7 @@ int mac_close(struct net_device *ndev)
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	struct host_if_drv *pstrWFIDrv;
+	struct wilc *wl;
 
 	nic = netdev_priv(ndev);
 
@@ -1386,6 +1387,7 @@ int mac_close(struct net_device *ndev)
 	}
 
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
+	wl = nic->wilc;
 
 	if (priv == NULL) {
 		PRINT_ER("priv = NULL\n");
-- 
1.9.1

