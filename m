Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2451 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbJMKvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:04 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/54] staging: wilc1000: rename uniHostIFkeyAttr of struct key_attr
Date: Tue, 13 Oct 2015 19:49:29 +0900
Message-ID: <1444733419-17679-4-git-send-email-tony.cho@atmel.com> (sfid-20151013_125110_552278_44B7D416)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames uniHostIFkeyAttr of struct key_attr to attr to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 217 +++++++++++-------------------
 1 file changed, 82 insertions(+), 135 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 203f870..9fe4ea9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -92,7 +92,7 @@ union host_if_key_attr {
 struct key_attr {
 	enum KEY_TYPE type;
 	u8 action;
-	union host_if_key_attr uniHostIFkeyAttr;
+	union host_if_key_attr attr;
 };
 
 struct scan_attr {
@@ -1786,41 +1786,38 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index));
+			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->attr.wep.index));
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.mode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wep.mode));
 
 			strWIDList[1].id = WID_AUTH_TYPE;
 			strWIDList[1].type = WID_CHAR;
 			strWIDList[1].size = sizeof(char);
-			strWIDList[1].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.auth_type));
+			strWIDList[1].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wep.auth_type));
 
 			strWIDList[2].id = (u16)WID_KEY_ID;
 			strWIDList[2].type = WID_CHAR;
 
-			strWIDList[2].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index));
+			strWIDList[2].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wep.index));
 			strWIDList[2].size = sizeof(char);
 
-
-			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len, GFP_KERNEL);
-
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len, GFP_KERNEL);
 
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
 				return -1;
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len);
-
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wep.key,
+				    pstrHostIFkeyAttr->attr.wep.key_len);
 
-			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key);
+			kfree(pstrHostIFkeyAttr->attr.wep.key);
 
 			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].type = WID_STR;
-			strWIDList[3].size = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len;
+			strWIDList[3].size = pstrHostIFkeyAttr->attr.wep.key_len;
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
 
@@ -1833,24 +1830,21 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 		if (pstrHostIFkeyAttr->action & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len + 2, GFP_KERNEL);
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
 				return -1;
 			}
-			pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index;
-
-			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len, 1);
-
-			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len);
-
-			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key);
+			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
+			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->attr.wep.key_len, 1);
+			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->attr.wep.key,
+				    pstrHostIFkeyAttr->attr.wep.key_len);
+			kfree(pstrHostIFkeyAttr->attr.wep.key);
 
 			strWID.id = (u16)WID_ADD_WEP_KEY;
 			strWID.type = WID_STR;
 			strWID.val = (s8 *)pu8keybuf;
-			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len + 2;
+			strWID.size = pstrHostIFkeyAttr->attr.wep.key_len + 2;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
@@ -1861,7 +1855,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.id = (u16)WID_REMOVE_WEP_KEY;
 			strWID.type = WID_STR;
 
-			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index;
+			s8idxarray[0] = (s8)pstrHostIFkeyAttr->attr.wep.index;
 			strWID.val = s8idxarray;
 			strWID.size = 1;
 
@@ -1870,7 +1864,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
-			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index));
+			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->attr.wep.index));
 			strWID.size = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
@@ -1892,20 +1886,18 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			memset(pu8keybuf, 0, RX_MIC_KEY_MSG_LEN);
 
-			if (pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq != NULL)
-				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq, 8);
+			if (pstrHostIFkeyAttr->attr.wpa.pu8seq != NULL)
+				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.pu8seq, 8);
 
+			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
+			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.pu8key,
+				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
 
-			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8keyidx, 1);
-
-			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
-
-			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Ciphermode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wpa.u8Ciphermode));
 
 			strWIDList[1].id = (u16)WID_ADD_RX_GTK;
 			strWIDList[1].type = WID_STR;
@@ -1936,13 +1928,11 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			else
 				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
 
-			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq, 8);
-
-			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8keyidx, 1);
-
-			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
-			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
+			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.pu8seq, 8);
+			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
+			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.pu8key,
+				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
 
 			strWID.id = (u16)WID_ADD_RX_GTK;
 			strWID.type = WID_STR;
@@ -1956,8 +1946,8 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			up(&hif_drv->hSemTestKeyBlock);
 		}
 _WPARxGtk_end_case_:
-		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key);
-		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq);
+		kfree(pstrHostIFkeyAttr->attr.wpa.pu8key);
+		kfree(pstrHostIFkeyAttr->attr.wpa.pu8seq);
 		if (ret == -1)
 			return ret;
 
@@ -1978,17 +1968,16 @@ _WPARxGtk_end_case_:
 
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8macaddr, 6);
-			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8keyidx, 1);
-			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
-			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
-
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.pu8macaddr, 6);
+			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
+			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->attr.wpa.pu8key,
+				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Ciphermode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wpa.u8Ciphermode));
 
 			strWIDList[1].id = (u16)WID_ADD_PTK;
 			strWIDList[1].type = WID_STR;
@@ -2014,11 +2003,10 @@ _WPARxGtk_end_case_:
 
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8macaddr, 6);
-			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
-			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
-
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.pu8macaddr, 6);
+			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->attr.wpa.pu8key,
+				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
 
 			strWID.id = (u16)WID_ADD_PTK;
 			strWID.type = WID_STR;
@@ -2032,7 +2020,7 @@ _WPARxGtk_end_case_:
 		}
 
 _WPAPtk_end_case_:
-		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key);
+		kfree(pstrHostIFkeyAttr->attr.wpa.pu8key);
 		if (ret == -1)
 			return ret;
 
@@ -2043,24 +2031,23 @@ _WPAPtk_end_case_:
 
 		PRINT_D(HOSTINF_DBG, "Handling PMKSA key\n");
 
-		pu8keybuf = kmalloc((pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
+		pu8keybuf = kmalloc((pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
 		if (pu8keybuf == NULL) {
 			PRINT_ER("No buffer to send PMKSA Key\n");
 			return -1;
 		}
 
-		pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.numpmkid;
+		pu8keybuf[0] = pstrHostIFkeyAttr->attr.pmkid.numpmkid;
 
-		for (i = 0; i < pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.numpmkid; i++) {
-
-			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
-			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
+		for (i = 0; i < pstrHostIFkeyAttr->attr.pmkid.numpmkid; i++) {
+			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + 1), pstrHostIFkeyAttr->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
+			memcpy(pu8keybuf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), pstrHostIFkeyAttr->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
 		}
 
 		strWID.id = (u16)WID_PMKID_INFO;
 		strWID.type = WID_STR;
 		strWID.val = (s8 *)pu8keybuf;
-		strWID.size = (pstrHostIFkeyAttr->uniHostIFkeyAttr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
+		strWID.size = (pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
 
 		s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 					   get_id_from_handler(hif_drv));
@@ -3213,7 +3200,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = REMOVEKEY;
 	msg.drv = hif_drv;
-	msg.body.key_info.uniHostIFkeyAttr.wep.index = index;
+	msg.body.key_info.attr.wep.index = index;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result)
@@ -3242,9 +3229,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = DEFAULTKEY;
 	msg.drv = hif_drv;
-
-
-	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Index;
+	msg.body.key_info.attr.wep.index = u8Index;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -3276,18 +3261,10 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY;
 	msg.drv = hif_drv;
-
-
-	msg.body.key_info.
-	uniHostIFkeyAttr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
-
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.wep.key,
-		    pu8WepKey, u8WepKeylen);
-
-
-	msg.body.key_info.uniHostIFkeyAttr.wep.key_len = (u8WepKeylen);
-
-	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Keyidx;
+	msg.body.key_info.attr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
+	memcpy(msg.body.key_info.attr.wep.key, pu8WepKey, u8WepKeylen);
+	msg.body.key_info.attr.wep.key_len = (u8WepKeylen);
+	msg.body.key_info.attr.wep.index = u8Keyidx;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -3326,23 +3303,12 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	msg.body.key_info.type = WEP;
 	msg.body.key_info.action = ADDKEY_AP;
 	msg.drv = hif_drv;
-
-
-	msg.body.key_info.
-	uniHostIFkeyAttr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
-
-
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.wep.key,
-		    pu8WepKey, (u8WepKeylen));
-
-
-	msg.body.key_info.uniHostIFkeyAttr.wep.key_len = (u8WepKeylen);
-
-	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Keyidx;
-
-	msg.body.key_info.uniHostIFkeyAttr.wep.mode = u8mode;
-
-	msg.body.key_info.uniHostIFkeyAttr.wep.auth_type = tenuAuth_type;
+	msg.body.key_info.attr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
+	memcpy(msg.body.key_info.attr.wep.key, pu8WepKey, (u8WepKeylen));
+	msg.body.key_info.attr.wep.key_len = (u8WepKeylen);
+	msg.body.key_info.attr.wep.index = u8Keyidx;
+	msg.body.key_info.attr.wep.mode = u8mode;
+	msg.body.key_info.attr.wep.auth_type = tenuAuth_type;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
@@ -3381,22 +3347,16 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.body.key_info.type = WPAPtk;
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
-		msg.body.key_info.uniHostIFkeyAttr.wpa.u8keyidx = u8Idx;
+		msg.body.key_info.attr.wpa.u8keyidx = u8Idx;
 	}
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
 
-
-	msg.body.key_info.
-	uniHostIFkeyAttr.wpa.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
-
-
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key,
-		    pu8Ptk, u8PtkKeylen);
+	msg.body.key_info.attr.wpa.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
+	memcpy(msg.body.key_info.attr.wpa.pu8key, pu8Ptk, u8PtkKeylen);
 
 	if (pu8RxMic != NULL) {
-
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key + 16,
+		memcpy(msg.body.key_info.attr.wpa.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
@@ -3404,8 +3364,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		}
 	}
 	if (pu8TxMic != NULL) {
-
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key + 24,
+		memcpy(msg.body.key_info.attr.wpa.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
@@ -3413,10 +3372,9 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		}
 	}
 
