Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41034 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbcAYHnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 02:43:35 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 14/26] staging: wilc1000: call power save after changing mode
Date: Mon, 25 Jan 2016 16:35:18 +0900
Message-ID: <1453707330-13526-15-git-send-email-glen.lee@atmel.com> (sfid-20160125_084338_082806_680AD3C0)
In-Reply-To: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
References: <1453707330-13526-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

host_int_set_power_mgmt should be called after changing operation mode to
work properly. Move the function below host_int_set_operation_mode.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4c18932..ff92cff 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2131,8 +2131,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
-		wilc_enable_ps = false;
-		wilc_set_power_mgmt(vif, 0, 0);
 		wilc_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_P2P_CLIENT\n");
 
@@ -2141,6 +2139,9 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		vif->monitor_flag = 0;
 		vif->iftype = CLIENT_MODE;
 		wilc_set_operation_mode(vif, STATION_MODE);
+
+		wilc_enable_ps = false;
+		wilc_set_power_mgmt(vif, 0, 0);
 		break;
 
 	case NL80211_IFTYPE_AP:
@@ -2163,14 +2164,15 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc_optaining_ip = true;
 		mod_timer(&wilc_during_ip_timer,
 			  jiffies + msecs_to_jiffies(during_ip_time));
-		wilc_set_power_mgmt(vif, 0, 0);
-		wilc_enable_ps = false;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_GO\n");
 
 		wilc_set_operation_mode(vif, AP_MODE);
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		vif->iftype = GO_MODE;
+
+		wilc_enable_ps = false;
+		wilc_set_power_mgmt(vif, 0, 0);
 		break;
 
 	default:
-- 
1.9.1

