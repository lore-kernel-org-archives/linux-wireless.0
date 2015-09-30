Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13924 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbbI3JsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:48:01 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/32] staging: wilc1000: rename strHostIFkeyAttr
Date: Wed, 30 Sep 2015 18:44:24 +0900
Message-ID: <1443606289-25407-7-git-send-email-tony.cho@atmel.com> (sfid-20150930_114805_288206_7665ECC4)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFkeyAttr to key_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 100 +++++++++++++++---------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b24c022..d4e8122 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -418,7 +418,7 @@ union message_body {
 	struct connect_attr con_info;
 	struct rcvd_net_info net_info;
 	struct rcvd_async_info async_info;
-	struct key_attr strHostIFkeyAttr;
+	struct key_attr key_info;
 	struct cfg_param_attr strHostIFCfgParamAttr;
 	struct set_channel strHostIFSetChan;
 	struct get_channel strHostIFGetChan;
@@ -4119,7 +4119,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_KEY:
-			Handle_Key(msg.drvHandler, &msg.body.strHostIFkeyAttr);
+			Handle_Key(msg.drvHandler, &msg.body.key_info);
 			break;
 
 		case HOST_IF_MSG_CFG_PARAMS:
@@ -4363,13 +4363,13 @@ s32 host_int_remove_wep_key(tstrWILC_WFIDrv *hWFIDrv, u8 u8keyIdx)
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.strHostIFkeyAttr.enuKeyType = WEP;
-	msg.body.strHostIFkeyAttr.u8KeyAction = REMOVEKEY;
+	msg.body.key_info.enuKeyType = WEP;
+	msg.body.key_info.u8KeyAction = REMOVEKEY;
 	msg.drvHandler = hWFIDrv;
 
 
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8keyIdx;
 
 	/* send the message */
@@ -4411,12 +4411,12 @@ s32 host_int_set_WEPDefaultKeyID(tstrWILC_WFIDrv *hWFIDrv, u8 u8Index)
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.strHostIFkeyAttr.enuKeyType = WEP;
-	msg.body.strHostIFkeyAttr.u8KeyAction = DEFAULTKEY;
+	msg.body.key_info.enuKeyType = WEP;
+	msg.body.key_info.u8KeyAction = DEFAULTKEY;
 	msg.drvHandler = hWFIDrv;
 
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Index;
 
 	/* send the message */
@@ -4465,22 +4465,22 @@ s32 host_int_add_wep_key_bss_sta(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey,
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.strHostIFkeyAttr.enuKeyType = WEP;
-	msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+	msg.body.key_info.enuKeyType = WEP;
+	msg.body.key_info.u8KeyAction = ADDKEY;
 	msg.drvHandler = hWFIDrv;
 
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
-	memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, u8WepKeylen);
 
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen = (u8WepKeylen);
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
 	/* send the message */
@@ -4531,29 +4531,29 @@ s32 host_int_add_wep_key_bss_ap(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8WepKey, u
 			PRINT_INFO(HOSTAPD_DBG, "KEY is %x\n", pu8WepKey[i]);
 	}
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.strHostIFkeyAttr.enuKeyType = WEP;
-	msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
+	msg.body.key_info.enuKeyType = WEP;
+	msg.body.key_info.u8KeyAction = ADDKEY_AP;
 	msg.drvHandler = hWFIDrv;
 
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
 
 
-	memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwepAttr.pu8WepKey,
 		    pu8WepKey, (u8WepKeylen));
 
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8WepKeylen = (u8WepKeylen);
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8Wepidx = u8Keyidx;
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.u8mode = u8mode;
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwepAttr.tenuAuth_type = tenuAuth_type;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4606,26 +4606,26 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.strHostIFkeyAttr.enuKeyType = WPAPtk;
+	msg.body.key_info.enuKeyType = WPAPtk;
 	if (mode == AP_MODE) {
-		msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
-		msg.body.strHostIFkeyAttr.
+		msg.body.key_info.u8KeyAction = ADDKEY_AP;
+		msg.body.key_info.
 		uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8Idx;
 	}
 	if (mode == STATION_MODE)
-		msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+		msg.body.key_info.u8KeyAction = ADDKEY;
 
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
 
 
-	memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8Ptk, u8PtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
@@ -4634,7 +4634,7 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 	}
 	if (pu8TxMic != NULL) {
 
-		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
@@ -4642,12 +4642,12 @@ s32 host_int_add_ptk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8Ptk, u8 u8PtkKeylen,
 		}
 	}
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr = mac_addr;
 	msg.drvHandler = hWFIDrv;
 
@@ -4700,51 +4700,51 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
 	if (pu8TxMic != NULL)
 		u8KeyLen += TX_MIC_KEY_LEN;
 	if (KeyRSC != NULL) {
-		msg.body.strHostIFkeyAttr.
+		msg.body.key_info.
 		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
 
-		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
 			    KeyRSC, u32KeyRSClen);
 	}
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.strHostIFkeyAttr.enuKeyType = WPARxGtk;
+	msg.body.key_info.enuKeyType = WPARxGtk;
 	msg.drvHandler = hWFIDrv;
 
 	if (mode == AP_MODE) {
-		msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY_AP;
-		msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
+		msg.body.key_info.u8KeyAction = ADDKEY_AP;
+		msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
 	}
 	if (mode == STATION_MODE)
-		msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+		msg.body.key_info.u8KeyAction = ADDKEY;
 
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
 
-	memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
 		    pu8RxGtk, u8GtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 
 	}
 	if (pu8TxMic != NULL) {
 
-		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 
 	}
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8KeyIdx;
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
 
-	msg.body.strHostIFkeyAttr.
+	msg.body.key_info.
 	uniHostIFkeyAttr.strHostIFwpaAttr.u8seqlen = u32KeyRSClen;
 
 
@@ -4798,16 +4798,16 @@ s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8Pm
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.strHostIFkeyAttr.enuKeyType = PMKSA;
-	msg.body.strHostIFkeyAttr.u8KeyAction = ADDKEY;
+	msg.body.key_info.enuKeyType = PMKSA;
+	msg.body.key_info.u8KeyAction = ADDKEY;
 	msg.drvHandler = hWFIDrv;
 
 	for (i = 0; i < pu8PmkidInfoArray->numpmkid; i++) {
 
-		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].bssid, &pu8PmkidInfoArray->pmkidlist[i].bssid,
 			    ETH_ALEN);
 
-		memcpy(msg.body.strHostIFkeyAttr.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFpmkidAttr.pmkidlist[i].pmkid, &pu8PmkidInfoArray->pmkidlist[i].pmkid,
 			    PMKID_LEN);
 	}
 
-- 
1.9.1

