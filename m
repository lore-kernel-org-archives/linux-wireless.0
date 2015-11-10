Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:58009 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbbKJXnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:43:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/20] staging/wilc1000: use device pointer for phy creation
Date: Wed, 11 Nov 2015 00:42:33 +0100
Message-Id: <1447198960-2760143-14-git-send-email-arnd@arndb.de> (sfid-20151111_004804_205362_B3193604)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_create_wiphy tries to get a pointer to a device from the
global wilc_sdio_func variable. This is a layering violation
and we can use the wilc_dev->dev pointer instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/linux_wlan_sdio.c        | 2 +-
 drivers/staging/wilc1000/linux_wlan_sdio.h        | 2 --
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 ++-------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 5 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b1707147aa7d..08c3be8728b2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1457,7 +1457,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type)
 
 		{
 			struct wireless_dev *wdev;
-			wdev = wilc_create_wiphy(ndev);
+			wdev = wilc_create_wiphy(ndev, dev);
 
 			if (dev)
 				SET_NETDEV_DEV(ndev, dev);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index d2843b949a1b..874a859cad21 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -22,7 +22,7 @@
  #define MAX_SPEED (6 * 1000000) /* Max 50M */
 #endif
 
-struct sdio_func *wilc_sdio_func;
+static struct sdio_func *wilc_sdio_func;
 static unsigned int sdio_default_speed;
 
 #define SDIO_VENDOR_ID_WILC 0x0296
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index 3e1618526e78..df733c25e770 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -1,7 +1,5 @@
 #include <linux/mmc/sdio_func.h>
 
-extern struct sdio_func *wilc_sdio_func;
-
 int wilc_sdio_init(void);
 int wilc_sdio_cmd52(sdio_cmd52_t *cmd);
 int wilc_sdio_cmd53(sdio_cmd53_t *cmd);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 46c3f578a6fd..cc279c654e53 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -11,9 +11,6 @@
  */
 
 #include "wilc_wfi_cfgoperations.h"
-#ifdef WILC_SDIO
-#include "linux_wlan_sdio.h"
-#endif
 #include "host_interface.h"
 #include <linux/errno.h>
 
@@ -3414,7 +3411,7 @@ _fail_:
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-struct wireless_dev *wilc_create_wiphy(struct net_device *net)
+struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *dev)
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
@@ -3466,9 +3463,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 		   wdev->wiphy->max_scan_ssids, wdev->wiphy->max_scan_ie_len, wdev->wiphy->signal_type,
 		   wdev->wiphy->interface_modes, wdev->iftype);
 
-	#ifdef WILC_SDIO
-	set_wiphy_dev(wdev->wiphy, &wilc_sdio_func->dev);
-	#endif
+	set_wiphy_dev(wdev->wiphy, dev);
 
 	/*Register wiphy structure*/
 	s32Error = wiphy_register(wdev->wiphy);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 158d98c0eb87..ab53d9d59081 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -10,7 +10,7 @@
 #define NM_WFI_CFGOPERATIONS
 #include "wilc_wfi_netdevice.h"
 
-struct wireless_dev *wilc_create_wiphy(struct net_device *net);
+struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *dev);
 void wilc_free_wiphy(struct net_device *net);
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed);
 int wilc_deinit_host_int(struct net_device *net);
-- 
2.1.0.rc2

