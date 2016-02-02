Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9907 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbcBBMI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:08:28 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 25/26] staging: wilc1000: remove unnecessary log message using GENERIC_DBG tag
Date: Tue, 2 Feb 2016 21:02:35 +0900
Message-ID: <1454414556-9822-25-git-send-email-leo.kim@atmel.com> (sfid-20160202_130832_074470_D45546E8)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove unnecessary log message using GENERIC_DBG tag.
Needed log messages has changed netdev_dbg from PRINT_D.
And removes variables that were used to log message.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 42 +------------
 drivers/staging/wilc1000/linux_wlan.c             |  2 -
 drivers/staging/wilc1000/linux_wlan_common.h      |  4 +-
 drivers/staging/wilc1000/wilc_debugfs.c           |  6 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 76 +++--------------------
 drivers/staging/wilc1000/wilc_wlan.c              |  2 -
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 11 +---
 7 files changed, 18 insertions(+), 125 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 017a357..caffb9c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -449,7 +449,6 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 	wid.type = WID_STR;
 	wid.val = mac_buf;
 	wid.size = ETH_ALEN;
-	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				 wilc_get_vif_idx(vif));
@@ -804,15 +803,12 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 
 	if ((hif_drv->hif_state >= HOST_IF_SCANNING) &&
 	    (hif_drv->hif_state < HOST_IF_CONNECTED)) {
-		PRINT_D(GENERIC_DBG, "Don't scan already in [%d] state\n",
-			hif_drv->hif_state);
 		PRINT_ER("Already scan\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
 	if (wilc_optaining_ip || wilc_connecting) {
-		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		PRINT_ER("Don't do obss scan\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
@@ -919,7 +915,6 @@ static s32 Handle_ScanDone(struct wilc_vif *vif,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (enuEvent == SCAN_EVENT_ABORTED) {
-		PRINT_D(GENERIC_DBG, "Abort running scan\n");
 		u8abort_running_scan = 1;
 		wid.id = (u16)WID_ABORT_RUNNING_SCAN;
 		wid.type = WID_CHAR;
@@ -960,8 +955,6 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	struct join_bss_param *ptstrJoinBssParam;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	PRINT_D(GENERIC_DBG, "Handling connect request\n");
-
 	if (memcmp(pstrHostIFconnectAttr->bssid, wilc_connected_ssid, ETH_ALEN) == 0) {
 		result = 0;
 		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
@@ -1153,13 +1146,9 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		join_req_vif = vif;
 	}
 
-	if (pstrHostIFconnectAttr->bssid) {
+	if (pstrHostIFconnectAttr->bssid)
 		memcpy(wilc_connected_ssid,
 		       pstrHostIFconnectAttr->bssid, ETH_ALEN);
-		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n",
-			pstrHostIFconnectAttr->bssid);
-		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", wilc_connected_ssid);
-	}
 
 	result = wilc_send_config_pkt(vif, SET_CFG, strWIDList,
 				      u32WidsCount,
@@ -1169,7 +1158,6 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		result = -EFAULT;
 		goto ERRORHANDLER;
 	} else {
-		PRINT_D(GENERIC_DBG, "set HOST_IF_WAITING_CONN_RESP\n");
 		hif_drv->hif_state = HOST_IF_WAITING_CONN_RESP;
 	}
 
@@ -1447,8 +1435,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 		PRINT_ER("Driver handler is NULL\n");
 		return -ENODEV;
 	}
-	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n",
-		hif_drv->hif_state, pstrRcvdGnrlAsyncInfo->buffer[7]);
 
 	if ((hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) ||
 	    (hif_drv->hif_state == HOST_IF_CONNECTED) ||
@@ -1552,7 +1538,6 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 				hif_drv->hif_state = HOST_IF_CONNECTED;
 
-				PRINT_D(GENERIC_DBG, "Obtaining an IP, Disable Scan\n");
 				wilc_optaining_ip = true;
 				mod_timer(&wilc_during_ip_timer,
 					  jiffies + msecs_to_jiffies(10000));
@@ -2425,19 +2410,16 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	}
 
 	if (hif_drv->usr_scan_req.scan_result) {
-		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while scanning return\n");
 		hif_drv->remain_on_ch_pending = 1;
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 	if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
-		PRINT_INFO(GENERIC_DBG, "Required to remain on chan while connecting return\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
 
 	if (wilc_optaining_ip || wilc_connecting) {
-		PRINT_D(GENERIC_DBG, "[handle_scan]: Don't do obss scan until IP adresss is obtained\n");
 		result = -EBUSY;
 		goto ERRORHANDLER;
 	}
@@ -2545,7 +2527,7 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 		}
 		P2P_LISTEN_STATE = 0;
 	} else {
-		PRINT_D(GENERIC_DBG, "Not in listen state\n");
+		netdev_dbg(vif->ndev, "Not in listen state\n");
 		result = -EFAULT;
 	}
 
@@ -2639,12 +2621,6 @@ static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 	struct wid wid;
 	char *ptr = NULL;
 
-	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
-		strHostIfBASessionInfo->bssid[0],
-		strHostIfBASessionInfo->bssid[1],
-		strHostIfBASessionInfo->bssid[2],
-		strHostIfBASessionInfo->tid);
-
 	wid.id = (u16)WID_DEL_ALL_RX_BA;
 	wid.type = WID_STR;
 	wid.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
@@ -2715,13 +2691,10 @@ static int hostIFthread(void *pvArg)
 	while (1) {
 		wilc_mq_recv(&hif_msg_q, &msg, sizeof(struct host_if_msg), &u32Ret);
 		vif = msg.vif;
-		if (msg.id == HOST_IF_MSG_EXIT) {
-			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
+		if (msg.id == HOST_IF_MSG_EXIT)
 			break;
-		}
 
 		if ((!wilc_initialized)) {
-			PRINT_D(GENERIC_DBG, "--WAIT--");
 			usleep_range(200 * 1000, 200 * 1000);
 			wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 			continue;
@@ -3319,9 +3292,6 @@ s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 	}
 	if (hif_drv->hif_state < HOST_IF_CONNECTING)
 		hif_drv->hif_state = HOST_IF_CONNECTING;
-	else
-		PRINT_D(GENERIC_DBG, "Don't set state to 'connecting' : %d\n",
-			hif_drv->hif_state);
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
@@ -3867,8 +3837,6 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 		return;
 	hif_drv = vif->hif_drv;
 
-	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", hif_drv);
-
 	if (!hif_drv || hif_drv == terminated_handle)
 		return;
 
@@ -4342,10 +4310,6 @@ static void *host_int_ParseJoinBssParam(struct network_info *ptstrNetworkInfo)
 					pNewJoinBssParam->opp_enabled = 0;
 				}
 
-				PRINT_D(GENERIC_DBG, "P2P Dump\n");
-				for (i = 0; i < pu8IEs[index + 7]; i++)
-					PRINT_D(GENERIC_DBG, " %x\n", pu8IEs[index + 9 + i]);
-
 				pNewJoinBssParam->cnt = pu8IEs[index + 11];
 				u16P2P_count = index + 12;
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e702020..c11830f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -253,8 +253,6 @@ void wilc_mac_indicate(struct wilc *wilc, int flag)
 		} else {
 			wilc->mac_status = status;
 		}
-	} else if (flag == WILC_MAC_INDICATE_SCAN) {
-		PRINT_D(GENERIC_DBG, "Scanning ...\n");
 	}
 }
 
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 758633e..44573e2 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -2,14 +2,12 @@
 #define LINUX_WLAN_COMMON_H
 
 enum debug_region {
-	Generic_debug = 0,
-	Hostapd_debug,
+	Hostapd_debug = 0,
 	CFG80211_debug,
 	Init_debug,
 	COMP = 0xFFFFFFFF,
 };
 