-	msg.body.key_info.uniHostIFkeyAttr.wpa.u8Keylen = u8KeyLen;
-
-	msg.body.key_info.uniHostIFkeyAttr.wpa.u8Ciphermode = u8Ciphermode;
-	msg.body.key_info.uniHostIFkeyAttr.wpa.pu8macaddr = mac_addr;
+	msg.body.key_info.attr.wpa.u8Keylen = u8KeyLen;
+	msg.body.key_info.attr.wpa.u8Ciphermode = u8Ciphermode;
+	msg.body.key_info.attr.wpa.pu8macaddr = mac_addr;
 	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -3453,10 +3411,8 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 		u8KeyLen += TX_MIC_KEY_LEN;
 	if (KeyRSC != NULL) {
 		msg.body.key_info.
-		uniHostIFkeyAttr.wpa.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
-
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8seq,
-			    KeyRSC, u32KeyRSClen);
+		attr.wpa.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
+		memcpy(msg.body.key_info.attr.wpa.pu8seq,KeyRSC, u32KeyRSClen);
 	}
 
 
@@ -3466,35 +3422,28 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
-		msg.body.key_info.uniHostIFkeyAttr.wpa.u8Ciphermode = u8Ciphermode;
+		msg.body.key_info.attr.wpa.u8Ciphermode = u8Ciphermode;
 	}
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
 
+	msg.body.key_info.attr.wpa.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.wpa.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
-
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key,
+	memcpy(msg.body.key_info.attr.wpa.pu8key,
 		    pu8RxGtk, u8GtkKeylen);
 
 	if (pu8RxMic != NULL) {
-
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key + 16,
+		memcpy(msg.body.key_info.attr.wpa.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
-
 	}
 	if (pu8TxMic != NULL) {
-
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key + 24,
+		memcpy(msg.body.key_info.attr.wpa.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
-
 	}
 
-	msg.body.key_info.uniHostIFkeyAttr.wpa.u8keyidx = u8KeyIdx;
-	msg.body.key_info.uniHostIFkeyAttr.wpa.u8Keylen = u8KeyLen;
-
-	msg.body.key_info.uniHostIFkeyAttr.wpa.u8seqlen = u32KeyRSClen;
+	msg.body.key_info.attr.wpa.u8keyidx = u8KeyIdx;
+	msg.body.key_info.attr.wpa.u8Keylen = u8KeyLen;
+	msg.body.key_info.attr.wpa.u8seqlen = u32KeyRSClen;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
@@ -3526,11 +3475,9 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	msg.drv = hif_drv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
-
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.pmkid.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
+		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
 			    ETH_ALEN);
-
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.pmkid.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
+		memcpy(msg.body.key_info.attr.pmkid.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
 			    PMKID_LEN);
 	}
 
-- 
1.9.1

