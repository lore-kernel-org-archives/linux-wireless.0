Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2485 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbJMKvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:10 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/54] staging: wilc1000: rename pu8key of struct host_if_wpa_attr
Date: Tue, 13 Oct 2015 19:49:30 +0900
Message-ID: <1444733419-17679-5-git-send-email-tony.cho@atmel.com> (sfid-20151013_125113_533267_D3A13A0D)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8key of struct host_if_wpa_attr to key to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 36 +++++++++++++------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9fe4ea9..18a2723 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -66,7 +66,7 @@ struct cfg_param_attr {
 };
 
 struct host_if_wpa_attr {
-	u8 *pu8key;
+	u8 *key;
 	const u8 *pu8macaddr;
 	u8 *pu8seq;
 	u8 u8seqlen;
@@ -1891,7 +1891,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
 			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
-			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.pu8key,
+			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
 				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
@@ -1931,7 +1931,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.pu8seq, 8);
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
 			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
-			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.pu8key,
+			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
 				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
 
 			strWID.id = (u16)WID_ADD_RX_GTK;
@@ -1946,7 +1946,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			up(&hif_drv->hSemTestKeyBlock);
 		}
 _WPARxGtk_end_case_:
-		kfree(pstrHostIFkeyAttr->attr.wpa.pu8key);
+		kfree(pstrHostIFkeyAttr->attr.wpa.key);
 		kfree(pstrHostIFkeyAttr->attr.wpa.pu8seq);
 		if (ret == -1)
 			return ret;
@@ -1971,7 +1971,7 @@ _WPARxGtk_end_case_:
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.pu8macaddr, 6);
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
 			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
-			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->attr.wpa.pu8key,
+			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->attr.wpa.key,
 				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
@@ -2005,7 +2005,7 @@ _WPARxGtk_end_case_:
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.pu8macaddr, 6);
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
-			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->attr.wpa.pu8key,
+			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->attr.wpa.key,
 				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
 
 			strWID.id = (u16)WID_ADD_PTK;
@@ -2020,7 +2020,7 @@ _WPARxGtk_end_case_:
 		}
 
 _WPAPtk_end_case_:
-		kfree(pstrHostIFkeyAttr->attr.wpa.pu8key);
+		kfree(pstrHostIFkeyAttr->attr.wpa.key);
 		if (ret == -1)
 			return ret;
 
@@ -3352,20 +3352,18 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
 
-	msg.body.key_info.attr.wpa.pu8key = kmalloc(u8PtkKeylen, GFP_KERNEL);
-	memcpy(msg.body.key_info.attr.wpa.pu8key, pu8Ptk, u8PtkKeylen);
+	msg.body.key_info.attr.wpa.key = kmalloc(u8PtkKeylen, GFP_KERNEL);
+	memcpy(msg.body.key_info.attr.wpa.key, pu8Ptk, u8PtkKeylen);
 
 	if (pu8RxMic != NULL) {
-		memcpy(msg.body.key_info.attr.wpa.pu8key + 16,
-			    pu8RxMic, RX_MIC_KEY_LEN);
+		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic, RX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < RX_MIC_KEY_LEN; i++)
 				PRINT_INFO(CFG80211_DBG, "PairwiseRx[%d] = %x\n", i, pu8RxMic[i]);
 		}
 	}
 	if (pu8TxMic != NULL) {
-		memcpy(msg.body.key_info.attr.wpa.pu8key + 24,
-			    pu8TxMic, TX_MIC_KEY_LEN);
+		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic, TX_MIC_KEY_LEN);
 		if (INFO) {
 			for (i = 0; i < TX_MIC_KEY_LEN; i++)
 				PRINT_INFO(CFG80211_DBG, "PairwiseTx[%d] = %x\n", i, pu8TxMic[i]);
@@ -3427,18 +3425,14 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
 
-	msg.body.key_info.attr.wpa.pu8key = kmalloc(u8KeyLen, GFP_KERNEL);
-
-	memcpy(msg.body.key_info.attr.wpa.pu8key,
-		    pu8RxGtk, u8GtkKeylen);
+	msg.body.key_info.attr.wpa.key = kmalloc(u8KeyLen, GFP_KERNEL);
+	memcpy(msg.body.key_info.attr.wpa.key, pu8RxGtk, u8GtkKeylen);
 
 	if (pu8RxMic != NULL) {
-		memcpy(msg.body.key_info.attr.wpa.pu8key + 16,
-			    pu8RxMic, RX_MIC_KEY_LEN);
+		memcpy(msg.body.key_info.attr.wpa.key + 16, pu8RxMic, RX_MIC_KEY_LEN);
 	}
 	if (pu8TxMic != NULL) {
-		memcpy(msg.body.key_info.attr.wpa.pu8key + 24,
-			    pu8TxMic, TX_MIC_KEY_LEN);
+		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic, TX_MIC_KEY_LEN);
 	}
 
 	msg.body.key_info.attr.wpa.u8keyidx = u8KeyIdx;
-- 
1.9.1

