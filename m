Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36167 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbbIVJfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:10 -0400
Received: by pacgz1 with SMTP id gz1so2036258pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:10 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 02/16] staging: wilc1000: remove useless comment
Date: Tue, 22 Sep 2015 18:34:47 +0900
Message-Id: <1442914501-2315-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_113514_978805_5FD1E1D9)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes useless comment.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index eaec88c..58b1481 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -13,7 +13,7 @@
 #include "wilc_wfi_cfgoperations.h"
 #include "wilc_wlan.c"
 #ifdef WILC_SDIO
-#include "linux_wlan_sdio.h"    /* tony : for set_wiphy_dev() */
+#include "linux_wlan_sdio.h"
 #endif
 #include <linux/errno.h>
 
@@ -701,10 +701,6 @@ static int set_channel(struct wiphy *wiphy,
  *  @version	1.0
  */
 
-/*
- *	kernel version 3.8.8 supported
- *	tony, sswd, WILC-KR, 2013-10-29
- */
 static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct wilc_priv *priv;
@@ -1626,11 +1622,6 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		host_int_get_statistics(priv->hWILCWFIDrv, &strStatistics);
 
-		/*
-		 * tony: 2013-11-13
-		 * tx_failed introduced more than
-		 * kernel version 3.0.0
-		 */
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
 						BIT(NL80211_STA_INFO_RX_PACKETS) |
 						BIT(NL80211_STA_INFO_TX_PACKETS) |
@@ -2657,7 +2648,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
  *  @return     int : Return 0 on Success.
  *  @author	mdaftedar
  *  @date	01 JUL 2012
- *  @version	1.0WILC_WFI_set_cqmWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_config_rssi_config
+ *  @version	1.0
  */
 static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			  bool enabled, int timeout)
@@ -3371,7 +3362,7 @@ struct wireless_dev *add_virtual_intf(struct wiphy *wiphy, const char *name,
  *  @date	01 JUL 2012
  *  @version	1.0
  */
-int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)      /* tony for v3.8 support */
+int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	PRINT_D(HOSTAPD_DBG, "Deleting virtual interface\n");
 	return 0;
@@ -3426,7 +3417,7 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
  *  @return     int : Return 0 on Success.
  *  @author	mdaftedar
  *  @date	01 MAR 2012
- *  @version	1.0WILC_WFI_set_cqmWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_configWILC_WFI_set_cqm_rssi_config_rssi_config
+ *  @version	1.0
  */
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
 {
@@ -3573,7 +3564,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 		   wdev->wiphy->interface_modes, wdev->iftype);
 
 	#ifdef WILC_SDIO
-	set_wiphy_dev(wdev->wiphy, &local_sdio_func->dev); /* tony */
+	set_wiphy_dev(wdev->wiphy, &local_sdio_func->dev);
 	#endif
 
 	/*Register wiphy structure*/
-- 
2.5.1

