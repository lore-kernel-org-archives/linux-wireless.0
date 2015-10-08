Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:37968 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbbJHJLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 05:11:44 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/11] staging: wilc1000: rename strHostIFwpaAttr of union host_if_key_attr
Date: Thu, 8 Oct 2015 18:10:50 +0900
Message-ID: <1444295456-25818-5-git-send-email-tony.cho@atmel.com> (sfid-20151008_111148_193832_74DD125F)
In-Reply-To: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
References: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFwpaAttr of union host_if_key_attr to wpa to
avoid CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 95 ++++++++++++++-----------------
 1 file changed, 44 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7d05754..b8899d7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -126,7 +126,7 @@ struct host_if_wep_attr {
  */
 union host_if_key_attr {
 	struct host_if_wep_attr wep;
-	struct host_if_wpa_attr strHostIFwpaAttr;
+	struct host_if_wpa_attr wpa;
 	struct host_if_pmkid_attr strHostIFpmkidAttr;
 };
 
@@ -2464,21 +2464,21 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 
 
-			if (pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq != NULL)
-				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq, 8);
+			if (pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq != NULL)
+				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq, 8);
 
 
-			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
+			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8keyidx, 1);
 
-			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
+			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
 
-			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
+			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
+				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
 			/* pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode =  0X51; */
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Ciphermode));
 
 			strWIDList[1].id = (u16)WID_ADD_RX_GTK;
 			strWIDList[1].type = WID_STR;
@@ -2518,13 +2518,13 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			else
 				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
 
-			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq, 8);
+			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq, 8);
 
-			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
+			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8keyidx, 1);
 
-			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
-			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
+			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
+				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
 
 			strWID.id = (u16)WID_ADD_RX_GTK;
 			strWID.type = WID_STR;
@@ -2541,8 +2541,8 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			/* ///////////////////////// */
 		}
 _WPARxGtk_end_case_:
-		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key);
-		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq);
+		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key);
+		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8seq);
 		if (ret == -1)
 			return ret;
 
@@ -2569,19 +2569,19 @@ _WPARxGtk_end_case_:
 			 |	6 bytes    |	1 byte    |   1byte	 |   16 bytes	 |	  8 bytes	  |	   8 bytes	  |
 			 |-----------------------------------------------------------------------------|*/
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr, 6);  /*1 bytes Key Length */
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8macaddr, 6);  /*1 bytes Key Length */
 
-			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx, 1);
-			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
+			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8keyidx, 1);
+			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
 			/*16 byte TK*/
-			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
+			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
+				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
 
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Ciphermode));
 
 			strWIDList[1].id = (u16)WID_ADD_PTK;
 			strWIDList[1].type = WID_STR;
@@ -2616,12 +2616,12 @@ _WPARxGtk_end_case_:
 			 |	6 bytes		 |	1byte	  |   16 bytes	 |	  8 bytes	  |	   8 bytes	  |
 			 |-----------------------------------------------------------------------------|*/
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr, 6);  /*1 bytes Key Length */
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8macaddr, 6);  /*1 bytes Key Length */
 
-			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen, 1);
+			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen, 1);
 			/*16 byte TK*/
-			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
-				    pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen);
+			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key,
+				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.u8Keylen);
 
 
 			strWID.id = (u16)WID_ADD_PTK;
@@ -2639,7 +2639,7 @@ _WPARxGtk_end_case_:
 		}
 
 _WPAPtk_end_case_:
-		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.strHostIFwpaAttr.pu8key);
+		kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wpa.pu8key);
 		if (ret == -1)
 			return ret;
 
@@ -4337,23 +4337,22 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.body.key_info.enuKeyType = WPAPtk;
 	if (mode == AP_MODE) {
 		msg.body.key_info.u8KeyAction = ADDKEY_AP;
-		msg.body.key_info.
-		uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8Idx;
+		msg.body.key_info.uniHostIFkeyAttr.wpa.u8keyidx = u8Idx;
 	}
 	if (mode == STATION_MODE)
 		msg.body.key_info.u8KeyAction = ADDKEY;
 
 
 	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
+	uniHostIFkeyAttr.wpa.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
 
 
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key,
 		    pu8Ptk, u8PtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
@@ -4362,7 +4361,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	}
 	if (pu8TxMic != NULL) {
 
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
@@ -4370,13 +4369,10 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		}
 	}
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
+	msg.body.key_info.uniHostIFkeyAttr.wpa.u8Keylen = u8KeyLen;
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwpaAttr.pu8macaddr = mac_addr;
+	msg.body.key_info.uniHostIFkeyAttr.wpa.u8Ciphermode = u8Ciphermode;
+	msg.body.key_info.uniHostIFkeyAttr.wpa.pu8macaddr = mac_addr;
 	msg.drv = hif_drv;
 
 	/* send the message */
@@ -4430,9 +4426,9 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 		u8KeyLen += TX_MIC_KEY_LEN;
 	if (KeyRSC != NULL) {
 		msg.body.key_info.
-		uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
+		uniHostIFkeyAttr.wpa.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
 
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8seq,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8seq,
 			    KeyRSC, u32KeyRSClen);
 	}
 
@@ -4443,38 +4439,35 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 
 	if (mode == AP_MODE) {
 		msg.body.key_info.u8KeyAction = ADDKEY_AP;
-		msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.u8Ciphermode = u8Ciphermode;
+		msg.body.key_info.uniHostIFkeyAttr.wpa.u8Ciphermode = u8Ciphermode;
 	}
 	if (mode == STATION_MODE)
 		msg.body.key_info.u8KeyAction = ADDKEY;
 
 
 	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwpaAttr.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
+	uniHostIFkeyAttr.wpa.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
 
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key,
 		    pu8RxGtk, u8GtkKeylen);
 
 	if (pu8RxMic != NULL) {
 
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 16,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key + 16,
 			    pu8RxMic, RX_MIC_KEY_LEN);
 
 	}
 	if (pu8TxMic != NULL) {
 
-		memcpy(msg.body.key_info.uniHostIFkeyAttr.strHostIFwpaAttr.pu8key + 24,
+		memcpy(msg.body.key_info.uniHostIFkeyAttr.wpa.pu8key + 24,
 			    pu8TxMic, TX_MIC_KEY_LEN);
 
 	}
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwpaAttr.u8keyidx = u8KeyIdx;
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwpaAttr.u8Keylen = u8KeyLen;
+	msg.body.key_info.uniHostIFkeyAttr.wpa.u8keyidx = u8KeyIdx;
+	msg.body.key_info.uniHostIFkeyAttr.wpa.u8Keylen = u8KeyLen;
 
-	msg.body.key_info.
-	uniHostIFkeyAttr.strHostIFwpaAttr.u8seqlen = u32KeyRSClen;
+	msg.body.key_info.uniHostIFkeyAttr.wpa.u8seqlen = u32KeyRSClen;
 
 
 
-- 
1.9.1

