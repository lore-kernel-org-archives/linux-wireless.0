Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38193 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbbJHJME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 05:12:04 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/11] staging: wilc1000: rename u8WepKeylen of struct host_if_wep_attr
Date: Thu, 8 Oct 2015 18:10:53 +0900
Message-ID: <1444295456-25818-8-git-send-email-tony.cho@atmel.com> (sfid-20151008_111241_314096_8001B2F0)
In-Reply-To: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
References: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8WepKeylen of struct host_if_wep_attr to key_len to
avoid CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 931dcb5..7919851 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -108,7 +108,7 @@ struct host_if_wpa_attr {
  */
 struct host_if_wep_attr {
 	u8 *key;
-	u8 u8WepKeylen;
+	u8 key_len;
 	u8 u8Wepidx;
 	u8 u8mode;
 	enum AUTHTYPE tenuAuth_type;
@@ -2368,7 +2368,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[2].size = sizeof(char);
 
 
-			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen, GFP_KERNEL);
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len, GFP_KERNEL);
 
 
 			if (pu8keybuf == NULL) {
@@ -2377,14 +2377,14 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			}
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen);
+				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len);
 
 
 			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key);
 
 			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].type = WID_STR;
-			strWIDList[3].size = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen;
+			strWIDList[3].size = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len;
 			strWIDList[3].val = (s8 *)pu8keybuf;
 
 
@@ -2397,24 +2397,24 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 		if (pstrHostIFkeyAttr->u8KeyAction & ADDKEY) {
 			PRINT_D(HOSTINF_DBG, "Handling WEP key\n");
-			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen + 2, GFP_KERNEL);
+			pu8keybuf = kmalloc(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len + 2, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
 				return -1;
 			}
 			pu8keybuf[0] = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8Wepidx;
 
-			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen, 1);
+			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len, 1);
 
 			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen);
+				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len);
 
 			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key);
 
 			strWID.id = (u16)WID_ADD_WEP_KEY;
 			strWID.type = WID_STR;
 			strWID.val = (s8 *)pu8keybuf;
-			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen + 2;
+			strWID.size = pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key_len + 2;
 
 			s32Error = send_config_pkt(SET_CFG, &strWID, 1,
 						   get_id_from_handler(hif_drv));
@@ -4206,7 +4206,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 		    pu8WepKey, u8WepKeylen);
 
 
-	msg.body.key_info.uniHostIFkeyAttr.wep.u8WepKeylen = (u8WepKeylen);
+	msg.body.key_info.uniHostIFkeyAttr.wep.key_len = (u8WepKeylen);
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8Keyidx;
 
@@ -4275,7 +4275,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 		    pu8WepKey, (u8WepKeylen));
 
 
-	msg.body.key_info.uniHostIFkeyAttr.wep.u8WepKeylen = (u8WepKeylen);
+	msg.body.key_info.uniHostIFkeyAttr.wep.key_len = (u8WepKeylen);
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.u8Wepidx = u8Keyidx;
 
-- 
1.9.1

