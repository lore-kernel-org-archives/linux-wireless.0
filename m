Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33464 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964851AbcAZJuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 04:50:08 -0500
Received: by mail-pf0-f193.google.com with SMTP id e65so8114499pfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 01:50:07 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] staging: wilc1000: fix alignment for open parenthesis
Date: Tue, 26 Jan 2016 18:50:00 +0900
Message-Id: <1453801800-21990-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160126_105022_864732_21661C2A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the check found by checkpatch.pl
CHECK: Alignment should match open parenthesis

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 90 +++++++++++++++----------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 98627a6..716f359 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -303,7 +303,7 @@ static s32 handle_set_channel(struct wilc_vif *vif,
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to set channel\n");
@@ -350,7 +350,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 	wid.size = sizeof(u32);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
 		up(&hif_sema_driver);
@@ -383,7 +383,7 @@ static s32 handle_set_ip_address(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 	wid.size = IP_ALEN;
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	host_int_get_ipaddress(vif, firmware_ip_addr, idx);
 
@@ -408,7 +408,7 @@ static s32 handle_get_ip_address(struct wilc_vif *vif, u8 idx)
 	wid.size = IP_ALEN;
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	PRINT_INFO(HOSTINF_DBG, "%pI4\n", wid.val);
 
@@ -451,7 +451,7 @@ static s32 handle_set_mac_address(struct wilc_vif *vif,
 	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", wid.val);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to set mac address\n");
 		result = -EFAULT;
@@ -473,7 +473,7 @@ static s32 handle_get_mac_address(struct wilc_vif *vif,
 	wid.size = ETH_ALEN;
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to get mac address\n");
@@ -939,7 +939,7 @@ static s32 Handle_ScanDone(struct wilc_vif *vif,
 		wid.size = sizeof(char);
 
 		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-					 wilc_get_vif_idx(vif));
+					      wilc_get_vif_idx(vif));
 
 		if (result) {
 			PRINT_ER("Failed to set abort running scan\n");
@@ -1356,7 +1356,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Sending disconnect request\n");
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
@@ -1750,8 +1750,8 @@ static int Handle_Key(struct wilc_vif *vif,
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						strWIDList, 4,
-						wilc_get_vif_idx(vif));
+						      strWIDList, 4,
+						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
@@ -1772,8 +1772,8 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						&wid, 1,
-						wilc_get_vif_idx(vif));
+						      &wid, 1,
+						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
@@ -1785,8 +1785,8 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.size = 1;
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						&wid, 1,
-						wilc_get_vif_idx(vif));
+						      &wid, 1,
+						      wilc_get_vif_idx(vif));
 		} else {
 			wid.id = (u16)WID_KEY_ID;
 			wid.type = WID_CHAR;
@@ -1796,8 +1796,8 @@ static int Handle_Key(struct wilc_vif *vif,
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						&wid, 1,
-						wilc_get_vif_idx(vif));
+						      &wid, 1,
+						      wilc_get_vif_idx(vif));
 		}
 		up(&hif_drv->sem_test_key_block);
 		break;
@@ -1830,8 +1830,8 @@ static int Handle_Key(struct wilc_vif *vif,
 			strWIDList[1].size = RX_MIC_KEY_MSG_LEN;
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						strWIDList, 2,
-						wilc_get_vif_idx(vif));
+						      strWIDList, 2,
+						      wilc_get_vif_idx(vif));
 
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1862,8 +1862,8 @@ static int Handle_Key(struct wilc_vif *vif,
 			wid.size = RX_MIC_KEY_MSG_LEN;
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						&wid, 1,
-						wilc_get_vif_idx(vif));
+						      &wid, 1,
+						      wilc_get_vif_idx(vif));
 
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
@@ -1902,8 +1902,8 @@ _WPARxGtk_end_case_:
 			strWIDList[1].size = PTK_KEY_MSG_LEN + 1;
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						strWIDList, 2,
-						wilc_get_vif_idx(vif));
+						      strWIDList, 2,
+						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
@@ -1925,8 +1925,8 @@ _WPARxGtk_end_case_:
 			wid.size = PTK_KEY_MSG_LEN;
 
 			result = wilc_send_config_pkt(vif->wilc, SET_CFG,
-						&wid, 1,
-						wilc_get_vif_idx(vif));
+						      &wid, 1,
+						      wilc_get_vif_idx(vif));
 			kfree(pu8keybuf);
 			up(&hif_drv->sem_test_key_block);
 		}
