Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:9538 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbcBDJYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:24:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 14/70] staging: wilc1000: pass vif to wilc_send_config_pkt
Date: Thu, 4 Feb 2016 18:15:31 +0900
Message-ID: <1454577387-509-15-git-send-email-glen.lee@atmel.com> (sfid-20160204_104503_956921_F3C5B610)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch passes vif instead of wilc to wilc_send_config_pkt and it's related
functions as well, because we need vif which is currently being used and
vif has wilc as well.
Change custom print with netdev_xxx format if there are custom print inside
the functions we have changed.

Function parameter of following functions are modified to vif.
wilc_send_config_pkt
wilc_wlan_cfg_set
wilc_wlan_cfg_get
wilc_wlan_cfg_commit
wilc_wlan_txq_add_cfg_pkt
wilc_wlan_txq_add_to_head

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 94 +++++++++++++++----------------
 drivers/staging/wilc1000/linux_wlan.c     | 88 ++++++++++++++---------------
 drivers/staging/wilc1000/wilc_wlan.c      | 57 +++++++++++--------
 drivers/staging/wilc1000/wilc_wlan.h      |  7 ++-
 4 files changed, 128 insertions(+), 118 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 67bcf88..6f583a4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -312,7 +312,7 @@ static s32 handle_set_channel(struct wilc_vif *vif,
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -334,7 +334,7 @@ static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
 	wid.val = (s8 *)hif_drv_handler;
 	wid.size = sizeof(*hif_drv_handler);
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      hif_drv_handler->handler);
 
 	if (!hif_drv_handler->handler)
@@ -359,7 +359,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 	wid.val = (s8 *)&hif_op_mode->mode;
 	wid.size = sizeof(u32);
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
@@ -392,7 +392,7 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	wid.val = (u8 *)ip_addr;
 	wid.size = IP_ALEN;
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	host_int_get_ipaddress(vif, firmware_ip_addr, idx);
@@ -417,7 +417,7 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	wid.val = kmalloc(IP_ALEN, GFP_KERNEL);
 	wid.size = IP_ALEN;
 
-	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
@@ -460,7 +460,7 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 	wid.size = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
@@ -482,7 +482,7 @@ static s32 handle_get_mac_address(struct wilc_vif *vif,
 	wid.val = get_mac_addr->mac_addr;
 	wid.size = ETH_ALEN;
 
-	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -778,7 +778,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		wid_cnt++;
 	}
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, wid_list,
+	result = wilc_send_config_pkt(vif, SET_CFG, wid_list,
 				      wid_cnt, wilc_get_vif_idx(vif));
 
 	if (result)
@@ -902,7 +902,7 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 	else if (hif_drv->hif_state == HOST_IF_IDLE)
 		scan_while_connected = false;
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif, SET_CFG, strWIDList,
 				      u32WidsCount,
 				      wilc_get_vif_idx(vif));
 
@@ -948,7 +948,7 @@ static s32 Handle_ScanDone(struct wilc_vif *vif,
 		wid.val = (s8 *)&u8abort_running_scan;
 		wid.size = sizeof(char);
 
-		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
 
 		if (result) {
@@ -1204,7 +1204,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", wilc_connected_ssid);
 	}
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif, SET_CFG, strWIDList,
 				      u32WidsCount,
 				      wilc_get_vif_idx(vif));
 	if (result) {
@@ -1302,7 +1302,7 @@ static s32 Handle_FlushConnect(struct wilc_vif *vif)
 
 	u32WidsCount++;
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif, SET_CFG, strWIDList,
 				      u32WidsCount,
 				      wilc_get_vif_idx(join_req_vif));
 	if (result) {
@@ -1365,7 +1365,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -1758,7 +1758,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			strWIDList[2].size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 			strWIDList[2].val = (s8 *)pu8keybuf;
 
-			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif, SET_CFG,
 						      strWIDList, 3,
 						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
@@ -1780,7 +1780,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
-			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
@@ -1793,7 +1793,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.val = s8idxarray;
 			wid.size = 1;
 
-			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 		} else if (pstrHostIFkeyAttr->action & DEFAULTKEY) {
@@ -1804,7 +1804,7 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 		}
@@ -1838,7 +1838,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif, SET_CFG,
 						      strWIDList, 2,
 						      wilc_get_vif_idx(vif));
 