-#define GENERIC_DBG             (1 << Generic_debug)
 #define HOSTAPD_DBG             (1 << Hostapd_debug)
 #define CFG80211_DBG            (1 << CFG80211_debug)
 #define INIT_DBG                (1 << Init_debug)
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 13330c9..709e40f 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,9 +24,9 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | CFG80211_DBG | INIT_DBG)
+#define DBG_REGION_ALL	(HOSTAPD_DBG | CFG80211_DBG | INIT_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG |
+atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | CFG80211_DBG |
 				   HOSTAPD_DBG);
 EXPORT_SYMBOL_GPL(WILC_REGION);
 atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
@@ -136,7 +136,7 @@ struct wilc_debugfs_info_t {
 
 static struct wilc_debugfs_info_t debugfs_info[] = {
 	{ "wilc_debug_level",	0666,	(DEBUG | ERR), FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write, NULL), },
-	{ "wilc_debug_region",	0666,	(INIT_DBG | GENERIC_DBG | CFG80211_DBG), FOPS(NULL, wilc_debug_region_read, wilc_debug_region_write, NULL), },
+	{ "wilc_debug_region",	0666,	(INIT_DBG | CFG80211_DBG), FOPS(NULL, wilc_debug_region_read, wilc_debug_region_write, NULL), },
 };
 
 static int __init wilc_debugfs_init(void)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1f0e4e2..79a4b7f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -317,7 +317,6 @@ static void remove_network_from_shadow(unsigned long arg)
 
 static void clear_duringIP(unsigned long arg)
 {
-	PRINT_D(GENERIC_DBG, "GO:IP Obtained , enable scan\n");
 	wilc_optaining_ip = false;
 }
 
