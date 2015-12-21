Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11798 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbbLUFTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:19:01 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 39/46] staging: wilc1000: use vif index to communicate with wilc device
Date: Mon, 21 Dec 2015 14:18:43 +0900
Message-ID: <1450675130-17866-40-git-send-email-glen.lee@atmel.com> (sfid-20151221_063104_483979_805B7B13)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We now have vif index in all functions related with host interface thread.
wilc_get_vif_idx and wilc_get_vif_from_idx are added to get id and vif
respectively.
Relace get_id_from_handler with wilc_get_vif_idx and get_handler_from_id with
wilc_get_vif_from_idx. Remove unused function get_handler_from_id as well.
We get vif where wilc_get_vif_from_idx is called, so pass vif to msg.vif.

There are two get_id_from_handler left. They will be removed in later patch.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 127 +++++++++++++++++++-----------
 1 file changed, 81 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 123887cf..0a9060c9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -309,11 +309,28 @@ static int get_id_from_handler(struct host_if_drv *handler)
 	return 0;
 }
 
-static struct host_if_drv *get_handler_from_id(int id)
+/* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
+ * special purpose in wilc device, so we add 1 to the index to starts from 1.
+ * As a result, the returned index will be 1 to NUM_CONCURRENT_IFC.
+ */
+static int wilc_get_vif_idx(struct wilc_vif *vif)
 {
-	if (id <= 0 || id >= ARRAY_SIZE(wfidrv_list))
+	return vif->u8IfIdx + 1;
+}
+
+/* We need to minus 1 from idx which is from wilc device to get real index
+ * of wilc->vif[], because we add 1 when pass to wilc device in the function
+ * wilc_get_vif_idx.
+ * As a result, the index should be between 0 and NUM_CONCURRENT_IFC -1.
+ */
+static struct wilc_vif *wilc_get_vif_from_idx(struct wilc *wilc, int idx)
+{
+	int index = idx - 1;
+
+	if (index < 0 || index >= NUM_CONCURRENT_IFC)
 		return NULL;
-	return wfidrv_list[id];
+
+	return wilc->vif[index];
 }
 
 static s32 handle_set_channel(struct wilc_vif *vif,
@@ -331,7 +348,7 @@ static s32 handle_set_channel(struct wilc_vif *vif,
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to set channel\n");
@@ -380,7 +397,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 	wid.size = sizeof(u32);
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
 		up(&hif_sema_driver);
@@ -418,7 +435,7 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	wid.size = IP_ALEN;
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	host_int_get_ipaddress(vif, hif_drv, firmware_ip_addr, idx);
 
@@ -444,7 +461,7 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	wid.size = IP_ALEN;
 
 	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
 
@@ -488,7 +505,7 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
 		result = -EFAULT;
@@ -511,7 +528,7 @@ static s32 handle_get_mac_address(struct wilc_vif *vif,
 	wid.size = ETH_ALEN;
 
 	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to get mac address\n");
@@ -807,7 +824,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 	}
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, wid_list,
-				      wid_cnt, get_id_from_handler(hif_drv));
+				      wid_cnt, wilc_get_vif_idx(vif));
 
 	if (result)
 		PRINT_ER("Error in setting CFG params\n");
@@ -932,7 +949,7 @@ static s32 Handle_Scan(struct wilc_vif *vif,
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
 				      u32WidsCount,
-				      get_id_from_handler(hif_drv));
+				      wilc_get_vif_idx(vif));
 
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -977,7 +994,7 @@ static s32 Handle_ScanDone(struct wilc_vif *vif,
 		wid.size = sizeof(char);
 
 		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-					 get_id_from_handler(hif_drv));
+					 wilc_get_vif_idx(vif));
 
 		if (result) {
 			PRINT_ER("Failed to set abort running scan\n");
@@ -1234,7 +1251,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
 				      u32WidsCount,
-				      get_id_from_handler(hif_drv));
+				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
 		result = -EFAULT;
@@ -1395,7 +1412,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
@@ -1790,7 +1807,7 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
 						strWIDList, 4,
-						get_id_from_handler(hif_drv));
+						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
@@ -1812,7 +1829,7 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
 						&wid, 1,
-						get_id_from_handler(hif_drv));
+						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
@@ -1825,7 +1842,7 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
 						&wid, 1,
-						get_id_from_handler(hif_drv));
+						wilc_get_vif_idx(vif));
 		} else {
 			wid.id = (u16)WID_KEY_ID;
 			wid.type = WID_CHAR;
@@ -1836,7 +1853,7 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
 						&wid, 1,
-						get_id_from_handler(hif_drv));
+						wilc_get_vif_idx(vif));
 		}
 		up(&hif_drv->sem_test_key_block);
 		break;
@@ -1870,7 +1887,7 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
 						strWIDList, 2,
-						get_id_from_handler(hif_drv));
+						wilc_get_vif_idx(vif));
 
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1902,7 +1919,7 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
 						&wid, 1,
-						get_id_from_handler(hif_drv));
+						wilc_get_vif_idx(vif));
 
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1942,7 +1959,7 @@ _WPARxGtk_end_case_:
 
 			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
 						strWIDList, 2,
