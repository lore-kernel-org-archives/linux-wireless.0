Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:34463 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbJPJXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 05:23:37 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/13] staging: wilc1000: wlan_init_locks: change parameter and use nic-wilc
Date: Fri, 16 Oct 2015 18:22:59 +0900
Message-ID: <1444987389-14151-3-git-send-email-tony.cho@atmel.com> (sfid-20151016_112341_591999_B946626D)
In-Reply-To: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
References: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch changes function parameter type wilc with net_device and use netdev
private data member wilc instead of global variable wl.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f79160c..38b981d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -921,8 +921,13 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 	}
 }
 
-int wlan_init_locks(struct wilc *p_nic)
+int wlan_init_locks(struct net_device *dev)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
 
 	PRINT_D(INIT_DBG, "Initializing Locks ...\n");
 
@@ -1032,7 +1037,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		wl->mac_status = WILC_MAC_STATUS_INIT;
 		wl->close = 0;
 
-		wlan_init_locks(wl);
+		wlan_init_locks(dev);
 
 		linux_to_wlan(&nwi, wl);
 
-- 
1.9.1

