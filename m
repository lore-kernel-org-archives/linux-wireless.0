Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29864 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbcBVERV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:17:21 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V3 16/24] staging: wilc1000: host_interface.c: removes unnecessary log messages
Date: Mon, 22 Feb 2016 13:12:01 +0900
Message-ID: <1456114329-7036-17-git-send-email-leo.kim@atmel.com> (sfid-20160222_051724_217934_3D9E1DEF)
In-Reply-To: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
References: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log messages.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index eddc0d6..a827e06 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1637,11 +1637,8 @@ static int Handle_Key(struct wilc_vif *vif,
 
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2,
 					    GFP_KERNEL);
-
-			if (pu8keybuf == NULL) {
-				PRINT_ER("No buffer to send Key\n");
+			if (!pu8keybuf)
 				return -ENOMEM;
-			}
 
 			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
 			pu8keybuf[1] = pstrHostIFkeyAttr->attr.wep.key_len;
@@ -1662,10 +1659,8 @@ static int Handle_Key(struct wilc_vif *vif,
 			kfree(pu8keybuf);
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2, GFP_KERNEL);
-			if (!pu8keybuf) {
-				PRINT_ER("No buffer to send Key\n");
+			if (!pu8keybuf)
 				return -ENOMEM;
-			}
 			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
 			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->attr.wep.key_len, 1);
 			memcpy(pu8keybuf + 2, pstrHostIFkeyAttr->attr.wep.key,
@@ -1709,7 +1704,6 @@ static int Handle_Key(struct wilc_vif *vif,
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
-				PRINT_ER("No buffer to send RxGTK Key\n");
 				ret = -ENOMEM;
 				goto _WPARxGtk_end_case_;
 			}
@@ -1741,7 +1735,6 @@ static int Handle_Key(struct wilc_vif *vif,
 		} else if (pstrHostIFkeyAttr->action & ADDKEY) {
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
-				PRINT_ER("No buffer to send RxGTK Key\n");
 				ret = -ENOMEM;
 				goto _WPARxGtk_end_case_;
 			}
@@ -1781,7 +1774,6 @@ _WPARxGtk_end_case_:
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!pu8keybuf) {
-				PRINT_ER("No buffer to send PTK Key\n");
 				ret = -ENOMEM;
 				goto _WPAPtk_end_case_;
 			}
-- 
1.9.1

