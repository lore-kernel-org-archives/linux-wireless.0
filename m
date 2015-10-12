Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13735 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbJLIAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 04:00:53 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 39/41] staging: wilc1000: rename u8Wepidx of struct host_if_wep_attr
Date: Mon, 12 Oct 2015 16:56:13 +0900
Message-ID: <1444636575-2486-39-git-send-email-tony.cho@atmel.com> (sfid-20151012_100056_397275_4D5E5CFC)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8Wepidx of struct host_if_wep_attr to index to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c4c570a..c808f92 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -110,7 +110,7 @@ struct host_if_wpa_attr {
 struct host_if_wep_attr {
 	u8 *key;
 	u8 key_len;
-	u8 u8Wepidx;
+	u8 index;
 	u8 u8mode;
 	enum AUTHTYPE tenuAuth_type;
 };
@@ -2349,7 +2349,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY_AP)	{
 
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx));
+			PRINT_D(GENERIC_DBG, "ID Hostint is %d\n", (pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index));
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
@@ -2363,7 +2363,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[2].id = (u16)WID_KEY_ID;
 			strWIDList[2].type = WID_CHAR;
 
-			strWIDList[2].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx));
+			strWIDList[2].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index));
 			strWIDList[2].size = sizeof(char);
 
 
@@ -2401,7 +2401,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 				PRINT_ER("No buffer to send Key\n");
 				return -1;
 			}
-			pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx;
+			pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index;
 
 			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len, 1);
 
@@ -2424,7 +2424,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWID.id = (u16)WID_REMOVE_WEP_KEY;
 			strWID.type = WID_STR;
 
-			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx;
+			s8idxarray[0] = (s8)pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index;
 			strWID.val = s8idxarray;
 			strWID.size = 1;
 
@@ -2433,7 +2433,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		} else {
 			strWID.id = (u16)WID_KEY_ID;
 			strWID.type = WID_CHAR;
-			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx));
+			strWID.val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.index));
 			strWID.size = sizeof(char);
 
 			PRINT_D(HOSTINF_DBG, "Setting default key index\n");
@@ -4092,7 +4092,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	msg.body.key_info.enuKeyType = WEP;
 	msg.body.key_info.u8KeyAction = REMOVEKEY;
 	msg.drv = hif_drv;
-	msg.body.key_info.uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = index;
+	msg.body.key_info.uniHostIFkeyAttr.wep.index = index;
 
 	/* send the message */
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4137,7 +4137,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 	msg.drv = hif_drv;
 
 
-	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8Index;
+	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Index;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4201,7 +4201,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.key_len = (u8WepKeylen);
 
-	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8Keyidx;
+	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Keyidx;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4270,7 +4270,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.key_len = (u8WepKeylen);
 
-	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8Keyidx;
+	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Keyidx;
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.u8mode = u8mode;
 
-- 
1.9.1