@@ -1870,7 +1870,7 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = RX_MIC_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 
@@ -1910,7 +1910,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
-			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif, SET_CFG,
 						      strWIDList, 2,
 						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
@@ -1933,7 +1933,7 @@ _WPARxGtk_end_case_:
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = PTK_KEY_MSG_LEN;
 
-			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
+			result = wilc_send_config_pkt(vif, SET_CFG,
 						      &wid, 1,
 						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
@@ -1969,7 +1969,7 @@ _WPAPtk_end_case_:
 		wid.val = (s8 *)pu8keybuf;
 		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
 
 		kfree(pu8keybuf);
@@ -2002,7 +2002,7 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 
 	eth_zero_addr(wilc_connected_ssid);
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -2093,7 +2093,7 @@ static s32 Handle_GetChnl(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -2118,7 +2118,7 @@ static void Handle_GetRssi(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
@@ -2143,7 +2143,7 @@ static void Handle_GetLinkspeed(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
@@ -2189,7 +2189,7 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->tx_fail_cnt;
 	u32WidsCount++;
 
-	result = wilc_send_config_pkt(vif->wilc, GET_CFG, strWIDList,
+	result = wilc_send_config_pkt(vif, GET_CFG, strWIDList,
 				      u32WidsCount,
 				      wilc_get_vif_idx(vif));
 
@@ -2225,7 +2225,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -2238,7 +2238,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 	wid.val = (s8 *)&inactive_time;
 	wid.size = sizeof(u32);
 
-	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
@@ -2297,8 +2297,8 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
 
@@ -2326,7 +2326,7 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -2399,7 +2399,7 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2441,7 +2441,7 @@ static void Handle_DelAllSta(struct wilc_vif *vif,
 		pu8CurrByte += ETH_ALEN;
 	}
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2473,7 +2473,7 @@ static void Handle_DelStation(struct wilc_vif *vif,
 
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2501,7 +2501,7 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -2563,7 +2563,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	wid.val[0] = u8remain_on_chan_flag;
 	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
@@ -2611,7 +2611,7 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 
 	wid.size = sizeof(u16) + 2;
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
@@ -2646,7 +2646,7 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 		wid.val[0] = u8remain_on_chan_flag;
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
-		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 					      wilc_get_vif_idx(vif));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
@@ -2704,7 +2704,7 @@ static void Handle_PowerManagement(struct wilc_vif *vif,
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
@@ -2741,7 +2741,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 		memcpy(pu8CurrByte, wilc_multicast_mac_addr_list,
 		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
@@ -2777,7 +2777,7 @@ static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 	*ptr++ = 0;
 	*ptr++ = 32;
 
-	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
@@ -2799,8 +2799,8 @@ static void handle_set_tx_pwr(struct wilc_vif *vif, u8 tx_pwr)
 	wid.val = &tx_pwr;
 	wid.size = sizeof(char);
 
-	ret = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-			     wilc_get_vif_idx(vif));
+	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
 	if (ret)
 		netdev_err(vif->ndev, "Failed to set TX PWR\n");
 }
@@ -2815,8 +2815,8 @@ static void handle_get_tx_pwr(struct wilc_vif *vif, u8 *tx_pwr)
 	wid.val = (s8 *)tx_pwr;
 	wid.size = sizeof(char);
 
-	ret = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-			     wilc_get_vif_idx(vif));
+	ret = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
+				   wilc_get_vif_idx(vif));
 	if (ret)
 		netdev_err(vif->ndev, "Failed to get TX PWR\n");
 
@@ -3513,7 +3513,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 	wid.val = pu8AssocRespInfo;
 	wid.size = u32MaxAssocRespInfoLen;
 
-	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
+	result = wilc_send_config_pkt(vif, GET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9de57ae..a3b4939 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -526,86 +526,86 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 
 	*(int *)c_val = 1;
 
-	if (!wilc_wlan_cfg_set(wilc, 1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_PC_TEST_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = INFRASTRUCTURE;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BSS_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = RATE_AUTO;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_TX_RATE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_MIXED_11B_2_MODE;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11G_OPERATING_MODE, c_val, 1, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11G_OPERATING_MODE, c_val, 1, 0,
 			       0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_CHANNEL, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = G_SHORT_PREAMBLE;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_PREAMBLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_PREAMBLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = AUTO_PROT;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_PROT_MECH, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = ACTIVE_SCAN;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_SCAN_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SCAN_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = SITE_SURVEY_OFF;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_SITE_SURVEY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SITE_SURVEY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 0xffff;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_RTS_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 2346;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_FRAG_THRESHOLD, c_val, 2, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_BCAST_SSID, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BCAST_SSID, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_QOS_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_QOS_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NO_POWERSAVE;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NO_SECURITY; /* NO_ENCRYPT, 0x79 */
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11I_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = OPEN_SYSTEM;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_AUTH_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_AUTH_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	strcpy(c_val, "123456790abcdef1234567890");
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_WEP_KEY_VALUE, c_val,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_WEP_KEY_VALUE, c_val,
 			       (strlen(c_val) + 1), 0, 0))
 		goto _fail_;
 
 	strcpy(c_val, "12345678");
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11I_PSK, c_val, (strlen(c_val)), 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_PSK, c_val, (strlen(c_val)), 0,
 			       0))
 		goto _fail_;
 
 	strcpy(c_val, "password");
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_1X_KEY, c_val, (strlen(c_val) + 1),
+	if (!wilc_wlan_cfg_set(vif, 0, WID_1X_KEY, c_val, (strlen(c_val) + 1),
 			       0, 0))
 		goto _fail_;
 
@@ -613,106 +613,106 @@ static int linux_wlan_init_test_config(struct net_device *dev,
 	c_val[1] = 168;
 	c_val[2] = 1;
 	c_val[3] = 112;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_1X_SERV_ADDR, c_val, 4, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_LISTEN_INTERVAL, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 3;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_DTIM_PERIOD, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = NORMAL_ACK;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_ACK_POLICY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_ACK_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_USER_CONTROL_ON_TX_POWER, c_val, 1,
 			       0, 0))
 		goto _fail_;
 
 	c_val[0] = 48;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11A, c_val, 1, 0,
 			       0))
 		goto _fail_;
 
 	c_val[0] = 28;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11B, c_val, 1, 0,
 			       0))
 		goto _fail_;
 
 	*((int *)c_val) = 100;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BEACON_INTERVAL, c_val, 2, 0, 0))
 		goto _fail_;
 
 	c_val[0] = REKEY_DISABLE;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_REKEY_POLICY, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_POLICY, c_val, 1, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 84600;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PERIOD, c_val, 4, 0, 0))
 		goto _fail_;
 
 	*((int *)c_val) = 500;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_REKEY_PACKET_COUNT, c_val, 4, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PACKET_COUNT, c_val, 4, 0,
 			       0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SHORT_SLOT_ALLOWED, c_val, 1, 0,
 			       0))
 		goto _fail_;
 
 	c_val[0] = G_SELF_CTS_PROT;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ERP_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_ENABLE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ENABLE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = HT_MIXED_MODE;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_OPERATING_MODE, c_val, 1, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OPERATING_MODE, c_val, 1, 0,
 			       0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_TXOP_PROT_DISABLE, c_val, 1, 0,
 			       0))
 		goto _fail_;
 
 	memcpy(c_val, mac_add, 6);
 
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_MAC_ADDR, c_val, 6, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_MAC_ADDR, c_val, 6, 0, 0))
 		goto _fail_;
 
 	c_val[0] = DETECT_PROTECT_REPORT;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OBSS_NONHT_DETECTION, c_val, 1,
 			       0, 0))
 		goto _fail_;
 
 	c_val[0] = RTS_CTS_NONHT_PROT;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_HT_PROT_TYPE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 0;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_RIFS_PROT_ENABLE, c_val, 1, 0,
 			       0))
 		goto _fail_;
 
 	c_val[0] = MIMO_MODE;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_SMPS_MODE, c_val, 1, 0, 0))
 		goto _fail_;
 
 	c_val[0] = 7;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_CURRENT_TX_MCS, c_val, 1, 0,
 			       0))
 		goto _fail_;
 
 	c_val[0] = 1;
