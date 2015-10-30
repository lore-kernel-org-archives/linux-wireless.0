Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20663 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbbJ3DHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:07:51 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/17] staging: wilc1000: send_config_pkt: add argument struct net_device
Date: Fri, 30 Oct 2015 12:10:27 +0900
Message-ID: <1446174642-28570-2-git-send-email-glen.lee@atmel.com> (sfid-20151030_040754_726980_4477C22C)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct net_device and pass dev to the function
as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |   3 +-
 drivers/staging/wilc1000/coreconfigurator.h |   3 +-
 drivers/staging/wilc1000/host_interface.c   | 196 +++++++++++++++++++++-------
 drivers/staging/wilc1000/wilc_wlan_if.h     |   1 +
 4 files changed, 156 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e10c6ff..3b4a950 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -586,7 +586,8 @@ s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo)
  *  @date		1 Mar 2012
  *  @version	1.0
  */
-s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv)
+s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
+		    u32 count, u32 drv)
 {
 	s32 counter = 0, ret = 0;
 
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 6294d92..1ea5f47 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -127,7 +127,8 @@ typedef struct {
 	size_t ie_len;
 } tstrDisconnectNotifInfo;
 
-s32 send_config_pkt(u8 mode, struct wid *wids, u32 count, u32 drv);
+s32 send_config_pkt(struct net_device *dev, u8 mode, struct wid *wids,
+		    u32 count, u32 drv);
 s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 17826f3..3a4fdc0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -329,6 +329,9 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_CURRENT_CHANNEL;
 	wid.type = WID_CHAR;
@@ -337,7 +340,7 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -353,13 +356,17 @@ static s32 Handle_SetWfiDrvHandler(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
 	wid.type = WID_INT;
 	wid.val = (s8 *)&hif_drv_handler->handler;
 	wid.size = sizeof(u32);
 
-	result = send_config_pkt(SET_CFG, &wid, 1, hif_drv_handler->handler);
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
+				 hif_drv_handler->handler);
 
 	if (!hif_drv)
 		up(&hif_sema_driver);
@@ -377,13 +384,16 @@ static s32 Handle_SetOperationMode(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_SET_OPERATION_MODE;
 	wid.type = WID_INT;
 	wid.val = (s8 *)&hif_op_mode->mode;
 	wid.size = sizeof(u32);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
@@ -402,6 +412,9 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	s32 result = 0;
 	struct wid wid;
 	char firmwareIPAddress[4] = {0};
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	if (pu8IPAddr[0] < 192)
 		pu8IPAddr[0] = 0;
@@ -415,7 +428,7 @@ s32 Handle_set_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 	wid.val = (u8 *)pu8IPAddr;
 	wid.size = IP_ALEN;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	host_int_get_ipaddress(hif_drv, firmwareIPAddress, idx);
@@ -434,13 +447,16 @@ s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 *pu8IPAddr, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_IP_ADDRESS;
 	wid.type = WID_STR;
 	wid.val = kmalloc(IP_ALEN, GFP_KERNEL);
 	wid.size = IP_ALEN;
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = send_config_pkt(dev, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
@@ -470,6 +486,9 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	u8 *mac_buf = kmalloc(ETH_ALEN, GFP_KERNEL);
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	if (!mac_buf) {
 		PRINT_ER("No buffer to send mac address\n");
@@ -483,7 +502,7 @@ static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
 	wid.size = ETH_ALEN;
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
@@ -499,13 +518,16 @@ static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_MAC_ADDR;
 	wid.type = WID_STR;
 	wid.val = pstrHostIfGetMacAddress->mac_addr;
 	wid.size = ETH_ALEN;
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = send_config_pkt(dev, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -523,6 +545,9 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid strWIDList[32];
 	u8 u8WidCnt = 0;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	down(&hif_drv->sem_cfg_values);
 
@@ -789,7 +814,7 @@ static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
 		u8WidCnt++;
 	}
 
-	result = send_config_pkt(SET_CFG, strWIDList, u8WidCnt,
+	result = send_config_pkt(dev, SET_CFG, strWIDList, u8WidCnt,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
@@ -817,6 +842,9 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	u8 *pu8Buffer;
 	u8 valuesize = 0;
 	u8 *pu8HdnNtwrksWidVal = NULL;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(HOSTINF_DBG, "Setting SCAN params\n");
 	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->hif_state);
@@ -910,7 +938,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	else if (hif_drv->hif_state == HOST_IF_IDLE)
 		scan_while_connected = false;
 
-	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = send_config_pkt(dev, SET_CFG, strWIDList, u32WidsCount,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
@@ -943,6 +971,9 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	u8 u8abort_running_scan;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(HOSTINF_DBG, "in Handle_ScanDone()\n");
 
@@ -954,7 +985,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 		wid.val = (s8 *)&u8abort_running_scan;
 		wid.size = sizeof(char);
 
-		result = send_config_pkt(SET_CFG, &wid, 1,
+		result = send_config_pkt(dev, SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 
 		if (result) {
@@ -986,6 +1017,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	u32 u32WidsCount = 0, dummyval = 0;
 	u8 *pu8CurrByte = NULL;
 	struct join_bss_param *ptstrJoinBssParam;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
@@ -1208,7 +1242,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
 	}
 
-	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = send_config_pkt(dev, SET_CFG, strWIDList, u32WidsCount,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
@@ -1275,6 +1309,9 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0;
 	u8 *pu8CurrByte = NULL;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
@@ -1305,7 +1342,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 
 	u32WidsCount++;
 
-	result = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
+	result = send_config_pkt(dev, SET_CFG, strWIDList, u32WidsCount,
 				 get_id_from_handler(join_req_drv));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
@@ -1321,12 +1358,15 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	tstrConnectInfo strConnectInfo;
 	struct wid wid;
 	u16 u16DummyReasonCode = 0;
+	struct net_device *dev;
 
 	if (!hif_drv) {
 		PRINT_ER("Driver handler is NULL\n");
 		return result;
 	}
 
+	dev = hif_drv->priv->dev;
+
 	hif_drv->hif_state = HOST_IF_IDLE;
 
 	scan_while_connected = false;
@@ -1366,7 +1406,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -1705,6 +1745,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 	u8 *pu8keybuf;
 	s8 s8idxarray[1];
 	s8 ret = 0;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	switch (pstrHostIFkeyAttr->type) {
 	case WEP:
@@ -1744,7 +1787,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[3].size = pstrHostIFkeyAttr->attr.wep.key_len;
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
-			result = send_config_pkt(SET_CFG, strWIDList, 4,
+			result = send_config_pkt(dev, SET_CFG, strWIDList, 4,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		}
@@ -1767,7 +1810,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = send_config_pkt(dev, SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
@@ -1779,7 +1822,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = s8idxarray;
 			wid.size = 1;
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = send_config_pkt(dev, SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 		} else {
 			wid.id = (u16)WID_KEY_ID;
@@ -1789,7 +1832,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = send_config_pkt(dev, SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 		}
 		up(&hif_drv->sem_test_key_block);
@@ -1822,7 +1865,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
-			result = send_config_pkt(SET_CFG, strWIDList, 2,
+			result = send_config_pkt(dev, SET_CFG, strWIDList, 2,
 						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
@@ -1855,7 +1898,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = RX_MIC_KEY_MSG_LEN;
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = send_config_pkt(dev, SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 
 			kfree(pu8keybuf);
@@ -1894,7 +1937,7 @@ _WPARxGtk_end_case_:
 			strWIDList[1].val = (s8 *)pu8keybuf;
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
-			result = send_config_pkt(SET_CFG, strWIDList, 2,
+			result = send_config_pkt(dev, SET_CFG, strWIDList, 2,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1917,7 +1960,7 @@ _WPARxGtk_end_case_:
 			wid.val = (s8 *)pu8keybuf;
 			wid.size = PTK_KEY_MSG_LEN;
 
-			result = send_config_pkt(SET_CFG, &wid, 1,
+			result = send_config_pkt(dev, SET_CFG, &wid, 1,
 						 get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1952,7 +1995,7 @@ _WPAPtk_end_case_:
 		wid.val = (s8 *)pu8keybuf;
 		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
-		result = send_config_pkt(SET_CFG, &wid, 1,
+		result = send_config_pkt(dev, SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 
 		kfree(pu8keybuf);
@@ -1971,6 +2014,9 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 	s32 result = 0;
 	u16 u16DummyReasonCode = 0;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_DISCONNECT;
 	wid.type = WID_CHAR;
@@ -1984,7 +2030,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 	eth_zero_addr(u8ConnectedSSID);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2063,6 +2109,9 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_CURRENT_CHANNEL;
 	wid.type = WID_CHAR;
@@ -2071,7 +2120,7 @@ static s32 Handle_GetChnl(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = send_config_pkt(dev, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2088,6 +2137,9 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_RSSI;
 	wid.type = WID_CHAR;
@@ -2096,7 +2148,7 @@ static void Handle_GetRssi(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = send_config_pkt(dev, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
@@ -2110,6 +2162,9 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	link_speed = 0;
 
@@ -2120,7 +2175,7 @@ static void Handle_GetLinkspeed(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = send_config_pkt(dev, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
@@ -2134,6 +2189,9 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 {
 	struct wid strWIDList[5];
 	u32 u32WidsCount = 0, result = 0;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	strWIDList[u32WidsCount].id = WID_LINKSPEED;
 	strWIDList[u32WidsCount].type = WID_CHAR;
@@ -2165,7 +2223,7 @@ s32 Handle_GetStatistics(struct host_if_drv *hif_drv, struct rf_info *pstrStatis
 	strWIDList[u32WidsCount].val = (s8 *)&pstrStatistics->tx_fail_cnt;
 	u32WidsCount++;
 
-	result = send_config_pkt(GET_CFG, strWIDList, u32WidsCount,
+	result = send_config_pkt(dev, GET_CFG, strWIDList, u32WidsCount,
 				 get_id_from_handler(hif_drv));
 
 	if (result)
@@ -2181,6 +2239,9 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	u8 *stamac;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_SET_STA_MAC_INACTIVE_TIME;
 	wid.type = WID_STR;
@@ -2192,7 +2253,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2205,7 +2266,7 @@ static s32 Handle_Get_InActiveTime(struct host_if_drv *hif_drv,
 	wid.val = (s8 *)&inactive_time;
 	wid.size = sizeof(u32);
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = send_config_pkt(dev, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
@@ -2226,6 +2287,9 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(HOSTINF_DBG, "Adding BEACON\n");
 
@@ -2264,7 +2328,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
 		memcpy(pu8CurrByte, pstrSetBeaconParam->tail, pstrSetBeaconParam->tail_len);
 	pu8CurrByte += pstrSetBeaconParam->tail_len;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add beacon config packet\n");
@@ -2280,6 +2344,9 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_DEL_BEACON;
 	wid.type = WID_CHAR;
@@ -2293,7 +2360,7 @@ static void Handle_DelBeacon(struct host_if_drv *hif_drv)
 
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
@@ -2353,6 +2420,9 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(HOSTINF_DBG, "Handling add station\n");
 	wid.id = (u16)WID_ADD_STA;
@@ -2366,7 +2436,7 @@ static void Handle_AddStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2384,6 +2454,9 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 	u8 *pu8CurrByte;
 	u8 i;
 	u8 au8Zero_Buff[6] = {0};
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_DEL_ALL_STA;
 	wid.type = WID_STR;
@@ -2408,7 +2481,7 @@ static void Handle_DelAllSta(struct host_if_drv *hif_drv,
 		pu8CurrByte += ETH_ALEN;
 	}
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2425,6 +2498,9 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_REMOVE_STA;
 	wid.type = WID_BIN;
@@ -2440,7 +2516,7 @@ static void Handle_DelStation(struct host_if_drv *hif_drv,
 
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
@@ -2455,6 +2531,9 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_EDIT_STA;
 	wid.type = WID_BIN;
@@ -2468,7 +2547,7 @@ static void Handle_EditStation(struct host_if_drv *hif_drv,
 	pu8CurrByte = wid.val;
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
@@ -2484,6 +2563,9 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	u8 u8remain_on_chan_flag;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	if (!hif_drv->remain_on_ch_pending) {
 		hif_drv->remain_on_ch.arg = pstrHostIfRemainOnChan->arg;
@@ -2529,7 +2611,7 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 	wid.val[0] = u8remain_on_chan_flag;
 	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
@@ -2558,6 +2640,9 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register : %d FrameType: %d\n",
 		pstrHostIfRegisterFrame->reg,
@@ -2577,7 +2662,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	wid.size = sizeof(u16) + 2;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
@@ -2593,6 +2678,9 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 	u8 u8remain_on_chan_flag;
 	struct wid wid;
 	s32 result = 0;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(HOSTINF_DBG, "CANCEL REMAIN ON CHAN\n");
 
@@ -2609,7 +2697,7 @@ static u32 Handle_ListenStateExpired(struct host_if_drv *hif_drv,
 		wid.val[0] = u8remain_on_chan_flag;
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
-		result = send_config_pkt(SET_CFG, &wid, 1,
+		result = send_config_pkt(dev, SET_CFG, &wid, 1,
 					 get_id_from_handler(hif_drv));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
@@ -2654,6 +2742,9 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	s8 s8PowerMode;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	wid.id = (u16)WID_POWER_MANAGEMENT;
 
@@ -2667,7 +2758,7 @@ static void Handle_PowerManagement(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
@@ -2679,6 +2770,9 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	u8 *pu8CurrByte;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(HOSTINF_DBG, "Setup Multicast Filter\n");
 
@@ -2703,7 +2797,7 @@ static void Handle_SetMulticastFilter(struct host_if_drv *hif_drv,
 	if ((strHostIfSetMulti->cnt) > 0)
 		memcpy(pu8CurrByte, gau8MulticastMacAddrList, ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
@@ -2719,6 +2813,9 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	struct wid wid;
 	int AddbaTimeout = 100;
 	char *ptr = NULL;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
 		strHostIfBASessionInfo->bssid[0],
@@ -2749,7 +2846,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 8;
 	*ptr++ = 0;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
@@ -2768,7 +2865,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
 	*ptr++ = 3;
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	kfree(wid.val);
@@ -2782,6 +2879,9 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	s32 result = 0;
 	struct wid wid;
 	char *ptr = NULL;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
 		strHostIfBASessionInfo->bssid[0],
@@ -2803,7 +2903,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 0;
 	*ptr++ = 32;
 
-	result = send_config_pkt(SET_CFG, &wid, 1,
+	result = send_config_pkt(dev, SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
@@ -3609,6 +3709,9 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
+
+	dev = hif_drv->priv->dev;
 
 	if (!hif_drv) {
 		PRINT_ER("Driver is null\n");
@@ -3620,7 +3723,7 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 	wid.val = pu8AssocRespInfo;
 	wid.size = u32MaxAssocRespInfoLen;
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = send_config_pkt(dev, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
@@ -3784,18 +3887,21 @@ s32 host_int_test_get_int_wid(struct host_if_drv *hif_drv, u32 *pu32TestMemAddr)
 {
 	s32 result = 0;
 	struct wid wid;
+	struct net_device *dev;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
 		return -EFAULT;
 	}
 
+	dev = hif_drv->priv->dev;
+
 	wid.id = (u16)WID_MEMORY_ADDRESS;
 	wid.type = WID_INT;
 	wid.val = (s8 *)pu32TestMemAddr;
 	wid.size = sizeof(u32);
 
-	result = send_config_pkt(GET_CFG, &wid, 1,
+	result = send_config_pkt(dev, GET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
 
 	if (result) {
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 89d2d65..1170169 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -12,6 +12,7 @@
 
 #include <linux/semaphore.h>
 #include "linux_wlan_common.h"
+#include <linux/netdevice.h>
 
 /********************************************
  *
-- 
1.9.1

