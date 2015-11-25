Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10124 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbbKYC4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 21:56:30 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/10] staging: wilc1000: wilc_wfi_cfgoperations.c: remove over-commenting
Date: Wed, 25 Nov 2015 11:59:41 +0900
Message-ID: <1448420389-4192-2-git-send-email-glen.lee@atmel.com> (sfid-20151125_035636_188965_987FA621)
In-Reply-To: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
References: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

There are over-commenting in the wilc_wfi_cfgoperations.c file and most of them
are not helpful to explain what the code does and generate 80 ending
line over warnings. So, all of comments are removed in this patch and the
comments will later be added if necessary with the preferred Linux style.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 681 +---------------------
 1 file changed, 23 insertions(+), 658 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bcfddbf..bfef022 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1,20 +1,7 @@
-/*!
- *  @file	wilc_wfi_cfgopertaions.c
- *  @brief	CFG80211 Function Implementation functionality
- *  @author	aabouzaeid
- *                      mabubakr
- *                      mdaftedar
- *                      zsalah
- *  @sa		wilc_wfi_cfgopertaions.h top level OS wrapper file
- *  @date	31 Aug 2010
- *  @version	1.0
- */
-
 #include "wilc_wfi_cfgoperations.h"
 #include "host_interface.h"
 #include <linux/errno.h>
 
-/* The following macros describe the bitfield map used by the firmware to determine its 11i mode */
 #define NO_ENCRYPT		0
 #define ENCRYPT_ENABLED		BIT(0)
 #define WEP			BIT(1)
@@ -24,13 +11,11 @@
 #define AES			BIT(5)
 #define TKIP			BIT(6)
 
-/*Public action frame index IDs*/
 #define FRAME_TYPE_ID			0
 #define ACTION_CAT_ID			24
 #define ACTION_SUBTYPE_ID		25
 #define P2P_PUB_ACTION_SUBTYPE		30
 
-/*Public action frame Attribute IDs*/
 #define ACTION_FRAME			0xd0
 #define GO_INTENT_ATTR_ID		0x04
 #define CHANLIST_ATTR_ID		0x0b
@@ -38,7 +23,6 @@
 #define PUB_ACTION_ATTR_ID		0x04
 #define P2PELEM_ATTR_ID			0xdd
 
-/*Public action subtype values*/
 #define GO_NEG_REQ			0x00
 #define GO_NEG_RSP			0x01
 #define GO_NEG_CONF			0x02
@@ -90,7 +74,6 @@ static const struct ieee80211_txrx_stypes
 	}
 };
 
-/* Time to stay on the channel */
 #define WILC_WFI_DWELL_PASSIVE 100
 #define WILC_WFI_DWELL_ACTIVE  40
 
@@ -123,7 +106,6 @@ u8 wilc_initialized = 1;
 		.max_power        = 30,			 \
 }
 
