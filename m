Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:34478 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbJPJXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 05:23:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/13] staging: wilc1000: mac_open: use netdev private wilc
Date: Fri, 16 Oct 2015 18:23:00 +0900
Message-ID: <1444987389-14151-4-git-send-email-tony.cho@atmel.com> (sfid-20151016_112347_090860_14748D85)
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
 drivers/staging/wilc1000/linux_wlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 38b981d..4450658 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1166,13 +1166,14 @@ int mac_open(struct net_device *ndev)
 	int i = 0;
 	struct wilc_priv *priv;
 
+	nic = netdev_priv(ndev);
+	wl = nic->wilc;
 #ifdef WILC_SPI
 	if (!wl || !wl->wilc_spidev) {
 		netdev_err(ndev, "wilc1000: SPI device not ready\n");
 		return -ENODEV;
 	}
 #endif
-	nic = netdev_priv(ndev);
 	priv = wiphy_priv(nic->wilc_netdev->ieee80211_ptr->wiphy);
 	PRINT_D(INIT_DBG, "MAC OPEN[%p]\n", ndev);
 
-- 
1.9.1