-	if (!wilc_wlan_cfg_set(wilc, 0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1,
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_IMMEDIATE_BA_ENABLED, c_val, 1,
 			       1, 1))
 		goto _fail_;
 
@@ -927,7 +927,7 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif)
 			goto _fail_irq_enable_;
 		}
 
-		if (wilc_wlan_cfg_get(wl, 1, WID_FIRMWARE_VERSION, 1, 0)) {
+		if (wilc_wlan_cfg_get(vif, 1, WID_FIRMWARE_VERSION, 1, 0)) {
 			int size;
 			char Firmware_ver[20];
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 265ddfe..392ef16 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -113,9 +113,11 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 	up(&wilc->txq_event);
 }
 
-static int wilc_wlan_txq_add_to_head(struct wilc *wilc, struct txq_entry_t *tqe)
+static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif, struct txq_entry_t *tqe)
 {
 	unsigned long flags;
+	struct wilc *wilc = vif->wilc;
+
 	if (wilc_lock_timeout(wilc, &wilc->txq_add_to_head_cs,
 				    CFG_PKTS_TIMEOUT))
 		return -1;
@@ -134,12 +136,12 @@ static int wilc_wlan_txq_add_to_head(struct wilc *wilc, struct txq_entry_t *tqe)
 		wilc->txq_head = tqe;
 	}
 	wilc->txq_entries += 1;