-/*Frequency range for channels*/
 static struct ieee80211_channel ieee80211_2ghz_channels[] = {
 	CHAN2G(1,  2412, 0),
 	CHAN2G(2,  2417, 0),
@@ -147,8 +129,6 @@ static struct ieee80211_channel ieee80211_2ghz_channels[] = {
 		.flags    = (_flags),			\
 }
 
-
-/* Table 6 in section 3.2.1.1 */
 static struct ieee80211_rate ieee80211_bitrates[] = {
 	RATETAB_ENT(10,  0,  0),
 	RATETAB_ENT(20,  1,  0),
@@ -342,7 +322,6 @@ static int is_network_in_shadow(tstrNetworkInfo *pstrNetworkInfo,
 		mod_timer(&hAgingTimer, jiffies + msecs_to_jiffies(AGING_TIME));
 		state = -1;
 	} else {
-		/* Linear search for now */
 		for (i = 0; i < last_scanned_cnt; i++) {
 			if (memcmp(last_scanned_shadow[i].au8bssid,
 				   pstrNetworkInfo->au8bssid, 6) == 0) {
@@ -394,7 +373,7 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
 	if (ap_found != -1)
 		kfree(last_scanned_shadow[ap_index].pu8IEs);
 	last_scanned_shadow[ap_index].pu8IEs =
-		kmalloc(pstrNetworkInfo->u16IEsLen, GFP_KERNEL);        /* will be deallocated by the WILC_WFI_CfgScan() function */
+		kmalloc(pstrNetworkInfo->u16IEsLen, GFP_KERNEL);
 	memcpy(last_scanned_shadow[ap_index].pu8IEs,
 	       pstrNetworkInfo->pu8IEs, pstrNetworkInfo->u16IEsLen);
 	last_scanned_shadow[ap_index].u32TimeRcvdInScan = jiffies;
@@ -405,20 +384,6 @@ static void add_network_to_shadow(tstrNetworkInfo *pstrNetworkInfo,
 	last_scanned_shadow[ap_index].pJoinParams = pJoinParams;
 }
 
-
-/**
- *  @brief      CfgScanResult
- *  @details  Callback function which returns the scan results found
- *
- *  @param[in] tenuScanEvent enuScanEvent: enum, indicating the scan event triggered, whether that is
- *                        SCAN_EVENT_NETWORK_FOUND or SCAN_EVENT_DONE
- *                        tstrNetworkInfo* pstrNetworkInfo: structure holding the scan results information
- *                        void* pUserVoid: Private structure associated with the wireless interface
- *  @return     NONE
- *  @author	mabubakr
- *  @date
- *  @version	1.0
- */
 static void CfgScanResult(enum scan_event scan_event,
 			  tstrNetworkInfo *network_info,
 			  void *user_void,
@@ -457,7 +422,7 @@ static void CfgScanResult(enum scan_event scan_event,
 					   network_info->u16CapInfo, network_info->u16BeaconPeriod);
 
 				if (network_info->bNewNetwork) {
-					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) { /* TODO: mostafa: to be replaced by */
+					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
 						PRINT_D(CFG80211_DBG, "Network %s found\n", network_info->au8ssid);
 						priv->u32RcvdChCount++;
 
@@ -465,7 +430,6 @@ static void CfgScanResult(enum scan_event scan_event,
 							PRINT_INFO(CORECONFIG_DBG, ">> Something really bad happened\n");
 						add_network_to_shadow(network_info, priv, join_params);
 
-						/*P2P peers are sent to WPA supplicant and added to shadow table*/
 						if (!(memcmp("DIRECT-", network_info->au8ssid, 7))) {
 							bss = cfg80211_inform_bss(wiphy, channel, CFG80211_BSS_FTYPE_UNKNOWN,  network_info->au8bssid, network_info->u64Tsf, network_info->u16CapInfo,
 										  network_info->u16BeaconPeriod, (const u8 *)network_info->pu8IEs,
@@ -479,7 +443,7 @@ static void CfgScanResult(enum scan_event scan_event,
 					}
 				} else {
 					u32 i;
-					/* So this network is discovered before, we'll just update its RSSI */
+
 					for (i = 0; i < priv->u32RcvdChCount; i++) {
 						if (memcmp(last_scanned_shadow[i].au8bssid, network_info->au8bssid, 6) == 0) {
 							PRINT_D(CFG80211_DBG, "Update RSSI of %s\n", last_scanned_shadow[i].au8ssid);
@@ -527,21 +491,6 @@ static void CfgScanResult(enum scan_event scan_event,
 	}
 }
 
-
-/**
- *  @brief      CfgConnectResult
- *  @details
- *  @param[in] tenuConnDisconnEvent enuConnDisconnEvent: Type of connection response either
- *                        connection response or disconnection notification.
- *                        tstrConnectInfo* pstrConnectInfo: COnnection information.
- *                        u8 u8MacStatus: Mac Status from firmware
- *                        tstrDisconnectNotifInfo* pstrDisconnectNotifInfo: Disconnection Notification
- *                        void* pUserVoid: Private data associated with wireless interface
- *  @return     NONE
- *  @author	mabubakr
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 int wilc_connecting;
 
 static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
@@ -566,7 +515,6 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
 	if (enuConnDisconnEvent == CONN_DISCONN_EVENT_CONN_RESP) {
-		/*Initialization*/
 		u16 u16ConnectStatus;
 
 		u16ConnectStatus = pstrConnectInfo->u16ConnectStatus;
@@ -575,8 +523,6 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 		if ((u8MacStatus == MAC_DISCONNECTED) &&
 		    (pstrConnectInfo->u16ConnectStatus == SUCCESSFUL_STATUSCODE)) {
-			/* The case here is that our station was waiting for association response frame and has just received it containing status code
-			 *  = SUCCESSFUL_STATUSCODE, while mac status is MAC_DISCONNECTED (which means something wrong happened) */
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, NullBssid);
 			eth_zero_addr(wilc_connected_ssid);
@@ -610,12 +556,8 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 				}
 			}
 
-			if (bNeedScanRefresh) {
-				/*Also, refrsh DIRECT- results if */
+			if (bNeedScanRefresh)
 				refresh_scan(priv, 1, true);
-
-			}
-
 		}
 
 
@@ -626,8 +568,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		cfg80211_connect_result(dev, pstrConnectInfo->au8bssid,
 					pstrConnectInfo->pu8ReqIEs, pstrConnectInfo->ReqIEsLen,
 					pstrConnectInfo->pu8RespIEs, pstrConnectInfo->u16RespIEsLen,
-					u16ConnectStatus, GFP_KERNEL);                         /* TODO: mostafa: u16ConnectStatus to */
-		/* be replaced by pstrConnectInfo->u16ConnectStatus */
+					u16ConnectStatus, GFP_KERNEL);
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
 		wilc_optaining_ip = false;
 		PRINT_ER("Received MAC_DISCONNECTED from firmware with reason %d on dev [%p]\n",
@@ -641,14 +582,9 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 		if (!pstrWFIDrv->p2p_connect)
 			wlan_channel = INVALID_CHANNEL;
-		/*Incase "P2P CLIENT Connected" send deauthentication reason by 3 to force the WPA_SUPPLICANT to directly change
-		 *      virtual interface to station*/
 		if ((pstrWFIDrv->IFC_UP) && (dev == wl->vif[1].ndev)) {
 			pstrDisconnectNotifInfo->u16reason = 3;
-		}
-		/*Incase "P2P CLIENT during connection(not connected)" send deauthentication reason by 1 to force the WPA_SUPPLICANT
-		 *      to scan again and retry the connection*/
-		else if ((!pstrWFIDrv->IFC_UP) && (dev == wl->vif[1].ndev)) {
+		} else if ((!pstrWFIDrv->IFC_UP) && (dev == wl->vif[1].ndev)) {
 			pstrDisconnectNotifInfo->u16reason = 1;
 		}
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
@@ -659,20 +595,6 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 
 }
 
-
-/**
- *  @brief      set_channel
- *  @details    Set channel for a given wireless interface. Some devices
- *                      may support multi-channel operation (by channel hopping) so cfg80211
- *                      doesn't verify much. Note, however, that the passed netdev may be
- *                      %NULL as well if the user requested changing the channel for the
- *                      device itself, or for a monitor interface.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int set_channel(struct wiphy *wiphy,
 		       struct cfg80211_chan_def *chandef)
 {
@@ -694,19 +616,6 @@ static int set_channel(struct wiphy *wiphy,
 	return result;
 }
 
-/**
- *  @brief      scan
- *  @details    Request to do a scan. If returning zero, the scan request is given
- *                      the driver, and will be valid until passed to cfg80211_scan_done().
- *                      For scan results, call cfg80211_inform_bss(); you can call this outside
- *                      the scan/scan_done bracket too.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mabubakr
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-
 static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct wilc_priv *priv;
@@ -725,8 +634,7 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	reset_shadow_found();
 
 	priv->bCfgScanning = true;
-	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) { /* TODO: mostafa: to be replaced by */
-		/*               max_scan_ssids */
+	if (request->n_channels <= MAX_NUM_SCANNED_NETWORKS) {
 		for (i = 0; i < request->n_channels; i++) {
 			au8ScanChanList[i] = (u8)ieee80211_frequency_to_channel(request->channels[i]->center_freq);
 			PRINT_INFO(CFG80211_DBG, "ScanChannel List[%d] = %d,", i, au8ScanChanList[i]);
@@ -781,18 +689,6 @@ static int scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	return s32Error;
 }
 
-/**
- *  @brief      connect
- *  @details    Connect to the ESS with the specified parameters. When connected,
- *                      call cfg80211_connect_result() with status code %WLAN_STATUS_SUCCESS.
- *                      If the connection fails for some reason, call cfg80211_connect_result()
- *                      with the status from the AP.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mabubakr
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int connect(struct wiphy *wiphy, struct net_device *dev,
 		   struct cfg80211_connect_params *sme)
 {
@@ -831,13 +727,9 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 			   sme->ssid_len) == 0) {
 			PRINT_INFO(CFG80211_DBG, "Network with required SSID is found %s\n", sme->ssid);
 			if (sme->bssid == NULL)	{
-				/* BSSID is not passed from the user, so decision of matching
-				 * is done by SSID only */
 				PRINT_INFO(CFG80211_DBG, "BSSID is not passed from the user\n");
 				break;
 			} else {
-				/* BSSID is also passed from the user, so decision of matching
-				 * should consider also this passed BSSID */
 				if (memcmp(last_scanned_shadow[i].au8bssid,
 					   sme->bssid,
 					   ETH_ALEN) == 0) {
@@ -882,8 +774,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (sme->crypto.cipher_group != NO_ENCRYPT) {
-		/* To determine the u8security value, first we check the group cipher suite then {in case of WPA or WPA2}
-		 *  we will add to it the pairwise cipher suite(s) */
 		pcwpa_version = "Default";
 		PRINT_D(CORECONFIG_DBG, ">> sme->crypto.wpa_versions: %x\n", sme->crypto.wpa_versions);
 		if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) {
@@ -930,8 +820,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				u8security = ENCRYPT_ENABLED | WPA2 | TKIP;
 				pcgroup_encrypt_val = "WPA2_TKIP";
 				pccipher_group = "TKIP";
-			} else {     /* TODO: mostafa: here we assume that any other encryption type is AES */
-				     /* tenuSecurity_t = WPA2_AES; */
+			} else {
 				u8security = ENCRYPT_ENABLED | WPA2 | AES;
 				pcgroup_encrypt_val = "WPA2_AES";
 				pccipher_group = "AES";
@@ -942,8 +831,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 				u8security = ENCRYPT_ENABLED | WPA | TKIP;
 				pcgroup_encrypt_val = "WPA_TKIP";
 				pccipher_group = "TKIP";
-			} else {     /* TODO: mostafa: here we assume that any other encryption type is AES */
-				     /* tenuSecurity_t = WPA_AES; */
+			} else {
 				u8security = ENCRYPT_ENABLED | WPA | AES;
 				pcgroup_encrypt_val = "WPA_AES";
 				pccipher_group = "AES";
@@ -960,14 +848,12 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	}
 
-	/* After we set the u8security value from checking the group cipher suite, {in case of WPA or WPA2} we will
-	 *   add to it the pairwise cipher suite(s) */
 	if ((sme->crypto.wpa_versions & NL80211_WPA_VERSION_1)
 	    || (sme->crypto.wpa_versions & NL80211_WPA_VERSION_2)) {
 		for (i = 0; i < sme->crypto.n_ciphers_pairwise; i++) {
 			if (sme->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP) {
 				u8security = u8security | TKIP;
-			} else {     /* TODO: mostafa: here we assume that any other encryption type is AES */
+			} else {
 				u8security = u8security | AES;
 			}
 		}
@@ -991,8 +877,6 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CFG80211_DBG, "Automatic Authentation type = %d\n", sme->auth_type);
 	}
 
-
-	/* ai: key_mgmt: enterprise case */
 	if (sme->crypto.n_akm_suites) {
 		switch (sme->crypto.akm_suites[0]) {
 		case WLAN_AKM_SUITE_8021X:
@@ -1033,16 +917,6 @@ done:
 	return s32Error;
 }
 
-
-/**
- *  @brief      disconnect
- *  @details    Disconnect from the BSS/ESS.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_code)
 {
 	s32 s32Error = 0;
@@ -1074,16 +948,6 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	return s32Error;
 }
 
-/**
- *  @brief      add_key
- *  @details    Add a key with the given parameters. @mac_addr will be %NULL
- *                      when adding a group key.
- *  @param[in] key : key buffer; TKIP: 16-byte temporal key, 8-byte Tx Mic key, 8-byte Rx Mic Key
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   bool pairwise,
 		   const u8 *mac_addr, struct key_params *params)
@@ -1187,13 +1051,10 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 					pu8RxMic = params->key + 16;
 					KeyLen = params->key_len - 16;
 				}
-				/* if there has been previous allocation for the same index through its key, free that memory and allocate again*/
 				kfree(priv->wilc_gtk[key_index]->key);
 
 				priv->wilc_gtk[key_index]->key = kmalloc(params->key_len, GFP_KERNEL);
 				memcpy(priv->wilc_gtk[key_index]->key, params->key, params->key_len);
-
-				/* if there has been previous allocation for the same index through its seq, free that memory and allocate again*/
 				kfree(priv->wilc_gtk[key_index]->seq);
 
 				if ((params->seq_len) > 0) {
@@ -1268,13 +1129,11 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			u8mode = 0;
 			if (!pairwise) {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					/* swap the tx mic by rx mic */
 					pu8RxMic = params->key + 24;
 					pu8TxMic = params->key + 16;
 					KeyLen = params->key_len - 16;
 				}
 
-				/*save keys only on interface 0 (wifi interface)*/
 				if (!g_gtk_keys_saved && netdev == wl->vif[0].ndev) {
 					g_add_gtk_key_params.key_idx = key_index;
 					g_add_gtk_key_params.pairwise = pairwise;
@@ -1304,13 +1163,11 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 						    key_index, params->seq_len, params->seq, pu8RxMic, pu8TxMic, STATION_MODE, u8mode);
 			} else {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
-					/* swap the tx mic by rx mic */
 					pu8RxMic = params->key + 24;
 					pu8TxMic = params->key + 16;
 					KeyLen = params->key_len - 16;
 				}
 
-				/*save keys only on interface 0 (wifi interface)*/
 				if (!g_ptk_keys_saved && netdev == wl->vif[0].ndev) {
 					g_add_ptk_key_params.key_idx = key_index;
 					g_add_ptk_key_params.pairwise = pairwise;
@@ -1356,16 +1213,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	return s32Error;
 }
 
-/**
- *  @brief      del_key
- *  @details    Remove a key given the @mac_addr (%NULL for a group key)
- *                      and @key_index, return -ENOENT if the key doesn't exist.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		   u8 key_index,
 		   bool pairwise,
@@ -1379,18 +1226,14 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	nic = netdev_priv(netdev);
 	wl = nic->wilc;
 
-	/*delete saved keys, if any*/
 	if (netdev == wl->vif[0].ndev) {
 		g_ptk_keys_saved = false;
 		g_gtk_keys_saved = false;
 		g_wep_keys_saved = false;
 
-		/*Delete saved WEP keys params, if any*/
 		kfree(g_key_wep_params.key);
 		g_key_wep_params.key = NULL;
 
-		/*freeing memory allocated by "wilc_gtk" and "wilc_ptk" in "WILC_WIFI_ADD_KEY"*/
-
 		if ((priv->wilc_gtk[key_index]) != NULL) {
 
 			kfree(priv->wilc_gtk[key_index]->key);
@@ -1413,7 +1256,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 			priv->wilc_ptk[key_index] = NULL;
 		}
 
-		/*Delete saved PTK and GTK keys params, if any*/
 		kfree(g_key_ptk_params.key);
 		g_key_ptk_params.key = NULL;
 		kfree(g_key_ptk_params.seq);
@@ -1424,7 +1266,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		kfree(g_key_gtk_params.seq);
 		g_key_gtk_params.seq = NULL;
 
-		/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
 		wilc_set_machw_change_vir_if(netdev, false);
 	}
 
@@ -1442,19 +1283,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 	return 0;
 }
 
-/**
- *  @brief      get_key
- *  @details    Get information about the key with the given parameters.
- *                      @mac_addr will be %NULL when requesting information for a group
- *                      key. All pointers given to the @callback function need not be valid
- *                      after it returns. This function should return an error if it is
- *                      not possible to retrieve the key, -ENOENT if it doesn't exist.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		   bool pairwise,
 		   const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
@@ -1490,18 +1318,9 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	callback(cookie, &key_params);
 
-	return 0;        /* priv->wilc_gtk->key_len ?0 : -ENOENT; */
+	return 0;
 }
 
-/**
- *  @brief      set_default_key
- *  @details    Set the default management frame key on an interface
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			   bool unicast, bool multicast)
 {
@@ -1520,16 +1339,6 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 	return 0;
 }
 
-/**
- *  @brief      get_station
- *  @details    Get station information for the station identified by @mac
- *  @param[in]   NONE
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-
 static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_info *sinfo)
 {
@@ -1597,28 +1406,6 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-
-/**
- *  @brief      change_bss
- *  @details    Modify parameters for a given BSS.
- *  @param[in]
- *   -use_cts_prot: Whether to use CTS protection
- *	    (0 = no, 1 = yes, -1 = do not change)
- *  -use_short_preamble: Whether the use of short preambles is allowed
- *	    (0 = no, 1 = yes, -1 = do not change)
- *  -use_short_slot_time: Whether the use of short slot time is allowed
- *	    (0 = no, 1 = yes, -1 = do not change)
- *  -basic_rates: basic rates in IEEE 802.11 format
- *	    (or NULL for no change)
- *  -basic_rates_len: number of basic rates
- *  -ap_isolate: do not forward packets between connected stations
- *  -ht_opmode: HT Operation mode
- *         (u16 = opmode, -1 = do not change)
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 		      struct bss_parameters *params)
 {
@@ -1626,16 +1413,6 @@ static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-/**
- *  @brief      set_wiphy_params
- *  @details    Notify that wiphy parameters have changed;
- *  @param[in]   Changed bitfield (see &enum wiphy_params_flags) describes which values
- *                      have changed.
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
 	s32 s32Error = 0;
@@ -1684,17 +1461,6 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	return s32Error;
 }
 
-/**
- *  @brief      set_pmksa
- *  @details    Cache a PMKID for a BSSID. This is mostly useful for fullmac
- *                      devices running firmwares capable of generating the (re) association
- *                      RSN IE. It allows for faster roaming between WPA2 BSSIDs.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
@@ -1710,7 +1476,6 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 				 ETH_ALEN)) {
-			/*If bssid already exists and pmkid value needs to reset*/
 			flag = PMKID_FOUND;
 			PRINT_D(CFG80211_DBG, "PMKID already exists\n");
 			break;
@@ -1736,15 +1501,6 @@ static int set_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	return s32Error;
 }
 
-/**
- *  @brief      del_pmksa
- *  @details    Delete a cached PMKID.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 		     struct cfg80211_pmksa *pmksa)
 {
@@ -1759,7 +1515,6 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	for (i = 0; i < priv->pmkid_list.numpmkid; i++)	{
 		if (!memcmp(pmksa->bssid, priv->pmkid_list.pmkidlist[i].bssid,
 				 ETH_ALEN)) {
-			/*If bssid is found, reset the values*/
 			PRINT_D(CFG80211_DBG, "Reseting PMKID values\n");
 			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(struct host_if_pmkid));
 			break;
@@ -1783,42 +1538,17 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 	return s32Error;
 }
 
-/**
- *  @brief      flush_pmksa
- *  @details    Flush all cached PMKIDs.
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 {
 	struct wilc_priv *priv = wiphy_priv(wiphy);
 
 	PRINT_D(CFG80211_DBG,  "Flushing  PMKID key values\n");
 
-	/*Get cashed Pmkids and set all with zeros*/
 	memset(&priv->pmkid_list, 0, sizeof(struct host_if_pmkid_attr));
 
 	return 0;
 }
 
-
-/**
- *  @brief      WILC_WFI_CfgParseRxAction
- *  @details Function parses the received  frames and modifies the following attributes:
- *                -GO Intent
- *		    -Channel list
- *		    -Operating Channel
- *
- *  @param[in] u8* Buffer, u32 length
- *  @return     NONE.
- *  @author	mdaftedar
- *  @date	12 DEC 2012
- *  @version
- */
-
 static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 {
 	u32 index = 0;
@@ -1836,10 +1566,9 @@ static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 			channel_list_attr_index = index;
 		else if (buf[index] ==  OPERCHAN_ATTR_ID)
 			op_channel_attr_index = index;
-		index += buf[index + 1] + 3; /* ID,Length byte */
+		index += buf[index + 1] + 3;
 	}
 	if (wlan_channel != INVALID_CHANNEL) {
-		/*Modify channel list attribute*/
 		if (channel_list_attr_index) {
 			PRINT_D(GENERIC_DBG, "Modify channel list attribute\n");
 			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
@@ -1851,7 +1580,7 @@ static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 				}
 			}
 		}
-		/*Modify operating channel attribute*/
+
 		if (op_channel_attr_index) {
 			PRINT_D(GENERIC_DBG, "Modify operating channel attribute\n");
 			buf[op_channel_attr_index + 6] = 0x51;
@@ -1860,16 +1589,6 @@ static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 	}
 }
 
-/**
- *  @brief      WILC_WFI_CfgParseTxAction
- *  @details Function parses the transmitted  action frames and modifies the
- *               GO Intent attribute
- *  @param[in] u8* Buffer, u32 length, bool bOperChan, u8 iftype
- *  @return     NONE.
- *  @author	mdaftedar
- *  @date	12 DEC 2012
- *  @version
- */
 static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftype)
 {
 	u32 index = 0;
@@ -1889,10 +1608,9 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 			channel_list_attr_index = index;
 		else if (buf[index] ==  OPERCHAN_ATTR_ID)
 			op_channel_attr_index = index;
-		index += buf[index + 1] + 3; /* ID,Length byte */
+		index += buf[index + 1] + 3;
 	}
 	if (wlan_channel != INVALID_CHANNEL && bOperChan) {
-		/*Modify channel list attribute*/
 		if (channel_list_attr_index) {
 			PRINT_D(GENERIC_DBG, "Modify channel list attribute\n");
 			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
@@ -1904,7 +1622,7 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 				}
 			}
 		}
