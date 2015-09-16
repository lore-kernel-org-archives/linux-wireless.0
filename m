Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40067 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbbIPJxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:53:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/8] staging: wilc1000: remove define WILC_AP_EXTERNAL_MLME and ifdef line
Date: Wed, 16 Sep 2015 18:53:20 +0900
Message-ID: <1442397207-20491-1-git-send-email-tony.cho@atmel.com> (sfid-20150916_115346_411767_06497F91)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This driver use WILC_AP_EXTERNAL_MLME define always. Delete define
WILC_AP_EXTERNAL_MLME and ifdef line.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 30 +++--------------------
 drivers/staging/wilc1000/linux_mon.c              |  2 --
 drivers/staging/wilc1000/linux_wlan.c             |  4 ---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 21 +---------------
 drivers/staging/wilc1000/wilc_wlan.c              | 12 +++------
 drivers/staging/wilc1000/wilc_wlan.h              |  2 --
 drivers/staging/wilc1000/wilc_wlan_if.h           |  5 +---
 7 files changed, 9 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8d7a639..41e80aa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -563,10 +563,8 @@ static s8 gs8lnkspd;
 static u8 gu8Chnl;
 static u8 gs8SetIP[2][4];
 static u8 gs8GetIP[2][4];
-#ifdef WILC_AP_EXTERNAL_MLME
 static u32 gu32InactiveTime;
 static u8 gu8DelBcn;
-#endif
 static u32 gu32WidConnRstHack;
 
 /*BugID_5137*/
@@ -2728,9 +2726,7 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-	#ifdef WILC_AP_EXTERNAL_MLME
 	tstrWID strWIDList[5];
-	#endif
 	u8 i;
 	u8 *pu8keybuf;
 	s8 s8idxarray[1];
@@ -2743,7 +2739,6 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 	case WEP:
 
-#ifdef WILC_AP_EXTERNAL_MLME
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
 
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
@@ -2791,7 +2786,6 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 
 
 		}
-#endif
 
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
@@ -2844,7 +2838,6 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 		break;
 
 	case WPARxGtk:
-			#ifdef WILC_AP_EXTERNAL_MLME
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
 			pu8keybuf = kmalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
@@ -2894,7 +2887,6 @@ static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIF
 			/* ///////////////////////// */
 		}
 
-			#endif
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling group key(Rx) function\n");
 
@@ -2949,7 +2941,6 @@ _WPARxGtk_end_case_:
 		break;
 
 	case WPAPtk:
-		#ifdef WILC_AP_EXTERNAL_MLME
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
 
 
@@ -2997,7 +2988,6 @@ _WPARxGtk_end_case_:
 			up(&(pstrWFIDrv->hSemTestKeyBlock));
 			/* ///////////////////////// */
 		}
-		#endif
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 
 
@@ -3395,10 +3385,6 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
 
 }
 
-
-#ifdef WILC_AP_EXTERNAL_MLME
-
-
 /**
  *  @brief Handle_Get_InActiveTime
  *  @details       Sending config packet to set mac adddress for station and
@@ -3800,7 +3786,6 @@ ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
 	kfree(strWID.ps8WidVal);
 }
-#endif /*WILC_AP_EXTERNAL_MLME*/
 
 #ifdef WILC_P2P
 /**
@@ -4447,7 +4432,6 @@ static int hostIFthread(void *pvArg)
 			Handle_GetChnl(strHostIFmsg.drvHandler);
 			break;
 
-#ifdef WILC_AP_EXTERNAL_MLME
 		case HOST_IF_MSG_ADD_BEACON:
 			Handle_AddBeacon(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon);
 			break;
@@ -4472,7 +4456,6 @@ static int hostIFthread(void *pvArg)
 			Handle_Get_InActiveTime(strHostIFmsg.drvHandler, &strHostIFmsg.uniHostIFmsgBody.strHostIfStaInactiveT);
 			break;
 
-#endif /*WILC_AP_EXTERNAL_MLME*/
 		case HOST_IF_MSG_SCAN_TIMER_FIRED:
 			PRINT_D(HOSTINF_DBG, "Scan Timeout\n");
 
@@ -4781,7 +4764,6 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 
 }
 
