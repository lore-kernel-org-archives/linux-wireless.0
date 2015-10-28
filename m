Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:41621 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbbJ1G6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 02:58:25 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/80] staging: wilc1000: rename variable strWID
Date: Wed, 28 Oct 2015 15:59:28 +0900
Message-ID: <1446015640-29398-8-git-send-email-glen.lee@atmel.com> (sfid-20151028_075828_975750_D4B143E9)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable strWID to wid
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 595 +++++++++++++++---------------
 1 file changed, 297 insertions(+), 298 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a10ee17..eee53b9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -328,16 +328,16 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 			     struct channel_attr *pstrHostIFSetChan)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_CURRENT_CHANNEL;
-	strWID.type = WID_CHAR;
-	strWID.val = (char *)&pstrHostIFSetChan->set_ch;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_CURRENT_CHANNEL;
+	wid.type = WID_CHAR;
+	wid.val = (char *)&pstrHostIFSetChan->set_ch;
+	wid.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -352,14 +352,14 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 				   struct drv_handler *pstrHostIfSetDrvHandler)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_SET_DRV_HANDLER;
-	strWID.type = WID_INT;
-	strWID.val = (s8 *)&pstrHostIfSetDrvHandler->u32Address;
-	strWID.size = sizeof(u32);
+	wid.id = (u16)WID_SET_DRV_HANDLER;
+	wid.type = WID_INT;
+	wid.val = (s8 *)&pstrHostIfSetDrvHandler->u32Address;
+	wid.size = sizeof(u32);
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 pstrHostIfSetDrvHandler->u32Address);
 
 	if (!hif_drv)
@@ -377,14 +377,14 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 				   struct op_mode *pstrHostIfSetOperationMode)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_SET_OPERATION_MODE;
-	strWID.type = WID_INT;
-	strWID.val = (s8 *)&pstrHostIfSetOperationMode->u32Mode;
-	strWID.size = sizeof(u32);
+	wid.id = (u16)WID_SET_OPERATION_MODE;
+	wid.type = WID_INT;
+	wid.val = (s8 *)&pstrHostIfSetOperationMode->u32Mode;
+	wid.size = sizeof(u32);
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if ((pstrHostIfSetOperationMode->u32Mode) == IDLE_MODE)
@@ -401,7 +401,7 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	char firmwareIPAddress[4] = {0};
 
 	if (pu8IPAddr[0] < 192)
@@ -411,12 +411,12 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 
 	memcpy(set_ip[idx], pu8IPAddr, IP_ALEN);
 
-	strWID.id = (u16)WID_IP_ADDRESS;
-	strWID.type = WID_STR;
-	strWID.val = (u8 *)pu8IPAddr;
-	strWID.size = IP_ALEN;
+	wid.id = (u16)WID_IP_ADDRESS;
+	wid.type = WID_STR;
+	wid.val = (u8 *)pu8IPAddr;
+	wid.size = IP_ALEN;
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	host_int_get_ipaddress(hif_drv, firmwareIPAddress, idx);
@@ -434,21 +434,21 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_IP_ADDRESS;
-	strWID.type = WID_STR;
-	strWID.val = kmalloc(IP_ALEN, GFP_KERNEL);
-	strWID.size = IP_ALEN;
+	wid.id = (u16)WID_IP_ADDRESS;
+	wid.type = WID_STR;
+	wid.val = kmalloc(IP_ALEN, GFP_KERNEL);
+	wid.size = IP_ALEN;
 
-	result = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
-	PRINT_INFO(HOSTINF_DBG, "%pI4\n", strWID.val);
+	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
 
-	memcpy(get_ip[idx], strWID.val, IP_ALEN);
+	memcpy(get_ip[idx], wid.val, IP_ALEN);
 
-	kfree(strWID.val);
+	kfree(wid.val);
 
 	if (memcmp(get_ip[idx], set_ip[idx], IP_ALEN) != 0)
 		host_int_setup_ipaddress(hif_drv, set_ip[idx], idx);
