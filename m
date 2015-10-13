Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2668 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbJMKvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:49 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/54] staging: wilc1000: rename u8Ciphermode of struct host_if_wpa_attr
Date: Tue, 13 Oct 2015 19:49:36 +0900
Message-ID: <1444733419-17679-11-git-send-email-tony.cho@atmel.com> (sfid-20151013_125151_897648_3D78AECF)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8Ciphermode of struct host_if_wpa_attr to mode to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2ebd0cc..14a01ce 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -72,7 +72,7 @@ struct host_if_wpa_attr {
 	u8 seq_len;
 	u8 index;
 	u8 key_len;
-	u8 u8Ciphermode;
+	u8 mode;
 };
 
 struct host_if_wep_attr {
@@ -1897,7 +1897,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wpa.u8Ciphermode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wpa.mode));
 
 			strWIDList[1].id = (u16)WID_ADD_RX_GTK;
 			strWIDList[1].type = WID_STR;
@@ -1977,7 +1977,7 @@ _WPARxGtk_end_case_:
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wpa.u8Ciphermode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->attr.wpa.mode));
 
 			strWIDList[1].id = (u16)WID_ADD_PTK;
 			strWIDList[1].type = WID_STR;
@@ -3371,8 +3371,8 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	}
 
 	msg.body.key_info.attr.wpa.key_len = u8KeyLen;
-	msg.body.key_info.attr.wpa.u8Ciphermode = u8Ciphermode;
 	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
+	msg.body.key_info.attr.wpa.mode = u8Ciphermode;
 	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -3419,7 +3419,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
-		msg.body.key_info.attr.wpa.u8Ciphermode = u8Ciphermode;
+		msg.body.key_info.attr.wpa.mode = u8Ciphermode;
 	}
 	if (mode == STATION_MODE)
 		msg.body.key_info.action = ADDKEY;
-- 
1.9.1