-		/*Modify operating channel attribute*/
+
 		if (op_channel_attr_index) {
 			PRINT_D(GENERIC_DBG, "Modify operating channel attribute\n");
 			buf[op_channel_attr_index + 6] = 0x51;
@@ -1913,16 +1631,6 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 	}
 }
 
-/*  @brief                       WILC_WFI_p2p_rx
- *  @details
- *  @param[in]
- *
- *  @return             None
- *  @author		Mai Daftedar
- *  @date			2 JUN 2013
- *  @version		1.0
- */
-
 void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 {
 
@@ -1935,11 +1643,8 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
 
-	/* Get WILC header */
 	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
 
-	/* The packet offset field conain info about what type of managment frame */
-	/* we are dealing with and ack status */
 	pkt_offset = GET_PKT_OFFSET(header);
 
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
@@ -1963,7 +1668,6 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 
 		PRINT_D(GENERIC_DBG, "Rx Frame Type:%x\n", buff[FRAME_TYPE_ID]);
 
-		/*Upper layer is informed that the frame is received on this freq*/
 		s32Freq = ieee80211_channel_to_frequency(curr_channel, IEEE80211_BAND_2GHZ);
 
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
@@ -2016,7 +1720,6 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 
 					if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP) && (wilc_ie))	{
 						PRINT_D(GENERIC_DBG, "Sending P2P to host without extra elemnt\n");
-						/* extra attribute for sig_dbm: signal strength in mBm, or 0 if unknown */
 						cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size - 7, 0);
 						return;
 					}
