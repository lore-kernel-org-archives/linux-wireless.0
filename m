Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13818 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbJLIBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 04:01:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 41/41] staging: wilc1000: rename tenuAuth_type of struct host_if_wep_attr
Date: Mon, 12 Oct 2015 16:56:15 +0900
Message-ID: <1444636575-2486-41-git-send-email-tony.cho@atmel.com> (sfid-20151012_100110_147585_E1C3649E)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames tenuAuth_type of struct host_if_wep_attr to auth_type
to avoid CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index edea265..ec04aec 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -112,7 +112,7 @@ struct host_if_wep_attr {
 	u8 key_len;
 	u8 index;
 	u8 mode;
-	enum AUTHTYPE tenuAuth_type;
+	enum AUTHTYPE auth_type;
 };
 
 /*!
@@ -2358,7 +2358,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			strWIDList[1].id = WID_AUTH_TYPE;
 			strWIDList[1].type = WID_CHAR;
 			strWIDList[1].size = sizeof(char);
-			strWIDList[1].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.tenuAuth_type));
+			strWIDList[1].val = (s8 *)(&(pstrHostIFkeyAttr->uniHostIFkeyAttr.wep.auth_type));
 
 			strWIDList[2].id = (u16)WID_KEY_ID;
 			strWIDList[2].type = WID_CHAR;
@@ -4274,7 +4274,7 @@ s32 host_int_add_wep_key_bss_ap(struct host_if_drv *hif_drv,
 
 	msg.body.key_info.uniHostIFkeyAttr.wep.mode = u8mode;
 
-	msg.body.key_info.uniHostIFkeyAttr.wep.tenuAuth_type = tenuAuth_type;
+	msg.body.key_info.uniHostIFkeyAttr.wep.auth_type = tenuAuth_type;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 
-- 
1.9.1

