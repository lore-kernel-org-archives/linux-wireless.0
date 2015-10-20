Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:59629 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbbJTWsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/19] staging/wilc1000: use device pointer for phy creation
Date: Wed, 21 Oct 2015 00:47:31 +0200
Message-Id: <1445381258-1455986-13-git-send-email-arnd@arndb.de> (sfid-20151021_005121_821133_FCFF49E3)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_create_wiphy tries to get a pointer to a device from the
global wilc1000_sdio_func variable. This is a layering violation
and we can use the wilc1000_dev->dev pointer instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 ++-------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h              | 1 +
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index aa6f5c7db139..abcb70bb1bd7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1638,7 +1638,7 @@ int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops)
 		{
 			struct wireless_dev *wdev;
 			/*Register WiFi*/
-			wdev = wilc_create_wiphy(ndev);
+			wdev = wilc_create_wiphy(ndev, wilc1000_dev->dev);
 
 			/* set netdev, tony */
 			if (dev)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 702c40c1df4b..7405fb8bae42 100644
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
 
@@ -3379,7 +3376,7 @@ _fail_:
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-struct wireless_dev *wilc_create_wiphy(struct net_device *net)
+struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *dev)
 {
 	struct wilc_priv *priv;
 	struct wireless_dev *wdev;
@@ -3431,9 +3428,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 		   wdev->wiphy->max_scan_ssids, wdev->wiphy->max_scan_ie_len, wdev->wiphy->signal_type,
 		   wdev->wiphy->interface_modes, wdev->iftype);
 
-	#ifdef WILC_SDIO
-	set_wiphy_dev(wdev->wiphy, &wilc1000_sdio_func->dev);
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
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 8c5253cce97c..2297e31b5b75 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -2,6 +2,7 @@
 #define WILC_WLAN_H
 
 #include <linux/types.h>
+#include <linux/netdevice.h>
 
 #define ISWILC1000(id)   (((id & 0xfffff000) == 0x100000) ? 1 : 0)
 
-- 
2.1.0.rc2