@@ -2033,16 +1736,6 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 	}
 }
 
-/**
- *  @brief                      WILC_WFI_mgmt_tx_complete
- *  @details            Returns result of writing mgmt frame to VMM (Tx buffers are freed here)
- *  @param[in]          priv
- *                              transmitting status
- *  @return             None
- *  @author		Amr Abdelmoghny
- *  @date			20 MAY 2013
- *  @version		1.0
- */
 static void WILC_WFI_mgmt_tx_complete(void *priv, int status)
 {
 	struct p2p_mgmt_data *pv_data = (struct p2p_mgmt_data *)priv;
@@ -2052,16 +1745,6 @@ static void WILC_WFI_mgmt_tx_complete(void *priv, int status)
 	kfree(pv_data);
 }
 
-/**
- * @brief               WILC_WFI_RemainOnChannelReady
- *  @details    Callback function, called from handle_remain_on_channel on being ready on channel
- *  @param
- *  @return     none
- *  @author	Amr abdelmoghny
- *  @date		9 JUNE 2013
- *  @version
- */
-
 static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 {
 	struct wilc_priv *priv;
@@ -2079,16 +1762,6 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 				  GFP_KERNEL);
 }
 
-/**
- * @brief               WILC_WFI_RemainOnChannelExpired
- *  @details    Callback function, called on expiration of remain-on-channel duration
- *  @param
- *  @return     none
- *  @author	Amr abdelmoghny
- *  @date		15 MAY 2013
- *  @version
- */
-
 static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 {
 	struct wilc_priv *priv;
@@ -2100,7 +1773,6 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 
 		priv->bInP2PlistenState = false;
 
-		/*Inform wpas of remain-on-channel expiration*/
 		cfg80211_remain_on_channel_expired(priv->wdev,
 						   priv->strRemainOnChanParams.u64ListenCookie,
 						   priv->strRemainOnChanParams.pstrListenChan,
@@ -2111,20 +1783,6 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 	}
 }
 
