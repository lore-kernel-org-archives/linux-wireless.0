Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2502 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbbJMKvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:16 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/54] staging: wilc1000: rename pu8macaddr of struct host_if_wpa_attr
Date: Tue, 13 Oct 2015 19:49:31 +0900
Message-ID: <1444733419-17679-6-git-send-email-tony.cho@atmel.com> (sfid-20151013_125120_241084_8A3053DB)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8macaddr of struct host_if_wpa_attr to mac_addr to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 18a2723..29bd5bf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -67,7 +67,7 @@ struct cfg_param_attr {
 
 struct host_if_wpa_attr {
 	u8 *key;
-	const u8 *pu8macaddr;
+	const u8 *mac_addr;
 	u8 *pu8seq;
 	u8 u8seqlen;
 	u8 u8keyidx;
@@ -1968,7 +1968,7 @@ _WPARxGtk_end_case_:
 
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.pu8macaddr, 6);
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.u8keyidx, 1);
 			memcpy(pu8keybuf + 7, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
 			memcpy(pu8keybuf + 8, pstrHostIFkeyAttr->attr.wpa.key,
@@ -2003,7 +2003,7 @@ _WPARxGtk_end_case_:
 
 			}
 
-			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.pu8macaddr, 6);
+			memcpy(pu8keybuf, pstrHostIFkeyAttr->attr.wpa.mac_addr, 6);
 			memcpy(pu8keybuf + 6, &pstrHostIFkeyAttr->attr.wpa.u8Keylen, 1);
 			memcpy(pu8keybuf + 7, pstrHostIFkeyAttr->attr.wpa.key,
 				    pstrHostIFkeyAttr->attr.wpa.u8Keylen);
@@ -3372,7 +3372,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 
 	msg.body.key_info.attr.wpa.u8Keylen = u8KeyLen;
 	msg.body.key_info.attr.wpa.u8Ciphermode = u8Ciphermode;
-	msg.body.key_info.attr.wpa.pu8macaddr = mac_addr;
+	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
 	msg.drv = hif_drv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