@@ -469,7 +469,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 				struct set_mac_addr *pstrHostIfSetMacAddress)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
 
 	if (!mac_buf) {
@@ -478,13 +478,13 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	}
 	memcpy(mac_buf, pstrHostIfSetMacAddress->u8MacAddress, ETH_ALEN);
 
-	strWID.id = (u16)WID_MAC_ADDR;
-	strWID.type = WID_STR;
-	strWID.val = mac_buf;
-	strWID.size = ETH_ALEN;
-	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.val);
+	wid.id = (u16)WID_MAC_ADDR;
+	wid.type = WID_STR;
+	wid.val = mac_buf;
+	wid.size = ETH_ALEN;
+	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
@@ -499,14 +499,14 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 				struct get_mac_addr *pstrHostIfGetMacAddress)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_MAC_ADDR;
-	strWID.type = WID_STR;
-	strWID.val = pstrHostIfGetMacAddress->u8MacAddress;
-	strWID.size = ETH_ALEN;
+	wid.id = (u16)WID_MAC_ADDR;
+	wid.type = WID_STR;
+	wid.val = pstrHostIfGetMacAddress->u8MacAddress;
+	wid.size = ETH_ALEN;
 
-	result = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -941,19 +941,19 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	u8 u8abort_running_scan;
-	struct wid strWID;
+	struct wid wid;
 
 	PRINT_D(HOSTINF_DBG, "in Handle_ScanDone()\n");
 
 	if (enuEvent == SCAN_EVENT_ABORTED) {
 		PRINT_D(GENERIC_DBG, "Abort running scan\n");
 		u8abort_running_scan = 1;
-		strWID.id = (u16)WID_ABORT_RUNNING_SCAN;
-		strWID.type = WID_CHAR;
-		strWID.val = (s8 *)&u8abort_running_scan;
-		strWID.size = sizeof(char);
+		wid.id = (u16)WID_ABORT_RUNNING_SCAN;
+		wid.type = WID_CHAR;
+		wid.val = (s8 *)&u8abort_running_scan;
+		wid.size = sizeof(char);
 
-		result = send_config_pkt(SET_CFG, &strWID, 1,
+		result = send_config_pkt(SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 
 		if (result) {
@@ -1317,7 +1317,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
 	tstrConnectInfo strConnectInfo;
-	struct wid strWID;
+	struct wid wid;
 	u16 u16DummyReasonCode = 0;
 
 	if (!hif_drv) {
@@ -1357,14 +1357,14 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 		PRINT_ER("Connect callback function pointer is NULL\n");
 	}
 
-	strWID.id = (u16)WID_DISCONNECT;
-	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)&u16DummyReasonCode;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_DISCONNECT;
+	wid.type = WID_CHAR;
+	wid.val = (s8 *)&u16DummyReasonCode;
+	wid.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -1698,7 +1698,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	struct wid strWIDList[5];
 	u8 i;
 	u8 *pu8keybuf;
@@ -1761,34 +1761,34 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			       pstrHostIFkeyAttr->attr.wep.key_len);
 			kfree(pstrHostIFkeyAttr->attr.wep.key);
 
-			strWID.id = (u16)WID_ADD_WEP_KEY;
-			strWID.type = WID_STR;
-			strWID.val = (s8 *)pu8keybuf;
-			strWID.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
+			wid.id = (u16)WID_ADD_WEP_KEY;
+			wid.type = WID_STR;
+			wid.val = (s8 *)pu8keybuf;
+			wid.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
-			result = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
-			strWID.id = (u16)WID_REMOVE_WEP_KEY;
-			strWID.type = WID_STR;
+			wid.id = (u16)WID_REMOVE_WEP_KEY;
+			wid.type = WID_STR;
 
 			s8idxarray[0] = (s8)pstrHostIFkeyAttr->attr.wep.index;
-			strWID.val = s8idxarray;
-			strWID.size = 1;
+			wid.val = s8idxarray;
+			wid.size = 1;
 
-			result = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 		} else {
-			strWID.id = (u16)WID_KEY_ID;
-			strWID.type = WID_CHAR;
-			strWID.val = (s8 *)&pstrHostIFkeyAttr->attr.wep.index;
-			strWID.size = sizeof(char);
+			wid.id = (u16)WID_KEY_ID;
+			wid.type = WID_CHAR;
+			wid.val = (s8 *)&pstrHostIFkeyAttr->attr.wep.index;
+			wid.size = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			result = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 		}
 		up(&hif_drv->hSemTestKeyBlock);
@@ -1849,12 +1849,12 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
 			       pstrHostIFkeyAttr->attr.wpa.key_len);
 
