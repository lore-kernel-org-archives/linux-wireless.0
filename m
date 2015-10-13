Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2404 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbJMKu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:50:56 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/54] staging: wilc1000: rename u8KeyAction of struct key_attr
Date: Tue, 13 Oct 2015 19:49:28 +0900
Message-ID: <1444733419-17679-3-git-send-email-tony.cho@atmel.com> (sfid-20151013_125104_294067_3DC19296)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8KeyAction of struct key_attr to action to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 34 +++++++++++++++----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index aeb28a1..203f870 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -91,7 +91,7 @@ union host_if_key_attr {
 
 struct key_attr {
 	enum KEY_TYPE type;
-	u8 u8KeyAction;
+	u8 action;
 	union host_if_key_attr uniHostIFkeyAttr;
 };
 
@@ -1783,7 +1783,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 	case WEP:
 
-		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
+		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
 			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index));
@@ -1831,7 +1831,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 		}
 
-		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
+		if (pstrHostIFkeyAttr->action & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len + 2, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
@@ -1855,7 +1855,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
 			kfree(pu8keybuf);
-		} else if (pstrHostIFkeyAttr->u8KeyAction & REMOVEKEY)	  {
+		} else if (pstrHostIFkeyAttr->action & REMOVEKEY) {
 
 			PRINT_D(HOSTINF_DBG, "Removing key\n");
 			strWID.id = (u16)WID_REMOVE_WEP_KEY;
@@ -1882,7 +1882,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		break;
 
 	case WPARxGtk:
-		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
+		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 			pu8keybuf = kmalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
@@ -1919,7 +1919,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			up(&hif_drv->hSemTestKeyBlock);
 		}
 
-		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
+		if (pstrHostIFkeyAttr->action & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling group key(Rx) function\n");
 
 			pu8keybuf = kmalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
@@ -1964,7 +1964,7 @@ _WPARxGtk_end_case_:
 		break;
 
 	case WPAPtk:
-		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
+		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 
 
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
@@ -2000,7 +2000,7 @@ _WPARxGtk_end_case_:
 			kfree(pu8keybuf);
 			up(&hif_drv->hSemTestKeyBlock);
 		}
-		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
+		if (pstrHostIFkeyAttr->action & ADDKEY) {
 
 
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
@@ -3211,7 +3211,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
-	msg.body.key_info.u8KeyAction = REMOVEKEY;
+	msg.body.key_info.action = REMOVEKEY;
 	msg.drv = hif_drv;
 	msg.body.key_info.uniHostIFkeyAttr.wep.index = index;
 
@@ -3240,7 +3240,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
-	msg.body.key_info.u8KeyAction = DEFAULTKEY;
+	msg.body.key_info.action = DEFAULTKEY;
 	msg.drv = hif_drv;
 
 
@@ -3274,7 +3274,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
-	msg.body.key_info.u8KeyAction = ADDKEY;
+	msg.body.key_info.action = ADDKEY;
 	msg.drv = hif_drv;
 
 
@@ -3324,7 +3324,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 	}
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WEP;
-	msg.body.key_info.u8KeyAction = ADDKEY_AP;
+	msg.body.key_info.action = ADDKEY_AP;
 	msg.drv = hif_drv;
 
 
@@ -3380,11 +3380,11 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = WPAPtk;
 	if (mode == AP_MODE) {
-		msg.body.key_info.u8KeyAction = ADDKEY_AP;
+		msg.body.key_info.action = ADDKEY_AP;
 		msg.body.key_info.uniHostIFkeyAttr.wpa.u8keyidx = u8Idx;
 	}
 	if (mode == STATION_MODE)
-		msg.body.key_info.u8KeyAction = ADDKEY;
+		msg.body.key_info.action = ADDKEY;
 
 
 	msg.body.key_info.
@@ -3465,11 +3465,11 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	msg.drv = hif_drv;
 
 	if (mode == AP_MODE) {
-		msg.body.key_info.u8KeyAction = ADDKEY_AP;
+		msg.body.key_info.action = ADDKEY_AP;
 		msg.body.key_info.uniHostIFkeyAttr.wpa.u8Ciphermode = u8Ciphermode;
 	}
 	if (mode == STATION_MODE)
-		msg.body.key_info.u8KeyAction = ADDKEY;
+		msg.body.key_info.action = ADDKEY;
 
 
 	msg.body.key_info.
@@ -3522,7 +3522,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 
 	msg.id = HOST_IF_MSG_KEY;
 	msg.body.key_info.type = PMKSA;
-	msg.body.key_info.u8KeyAction = ADDKEY;
+	msg.body.key_info.action = ADDKEY;
 	msg.drv = hif_drv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
-- 
1.9.1

