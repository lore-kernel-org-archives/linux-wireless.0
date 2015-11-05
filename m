Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27072 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030350AbbKEFgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:40 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 33/38] staging: wilc1000: remove goto from mac_open
Date: Thu, 5 Nov 2015 14:36:34 +0900
Message-ID: <1446701799-24870-33-git-send-email-glen.lee@atmel.com> (sfid-20151105_063647_973810_6BF5E795)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes goto from mac_open function. If address is invalid, goto
handles deinit process and return result.
So, just call deinit process and return the error value directly instead of
goto statement.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3c8155e..6492103 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1124,8 +1124,9 @@ int mac_open(struct net_device *ndev)
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
-		ret = -EINVAL;
-		goto _err_;
+		wilc_deinit_host_int(ndev);
+		wilc1000_wlan_deinit(ndev);
+		return -EINVAL;
 	}
 
 	wilc_mgmt_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy,
@@ -1140,11 +1141,6 @@ int mac_open(struct net_device *ndev)
 	wl->open_ifcs++;
 	nic->mac_opened = 1;
 	return 0;
-
-_err_:
-	wilc_deinit_host_int(ndev);
-	wilc1000_wlan_deinit(ndev);
-	return ret;
 }
 
 struct net_device_stats *mac_stats(struct net_device *dev)
-- 
1.9.1