-#ifdef WILC_AP_EXTERNAL_MLME
 /**
  *
  *  @brief              host_int_add_wep_key_bss_ap
@@ -4854,7 +4836,7 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 	return s32Error;
 
 }
-#endif
+
 /**
  *  @brief              adds ptk Key
  *  @details
@@ -4896,13 +4878,11 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 
 	strHostIFmsg.u16MsgId = HOST_IF_MSG_KEY;
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPAPtk;
-	#ifdef WILC_AP_EXTERNAL_MLME
 	if (mode == AP_MODE) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.
 		uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8Idx;
 	}
-	#endif
 	if (mode == STATION_MODE)
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 
@@ -5003,12 +4983,10 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.enuKeyType = WPARxGtk;
 	strHostIFmsg.drvHandler = hWFIDrv;
 
-    #ifdef WILC_AP_EXTERNAL_MLME
 	if (mode == AP_MODE) {
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
 	}
-    #endif
 	if (mode == STATION_MODE)
 		strHostIFmsg.uniHostIFmsgBody.strHostIFkeyAttr.u8KeyAction = ADDKEY;
 
@@ -5912,7 +5890,6 @@ s32 host_int_test_set_int_wid(tstrWILC_WFIDrv *hWFIDrv, u32 u32TestMemAddr)
 	return s32Error;
 }
 
-#ifdef WILC_AP_EXTERNAL_MLME
 /**
  *  @brief              host_int_get_inactive_time
  *  @details
@@ -5955,7 +5932,7 @@ s32 host_int_get_inactive_time(tstrWILC_WFIDrv *hWFIDrv, const u8 *mac, u32 *pu3
 
 	return s32Error;
 }
-#endif
+
 /**
  *  @brief              host_int_test_get_int_wid
  *  @details    Test function for getting wids
@@ -6991,7 +6968,6 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 }
 #endif
 
-#ifdef WILC_AP_EXTERNAL_MLME
 /**
  *  @brief host_int_add_beacon
  *  @details       Setting add beacon params in message queue
@@ -7298,7 +7274,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 
 	return s32Error;
 }
-#endif /*WILC_AP_EXTERNAL_MLME*/
+
 u32 wilc_get_chipid(u8);
 
 s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index af5d0f5..4c02b98 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -11,7 +11,6 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
-#ifdef WILC_AP_EXTERNAL_MLME
 
 struct wilc_wfi_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
@@ -419,4 +418,3 @@ int WILC_WFI_deinit_mon_interface(void)
 	return 0;
 
 }
-#endif /* WILC_AP_EXTERNAL_MLME */
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3477e09..bc9aae4 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1886,9 +1886,7 @@ int mac_close(struct net_device *ndev)
 		PRINT_D(GENERIC_DBG, "Deinitializing wilc1000\n");
 		g_linux_wlan->close = 1;
 		wilc1000_wlan_deinit(g_linux_wlan);
-		#ifdef WILC_AP_EXTERNAL_MLME
 		WILC_WFI_deinit_mon_interface();
-		#endif
 	}
 
 	up(&close_exit_sync);
@@ -2247,10 +2245,8 @@ static void __exit exit_wilc_driver(void)
 		}
 	}
 
-#ifdef WILC_AP_EXTERNAL_MLME
 	/* Bug 4600 : WILC_WFI_deinit_mon_interface was already called at mac_close */
 	/* WILC_WFI_deinit_mon_interface(); */