-	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", wilc->txq_entries);
+	netdev_dbg(vif->ndev, "Number of entries in TxQ = %d\n", wilc->txq_entries);
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	up(&wilc->txq_add_to_head_cs);
 	up(&wilc->txq_event);
-	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
+	netdev_dbg(vif->ndev, "Wake up the txq_handler\n");
 
 	return 0;
 }
@@ -351,20 +353,22 @@ static bool is_tcp_ack_filter_enabled(void)
 	return enabled;
 }
 
-static int wilc_wlan_txq_add_cfg_pkt(struct wilc *wilc, u8 *buffer, u32 buffer_size)
+static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
+				     u32 buffer_size)
 {
 	struct txq_entry_t *tqe;
+	struct wilc *wilc = vif->wilc;
 
-	PRINT_D(TX_DBG, "Adding config packet ...\n");
+	netdev_dbg(vif->ndev, "Adding config packet ...\n");
 	if (wilc->quit) {
-		PRINT_D(TX_DBG, "Return due to clear function\n");
+		netdev_dbg(vif->ndev, "Return due to clear function\n");
 		up(&wilc->cfg_event);
 		return 0;
 	}
 
 	tqe = kmalloc(sizeof(*tqe), GFP_ATOMIC);
 	if (!tqe) {
-		PRINT_ER("Failed to allocate memory\n");
+		netdev_err(vif->ndev, "Failed to allocate memory\n");
 		return 0;
 	}
 
@@ -374,9 +378,9 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc *wilc, u8 *buffer, u32 buffer_s
 	tqe->tx_complete_func = NULL;
 	tqe->priv = NULL;
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
-	PRINT_D(TX_DBG, "Adding the config packet at the Queue tail\n");
+	netdev_dbg(vif->ndev, "Adding the config packet at the Queue tail\n");
 
-	if (wilc_wlan_txq_add_to_head(wilc, tqe))
+	if (wilc_wlan_txq_add_to_head(vif, tqe))
 		return 0;
 	return 1;
 }
@@ -1326,8 +1330,10 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	wilc->hif_func->hif_deinit(NULL);
 }
 
-static int wilc_wlan_cfg_commit(struct wilc *wilc, int type, u32 drv_handler)
+static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
+				u32 drv_handler)
 {
+	struct wilc *wilc = vif->wilc;
 	struct wilc_cfg_frame *cfg = &wilc->cfg_frame;
 	int total_len = wilc->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
 	int seq_no = wilc->cfg_seq_no % 256;
@@ -1346,17 +1352,18 @@ static int wilc_wlan_cfg_commit(struct wilc *wilc, int type, u32 drv_handler)
 	cfg->wid_header[7] = (u8)(driver_handler >> 24);
 	wilc->cfg_seq_no = seq_no;
 
-	if (!wilc_wlan_txq_add_cfg_pkt(wilc, &cfg->wid_header[0], total_len))
+	if (!wilc_wlan_txq_add_cfg_pkt(vif, &cfg->wid_header[0], total_len))
 		return -1;
 
 	return 0;
 }
 