-						get_id_from_handler(hif_drv));
+						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
@@ -1965,7 +1982,7 @@ _WPARxGtk_end_case_:
 
 			result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG,
 						&wid, 1,
-						get_id_from_handler(hif_drv));
+						wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
 		}
@@ -2000,7 +2017,7 @@ _WPAPtk_end_case_:
 		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-					 get_id_from_handler(hif_drv));
+					 wilc_get_vif_idx(vif));
 
 		kfree(pu8keybuf);
 		break;
@@ -2033,7 +2050,7 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 	eth_zero_addr(wilc_connected_ssid);
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -2124,7 +2141,7 @@ static s32 Handle_GetChnl(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
 	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to get channel number\n");
@@ -2149,7 +2166,7 @@ static void Handle_GetRssi(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
 	result = wilc_send_config_pkt(vif->hif_drv->wilc, GET_CFG, &wid, 1,
-				 get_id_from_handler(vif->hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
 		result = -EFAULT;
@@ -2174,7 +2191,7 @@ static void Handle_GetLinkspeed(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
 	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		result = -EFAULT;
@@ -2222,7 +2239,7 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 
 	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, strWIDList,
 				u32WidsCount,
-				get_id_from_handler(hif_drv));
+				wilc_get_vif_idx(vif));
 
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -2250,7 +2267,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -2263,7 +2280,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 	wid.size = sizeof(u32);
 
 	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to get incative time\n");
@@ -2323,7 +2340,7 @@ static void Handle_AddBeacon(struct wilc_vif *vif,
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
 
@@ -2353,7 +2370,7 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
 }
@@ -2427,7 +2444,7 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2470,7 +2487,7 @@ static void Handle_DelAllSta(struct wilc_vif *vif,
 	}
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2503,7 +2520,7 @@ static void Handle_DelStation(struct wilc_vif *vif,
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2532,7 +2549,7 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
 
@@ -2594,7 +2611,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
 
@@ -2643,7 +2660,7 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 	wid.size = sizeof(u16) + 2;
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
 		result = -EINVAL;
@@ -2678,7 +2695,7 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
 		result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-					 get_id_from_handler(hif_drv));
+					 wilc_get_vif_idx(vif));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -2737,7 +2754,7 @@ static void Handle_PowerManagement(struct wilc_vif *vif,
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
 }
@@ -2775,7 +2792,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
@@ -2812,7 +2829,7 @@ static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 	*ptr++ = 32;
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -3565,7 +3582,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 	wid.size = u32MaxAssocRespInfoLen;
 
 	result = wilc_send_config_pkt(hif_drv->wilc, GET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
+				 wilc_get_vif_idx(vif));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
 		PRINT_ER("Failed to send association response config packet\n");
@@ -4035,9 +4052,13 @@ void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	struct host_if_msg msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
+	struct wilc_vif *vif;
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	hif_drv = get_handler_from_id(id);
+	vif = wilc_get_vif_from_idx(wilc, id);
+	if (!vif)
+		return;
+	hif_drv = vif->hif_drv;
 
 	if (!hif_drv || hif_drv == terminated_handle)	{
 		PRINT_ER("NetworkInfo received but driver not init[%p]\n", hif_drv);
@@ -4048,6 +4069,7 @@ void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
 
 	msg.id = HOST_IF_MSG_RCVD_NTWRK_INFO;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	msg.body.net_info.len = u32Length;
 	msg.body.net_info.buffer = kmalloc(u32Length, GFP_KERNEL);
@@ -4065,11 +4087,18 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 	struct host_if_msg msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
+	struct wilc_vif *vif;
 
 	down(&hif_sema_deinit);
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	hif_drv = get_handler_from_id(id);
+	vif = wilc_get_vif_from_idx(wilc, id);
+	if (!vif) {
+		up(&hif_sema_deinit);
+		return;
+	}
+
+	hif_drv = vif->hif_drv;
 	PRINT_D(HOSTINF_DBG, "General asynchronous info packet received\n");
 
 	if (!hif_drv || hif_drv == terminated_handle) {
@@ -4088,6 +4117,7 @@ void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *pu8Buffer,
 
 	msg.id = HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO;
 	msg.drv = hif_drv;
+	msg.vif = vif;
 
 	msg.body.async_info.len = u32Length;
 	msg.body.async_info.buffer = kmalloc(u32Length, GFP_KERNEL);
@@ -4107,9 +4137,13 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 	struct host_if_msg msg;
 	int id;
 	struct host_if_drv *hif_drv = NULL;
+	struct wilc_vif *vif;
 
 	id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
-	hif_drv = get_handler_from_id(id);
+	vif = wilc_get_vif_from_idx(wilc, id);
+	if (!vif)
+		return;
+	hif_drv = vif->hif_drv;
 
 	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", hif_drv);
 
@@ -4121,6 +4155,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 
 		msg.id = HOST_IF_MSG_RCVD_SCAN_COMPLETE;
 		msg.drv = hif_drv;
+		msg.vif = vif;
 
 		result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 		if (result)
-- 
1.9.1

