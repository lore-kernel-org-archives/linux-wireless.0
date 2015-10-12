Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12011 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbJLH4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:56:55 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 04/41] staging: wilc1000: wilc_wfi_cfgoperations.c : removes unused local variables
Date: Mon, 12 Oct 2015 16:55:38 +0900
Message-ID: <1444636575-2486-4-git-send-email-tony.cho@atmel.com> (sfid-20151012_095658_470726_2E1C31EA)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes useless local variable, s32Error and returns directly
zero from wilc_wfi_cfgoperations.c and also removes incorrect break in
switch-case statement. The break is not useless which is being called right
after return statement.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 30 +++++++----------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 04b8dae..a5617de 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1360,7 +1360,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		   const u8 *mac_addr)
 {
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
 
 	priv = wiphy_priv(wiphy);
 
@@ -1446,7 +1445,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		host_int_remove_key(priv->hWILCWFIDrv, mac_addr);
 	}
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -1466,9 +1465,6 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   bool pairwise,
 		   const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
 {
-
-	s32 s32Error = 0;
-
 	struct wilc_priv *priv;
 	struct  key_params key_params;
 	u32 i;
@@ -1501,7 +1497,7 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	callback(cookie, &key_params);
 
-	return s32Error;        /* priv->wilc_gtk->key_len ?0 : -ENOENT; */
+	return 0;        /* priv->wilc_gtk->key_len ?0 : -ENOENT; */
 }
 
 /**
@@ -1516,7 +1512,6 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			   bool unicast, bool multicast)
 {
-	s32 s32Error = 0;
 	struct wilc_priv *priv;
 
 
@@ -1529,7 +1524,7 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 		host_int_set_WEPDefaultKeyID(priv->hWILCWFIDrv, key_index);
 	}
 
-	return s32Error;
+	return 0;
 }
 
 /**
@@ -1545,7 +1540,6 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_info *sinfo)
 {
-	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	u32 i = 0;
@@ -1569,10 +1563,8 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		if (associatedsta == -1) {
-			s32Error = -ENOENT;
-			PRINT_ER("Station required is not associated : Error(%d)\n", s32Error);
-
-			return s32Error;
+			PRINT_ER("Station required is not associated\n");
+			return -ENOENT;
 		}
 
 		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
@@ -1608,7 +1600,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CORECONFIG_DBG, "*** stats[%d][%d][%d][%d][%d]\n", sinfo->signal, sinfo->rx_packets, sinfo->tx_packets,
 			sinfo->tx_failed, sinfo->txrate.legacy);
 	}
-	return s32Error;
+	return 0;
 }
 
 
@@ -2248,7 +2240,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 	const struct ieee80211_mgmt *mgmt;
 	struct p2p_mgmt_data *mgmt_tx;
 	struct wilc_priv *priv;
-	s32 s32Error = 0;
 	struct host_if_drv *pstrWFIDrv;
 	u32 i;
 	perInterface_wlan_t *nic;
@@ -2386,7 +2377,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	} else {
 		PRINT_D(GENERIC_DBG, "This function transmits only management frames\n");
 	}
-	return s32Error;
+	return 0;
 }
 
 static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
@@ -2574,7 +2565,6 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
-	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
 	u8 interface_type;
@@ -2885,12 +2875,10 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	default:
 		PRINT_ER("Unknown interface type= %d\n", type);
-		s32Error = -EINVAL;
-		return s32Error;
-		break;
+		return -EINVAL;
 	}
 
-	return s32Error;
+	return 0;
 }
 
 /* (austin.2013-07-23)
-- 
1.9.1

