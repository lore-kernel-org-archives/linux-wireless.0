Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:38346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbXIPMIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:30 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1643781wah
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:30 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/24] rt2x00: macro's shouldn't use hidden arguments
Date: Sun, 16 Sep 2007 14:19:23 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.25132.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RT2X00DEBUGFS_CREATE_ENTRY used the intf variable
while this wasn't passed as argument. That can be
considered as a bad coding style.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index eaa4c54..4d2aaec 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -270,29 +270,29 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->chipset_entry))
 		goto exit;
 
-#define RT2X00DEBUGFS_CREATE_ENTRY(__name)			\
+#define RT2X00DEBUGFS_CREATE_ENTRY(__intf, __name)		\
 ({								\
-	intf->__name##_off_entry =				\
+	(__intf)->__name##_off_entry =				\
 	    debugfs_create_u32(__stringify(__name) "_offset",	\
 			       S_IRUGO | S_IWUSR,		\
-			       intf->driver_folder,		\
-			       &intf->offset_##__name);		\
-	if (IS_ERR(intf->__name##_off_entry))			\
+			       (__intf)->driver_folder,		\
+			       &(__intf)->offset_##__name);	\
+	if (IS_ERR((__intf)->__name##_off_entry))		\
 		goto exit;					\
 								\
-	intf->__name##_val_entry =				\
+	(__intf)->__name##_val_entry =				\
 	    debugfs_create_file(__stringify(__name) "_value",	\
 				S_IRUGO | S_IWUSR,		\
-				intf->driver_folder,		\
-				intf, &rt2x00debug_fop_##__name);\
-	if (IS_ERR(intf->__name##_val_entry))			\
+				(__intf)->driver_folder,	\
+				(__intf), &rt2x00debug_fop_##__name);\
+	if (IS_ERR((__intf)->__name##_val_entry))		\
 		goto exit;					\
 })
 
-	RT2X00DEBUGFS_CREATE_ENTRY(csr);
-	RT2X00DEBUGFS_CREATE_ENTRY(eeprom);
-	RT2X00DEBUGFS_CREATE_ENTRY(bbp);
-	RT2X00DEBUGFS_CREATE_ENTRY(rf);
+	RT2X00DEBUGFS_CREATE_ENTRY(intf, csr);
+	RT2X00DEBUGFS_CREATE_ENTRY(intf, eeprom);
+	RT2X00DEBUGFS_CREATE_ENTRY(intf, bbp);
+	RT2X00DEBUGFS_CREATE_ENTRY(intf, rf);
 
 #undef RT2X00DEBUGFS_CREATE_ENTRY
 
-- 
1.5.3
