Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2625 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbJMKvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/54] staging: wilc1000: rename u8Keylen of struct host_if_wpa_attr
Date: Tue, 13 Oct 2015 19:49:35 +0900
Message-ID: <1444733419-17679-10-git-send-email-tony.cho@atmel.com> (sfid-20151013_125145_805670_649FE8BF)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8Keylen of struct host_if_wpa_attr to key_len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2521987..2ebd0cc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -71,7 +71,7 @@ struct host_if_wpa_attr {
 	u8 *seq;
 	u8 seq_len;
 	u8 index;
-	u8 u8Keylen;
+	u8 key_len;
 	u8 u8Ciphermode;
 };
 
@@ -1890,9 +1890,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
 
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
-				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
+				    pstrHostIFkeyAttr->attr.wpa.key_len);
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
@@ -1930,9 +1930,9 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
-				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
+				    pstrHostIFkeyAttr->attr.wpa.key_len);
 
 			strWID.id = (u16)WID_ADD_RX_GTK;
 			strWID.type = WID_STR;
@@ -1970,9 +1970,9 @@ _WPARxGtk_end_case_:
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.index, 1);
-			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
 			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->attr.wpa.key,
-				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
+				    pstrHostIFkeyAttr->attr.wpa.key_len);
 
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
@@ -2004,9 +2004,9 @@ _WPARxGtk_end_case_:
 			}
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
-			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
+			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.key_len, 1);
 			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->attr.wpa.key,
-				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
+				    pstrHostIFkeyAttr->attr.wpa.key_len);
 
 			strWID.id = (u16)WID_ADD_PTK;
 			strWID.type = WID_STR;
@@ -3370,7 +3370,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 		}
 	}
 
-	msg.body.key_info.attr.wpa.u8Keylen = u8KeyLen;
+	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
 	msg.body.key_info.attr.wpa.u8Ciphermode = u8Ciphermode;
 	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
 	msg.drv = hif_drv;
@@ -3435,7 +3435,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	}
 
 	msg.body.key_info.attr.wpa.index = u8KeyIdx;
-	msg.body.key_info.attr.wpa.u8Keylen = u8KeyLen;
+	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
 	msg.body.key_info.attr.wpa.seq_len = u32KeyRSClen;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