-			strWID.id = (u16)WID_ADD_RX_GTK;
-			strWID.type = WID_STR;
-			strWID.val = (s8 *)pu8keybuf;
-			strWID.size = RX_MIC_KEY_MSG_LEN;
+			wid.id = (u16)WID_ADD_RX_GTK;
+			wid.type = WID_STR;
+			wid.val = (s8 *)pu8keybuf;
+			wid.size = RX_MIC_KEY_MSG_LEN;
 
-			result = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
@@ -1911,12 +1911,12 @@ _WPARxGtk_end_case_:
 			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->attr.wpa.key,
 			       pstrHostIFkeyAttr->attr.wpa.key_len);
 
-			strWID.id = (u16)WID_ADD_PTK;
-			strWID.type = WID_STR;
-			strWID.val = (s8 *)pu8keybuf;
-			strWID.size = PTK_KEY_MSG_LEN;
+			wid.id = (u16)WID_ADD_PTK;
+			wid.type = WID_STR;
+			wid.val = (s8 *)pu8keybuf;
+			wid.size = PTK_KEY_MSG_LEN;
 
-			result = send_config_pkt(SET_CFG, &strWID, 1,
+			result = send_config_pkt(SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->hSemTestKeyBlock);
@@ -1946,12 +1946,12 @@ _WPAPtk_end_case_:
 			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
 		}
 
-		strWID.id = (u16)WID_PMKID_INFO;
-		strWID.type = WID_STR;
-		strWID.val = (s8 *)pu8keybuf;
-		strWID.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
+		wid.id = (u16)WID_PMKID_INFO;
+		wid.type = WID_STR;
+		wid.val = (s8 *)pu8keybuf;
+		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		result = send_config_pkt(SET_CFG, &strWID, 1,
+		result = send_config_pkt(SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 
 		kfree(pu8keybuf);
@@ -1966,15 +1966,15 @@ _WPAPtk_end_case_:
 
 static void Handle_Disconnect(struct host_if_drv *hif_drv)
 {
-	struct wid strWID;
+	struct wid wid;
 
 	s32 result = 0;
 	u16 u16DummyReasonCode = 0;
 
-	strWID.id = (u16)WID_DISCONNECT;
-	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)&u16DummyReasonCode;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_DISCONNECT;
+	wid.type = WID_CHAR;
+	wid.val = (s8 *)&u16DummyReasonCode;
+	wid.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
@@ -1983,7 +1983,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 	eth_zero_addr(u8ConnectedSSID);
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2056,16 +2056,16 @@ void resolve_disconnect_aberration(struct host_if_drv *hif_drv)
 static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_CURRENT_CHANNEL;
-	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)&ch_no;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_CURRENT_CHANNEL;
+	wid.type = WID_CHAR;
+	wid.val = (s8 *)&ch_no;
+	wid.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	result = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2081,16 +2081,16 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 static void Handle_GetRssi(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_RSSI;
-	strWID.type = WID_CHAR;
-	strWID.val = &rssi;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_RSSI;
+	wid.type = WID_CHAR;
+	wid.val = &rssi;
+	wid.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	result = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
@@ -2103,18 +2103,18 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
 	link_speed = 0;
 
-	strWID.id = (u16)WID_LINKSPEED;
-	strWID.type = WID_CHAR;
-	strWID.val = &link_speed;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_LINKSPEED;
+	wid.type = WID_CHAR;
+	wid.val = &link_speed;
+	wid.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	result = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
@@ -2174,19 +2174,19 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	u8 *stamac;
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
-	strWID.type = WID_STR;
-	strWID.size = ETH_ALEN;
-	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
+	wid.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
+	wid.type = WID_STR;
+	wid.size = ETH_ALEN;
+	wid.val = kmalloc(wid.size, GFP_KERNEL);
 
-	stamac = strWID.val;
+	stamac = wid.val;
 	memcpy(stamac, strHostIfStaInactiveT->mac, ETH_ALEN);
 
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2194,12 +2194,12 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 		return -EFAULT;
 	}
 
-	strWID.id = (u16)WID_GET_INACTIVE_TIME;
-	strWID.type = WID_INT;
-	strWID.val = (s8 *)&inactive_time;
-	strWID.size = sizeof(u32);
+	wid.id = (u16)WID_GET_INACTIVE_TIME;
+	wid.type = WID_INT;
+	wid.val = (s8 *)&inactive_time;
+	wid.size = sizeof(u32);
 
-	result = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2218,19 +2218,19 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 			     struct beacon_attr *pstrSetBeaconParam)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	u8 *pu8CurrByte;
 
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
-	strWID.id = (u16)WID_ADD_BEACON;
-	strWID.type = WID_BIN;
-	strWID.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->tail_len + 16;
-	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (!strWID.val)
+	wid.id = (u16)WID_ADD_BEACON;
+	wid.type = WID_BIN;
+	wid.size = pstrSetBeaconParam->head_len + pstrSetBeaconParam->tail_len + 16;
+	wid.val = kmalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.val;
+	pu8CurrByte = wid.val;
 	*pu8CurrByte++ = (pstrSetBeaconParam->interval & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->interval >> 8) & 0xFF);
 	*pu8CurrByte++ = ((pstrSetBeaconParam->interval >> 16) & 0xFF);