@@ -1567,7 +1566,6 @@ static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 	}
 	if (wlan_channel != INVALID_CHANNEL) {
 		if (channel_list_attr_index) {
-			PRINT_D(GENERIC_DBG, "Modify channel list attribute\n");
 			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
 				if (buf[i] == 0x51) {
 					for (j = i + 2; j < ((i + 2) + buf[i + 1]); j++) {
@@ -1579,7 +1577,6 @@ static void WILC_WFI_CfgParseRxAction(u8 *buf, u32 len)
 		}
 
 		if (op_channel_attr_index) {
-			PRINT_D(GENERIC_DBG, "Modify operating channel attribute\n");
 			buf[op_channel_attr_index + 6] = 0x51;
 			buf[op_channel_attr_index + 7] = wlan_channel;
 		}
@@ -1609,7 +1606,6 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 	}
 	if (wlan_channel != INVALID_CHANNEL && bOperChan) {
 		if (channel_list_attr_index) {
-			PRINT_D(GENERIC_DBG, "Modify channel list attribute\n");
 			for (i = channel_list_attr_index + 3; i < ((channel_list_attr_index + 3) + buf[channel_list_attr_index + 1]); i++) {
 				if (buf[i] == 0x51) {
 					for (j = i + 2; j < ((i + 2) + buf[i + 1]); j++) {
@@ -1621,7 +1617,6 @@ static void WILC_WFI_CfgParseTxAction(u8 *buf, u32 len, bool bOperChan, u8 iftyp
 		}
 
 		if (op_channel_attr_index) {
-			PRINT_D(GENERIC_DBG, "Modify operating channel attribute\n");
 			buf[op_channel_attr_index + 6] = 0x51;
 			buf[op_channel_attr_index + 7] = wlan_channel;
 		}
@@ -1645,41 +1640,29 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
 		if (buff[FRAME_TYPE_ID] == IEEE80211_STYPE_PROBE_RESP) {
-			PRINT_D(GENERIC_DBG, "Probe response ACK\n");
 			cfg80211_mgmt_tx_status(priv->wdev, priv->u64tx_cookie, buff, size, true, GFP_KERNEL);
 			return;
 		} else {
-			if (pkt_offset & IS_MGMT_STATUS_SUCCES)	{
-				PRINT_D(GENERIC_DBG, "Success Ack - Action frame category: %x Action Subtype: %d Dialog T: %x OR %x\n", buff[ACTION_CAT_ID], buff[ACTION_SUBTYPE_ID],
-					buff[ACTION_SUBTYPE_ID + 1], buff[P2P_PUB_ACTION_SUBTYPE + 1]);
+			if (pkt_offset & IS_MGMT_STATUS_SUCCES)
 				cfg80211_mgmt_tx_status(priv->wdev, priv->u64tx_cookie, buff, size, true, GFP_KERNEL);
-			} else {
-				PRINT_D(GENERIC_DBG, "Fail Ack - Action frame category: %x Action Subtype: %d Dialog T: %x OR %x\n", buff[ACTION_CAT_ID], buff[ACTION_SUBTYPE_ID],
-					buff[ACTION_SUBTYPE_ID + 1], buff[P2P_PUB_ACTION_SUBTYPE + 1]);
+			else
 				cfg80211_mgmt_tx_status(priv->wdev, priv->u64tx_cookie, buff, size, false, GFP_KERNEL);
-			}
 			return;
 		}
 	} else {
-		PRINT_D(GENERIC_DBG, "Rx Frame Type:%x\n", buff[FRAME_TYPE_ID]);
-
 		s32Freq = ieee80211_channel_to_frequency(curr_channel, IEEE80211_BAND_2GHZ);
 
 		if (ieee80211_is_action(buff[FRAME_TYPE_ID])) {
-			PRINT_D(GENERIC_DBG, "Rx Action Frame Type: %x %x\n", buff[ACTION_SUBTYPE_ID], buff[P2P_PUB_ACTION_SUBTYPE]);
-
 			if (priv->bCfgScanning && time_after_eq(jiffies, (unsigned long)pstrWFIDrv->p2p_timeout)) {
-				PRINT_D(GENERIC_DBG, "Receiving action frames from wrong channels\n");
+				netdev_dbg(dev, "Receiving action wrong ch\n");
 				return;
 			}
 			if (buff[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
 				switch (buff[ACTION_SUBTYPE_ID]) {
 				case GAS_INTIAL_REQ:
-					PRINT_D(GENERIC_DBG, "GAS INITIAL REQ %x\n", buff[ACTION_SUBTYPE_ID]);
 					break;
 
 				case GAS_INTIAL_RSP:
-					PRINT_D(GENERIC_DBG, "GAS INITIAL RSP %x\n", buff[ACTION_SUBTYPE_ID]);
 					break;
 
 				case PUBLIC_ACT_VENDORSPEC:
@@ -1690,7 +1673,6 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 									if (!memcmp(p2p_vendor_spec, &buff[i], 6)) {
 										p2p_recv_random = buff[i + 6];
 										wilc_ie = true;
-										PRINT_D(GENERIC_DBG, "WILC Vendor specific IE:%02x\n", p2p_recv_random);
 										break;
 									}
 								}
@@ -1707,20 +1689,19 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 								}
 							}
 						} else {
-							PRINT_D(GENERIC_DBG, "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
+							netdev_dbg(dev, "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
 						}
 					}
 
 
 					if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP) && (wilc_ie))	{
-						PRINT_D(GENERIC_DBG, "Sending P2P to host without extra elemnt\n");
 						cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size - 7, 0);
 						return;
 					}
 					break;
 
 				default:
-					PRINT_D(GENERIC_DBG, "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n", buff[ACTION_SUBTYPE_ID]);
+					netdev_dbg(dev, "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n", buff[ACTION_SUBTYPE_ID]);
 					break;
 				}
 			}
@@ -1761,17 +1742,12 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 	priv = (struct wilc_priv *)pUserVoid;
 
 	if (u32SessionID == priv->strRemainOnChanParams.u32ListenSessionID) {
-		PRINT_D(GENERIC_DBG, "Remain on channel expired\n");
-
 		priv->bInP2PlistenState = false;
 
 		cfg80211_remain_on_channel_expired(priv->wdev,
 						   priv->strRemainOnChanParams.u64ListenCookie,
 						   priv->strRemainOnChanParams.pstrListenChan,
 						   GFP_KERNEL);
-	} else {
-		PRINT_D(GENERIC_DBG, "Received ID 0x%x Expected ID 0x%x (No match)\n", u32SessionID
-			, priv->strRemainOnChanParams.u32ListenSessionID);
 	}
 }
 
@@ -1787,11 +1763,8 @@ static int remain_on_channel(struct wiphy *wiphy,
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	PRINT_D(GENERIC_DBG, "Remaining on channel %d\n", chan->hw_value);
-
-
 	if (wdev->iftype == NL80211_IFTYPE_AP) {
-		PRINT_D(GENERIC_DBG, "Required remain-on-channel while in AP mode");
+		netdev_dbg(vif->ndev, "Required while in AP mode\n");
 		return s32Error;
 	}
 
@@ -1868,34 +1841,22 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 
 		if (ieee80211_is_probe_resp(mgmt->frame_control)) {
-			PRINT_D(GENERIC_DBG, "TX: Probe Response\n");
-			PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
 			wilc_set_mac_chnl_num(vif, chan->hw_value);
 			curr_channel = chan->hw_value;
 		} else if (ieee80211_is_action(mgmt->frame_control))   {
-			PRINT_D(GENERIC_DBG, "ACTION FRAME:%x\n", (u16)mgmt->frame_control);
-
-
 			if (buf[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
 				if (buf[ACTION_SUBTYPE_ID] != PUBLIC_ACT_VENDORSPEC ||
 				    buf[P2P_PUB_ACTION_SUBTYPE] != GO_NEG_CONF)	{
-					PRINT_D(GENERIC_DBG, "Setting channel: %d\n", chan->hw_value);
 					wilc_set_mac_chnl_num(vif,
 							      chan->hw_value);
 					curr_channel = chan->hw_value;
 				}
 				switch (buf[ACTION_SUBTYPE_ID])	{
 				case GAS_INTIAL_REQ:
-				{
-					PRINT_D(GENERIC_DBG, "GAS INITIAL REQ %x\n", buf[ACTION_SUBTYPE_ID]);
 					break;
-				}
 
 				case GAS_INTIAL_RSP:
-				{
-					PRINT_D(GENERIC_DBG, "GAS INITIAL RSP %x\n", buf[ACTION_SUBTYPE_ID]);
 					break;
-				}
 
 				case PUBLIC_ACT_VENDORSPEC:
 				{
@@ -1910,8 +1871,6 @@ static int mgmt_tx(struct wiphy *wiphy,
 						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP
 						      || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
 							if (p2p_local_random > p2p_recv_random)	{
-								PRINT_D(GENERIC_DBG, "LOCAL WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
-
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
 									if (buf[i] == P2PELEM_ATTR_ID && !(memcmp(p2p_oui, &buf[i + 2], 4))) {
 										if (buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)
@@ -1927,13 +1886,11 @@ static int mgmt_tx(struct wiphy *wiphy,
 									mgmt_tx->buff[len + sizeof(p2p_vendor_spec)] = p2p_local_random;
 									mgmt_tx->size = buf_len;
 								}
-							} else {
-								PRINT_D(GENERIC_DBG, "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
 							}
 						}
 
 					} else {
-						PRINT_D(GENERIC_DBG, "Not a P2P public action frame\n");
+						netdev_dbg(vif->ndev, "Not a P2P public action frame\n");
 					}
 
 					break;
@@ -1941,24 +1898,18 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 				default:
 				{
-					PRINT_D(GENERIC_DBG, "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n", buf[ACTION_SUBTYPE_ID]);
+					netdev_dbg(vif->ndev, "NOT HANDLED PUBLIC ACTION FRAME TYPE:%x\n", buf[ACTION_SUBTYPE_ID]);
 					break;
 				}
 				}
 			}
 
-			PRINT_D(GENERIC_DBG, "TX: ACTION FRAME Type:%x : Chan:%d\n", buf[ACTION_SUBTYPE_ID], chan->hw_value);
 			pstrWFIDrv->p2p_timeout = (jiffies + msecs_to_jiffies(wait));
-
-			PRINT_D(GENERIC_DBG, "Current Jiffies: %lu Timeout:%llu\n",
-				jiffies, pstrWFIDrv->p2p_timeout);
 		}
 
 		wilc_wlan_txq_add_mgmt_pkt(wdev->netdev, mgmt_tx,
 					   mgmt_tx->buff, mgmt_tx->size,
 					   WILC_WFI_mgmt_tx_complete);
-	} else {
-		PRINT_D(GENERIC_DBG, "This function transmits only management frames\n");
 	}
 	return 0;
 }
@@ -1972,9 +1923,6 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 
 	priv = wiphy_priv(wiphy);
 	pstrWFIDrv = (struct host_if_drv *)priv->hif_drv;
-
-
-	PRINT_D(GENERIC_DBG, "Tx Cancel wait :%lu\n", jiffies);
 	pstrWFIDrv->p2p_timeout = jiffies;
 
 	if (!priv->bInP2PlistenState) {
@@ -2001,7 +1949,6 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (!frame_type)
 		return;
 
-	PRINT_D(GENERIC_DBG, "Frame registering Frame Type: %x: Boolean: %d\n", frame_type, reg);
 	switch (frame_type) {
 	case PROBE_REQ:
 	{
@@ -2023,10 +1970,8 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 	}
 	}
 
-	if (!wl->initialized) {
-		PRINT_D(GENERIC_DBG, "Return since mac is closed\n");
+	if (!wl->initialized)
 		return;
-	}
 	wilc_frame_register(vif, frame_type, reg);
 }
 
@@ -2099,7 +2044,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	wilc_ie = false;
 	wilc_optaining_ip = false;
 	del_timer(&wilc_during_ip_timer);
-	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
 
 	switch (type) {
 	case NL80211_IFTYPE_STATION:
@@ -2148,8 +2092,6 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		break;
 
 	case NL80211_IFTYPE_P2P_GO:
-		PRINT_D(GENERIC_DBG, "start duringIP timer\n");
-
 		wilc_optaining_ip = true;
 		mod_timer(&wilc_during_ip_timer,
 			  jiffies + msecs_to_jiffies(during_ip_time));
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index fc0f772..7d6492f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -713,8 +713,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				break;
 
 			if (entries == 0) {
-				PRINT_WRN(GENERIC_DBG, "[wilc txq]: no more buffer in the chip (reg: %08x), retry later [[ %d, %x ]]\n", reg, i, vmm_table[i - 1]);
-
 				ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
 				if (!ret)
 					break;
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 3b3065b..2bb684a 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -270,13 +270,12 @@ static int wilc_wlan_cfg_set_bin(u8 *frame, u32 offset, u16 id, u8 *b, u32 size)
 static void wilc_wlan_parse_response_frame(u8 *info, int size)
 {
 	u32 wid, len = 0, i = 0;
-	static int seq;
 
 	while (size > 0) {
 		i = 0;
 		wid = info[0] | (info[1] << 8);
 		wid = cpu_to_le32(wid);
-		PRINT_INFO(GENERIC_DBG, "Processing response for %d seq %d\n", wid, seq++);
+
 		switch ((wid >> 12) & 0x7) {
 		case WID_CHAR:
 			do {
@@ -329,10 +328,6 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 					if (wid == WID_SITE_SURVEY_RESULTS) {
 						static int toggle;
 
-						PRINT_INFO(GENERIC_DBG, "Site survey results received[%d]\n",
-							   size);
-
-						PRINT_INFO(GENERIC_DBG, "Site survey results value[%d]toggle[%d]\n", size, toggle);
 						i += toggle;
 						toggle ^= 1;
 					}
@@ -361,7 +356,7 @@ static int wilc_wlan_parse_info_frame(u8 *info, int size)
 	wid = info[0] | (info[1] << 8);
 
 	len = info[2];
-	PRINT_INFO(GENERIC_DBG, "Status Len = %d Id= %d\n", len, wid);
+
 	if ((len == 1) && (wid == WID_STATUS)) {
 		pd->mac_status = info[3];
 		type = WILC_CFG_RSP_STATUS;
@@ -475,8 +470,6 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 					if (g_cfg_str[i].id == WID_SITE_SURVEY_RESULTS)	{
 						static int toggle;
 
-						PRINT_INFO(GENERIC_DBG, "Site survey results value[%d]\n",
-							   size);
 						i += toggle;
 						toggle ^= 1;
 
-- 
1.9.1

