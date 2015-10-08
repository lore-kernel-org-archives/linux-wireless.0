Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:37933 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbbJHJLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 05:11:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/11] staging: wilc1000: rename strHostIFwepAttr of union host_if_key_attr
Date: Thu, 8 Oct 2015 18:10:49 +0900
Message-ID: <1444295456-25818-4-git-send-email-tony.cho@atmel.com> (sfid-20151008_111141_560506_0CA0D4A3)
In-Reply-To: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
References: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFwepAttr of union host_if_key_attr to wep to
avoid CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 70 ++++++++++++++-----------------
 1 file changed, 31 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 67b7f0b..7d05754 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -125,7 +125,7 @@ struct host_if_wep_attr {
  *  @version		1.0
  */
 union host_if_key_attr {
-	struct host_if_wep_attr strHostIFwepAttr;
+	struct host_if_wep_attr wep;
 	struct host_if_wpa_attr strHostIFwpaAttr;
 	struct host_if_pmkid_attr strHostIFpmkidAttr;
 };
@@ -2350,25 +2350,25 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
 
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
+			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx));
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8mode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8mode));
 
 			strWIDList[1].id = WID_AUTH_TYPE;
 			strWIDList[1].type = WID_CHAR;
 			strWIDList[1].size = sizeof(char);
-			strWIDList[1].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type));
+			strWIDList[1].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.tenuAuth_type));
 
 			strWIDList[2].id = (u16)WID_KEY_ID;
 			strWIDList[2].type = WID_CHAR;
 
-			strWIDList[2].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
+			strWIDList[2].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx));
 			strWIDList[2].size = sizeof(char);
 
 
-			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen, GFP_KERNEL);
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen, GFP_KERNEL);
 
 
 			if (pu8keybuf == NULL) {
@@ -2376,15 +2376,15 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 				return -1;
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.pu8WepKey,
+				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen);
 
 
-			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
+			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.pu8WepKey);
 
 			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].type = WID_STR;
-			strWIDList[3].size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen;
+			strWIDList[3].size = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen;
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
 
@@ -2397,24 +2397,24 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2, GFP_KERNEL);
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen + 2, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
 				return -1;
 			}
-			pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx;
+			pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx;
 
-			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen, 1);
+			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen, 1);
 
-			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen);
+			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.pu8WepKey,
+				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen);
 
-			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey);
+			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.pu8WepKey);
 
 			strWID.id = (u16)WID_ADD_WEP_KEY;
 			strWID.type = WID_STR;
 			strWID.val = (s8 *)pu8keybuf;
-			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen + 2;
+			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen + 2;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
@@ -2425,7 +2425,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.id = (u16)WID_REMOVE_WEP_KEY;
 			strWID.type = WID_STR;
 
-			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx;
+			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx;
 			strWID.val = s8idxarray;
 			strWID.size = 1;
 
@@ -2434,7 +2434,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
-			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx));
+			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx));
 			strWID.size = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
@@ -4099,8 +4099,7 @@ s32 host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 u8keyIdx)
 
 
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
+	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8keyIdx;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4145,8 +4144,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 	msg.drv = hif_drv;
 
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Index;
+	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8Index;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4202,17 +4200,15 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 
 	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
+	uniHostIFkeyAttr.wep.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.wep.pu8WepKey,
 		    pu8WepKey, u8WepKeylen);
 
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen = (u8WepKeylen);
+	msg.body.key_info.uniHostIFkeyAttr.wep.u8WepKeylen = (u8WepKeylen);
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
+	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8Keyidx;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4272,24 +4268,20 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 
 	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
+	uniHostIFkeyAttr.wep.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
 
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.wep.pu8WepKey,
 		    pu8WepKey, (u8WepKeylen));
 
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen = (u8WepKeylen);
+	msg.body.key_info.uniHostIFkeyAttr.wep.u8WepKeylen = (u8WepKeylen);
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
+	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8Keyidx;
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.u8mode = u8mode;
+	msg.body.key_info.uniHostIFkeyAttr.wep.u8mode = u8mode;
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type = tenuAuth_type;
+	msg.body.key_info.uniHostIFkeyAttr.wep.tenuAuth_type = tenuAuth_type;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
-- 
1.9.1