-#endif
 
 	/* if(g_linux_wlan->open_ifcs==0) */
 	{
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f01260f..cc61f26 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1130,11 +1130,9 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	const u8 *pu8RxMic = NULL;
 	const u8 *pu8TxMic = NULL;
 	u8 u8mode = NO_ENCRYPT;
-	#ifdef WILC_AP_EXTERNAL_MLME
 	u8 u8gmode = NO_ENCRYPT;
 	u8 u8pmode = NO_ENCRYPT;
 	AUTHTYPE_T tenuAuth_type = ANY;
-	#endif
 
 	priv = wiphy_priv(wiphy);
 
@@ -1151,7 +1149,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	switch (params->cipher)	{
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-				#ifdef WILC_AP_EXTERNAL_MLME
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP) {
 
 			priv->WILC_WFI_wep_default = key_index;
@@ -1174,7 +1171,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			host_int_add_wep_key_bss_ap(priv->hWILCWFIDrv, params->key, params->key_len, key_index, u8mode, tenuAuth_type);
 			break;
 		}
-				#endif
 		if (memcmp(params->key, priv->WILC_WFI_wep_key[key_index], params->key_len)) {
 			priv->WILC_WFI_wep_default = key_index;
 			priv->WILC_WFI_wep_key_len[key_index] = params->key_len;
@@ -1193,7 +1189,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 
 	case WLAN_CIPHER_SUITE_TKIP:
 	case WLAN_CIPHER_SUITE_CCMP:
-				#ifdef WILC_AP_EXTERNAL_MLME
 		if (priv->wdev->iftype == NL80211_IFTYPE_AP || priv->wdev->iftype == NL80211_IFTYPE_P2P_GO) {
 
 			if (priv->wilc_gtk[key_index] == NULL) {
@@ -1304,7 +1299,6 @@ static int add_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 			}
 			break;
 		}
-				#endif
 
 		{
 			u8mode = 0;
@@ -1435,7 +1429,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 
 		/*freeing memory allocated by "wilc_gtk" and "wilc_ptk" in "WILC_WIFI_ADD_KEY"*/
 
-	#ifdef WILC_AP_EXTERNAL_MLME
 		if ((priv->wilc_gtk[key_index]) != NULL) {
 
 			if (priv->wilc_gtk[key_index]->key != NULL) {
@@ -1469,7 +1462,6 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 			kfree(priv->wilc_ptk[key_index]);
 			priv->wilc_ptk[key_index] = NULL;
 		}
-	#endif
 
 		/*Delete saved PTK and GTK keys params, if any*/
 		if (g_key_ptk_params.key != NULL) {
@@ -1632,15 +1624,12 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 	s32 s32Error = 0;
 	struct wilc_priv *priv;
 	perInterface_wlan_t *nic;
-	#ifdef WILC_AP_EXTERNAL_MLME
 	u32 i = 0;
 	u32 associatedsta = 0;
 	u32 inactive_time = 0;
-	#endif
 	priv = wiphy_priv(wiphy);
 	nic = netdev_priv(dev);
 
-	#ifdef WILC_AP_EXTERNAL_MLME
 	if (nic->iftype == AP_MODE || nic->iftype == GO_MODE) {
 		PRINT_D(HOSTAPD_DBG, "Getting station parameters\n");
 
@@ -1669,7 +1658,6 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CFG80211_DBG, "Inactive time %d\n", sinfo->inactive_time);
 
 	}
-	#endif
 
 	if (nic->iftype == STATION_MODE) {
 		tstrStatistics strStatistics;
@@ -2749,7 +2737,7 @@ int WILC_WFI_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 
 }
-#ifdef WILC_AP_EXTERNAL_MLME
+
 /**
  *  @brief      change_virtual_intf
  *  @details    Change type/configuration of virtual interface,
@@ -3471,9 +3459,6 @@ int del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)      /* ton
 	return 0;
 }
 
-
-
-#endif /*WILC_AP_EXTERNAL_MLME*/
 static struct cfg80211_ops wilc_cfg80211_ops = {
 
 	.set_monitor_channel = set_channel,
@@ -3484,7 +3469,6 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.del_key = del_key,
 	.get_key = get_key,
 	.set_default_key = set_default_key,
-	#ifdef WILC_AP_EXTERNAL_MLME
 	.add_virtual_intf = add_virtual_intf,
 	.del_virtual_intf = del_virtual_intf,
 	.change_virtual_intf = change_virtual_intf,
@@ -3495,7 +3479,6 @@ static struct cfg80211_ops wilc_cfg80211_ops = {
 	.add_station = add_station,
 	.del_station = del_station,
 	.change_station = change_station,
-	#endif /* WILC_AP_EXTERNAL_MLME*/
 	.get_station = get_station,
 	.dump_station = dump_station,
 	.change_bss = change_bss,
@@ -3594,14 +3577,12 @@ struct wireless_dev *WILC_WFI_CfgAlloc(void)
 
 	}
 
-	#ifdef WILC_AP_EXTERNAL_MLME
 	/* enable 802.11n HT */
 	WILC_WFI_band_2ghz.ht_cap.ht_supported = 1;
 	WILC_WFI_band_2ghz.ht_cap.cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
 	WILC_WFI_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
 	WILC_WFI_band_2ghz.ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
 	WILC_WFI_band_2ghz.ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
-	#endif
 
 	/*wiphy bands*/
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &WILC_WFI_band_2ghz;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7496c1f..97aac50 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -562,7 +562,7 @@ static int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size, wi
 	return p->txq_entries;
 }
 /*Bug3959: transmitting mgmt frames received from host*/
-#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
+#if defined(WILC_P2P)
 int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_complete_func_t func)
 {
 
@@ -588,7 +588,7 @@ int wilc_wlan_txq_add_mgmt_pkt(void *priv, u8 *buffer, u32 buffer_size, wilc_tx_
 	wilc_wlan_txq_add_to_tail(tqe);
 	return 1;
 }
-#endif /*WILC_AP_EXTERNAL_MLME*/
+#endif /* WILC_P2P */
 static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
@@ -896,11 +896,9 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 				else if (tqe->type == WILC_NET_PKT) {
 					vmm_sz = ETH_ETHERNET_HDR_OFFSET;
 				}
-#ifdef WILC_AP_EXTERNAL_MLME
 				else {
 					vmm_sz = HOST_HDR_OFFSET;
 				}
-#endif
 				vmm_sz += tqe->buffer_size;
 				PRINT_D(TX_DBG, "VMM Size before alignment = %d\n", vmm_sz);
 				if (vmm_sz & 0x3) {                                                                                                     /* has to be word aligned */
@@ -1081,12 +1079,10 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 				header = (tqe->type << 31) | (tqe->buffer_size << 15) | vmm_sz;
 				/*Bug3959: transmitting mgmt frames received from host*/
 				/*setting bit 30 in the host header to indicate mgmt frame*/
-#ifdef WILC_AP_EXTERNAL_MLME
 				if (tqe->type == WILC_MGMT_PKT)
 					header |= (1 << 30);
 				else
 					header &= ~(1 << 30);
-#endif
 
 #ifdef BIG_ENDIAN
 				header = BYTE_SWAP(header);
@@ -1217,7 +1213,7 @@ static void wilc_wlan_handle_rxq(void)
 			}
 
 /*bug 3887: [AP] Allow Management frames to be passed to the host*/
-			#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
+			#if defined(WILC_P2P)
 			#define IS_MANAGMEMENT				0x100
 			#define IS_MANAGMEMENT_CALLBACK			0x080
 			#define IS_MGMT_STATUS_SUCCES			0x040
@@ -2149,7 +2145,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	oup->wlan_cfg_get_value = wilc_wlan_cfg_get_val;
 
 	/*Bug3959: transmitting mgmt frames received from host*/
-	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
+	#if defined(WILC_P2P)
 	oup->wlan_add_mgmt_to_tx_que = wilc_wlan_txq_add_mgmt_pkt;
 	#endif
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 18bc11c..c6f1556 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -139,10 +139,8 @@
 #define WILC_CFG_PKT	1
 #define WILC_NET_PKT 0
 /*Bug3959: transmitting mgmt frames received from host*/
-#ifdef WILC_AP_EXTERNAL_MLME
 #define WILC_MGMT_PKT 2
 
-#endif /*WILC_AP_EXTERNAL_MLME*/
 #define WILC_CFG_SET 1
 #define WILC_CFG_QUERY 0
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index b64f93a..da37cff 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -12,7 +12,6 @@
 #define WILC_WLAN_IF_H
 
 /*bug 3887: [AP] Allow Management frames to be passed to the host*/
-#define WILC_AP_EXTERNAL_MLME
 #define WILC_P2P
 #define TCP_ENHANCEMENTS
 /* #define MEMORY_STATIC */
@@ -178,7 +177,7 @@ typedef struct {
 	int (*wlan_cfg_get)(int, u32, int, u32);
 	int (*wlan_cfg_get_value)(u32, u8 *, u32);
 	/*Bug3959: transmitting mgmt frames received from host*/
-	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
+	#if defined(WILC_P2P)
 	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
 	#endif
 } wilc_wlan_oup_t;
@@ -771,9 +770,7 @@ typedef enum {
 	/* SCAN Complete notification WID*/
 	WID_SCAN_COMPLETE		= 0x00C9,
 
-#ifdef WILC_AP_EXTERNAL_MLME
 	WID_DEL_BEACON					= 0x00CA,
-#endif
 
 	WID_LOGTerminal_Switch					= 0x00CD,
 	/* EMAC Short WID list */
-- 
1.9.1

