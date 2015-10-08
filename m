Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:38299 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbbJHJMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 05:12:16 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/11] staging: wilc1000: rename u8mode of struct host_if_wep_attr
Date: Thu, 8 Oct 2015 18:10:55 +0900
Message-ID: <1444295456-25818-10-git-send-email-tony.cho@atmel.com> (sfid-20151008_111224_592786_FD59ADA4)
In-Reply-To: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
References: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8mode of struct host_if_wep_attr to mode to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e99db7d..97290c8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -110,7 +110,7 @@ struct host_if_wep_attr {
 	u8 *key;
 	u8 key_len;
 	u8 index;
-	u8 u8mode;
+	u8 mode;
 	enum AUTHTYPE tenuAuth_type;
 };
 
@@ -2354,7 +2354,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[0].id = (u16)WID_11I_MODE;
 			strWIDList[0].type = WID_CHAR;
 			strWIDList[0].size = sizeof(char);
-			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.u8mode));
+			strWIDList[0].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.mode));
 
 			strWIDList[1].id = WID_AUTH_TYPE;
 			strWIDList[1].type = WID_CHAR;
@@ -4279,7 +4279,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.index = u8Keyidx;
 
-	msg.body.key_info.uniHostIFkeyAttr.wep.u8mode = u8mode;
+	msg.body.key_info.uniHostIFkeyAttr.wep.mode = u8mode;
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.tenuAuth_type = tenuAuth_type;
 	/* send the message */
-- 
1.9.1

