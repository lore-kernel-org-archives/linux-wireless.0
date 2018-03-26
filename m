Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35764 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbeCZNWF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 09:22:05 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com
Cc: gehariprasath@gmail.com,
        HariPrasath Elango <hariprasath.elango@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: remove unused return variable
Date: Mon, 26 Mar 2018 18:51:55 +0530
Message-Id: <20180326132155.24612-1-hariprasath.elango@gmail.com> (sfid-20180326_152219_883932_AE3C2B44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

In this function,removed the unused integer variable as it is not
actually used to return function success or failure. Return is a pointer
to net_device structure.

Signed-off-by: HariPrasath Elango <hariprasath.elango@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 47e3025..169213f 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -252,7 +252,7 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
  *  @brief      WILC_WFI_init_mon_interface
  *  @details
  *  @param[in]
- *  @return     int : Return 0 on Success
+ *  @return     Pointer to net_device
  *  @author	mdaftedar
  *  @date	12 JUL 2012
  *  @version	1.0
@@ -260,7 +260,6 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
 struct net_device *WILC_WFI_init_mon_interface(const char *name,
 					       struct net_device *real_dev)
 {
-	u32 ret = 0;
 	struct WILC_WFI_mon_priv *priv;
 
 	/*If monitor interface is already initialized, return it*/
@@ -275,8 +274,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name,
 	wilc_wfi_mon->name[IFNAMSIZ - 1] = 0;
 	wilc_wfi_mon->netdev_ops = &wilc_wfi_netdev_ops;
 
-	ret = register_netdevice(wilc_wfi_mon);
-	if (ret) {
+	if (register_netdevice(wilc_wfi_mon)) {
 		netdev_err(real_dev, "register_netdevice failed\n");
 		return NULL;
 	}
-- 
2.10.0.GIT