@@ -2258,13 +2258,13 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.val);
+	kfree(wid.val);
 	kfree(pstrSetBeaconParam->head);
 	kfree(pstrSetBeaconParam->tail);
 }
@@ -2272,22 +2272,22 @@ ERRORHANDLER:
 static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	u8 *pu8CurrByte;
 
-	strWID.id = (u16)WID_DEL_BEACON;
-	strWID.type = WID_CHAR;
-	strWID.size = sizeof(char);
-	strWID.val = &del_beacon;
+	wid.id = (u16)WID_DEL_BEACON;
+	wid.type = WID_CHAR;
+	wid.size = sizeof(char);
+	wid.val = &del_beacon;
 
-	if (!strWID.val)
+	if (!wid.val)
 		return;
 
-	pu8CurrByte = strWID.val;
+	pu8CurrByte = wid.val;
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -2343,52 +2343,51 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 			      struct add_sta_param *pstrStationParam)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	u8 *pu8CurrByte;
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
-	strWID.id = (u16)WID_ADD_STA;
-	strWID.type = WID_BIN;
-	strWID.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
+	wid.id = (u16)WID_ADD_STA;
+	wid.type = WID_BIN;
+	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
-	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (!strWID.val)
+	wid.val = kmalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.val;
+	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
-	kfree(strWID.val);
+	kfree(wid.val);
 }
 
 static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 			     struct del_all_sta *pstrDelAllStaParam)
 {
 	s32 result = 0;
-
-	struct wid strWID;
+	struct wid wid;
 	u8 *pu8CurrByte;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
 
-	strWID.id = (u16)WID_DEL_ALL_STA;
-	strWID.type = WID_STR;
-	strWID.size = (pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1;
+	wid.id = (u16)WID_DEL_ALL_STA;
+	wid.type = WID_STR;
+	wid.size = (pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1;
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.val = kmalloc((pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
-	if (!strWID.val)
+	wid.val = kmalloc((pstrDelAllStaParam->assoc_sta * ETH_ALEN) + 1, GFP_KERNEL);
+	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.val;
+	pu8CurrByte = wid.val;
 
 	*(pu8CurrByte++) = pstrDelAllStaParam->assoc_sta;
 
@@ -2401,13 +2400,13 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 		pu8CurrByte += ETH_ALEN;
 	}
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.val);
+	kfree(wid.val);
 
 	up(&hif_sema_wait_response);
 }
@@ -2416,59 +2415,59 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 			      struct del_sta *pstrDelStaParam)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	u8 *pu8CurrByte;
 
-	strWID.id = (u16)WID_REMOVE_STA;
-	strWID.type = WID_BIN;
-	strWID.size = ETH_ALEN;
+	wid.id = (u16)WID_REMOVE_STA;
+	wid.type = WID_BIN;
+	wid.size = ETH_ALEN;
 
 	PRINT_D(HOSTINF_DBG, "Handling delete station\n");
 
-	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (!strWID.val)
+	wid.val = kmalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.val;
+	pu8CurrByte = wid.val;
 
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.val);
+	kfree(wid.val);
 }
 
 static void Handle_EditStation(struct host_if_drv *hif_drv,
 			       struct add_sta_param *pstrStationParam)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	u8 *pu8CurrByte;
 