-int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
+int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u32 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler)
 {
 	u32 offset;
 	int ret_size;
+	struct wilc *wilc = vif->wilc;
 
 	if (wilc->cfg_frame_in_use)
 		return 0;
@@ -1371,17 +1378,18 @@ int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
 	wilc->cfg_frame_offset = offset;
 
 	if (commit) {
-		PRINT_D(TX_DBG, "[WILC]PACKET Commit with sequence number %d\n",
-			wilc->cfg_seq_no);
-		PRINT_D(RX_DBG, "Processing cfg_set()\n");
+		netdev_dbg(vif->ndev,
+			   "[WILC]PACKET Commit with sequence number %d\n",
+			   wilc->cfg_seq_no);
+		netdev_dbg(vif->ndev, "Processing cfg_set()\n");
 		wilc->cfg_frame_in_use = 1;
 
-		if (wilc_wlan_cfg_commit(wilc, WILC_CFG_SET, drv_handler))
+		if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
 			ret_size = 0;
 
 		if (wilc_lock_timeout(wilc, &wilc->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
-			PRINT_D(TX_DBG, "Set Timed Out\n");
+			netdev_dbg(vif->ndev, "Set Timed Out\n");
 			ret_size = 0;
 		}
 		wilc->cfg_frame_in_use = 0;
@@ -1392,11 +1400,12 @@ int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
 	return ret_size;
 }
 
-int wilc_wlan_cfg_get(struct wilc *wilc, int start, u32 wid, int commit,
+int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u32 wid, int commit,
 		      u32 drv_handler)
 {
 	u32 offset;
 	int ret_size;
+	struct wilc *wilc = vif->wilc;
 
 	if (wilc->cfg_frame_in_use)
 		return 0;
@@ -1413,15 +1422,15 @@ int wilc_wlan_cfg_get(struct wilc *wilc, int start, u32 wid, int commit,
 	if (commit) {
 		wilc->cfg_frame_in_use = 1;
 
-		if (wilc_wlan_cfg_commit(wilc, WILC_CFG_QUERY, drv_handler))
+		if (wilc_wlan_cfg_commit(vif, WILC_CFG_QUERY, drv_handler))
 			ret_size = 0;
 
 		if (wilc_lock_timeout(wilc, &wilc->cfg_event,
 					    CFG_PKTS_TIMEOUT)) {
-			PRINT_D(TX_DBG, "Get Timed Out\n");
+			netdev_dbg(vif->ndev, "Get Timed Out\n");
 			ret_size = 0;
 		}
-		PRINT_D(GENERIC_DBG, "[WILC]Get Response received\n");
+		netdev_dbg(vif->ndev, "[WILC]Get Response received\n");
 		wilc->cfg_frame_in_use = 0;
 		wilc->cfg_frame_offset = 0;
 		wilc->cfg_seq_no += 1;
@@ -1439,14 +1448,14 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 	return ret;
 }
 
-s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
+s32 wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 			 u32 count, u32 drv)
 {
 	s32 counter = 0, ret = 0;
 
 	if (mode == GET_CFG) {
 		for (counter = 0; counter < count; counter++) {
-			if (!wilc_wlan_cfg_get(wilc, !counter,
+			if (!wilc_wlan_cfg_get(vif, !counter,
 					       wids[counter].id,
 					       (counter == count - 1),
 					       drv)) {
@@ -1463,7 +1472,7 @@ s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 		}
 	} else if (mode == SET_CFG) {
 		for (counter = 0; counter < count; counter++) {
-			if (!wilc_wlan_cfg_set(wilc, !counter,
+			if (!wilc_wlan_cfg_set(vif, !counter,
 					       wids[counter].id,
 					       wids[counter].val,
 					       wids[counter].size,
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 3ebaf0e..e913ae7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -268,6 +268,7 @@ struct wilc_cfg_rsp {
 };
 
 struct wilc;
+struct wilc_vif;
 
 int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_size);
 int wilc_wlan_start(struct wilc *);
@@ -277,9 +278,9 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count);
 void wilc_handle_isr(struct wilc *wilc);
 void wilc_wlan_cleanup(struct net_device *dev);
-int wilc_wlan_cfg_set(struct wilc *wilc, int start, u32 wid, u8 *buffer,
+int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u32 wid, u8 *buffer,
 		      u32 buffer_size, int commit, u32 drv_handler);
-int wilc_wlan_cfg_get(struct wilc *wilc, int start, u32 wid, int commit,
+int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u32 wid, int commit,
 		      u32 drv_handler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
@@ -299,6 +300,6 @@ void host_sleep_notify(struct wilc *wilc);
 extern bool wilc_enable_ps;
 void chip_allow_sleep(struct wilc *wilc);
 void chip_wakeup(struct wilc *wilc);
-s32 wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
+s32 wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 			 u32 count, u32 drv);
 #endif
-- 
1.9.1