@@ -1961,7 +1961,7 @@ _WPAPtk_end_case_:
 		wid.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-					 wilc_get_vif_idx(vif));
+					      wilc_get_vif_idx(vif));
 
 		kfree(pu8keybuf);
 		break;
@@ -1994,7 +1994,7 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 	eth_zero_addr(wilc_connected_ssid);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to send dissconect config packet\n");
@@ -2085,7 +2085,7 @@ static s32 Handle_GetChnl(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Getting channel value\n");
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to get channel number\n");
@@ -2110,7 +2110,7 @@ static void Handle_GetRssi(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Getting RSSI value\n");
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to get RSSI value\n");
 		result = -EFAULT;
@@ -2135,7 +2135,7 @@ static void Handle_GetLinkspeed(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Getting LINKSPEED value\n");
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to get LINKSPEED value\n");
 		result = -EFAULT;
@@ -2181,8 +2181,8 @@ static s32 Handle_GetStatistics(struct wilc_vif *vif,
 	u32WidsCount++;
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, strWIDList,
-				u32WidsCount,
-				wilc_get_vif_idx(vif));
+				      u32WidsCount,
+				      wilc_get_vif_idx(vif));
 
 	if (result)
 		PRINT_ER("Failed to send scan paramters config packet\n");
@@ -2210,7 +2210,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 	PRINT_D(CFG80211_DBG, "SETING STA inactive time\n");
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to SET incative time\n");
@@ -2223,7 +2223,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 	wid.size = sizeof(u32);
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 
 	if (result) {
 		PRINT_ER("Failed to get incative time\n");
@@ -2311,7 +2311,7 @@ static void Handle_DelBeacon(struct wilc_vif *vif)
 	PRINT_D(HOSTINF_DBG, "Deleting BEACON\n");
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send delete beacon config packet\n");
 }
@@ -2384,7 +2384,7 @@ static void Handle_AddStation(struct wilc_vif *vif,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result != 0)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2426,7 +2426,7 @@ static void Handle_DelAllSta(struct wilc_vif *vif,
 	}
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2458,7 +2458,7 @@ static void Handle_DelStation(struct wilc_vif *vif,
 	memcpy(pu8CurrByte, pstrDelStaParam->mac_addr, ETH_ALEN);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send add station config packet\n");
 
@@ -2486,7 +2486,7 @@ static void Handle_EditStation(struct wilc_vif *vif,
 	pu8CurrByte += WILC_HostIf_PackStaParam(pu8CurrByte, pstrStationParam);
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send edit station config packet\n");
 
@@ -2548,7 +2548,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result != 0)
 		PRINT_ER("Failed to set remain on channel\n");
 
@@ -2596,7 +2596,7 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 	wid.size = sizeof(u16) + 2;
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result) {
 		PRINT_ER("Failed to frame register config packet\n");
 		result = -EINVAL;
@@ -2631,7 +2631,7 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 		wid.val[1] = FALSE_FRMWR_CHANNEL;
 
 		result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-					 wilc_get_vif_idx(vif));
+					      wilc_get_vif_idx(vif));
 		if (result != 0) {
 			PRINT_ER("Failed to set remain on channel\n");
 			goto _done_;
@@ -2689,7 +2689,7 @@ static void Handle_PowerManagement(struct wilc_vif *vif,
 	PRINT_D(HOSTINF_DBG, "Handling Power Management\n");
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send power management config packet\n");
 }
@@ -2726,7 +2726,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 		       ((strHostIfSetMulti->cnt) * ETH_ALEN));
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_ER("Failed to send setup multicast config packet\n");
 
@@ -2762,7 +2762,7 @@ static s32 Handle_DelAllRxBASessions(struct wilc_vif *vif,
 	*ptr++ = 32;
 
 	result = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result)
 		PRINT_D(HOSTINF_DBG, "Couldn't delete BA Session\n");
 
@@ -3502,7 +3502,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 	wid.size = u32MaxAssocRespInfoLen;
 
 	result = wilc_send_config_pkt(vif->wilc, GET_CFG, &wid, 1,
-				 wilc_get_vif_idx(vif));
+				      wilc_get_vif_idx(vif));
 	if (result) {
 		*pu32RcvdAssocRespInfoLen = 0;
 		PRINT_ER("Failed to send association response config packet\n");
-- 
2.7.0