-
-/**
- *  @brief      remain_on_channel
- *  @details    Request the driver to remain awake on the specified
- *                      channel for the specified duration to complete an off-channel
- *                      operation (e.g., public action frame exchange). When the driver is
- *                      ready on the requested channel, it must indicate this with an event
- *                      notification by calling cfg80211_ready_on_channel().
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int remain_on_channel(struct wiphy *wiphy,
 			     struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan,
@@ -2145,7 +1803,6 @@ static int remain_on_channel(struct wiphy *wiphy,
 
 	curr_channel = chan->hw_value;
 
-	/*Setting params needed by WILC_WFI_RemainOnChannelExpired()*/
 	priv->strRemainOnChanParams.pstrListenChan = chan;
 	priv->strRemainOnChanParams.u64ListenCookie = *cookie;
 	priv->strRemainOnChanParams.u32ListenDuration = duration;
@@ -2162,19 +1819,6 @@ static int remain_on_channel(struct wiphy *wiphy,
 	return s32Error;
 }
 
-/**
- *  @brief      cancel_remain_on_channel
- *  @details    Cancel an on-going remain-on-channel operation.
- *                      This allows the operation to be terminated prior to timeout based on
- *                      the duration value.
- *  @param[in]   struct wiphy *wiphy,
- *  @param[in]  struct net_device *dev
- *  @param[in]  u64 cookie,
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int cancel_remain_on_channel(struct wiphy *wiphy,
 				    struct wireless_dev *wdev,
 				    u64 cookie)
@@ -2189,16 +1833,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 	s32Error = wilc_listen_state_expired(priv->hWILCWFIDrv, priv->strRemainOnChanParams.u32ListenSessionID);
 	return s32Error;
 }
-/**
- *  @brief      WILC_WFI_mgmt_tx_frame
- *  @details
- *
- *  @param[in]
- *  @return     NONE.
- *  @author	mdaftedar
- *  @date	01 JUL 2012
- *  @version
- */
+
 static int mgmt_tx(struct wiphy *wiphy,
 		   struct wireless_dev *wdev,
 		   struct cfg80211_mgmt_tx_params *params,
@@ -2225,8 +1860,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 	mgmt = (const struct ieee80211_mgmt *) buf;
 
 	if (ieee80211_is_mgmt(mgmt->frame_control)) {
-
-		/*mgmt frame allocation*/
 		mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
 		if (mgmt_tx == NULL) {
 			PRINT_ER("Failed to allocate memory for mgmt_tx structure\n");
@@ -2246,22 +1879,16 @@ static int mgmt_tx(struct wiphy *wiphy,
 			PRINT_D(GENERIC_DBG, "TX: Probe Response\n");
 			PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
 			wilc_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
-			/*Save the current channel after we tune to it*/
 			curr_channel = chan->hw_value;
 		} else if (ieee80211_is_action(mgmt->frame_control))   {
 			PRINT_D(GENERIC_DBG, "ACTION FRAME:%x\n", (u16)mgmt->frame_control);
 
 
 			if (buf[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
-				/*Only set the channel, if not a negotiation confirmation frame
-				 * (If Negotiation confirmation frame, force it
-				 * to be transmitted on the same negotiation channel)*/
-
 				if (buf[ACTION_SUBTYPE_ID] != PUBLIC_ACT_VENDORSPEC ||
 				    buf[P2P_PUB_ACTION_SUBTYPE] != GO_NEG_CONF)	{
 					PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
 					wilc_set_mac_chnl_num(priv->hWILCWFIDrv, chan->hw_value);
-					/*Save the current channel after we tune to it*/
 					curr_channel = chan->hw_value;
 				}
 				switch (buf[ACTION_SUBTYPE_ID])	{
@@ -2280,7 +1907,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 				case PUBLIC_ACT_VENDORSPEC:
 				{
 					if (!memcmp(p2p_oui, &buf[ACTION_SUBTYPE_ID + 1], 4)) {
-						/*For the connection of two WILC's connection generate a rand number to determine who will be a GO*/
 						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP)) {
 							if (p2p_local_random == 1 && p2p_recv_random < p2p_local_random) {
 								get_random_bytes(&p2p_local_random, 1);
@@ -2293,14 +1919,10 @@ static int mgmt_tx(struct wiphy *wiphy,
 							if (p2p_local_random > p2p_recv_random)	{
 								PRINT_D(GENERIC_DBG, "LOCAL WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
 
-								/*Search for the p2p information information element , after the Public action subtype theres a byte for teh dialog token, skip that*/
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
 									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buf[i + 2], 4))) {
 										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
 											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), true, nic->iftype);
-
-										/*If using supplicant go intent, no need at all*/
-										/*to parse transmitted negotiation frames*/
 										else
 											WILC_WFI_CfgParseTxAction(&mgmt_tx->buff[i + 6], len - (i + 6), false, nic->iftype);
 										break;
@@ -2308,10 +1930,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 								}
 
 								if (buf[P2P_PUB_ACTION_SUBTYPE] != P2P_INV_REQ && buf[P2P_PUB_ACTION_SUBTYPE] != P2P_INV_RSP) {
-									/*
-									 * Adding WILC information element to allow two WILC devices to
-									 * identify each other and connect
-									 */
 									memcpy(&mgmt_tx->buff[len], p2p_vendor_spec, sizeof(p2p_vendor_spec));
 									mgmt_tx->buff[len + sizeof(p2p_vendor_spec)] = p2p_local_random;
 									mgmt_tx->size = buf_len;
@@ -2377,17 +1995,6 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 	return 0;
 }
 
-/**
- *  @brief      wilc_mgmt_frame_register
- *  @details Notify driver that a management frame type was
- *              registered. Note that this callback may not sleep, and cannot run
- *                      concurrently with itself.
- *  @param[in]
- *  @return     NONE.
- *  @author	mdaftedar
- *  @date	01 JUL 2012
- *  @version
- */
 void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      u16 frame_type, bool reg)
 {
@@ -2425,7 +2032,7 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 
 	}
-	/*If mac is closed, then return*/
+
 	if (!wl->initialized) {
 		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
 		return;
@@ -2435,18 +2042,6 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 }
 
-/**
- *  @brief      set_cqm_rssi_config
- *  @details    Configure connection quality monitor RSSI threshold.
- *  @param[in]   struct wiphy *wiphy:
- *  @param[in]	struct net_device *dev:
- *  @param[in]          s32 rssi_thold:
- *  @param[in]	u32 rssi_hyst:
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
 			       s32 rssi_thold, u32 rssi_hyst)
 {
@@ -2454,19 +2049,7 @@ static int set_cqm_rssi_config(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 
 }
-/**
- *  @brief      dump_station
- *  @details    Configure connection quality monitor RSSI threshold.
- *  @param[in]   struct wiphy *wiphy:
- *  @param[in]	struct net_device *dev
- *  @param[in]          int idx
- *  @param[in]	u8 *mac
- *  @param[in]	struct station_info *sinfo
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
+
 static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 			int idx, u8 *mac, struct station_info *sinfo)
 {
@@ -2487,16 +2070,6 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 
 }
 
-
-/**
- *  @brief      set_power_mgmt
- *  @details
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 JUL 2012
- *  @version	1.0
- */
 static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			  bool enabled, int timeout)
 {
@@ -2521,16 +2094,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 }
 
-/**
- *  @brief      change_virtual_intf
- *  @details    Change type/configuration of virtual interface,
- *                      keep the struct wireless_dev's iftype updated.
- *  @param[in]   NONE
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			       enum nl80211_iftype type, u32 *flags, struct vif_params *params)
 {
@@ -2553,7 +2116,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	wilc_optaining_ip = false;
 	del_timer(&wilc_during_ip_timer);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
-	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
+
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
 		wilc_set_machw_change_vir_if(dev, true);
 	}
@@ -2563,15 +2126,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		wilc_connecting = 0;
 		PRINT_D(HOSTAPD_DBG, "Interface type = NL80211_IFTYPE_STATION\n");
 
-		/* send delba over wlan interface */
-
-
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		nic->monitor_flag = 0;
 		nic->iftype = STATION_MODE;
 
-		/*Remove the enteries of the previously connected clients*/
 		memset(priv->assoc_stainfo.au8Sta_AssociatedBss, 0, MAX_NUM_STA * ETH_ALEN);
 		interface_type = nic->iftype;
 		nic->iftype = STATION_MODE;
@@ -2579,10 +2138,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		if (wl->initialized) {
 			wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
 						   wl->vif[0].bssid, TID);
-			/* ensure that the message Q is empty */
 			wilc_wait_msg_queue_idle();
 
-			/*Eliminate host interface blocking state*/
 			up(&wl->cfg_event);
 
 			wilc1000_wlan_deinit(dev);
@@ -2590,13 +2147,11 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc_initialized = 1;
 			nic->iftype = interface_type;
 
-			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 			wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
 			wilc_set_mac_address(wl->vif[0].hif_drv,
 						wl->vif[0].src_addr);
 			wilc_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
-			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
 				wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
 							     g_key_wep_params.key_idx);
@@ -2606,11 +2161,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 							     g_key_wep_params.key_idx);
 			}
 
-			/*No matter the driver handler passed here, it will be overwriiten*/
-			/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
 			wilc_flush_join_req(priv->hWILCWFIDrv);
 
-			/*Add saved PTK and GTK keys, if any*/
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
 				PRINT_D(CFG80211_DBG, "ptk %x %x %x\n", g_key_ptk_params.key[0],
 					g_key_ptk_params.key[1],
@@ -2666,7 +2218,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 
 		if (wl->initialized)	{
-			/* ensure that the message Q is empty */
 			wilc_wait_msg_queue_idle();
 
 			wilc1000_wlan_deinit(dev);
@@ -2678,7 +2229,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 						wl->vif[0].src_addr);
 			wilc_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
-			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
 				wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
 							   g_key_wep_params.key_idx);
@@ -2688,11 +2238,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 							 g_key_wep_params.key_idx);
 			}
 