-	strWID.id = (u16)WID_EDIT_STA;
-	strWID.type = WID_BIN;
-	strWID.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
+	wid.id = (u16)WID_EDIT_STA;
+	wid.type = WID_BIN;
+	wid.size = WILC_ADD_STA_LENGTH + pstrStationParam->u8NumRates;
 
 	PRINT_D(HOSTINF_DBG, "Handling edit station\n");
-	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (!strWID.val)
+	wid.val = kmalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.val;
+	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
 
 ERRORHANDLER:
 	kfree(pstrStationParam->pu8Rates);
-	kfree(strWID.val);
+	kfree(wid.val);
 }
 
 static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
@@ -2476,7 +2475,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	u8 u8remain_on_chan_flag;
-	struct wid strWID;
+	struct wid wid;
 
 	if (!hif_drv->u8RemainOnChan_pendingreq) {
 		hif_drv->strHostIfRemainOnChan.pVoid = pstrHostIfRemainOnChan->pVoid;
@@ -2509,19 +2508,19 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Setting channel :%d\n", pstrHostIfRemainOnChan->u16Channel);
 
 	u8remain_on_chan_flag = true;
-	strWID.id = (u16)WID_REMAIN_ON_CHAN;
-	strWID.type = WID_STR;
-	strWID.size = 2;
-	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (!strWID.val) {
+	wid.id = (u16)WID_REMAIN_ON_CHAN;
+	wid.type = WID_STR;
+	wid.size = 2;
+	wid.val = kmalloc(wid.size, GFP_KERNEL);
+	if (!wid.val) {
 		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
 
-	strWID.val[0] = u8remain_on_chan_flag;
-	strWID.val[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
+	wid.val[0] = u8remain_on_chan_flag;
+	wid.val[1] = (s8)pstrHostIfRemainOnChan->u16Channel;
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
@@ -2548,27 +2547,27 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 				struct reg_frame *pstrHostIfRegisterFrame)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	u8 *pu8CurrByte;
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register Flag : %d FrameType: %d\n", pstrHostIfRegisterFrame->bReg, pstrHostIfRegisterFrame->u16FrameType);
 
-	strWID.id = (u16)WID_REGISTER_FRAME;
-	strWID.type = WID_STR;
-	strWID.val = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
-	if (!strWID.val)
+	wid.id = (u16)WID_REGISTER_FRAME;
+	wid.type = WID_STR;
+	wid.val = kmalloc(sizeof(u16) + 2, GFP_KERNEL);
+	if (!wid.val)
 		return -ENOMEM;
 
-	pu8CurrByte = strWID.val;
+	pu8CurrByte = wid.val;
 
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->bReg;
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->u8Regid;
 	memcpy(pu8CurrByte, &pstrHostIfRegisterFrame->u16FrameType,
 	       sizeof(u16));
 
-	strWID.size = sizeof(u16) + 2;
+	wid.size = sizeof(u16) + 2;
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
@@ -2582,25 +2581,25 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 				     struct remain_ch *pstrHostIfRemainOnChan)
 {
 	u8 u8remain_on_chan_flag;
-	struct wid strWID;
+	struct wid wid;
 	s32 result = 0;
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
 
 	if (P2P_LISTEN_STATE) {
 		u8remain_on_chan_flag = false;
-		strWID.id = (u16)WID_REMAIN_ON_CHAN;
-		strWID.type = WID_STR;
-		strWID.size = 2;
-		strWID.val = kmalloc(strWID.size, GFP_KERNEL);
+		wid.id = (u16)WID_REMAIN_ON_CHAN;
+		wid.type = WID_STR;
+		wid.size = 2;
+		wid.val = kmalloc(wid.size, GFP_KERNEL);
 
-		if (!strWID.val)
+		if (!wid.val)
 			PRINT_ER("Failed to allocate memory\n");
 
-		strWID.val[0] = u8remain_on_chan_flag;
-		strWID.val[1] = FALSE_FRMWR_CHANNEL;
+		wid.val[0] = u8remain_on_chan_flag;
+		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
-		result = send_config_pkt(SET_CFG, &strWID, 1,
+		result = send_config_pkt(SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
@@ -2643,22 +2642,22 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 				   struct power_mgmt_param *strPowerMgmtParam)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	s8 s8PowerMode;
 
-	strWID.id = (u16)WID_POWER_MANAGEMENT;
+	wid.id = (u16)WID_POWER_MANAGEMENT;
 
 	if (strPowerMgmtParam->enabled)
 		s8PowerMode = MIN_FAST_PS;
 	else
 		s8PowerMode = NO_POWERSAVE;
 	PRINT_D(HOSTINF_DBG, "Handling power mgmt to %d\n", s8PowerMode);
-	strWID.val = &s8PowerMode;
-	strWID.size = sizeof(char);
+	wid.val = &s8PowerMode;
+	wid.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
@@ -2668,19 +2667,19 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 				      struct set_multicast *strHostIfSetMulti)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	u8 *pu8CurrByte;
 
 	PRINT_D(HOSTINF_DBG, "Setup Multicast Filter\n");
 
-	strWID.id = (u16)WID_SETUP_MULTICAST_FILTER;
-	strWID.type = WID_BIN;
-	strWID.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->cnt) * ETH_ALEN);
-	strWID.val = kmalloc(strWID.size, GFP_KERNEL);
-	if (!strWID.val)
+	wid.id = (u16)WID_SETUP_MULTICAST_FILTER;
+	wid.type = WID_BIN;
+	wid.size = sizeof(struct set_multicast) + ((strHostIfSetMulti->cnt) * ETH_ALEN);
+	wid.val = kmalloc(wid.size, GFP_KERNEL);
+	if (!wid.val)
 		goto ERRORHANDLER;
 
-	pu8CurrByte = strWID.val;
+	pu8CurrByte = wid.val;
 	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
@@ -2694,20 +2693,20 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	if ((strHostIfSetMulti->cnt) > 0)
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
 ERRORHANDLER:
-	kfree(strWID.val);
+	kfree(wid.val);
 }
 
 static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 			       struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
 
@@ -2719,11 +2718,11 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->u16SessionTimeout,
 		strHostIfBASessionInfo->u8Ted);
 
