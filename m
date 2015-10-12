Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13645 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbJLIAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 04:00:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 37/41] staging: wilc1000: rename pu8WepKey of struct host_if_wep_attr
Date: Mon, 12 Oct 2015 16:56:11 +0900
Message-ID: <1444636575-2486-37-git-send-email-tony.cho@atmel.com> (sfid-20151012_100041_594923_E7833972)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8WepKey of struct host_if_wep_attr to key in order
to avoid CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3437d8c..b331a7b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -108,7 +108,7 @@ struct host_if_wpa_attr {
  *  @version		1.0
  */
 struct host_if_wep_attr {
-	u8 *pu8WepKey;
+	u8 *key;
 	u8 u8WepKeylen;
 	u8 u8Wepidx;
 	u8 u8mode;
@@ -2375,11 +2375,11 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 				return -1;
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.pu8WepKey,
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen);
 
 
-			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.pu8WepKey);
+			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key);
 
 			strWIDList[3].id = (u16)WID_WEP_KEY_VALUE;
 			strWIDList[3].type = WID_STR;
@@ -2405,10 +2405,10 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen, 1);
 
-			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.pu8WepKey,
+			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key,
 				    pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8WepKeylen);
 
-			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.pu8WepKey);
+			kfree(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.key);
 
 			strWID.id = (u16)WID_ADD_WEP_KEY;
 			strWID.type = WID_STR;
@@ -4193,9 +4193,9 @@ s32 host_int_add_wep_key_bss_sta(struct host_if_drv *hif_drv,
 
 
 	msg.body.key_info.
-	uniHostIFkeyAttr.wep.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
+	uniHostIFkeyAttr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
 
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.wep.pu8WepKey,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.wep.key,
 		    pu8WepKey, u8WepKeylen);
 
 
@@ -4261,10 +4261,10 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 
 	msg.body.key_info.
-	uniHostIFkeyAttr.wep.pu8WepKey = kmalloc(u8WepKeylen, GFP_KERNEL);
+	uniHostIFkeyAttr.wep.key = kmalloc(u8WepKeylen, GFP_KERNEL);
 
 
-	memcpy(msg.body.key_info.uniHostIFkeyAttr.wep.pu8WepKey,
+	memcpy(msg.body.key_info.uniHostIFkeyAttr.wep.key,
 		    pu8WepKey, (u8WepKeylen));
 
 
-- 
1.9.1

