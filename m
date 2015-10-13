Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2593 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbbJMKvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:36 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/54] staging: wilc1000: rename u8keyidx of struct host_if_wpa_attr
Date: Tue, 13 Oct 2015 19:49:34 +0900
Message-ID: <1444733419-17679-9-git-send-email-tony.cho@atmel.com> (sfid-20151013_125139_554003_E2C478A0)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8keyidx of struct host_if_wpa_attr to index to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5c8af19..2521987 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -70,7 +70,7 @@ struct host_if_wpa_attr {
 	const u8 *mac_addr;
 	u8 *seq;
 	u8 seq_len;
-	u8 u8keyidx;
+	u8 index;
 	u8 u8Keylen;
 	u8 u8Ciphermode;
 };
@@ -1889,7 +1889,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			if (pstrHostIFkeyAttr->attr.wpa.seq != NULL)
 				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
 
-			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
+			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
 			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
 				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
@@ -1929,7 +1929,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
 
 			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
-			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
+			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.index, 1);
 			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
 				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
@@ -1969,7 +1969,7 @@ _WPARxGtk_end_case_:
 			}
 
 			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
-			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
+			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.index, 1);
 			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
 			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->attr.wpa.key,
 				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
@@ -3347,7 +3347,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	msg.body.key_info.type = WPAPtk;
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
-		msg.body.key_info.attr.wpa.u8keyidx = u8Idx;
+		msg.body.key_info.attr.wpa.index = u8Idx;
 	}
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
@@ -3434,7 +3434,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 		memcpy(msg.body.key_info.attr.wpa.key + 24, pu8TxMic, TX_MIC_KEY_LEN);
 	}
 
-	msg.body.key_info.attr.wpa.u8keyidx = u8KeyIdx;
+	msg.body.key_info.attr.wpa.index = u8KeyIdx;
 	msg.body.key_info.attr.wpa.u8Keylen = u8KeyLen;
 	msg.body.key_info.attr.wpa.seq_len = u32KeyRSClen;
 
-- 
1.9.1