-	strWID.id = (u16)WID_11E_P_ACTION_REQ;
-	strWID.type = WID_STR;
-	strWID.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
-	strWID.size = BLOCK_ACK_REQ_SIZE;
-	ptr = strWID.val;
+	wid.id = (u16)WID_11E_P_ACTION_REQ;
+	wid.type = WID_STR;
+	wid.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
+	wid.size = BLOCK_ACK_REQ_SIZE;
+	ptr = wid.val;
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x0;
@@ -2740,15 +2739,15 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 8;
 	*ptr++ = 0;
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
 
-	strWID.id = (u16)WID_11E_P_ACTION_REQ;
-	strWID.type = WID_STR;
-	strWID.size = 15;
-	ptr = strWID.val;
+	wid.id = (u16)WID_11E_P_ACTION_REQ;
+	wid.type = WID_STR;
+	wid.size = 15;
+	ptr = wid.val;
 	*ptr++ = 15;
 	*ptr++ = 7;
 	*ptr++ = 0x2;
@@ -2759,10 +2758,10 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	*ptr++ = 3;
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
-	kfree(strWID.val);
+	kfree(wid.val);
 
 	return result;
 }
@@ -2771,7 +2770,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 				     struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 	char *ptr = NULL;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
@@ -2780,11 +2779,11 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->au8Bssid[2],
 		strHostIfBASessionInfo->u8Ted);
 