-			/*No matter the driver handler passed here, it will be overwriiten*/
-			/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
 			wilc_flush_join_req(priv->hWILCWFIDrv);
 
-			/*Add saved PTK and GTK keys, if any*/
 			if (g_ptk_keys_saved && g_gtk_keys_saved) {
 				PRINT_D(CFG80211_DBG, "ptk %x %x %x\n", g_key_ptk_params.key[0],
 					g_key_ptk_params.key[1],
@@ -2715,7 +2262,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 					(struct key_params *)(&g_key_gtk_params));
 			}
 
-			/*Refresh scan, to refresh the scan results to the wpa_supplicant. Set MachHw to false to enable further key installments*/
 			refresh_scan(priv, 1, true);
 			wilc_set_machw_change_vir_if(dev, false);
 
@@ -2741,7 +2287,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
 		wilc_wlan_get_firmware(dev);
-		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
+
 		if (wl->initialized)	{
 			nic->iftype = AP_MODE;
 			wilc_mac_close(dev);
@@ -2764,10 +2310,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		mod_timer(&wilc_during_ip_timer,
 			  jiffies + msecs_to_jiffies(during_ip_time));
 		wilc_set_power_mgmt(priv->hWILCWFIDrv, 0, 0);
-		/*Delete block ack has to be the latest config packet*/
-		/*sent before downloading new FW. This is because it blocks on*/
-		/*hWaitResponse semaphore, which allows previous config*/
-		/*packets to actually take action on old FW*/
 		wilc_del_all_rx_ba_session(priv->hWILCWFIDrv,
 					   wl->vif[0].bssid, TID);
 		wilc_enable_ps = false;
@@ -2782,20 +2324,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		nic->iftype = GO_MODE;
 
-		/* ensure that the message Q is empty */
 		wilc_wait_msg_queue_idle();
 		wilc1000_wlan_deinit(dev);
 		wilc1000_wlan_init(dev, nic);
 		wilc_initialized = 1;
 
-
-		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 		wilc_set_wfi_drv_handler(wl->vif[0].hif_drv);
 		wilc_set_mac_address(wl->vif[0].hif_drv,
 				     wl->vif[0].src_addr);
 		wilc_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
-		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
 			wilc_set_wep_default_keyid(wl->vif[0].hif_drv,
 						   g_key_wep_params.key_idx);
@@ -2805,11 +2343,8 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 						     g_key_wep_params.key_idx);
 		}
 
