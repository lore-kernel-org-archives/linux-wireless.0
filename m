Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2384 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbbJMKut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:50:49 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/54] staging: wilc1000: rename enuKeyType of struct key_attr
Date: Tue, 13 Oct 2015 19:49:27 +0900
Message-ID: <1444733419-17679-2-git-send-email-tony.cho@atmel.com> (sfid-20151013_125056_211882_6F75BB77)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames enuKeyType of struct key_attr to type to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 15b2770..aeb28a1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -90,7 +90,7 @@ union host_if_key_attr {
 };
 
 struct key_attr {
-	enum KEY_TYPE enuKeyType;
+	enum KEY_TYPE type;
 	u8 u8KeyAction;
 	union host_if_key_attr uniHostIFkeyAttr;
 };
@@ -1778,7 +1778,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 	s8 s8idxarray[1];
 	s8 ret = 0;
 
-	switch (pstrHostIFkeyAttr->enuKeyType) {
+	switch (pstrHostIFkeyAttr->type) {
 
 
 	case WEP:
@@ -3210,7 +3210,7 @@ int host_int_remove_wep_key(struct host_if_drv *hif_drv, u8 index)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.enuKeyType = WEP;
+	msg.body.key_info.type = WEP;
 	msg.body.key_info.u8KeyAction = REMOVEKEY;
 	msg.drv = hif_drv;
 	msg.body.key_info.uniHostIFkeyAttr.wep.index = index;
@@ -3239,7 +3239,7 @@ s32 host_int_set_WEPDefaultKeyID(struct host_if_drv *hif_drv, u8 u8Index)
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.enuKeyType = WEP;
+	msg.body.key_info.type = WEP;
 	msg.body.key_info.u8KeyAction = DEFAULTKEY;
 	msg.drv = hif_drv;
 
@@ -3273,7 +3273,7 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.enuKeyType = WEP;
+	msg.body.key_info.type = WEP;
 	msg.body.key_info.u8KeyAction = ADDKEY;
 	msg.drv = hif_drv;
 
@@ -3323,7 +3323,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 			PRINT_INFO(HOSTAPD_DBG, "KEY is %x\n", pu8WepKey[i]);
 	}
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.enuKeyType = WEP;
+	msg.body.key_info.type = WEP;
 	msg.body.key_info.u8KeyAction = ADDKEY_AP;
 	msg.drv = hif_drv;
 
@@ -3378,7 +3378,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.enuKeyType = WPAPtk;
+	msg.body.key_info.type = WPAPtk;
 	if (mode == AP_MODE) {
 		msg.body.key_info.u8KeyAction = ADDKEY_AP;
 		msg.body.key_info.uniHostIFkeyAttr.wpa.u8keyidx = u8Idx;
@@ -3461,7 +3461,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.enuKeyType = WPARxGtk;
+	msg.body.key_info.type = WPARxGtk;
 	msg.drv = hif_drv;
 
 	if (mode == AP_MODE) {
@@ -3521,7 +3521,7 @@ s32 host_int_set_pmkid_info(struct host_if_drv *hif_drv, struct host_if_pmkid_at
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.enuKeyType = PMKSA;
+	msg.body.key_info.type = PMKSA;
 	msg.body.key_info.u8KeyAction = ADDKEY;
 	msg.drv = hif_drv;
 
-- 
1.9.1