-	strWID.id = (u16)WID_DEL_ALL_RX_BA;
-	strWID.type = WID_STR;
-	strWID.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
-	strWID.size = BLOCK_ACK_REQ_SIZE;
-	ptr = strWID.val;
+	wid.id = (u16)WID_DEL_ALL_RX_BA;
+	wid.type = WID_STR;
+	wid.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
+	wid.size = BLOCK_ACK_REQ_SIZE;
+	ptr = wid.val;
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x2;
@@ -2794,12 +2793,12 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 0;
 	*ptr++ = 32;
 
-	result = send_config_pkt(SET_CFG, &strWID, 1,
+	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
-	kfree(strWID.val);
+	kfree(wid.val);
 
 	up(&hif_sema_wait_response);
 
@@ -3043,12 +3042,12 @@ static void TimerCB_Connect(unsigned long arg)
 
 s32 host_int_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
 {
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_REMOVE_KEY;
-	strWID.type = WID_STR;
-	strWID.val = (s8 *)pu8StaAddress;
-	strWID.size = 6;
+	wid.id = (u16)WID_REMOVE_KEY;
+	wid.type = WID_STR;
+	wid.val = (s8 *)pu8StaAddress;
+	wid.size = 6;
 
 	return 0;
 }
@@ -3344,12 +3343,12 @@ s32 host_int_get_pmkid_info(struct host_if_drv *hif_drv,
 			    u8 *pu8PmkidInfoArray,
 			    u32 u32PmkidInfoLen)
 {
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_PMKID_INFO;
-	strWID.type = WID_STR;
-	strWID.size = u32PmkidInfoLen;
-	strWID.val = pu8PmkidInfoArray;
+	wid.id = (u16)WID_PMKID_INFO;
+	wid.type = WID_STR;
+	wid.size = u32PmkidInfoLen;
+	wid.val = pu8PmkidInfoArray;
 
 	return 0;
 }
@@ -3358,13 +3357,13 @@ s32 host_int_set_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 					 u8 *pu8PassPhrase,
 					 u8 u8Psklength)
 {
-	struct wid strWID;
+	struct wid wid;
 
 	if ((u8Psklength > 7) && (u8Psklength < 65)) {
-		strWID.id = (u16)WID_11I_PSK;
-		strWID.type = WID_STR;
-		strWID.val = pu8PassPhrase;
-		strWID.size = u8Psklength;
+		wid.id = (u16)WID_11I_PSK;
+		wid.type = WID_STR;
+		wid.val = pu8PassPhrase;
+		wid.size = u8Psklength;
 	}
 
 	return 0;
@@ -3413,36 +3412,36 @@ s32 host_int_set_MacAddress(struct host_if_drv *hif_drv, u8 *pu8MacAddress)
 s32 host_int_get_RSNAConfigPSKPassPhrase(struct host_if_drv *hif_drv,
 					 u8 *pu8PassPhrase, u8 u8Psklength)
 {
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_11I_PSK;
-	strWID.type = WID_STR;
-	strWID.size = u8Psklength;
-	strWID.val = pu8PassPhrase;
+	wid.id = (u16)WID_11I_PSK;
+	wid.type = WID_STR;
+	wid.size = u8Psklength;
+	wid.val = pu8PassPhrase;
 
 	return 0;
 }
 
 s32 host_int_set_start_scan_req(struct host_if_drv *hif_drv, u8 scanSource)
 {
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_START_SCAN_REQ;
-	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)&scanSource;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_START_SCAN_REQ;
+	wid.type = WID_CHAR;
+	wid.val = (s8 *)&scanSource;
+	wid.size = sizeof(char);
 
 	return 0;
 }
 
 s32 host_int_get_start_scan_req(struct host_if_drv *hif_drv, u8 *pu8ScanSource)
 {
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_START_SCAN_REQ;
-	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)pu8ScanSource;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_START_SCAN_REQ;
+	wid.type = WID_CHAR;
+	wid.val = (s8 *)pu8ScanSource;
+	wid.size = sizeof(char);
 
 	return 0;
 }