-		/*No matter the driver handler passed here, it will be overwriiten*/
-		/*in Handle_FlushConnect() with gu8FlushedJoinReqDrvHandler*/
 		wilc_flush_join_req(priv->hWILCWFIDrv);
 
-		/*Add saved PTK and GTK keys, if any*/
 		if (g_ptk_keys_saved && g_gtk_keys_saved) {
 			PRINT_D(CFG80211_DBG, "ptk %x %x %x cipher %x\n", g_key_ptk_params.key[0],
 				g_key_ptk_params.key[1],
@@ -2853,32 +2388,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-/* (austin.2013-07-23)
- *
- *      To support revised cfg80211_ops
- *
- *              add_beacon --> start_ap
- *              set_beacon --> change_beacon
- *              del_beacon --> stop_ap
- *
- *              beacon_parameters  -->	cfg80211_ap_settings
- *                                                              cfg80211_beacon_data
- *
- *      applicable for linux kernel 3.4+
- */
-
-/**
- *  @brief      start_ap
- *  @details    Add a beacon with given parameters, @head, @interval
- *                      and @dtim_period will be valid, @tail is optional.
- *  @param[in]   wiphy
- *  @param[in]   dev	The net device structure
- *  @param[in]   settings	cfg80211_ap_settings parameters for the beacon to be added
- *  @return     int : Return 0 on Success.
- *  @author	austin
- *  @date	23 JUL 2013
- *  @version	1.0
- */
 static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 		    struct cfg80211_ap_settings *settings)
 {
@@ -2912,18 +2421,6 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	return s32Error;
 }
 
-/**
- *  @brief      change_beacon
- *  @details    Add a beacon with given parameters, @head, @interval
- *                      and @dtim_period will be valid, @tail is optional.
- *  @param[in]   wiphy
- *  @param[in]   dev	The net device structure
- *  @param[in]   beacon	cfg80211_beacon_data for the beacon to be changed
- *  @return     int : Return 0 on Success.
- *  @author	austin
- *  @date	23 JUL 2013
- *  @version	1.0
- */
 static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_beacon_data *beacon)
 {
@@ -2943,15 +2440,6 @@ static int change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	return s32Error;
 }
 
-/**
- *  @brief      stop_ap
- *  @details    Remove beacon configuration and stop sending the beacon.
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	austin
- *  @date	23 JUL 2013
- *  @version	1.0
- */
 static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
 	s32 s32Error = 0;
@@ -2975,15 +2463,6 @@ static int stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	return s32Error;
 }
 
