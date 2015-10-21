Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44438 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbbJUXHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 19:07:50 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] staging: wilc1000: return -ENOMEM when kmalloc failed
Date: Thu, 22 Oct 2015 00:07:36 +0100
Message-Id: <1445468856-18931-1-git-send-email-luisbg@osg.samsung.com> (sfid-20151022_010808_403118_7C6FBB73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver is using -1 instead of the -ENOMEM defined macro to specify that
a buffer allocation failed.

Fixes smatch warning and similars:
drivers/staging/wilc1000/host_interface.c:1782 Handle_Key() warn:
returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 38fead4..ec47a28 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1756,7 +1756,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
-				return -1;
+				return -ENOMEM;
 			}
 
 			kfree(pstrHostIFkeyAttr->attr.wep.key);
@@ -1779,7 +1779,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
-				return -1;
+				return -ENOMEM;
 			}
 			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
 			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->attr.wep.key_len, 1);
@@ -1826,7 +1826,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
-				ret = -1;
+				ret = -ENOMEM;
 				goto _WPARxGtk_end_case_;
 			}
 
@@ -1861,7 +1861,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
-				ret = -1;
+				ret = -ENOMEM;
 				goto _WPARxGtk_end_case_;
 			}
 
@@ -1890,7 +1890,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 _WPARxGtk_end_case_:
 		kfree(pstrHostIFkeyAttr->attr.wpa.key);
 		kfree(pstrHostIFkeyAttr->attr.wpa.seq);
-		if (ret == -1)
+		if (ret)
 			return ret;
 
 		break;
@@ -1905,7 +1905,7 @@ _WPARxGtk_end_case_:
 
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send PTK Key\n");
-				ret = -1;
+				ret = -ENOMEM;
 				goto _WPAPtk_end_case_;
 
 			}
@@ -1940,7 +1940,7 @@ _WPARxGtk_end_case_:
 
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send PTK Key\n");
-				ret = -1;
+				ret = -ENOMEM;
 				goto _WPAPtk_end_case_;
 
 			}
@@ -1963,7 +1963,7 @@ _WPARxGtk_end_case_:
 
 _WPAPtk_end_case_:
 		kfree(pstrHostIFkeyAttr->attr.wpa.key);
-		if (ret == -1)
+		if (ret)
 			return ret;
 
 		break;
@@ -1976,7 +1976,7 @@ _WPAPtk_end_case_:
 		pu8keybuf = kmalloc((pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
 		if (pu8keybuf == NULL) {
 			PRINT_ER("No buffer to send PMKSA Key\n");
-			return -1;
+			return -ENOMEM;
 		}
 
 		pu8keybuf[0] = pstrHostIFkeyAttr->attr.pmkid.numpmkid;
-- 
2.5.1