@@ -3564,12 +3563,12 @@ s32 host_int_disconnect(struct host_if_drv *hif_drv, u16 u16ReasonCode)
 
 s32 host_int_disconnect_station(struct host_if_drv *hif_drv, u8 assoc_id)
 {
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_DISCONNECT;
-	strWID.type = WID_CHAR;
-	strWID.val = (s8 *)&assoc_id;
-	strWID.size = sizeof(char);
+	wid.id = (u16)WID_DISCONNECT;
+	wid.type = WID_CHAR;
+	wid.val = (s8 *)&assoc_id;
+	wid.size = sizeof(char);
 
 	return 0;
 }
@@ -3578,12 +3577,12 @@ s32 host_int_get_assoc_req_info(struct host_if_drv *hif_drv,
 				u8 *pu8AssocReqInfo,
 				u32 u32AssocReqInfoLen)
 {
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_ASSOC_REQ_INFO;
-	strWID.type = WID_STR;
-	strWID.val = pu8AssocReqInfo;
-	strWID.size = u32AssocReqInfoLen;
+	wid.id = (u16)WID_ASSOC_REQ_INFO;
+	wid.type = WID_STR;
+	wid.val = pu8AssocReqInfo;
+	wid.size = u32AssocReqInfoLen;
 
 	return 0;
 }
@@ -3594,26 +3593,26 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 				u32 *pu32RcvdAssocRespInfoLen)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
 	if (!hif_drv) {
 		PRINT_ER("Driver is null\n");
 		return -EFAULT;
 	}
 
-	strWID.id = (u16)WID_ASSOC_RES_INFO;
-	strWID.type = WID_STR;
-	strWID.val = pu8AssocRespInfo;
-	strWID.size = u32MaxAssocRespInfoLen;
+	wid.id = (u16)WID_ASSOC_RES_INFO;
+	wid.type = WID_STR;
+	wid.val = pu8AssocRespInfo;
+	wid.size = u32MaxAssocRespInfoLen;
 
-	result = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
 		PRINT_ER("Failed to send association response config packet\n");
 		return -EINVAL;
 	} else {
-		*pu32RcvdAssocRespInfoLen = strWID.size;
+		*pu32RcvdAssocRespInfoLen = wid.size;
 	}
 
 	return result;
@@ -3623,12 +3622,12 @@ s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv,
 				u8 *pu8RxPowerLevel,
 				u32 u32RxPowerLevelLen)
 {
-	struct wid strWID;
+	struct wid wid;
 
-	strWID.id = (u16)WID_RX_POWER_LEVEL;
-	strWID.type = WID_STR;
-	strWID.val = pu8RxPowerLevel;
-	strWID.size = u32RxPowerLevelLen;
+	wid.id = (u16)WID_RX_POWER_LEVEL;
+	wid.type = WID_STR;
+	wid.val = pu8RxPowerLevel;
+	wid.size = u32RxPowerLevelLen;
 
 	return 0;
 }
@@ -3769,19 +3768,19 @@ s32 host_int_get_inactive_time(struct host_if_drv *hif_drv,
 s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 {
 	s32 result = 0;
-	struct wid strWID;
+	struct wid wid;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
-	strWID.id = (u16)WID_MEMORY_ADDRESS;
-	strWID.type = WID_INT;
-	strWID.val = (s8 *)pu32TestMemAddr;
-	strWID.size = sizeof(u32);
+	wid.id = (u16)WID_MEMORY_ADDRESS;
+	wid.type = WID_INT;
+	wid.val = (s8 *)pu32TestMemAddr;
+	wid.size = sizeof(u32);
 
-	result = send_config_pkt(GET_CFG, &strWID, 1,
+	result = send_config_pkt(GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
-- 
1.9.1