-/**
- *  @brief      add_station
- *  @details    Add a new station.
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int add_station(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *mac, struct station_parameters *params)
 {
@@ -3055,15 +2534,6 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 	return s32Error;
 }
 
-/**
- *  @brief      del_station
- *  @details    Remove a station; @mac may be NULL to remove all stations.
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int del_station(struct wiphy *wiphy, struct net_device *dev,
 		       struct station_del_parameters *params)
 {
@@ -3097,15 +2567,6 @@ static int del_station(struct wiphy *wiphy, struct net_device *dev,
 	return s32Error;
 }
 
-/**
- *  @brief      change_station
- *  @details    Modify a given station.
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			  const u8 *mac, struct station_parameters *params)
 {
@@ -3178,16 +2639,6 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 	return s32Error;
 }
 
-
-/**
- *  @brief      add_virtual_intf
- *  @details
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 JUL 2012
- *  @version	1.0
- */
 static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 					     const char *name,
 					     unsigned char name_assign_type,
@@ -3222,15 +2673,6 @@ static struct wireless_dev *add_virtual_intf(struct wiphy *wiphy,
 	return priv->wdev;
 }
 
-/**
- *  @brief      del_virtual_intf
- *  @details
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 JUL 2012
- *  @version	1.0
- */
 static int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 {
 	PRINT_D(HOSTAPD_DBG, "Deleting virtual interface\n");
@@ -3275,19 +2717,6 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 
 };
 
-
-
-
-
-/**
- *  @brief      WILC_WFI_update_stats
- *  @details    Modify parameters for a given BSS.
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
 {
 
@@ -3319,16 +2748,6 @@ int WILC_WFI_update_stats(struct wiphy *wiphy, u32 pktlen, u8 changed)
 	return 0;
 }
 
-/**
- *  @brief      WILC_WFI_CfgAlloc
- *  @details    Allocation of the wireless device structure and assigning it
- *		to the cfg80211 operations structure.
- *  @param[in]   NONE
- *  @return     wireless_dev : Returns pointer to wireless_dev structure.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 {
 
@@ -3336,14 +2755,13 @@ static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 
 
 	PRINT_D(CFG80211_DBG, "Allocating wireless device\n");
-	/*Allocating the wireless device structure*/
+
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev) {
 		PRINT_ER("Cannot allocate wireless device\n");
 		goto _fail_;
 	}
 
-	/*Creating a new wiphy, linking wireless structure with the wiphy structure*/
 	wdev->wiphy = wiphy_new(&wilc_cfg80211_ops, sizeof(struct wilc_priv));
 	if (!wdev->wiphy) {
 		PRINT_ER("Cannot allocate wiphy\n");
@@ -3351,14 +2769,12 @@ static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 
 	}
 
-	/* enable 802.11n HT */
 	WILC_WFI_band_2ghz.ht_cap.ht_supported = 1;
 	WILC_WFI_band_2ghz.ht_cap.cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
 	WILC_WFI_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
 	WILC_WFI_band_2ghz.ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
 	WILC_WFI_band_2ghz.ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
 
-	/*wiphy bands*/
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &WILC_WFI_band_2ghz;
 
 	return wdev;
@@ -3369,15 +2785,7 @@ _fail_:
 	return NULL;
 
 }
-/**
- *  @brief      wilc_create_wiphy
- *  @details    Registering of the wiphy structure and interface modes
- *  @param[in]   NONE
- *  @return     NONE
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
+
 struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *dev)
 {
 	struct wilc_priv *priv;
@@ -3392,33 +2800,20 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 		return NULL;
 	}
 
-
-	/*Return hardware description structure (wiphy)'s priv*/
 	priv = wdev_priv(wdev);
 	sema_init(&(priv->SemHandleUpdateStats), 1);
-
-	/*Link the wiphy with wireless structure*/
 	priv->wdev = wdev;
-
-	/*Maximum number of probed ssid to be added by user for the scan request*/
 	wdev->wiphy->max_scan_ssids = MAX_NUM_PROBED_SSID;
-	/*Maximum number of pmkids to be cashed*/
 	wdev->wiphy->max_num_pmkids = WILC_MAX_NUM_PMKIDS;
 	PRINT_INFO(CFG80211_DBG, "Max number of PMKIDs = %d\n", wdev->wiphy->max_num_pmkids);
 
 	wdev->wiphy->max_scan_ie_len = 1000;
-
-	/*signal strength in mBm (100*dBm) */
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
-
-	/*Set the availaible cipher suites*/
 	wdev->wiphy->cipher_suites = cipher_suites;
 	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
-	/*Setting default managment types: for register action frame:  */
 	wdev->wiphy->mgmt_stypes = wilc_wfi_cfg80211_mgmt_types;
 
 	wdev->wiphy->max_remain_on_channel_duration = 500;
-	/*Setting the wiphy interfcae mode and type before registering the wiphy*/
 	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_AP) | BIT(NL80211_IFTYPE_MONITOR) | BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT);
 	wdev->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
@@ -3432,11 +2827,9 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 
 	set_wiphy_dev(wdev->wiphy, dev);
 
-	/*Register wiphy structure*/
 	s32Error = wiphy_register(wdev->wiphy);
 	if (s32Error) {
 		PRINT_ER("Cannot register wiphy device\n");
-		/*should define what action to be taken in such failure*/
 	} else {
 		PRINT_D(CFG80211_DBG, "Successful Registering\n");
 	}
@@ -3446,15 +2839,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 
 
 }
-/**
- *  @brief      WILC_WFI_WiphyFree
- *  @details    Freeing allocation of the wireless device structure
- *  @param[in]   NONE
- *  @return     NONE
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
+
 int wilc_init_host_int(struct net_device *net)
 {
 
@@ -3486,15 +2871,6 @@ int wilc_init_host_int(struct net_device *net)
 	return s32Error;
 }
 
-/**
- *  @brief      WILC_WFI_WiphyFree
- *  @details    Freeing allocation of the wireless device structure
- *  @param[in]   NONE
- *  @return     NONE
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 int wilc_deinit_host_int(struct net_device *net)
 {
 	int s32Error = 0;
@@ -3511,7 +2887,6 @@ int wilc_deinit_host_int(struct net_device *net)
 
 	s32Error = wilc_deinit(priv->hWILCWFIDrv);
 
-	/* Clear the Shadow scan */
 	clear_shadow_scan();
 	if (op_ifcs == 0) {
 		PRINT_D(CORECONFIG_DBG, "destroy during ip\n");
@@ -3524,16 +2899,6 @@ int wilc_deinit_host_int(struct net_device *net)
 	return s32Error;
 }
 
-
-/**
- *  @brief      WILC_WFI_WiphyFree
- *  @details    Freeing allocation of the wireless device structure
- *  @param[in]   NONE
- *  @return     NONE
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 void wilc_free_wiphy(struct net_device *net)
 {
 	PRINT_D(CFG80211_DBG, "Unregistering wiphy\n");
-- 
1.9.1

