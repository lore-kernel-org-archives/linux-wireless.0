Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53178 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbbJZFxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 01:53:17 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [RESEND PATCH] staging: wilc1000: return -ENOMEM when kmalloc failed
Date: Mon, 26 Oct 2015 05:52:50 +0000
Message-Id: <1445838770-10882-1-git-send-email-luisbg@osg.samsung.com> (sfid-20151026_065335_729421_86AFCC4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver is using -1 instead of the -ENOMEM defined macro to specify that
a buffer allocation failed.

Fixes smatch warning and similars:
drivers/staging/wilc1000/host_interface.c:1757 Handle_Key() warn:
returning -1 instead of -ENOMEM is sloppy

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

Resending because previous version didn't apply against staging-next due to the
recent changes on this file. Refreshed.

Thanks,
Luis

 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5f81eab..064e34c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1754,7 +1754,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send Key\n");
-				return -1;
+				return -ENOMEM;
 			}
 
 			kfree(pstrHostIFkeyAttr->attr.wep.key);
@@ -1776,7 +1776,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			pu8keybuf = kmalloc(pstrHostIFkeyAttr->attr.wep.key_len + 2, GFP_KERNEL);
 			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send Key\n");
-				return -1;
+				return -ENOMEM;
 			}
 			pu8keybuf[0] = pstrHostIFkeyAttr->attr.wep.index;
 			memcpy(pu8keybuf + 1, &pstrHostIFkeyAttr->attr.wep.key_len, 1);
@@ -1823,7 +1823,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
-				ret = -1;
+				ret = -ENOMEM;
 				goto _WPARxGtk_end_case_;
 			}
 
@@ -1858,7 +1858,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (pu8keybuf == NULL) {
 				PRINT_ER("No buffer to send RxGTK Key\n");
-				ret = -1;
+				ret = -ENOMEM;
 				goto _WPARxGtk_end_case_;
 			}
 
@@ -1887,7 +1887,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 _WPARxGtk_end_case_:
 		kfree(pstrHostIFkeyAttr->attr.wpa.key);
 		kfree(pstrHostIFkeyAttr->attr.wpa.seq);
-		if (ret == -1)
+		if (ret)
 			return ret;
 
 		break;
@@ -1899,7 +1899,7 @@ _WPARxGtk_end_case_:
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send PTK Key\n");
-				ret = -1;
+				ret = -ENOMEM;
 				goto _WPAPtk_end_case_;
 
 			}
@@ -1931,7 +1931,7 @@ _WPARxGtk_end_case_:
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
 				PRINT_ER("No buffer to send PTK Key\n");
-				ret = -1;
+				ret = -ENOMEM;
 				goto _WPAPtk_end_case_;
 
 			}
@@ -1954,7 +1954,7 @@ _WPARxGtk_end_case_:
 
 _WPAPtk_end_case_:
 		kfree(pstrHostIFkeyAttr->attr.wpa.key);
-		if (ret == -1)
+		if (ret)
 			return ret;
 
 		break;
@@ -1967,7 +1967,7 @@ _WPAPtk_end_case_:
 		pu8keybuf = kmalloc((pstrHostIFkeyAttr->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
 		if (!pu8keybuf) {
 			PRINT_ER("No buffer to send PMKSA Key\n");
-			return -1;
+			return -ENOMEM;
 		}
 
 		pu8keybuf[0] = pstrHostIFkeyAttr->attr.pmkid.numpmkid;
-- 
2.5.1

