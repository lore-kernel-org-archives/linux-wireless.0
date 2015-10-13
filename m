Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2524 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbbJMKvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:23 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/54] staging: wilc1000: rename pu8seq of struct host_if_wpa_attr
Date: Tue, 13 Oct 2015 19:49:32 +0900
Message-ID: <1444733419-17679-7-git-send-email-tony.cho@atmel.com> (sfid-20151013_125134_926959_10FEB384)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8seq of struct host_if_wpa_attr to seq to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 29bd5bf..eb4e03b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -68,7 +68,7 @@ struct cfg_param_attr {
 struct host_if_wpa_attr {
 	u8 *key;
 	const u8 *mac_addr;
-	u8 *pu8seq;
+	u8 *seq;
 	u8 u8seqlen;
 	u8 u8keyidx;
 	u8 u8Keylen;
@@ -1886,8 +1886,8 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			memset(pu8keybuf, 0, RX_MIC_KEY_MSG_LEN);
 
-			if (pstrHostIFkeyAttr->attr.wpa.pu8seq != NULL)
-				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.pu8seq, 8);
+			if (pstrHostIFkeyAttr->attr.wpa.seq != NULL)
+				memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
 
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
 			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
@@ -1928,7 +1928,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			else
 				PRINT_ER("Couldn't handle WPARxGtk while enuHostIFstate is not HOST_IF_CONNECTED\n");
 
-			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.pu8seq, 8);
+			memcpy(pu8keybuf + 6, pstrHostIFkeyAttr->attr.wpa.seq, 8);
 			memcpy(pu8keybuf + 14, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
 			memcpy(pu8keybuf + 15, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
 			memcpy(pu8keybuf + 16, pstrHostIFkeyAttr->attr.wpa.key,
@@ -1947,7 +1947,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		}
 _WPARxGtk_end_case_:
 		kfree(pstrHostIFkeyAttr->attr.wpa.key);
-		kfree(pstrHostIFkeyAttr->attr.wpa.pu8seq);
+		kfree(pstrHostIFkeyAttr->attr.wpa.seq);
 		if (ret == -1)
 			return ret;
 
@@ -3408,9 +3408,8 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	if (pu8TxMic != NULL)
 		u8KeyLen += TX_MIC_KEY_LEN;
 	if (KeyRSC != NULL) {
-		msg.body.key_info.
-		attr.wpa.pu8seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
-		memcpy(msg.body.key_info.attr.wpa.pu8seq,KeyRSC, u32KeyRSClen);
+		msg.body.key_info.attr.wpa.seq = kmalloc(u32KeyRSClen, GFP_KERNEL);
+		memcpy(msg.body.key_info.attr.wpa.seq, KeyRSC, u32KeyRSClen);
 	}
 
 
-- 
1.9.1

