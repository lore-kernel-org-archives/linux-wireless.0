Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62191 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2D3Qim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 12:38:42 -0400
Received: by wibhq7 with SMTP id hq7so3067500wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 09:38:41 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>, linville@tuxdriver.com,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH v5 2/3] rt2x00: debugfs support - allow a register to be empty
Date: Mon, 30 Apr 2012 18:33:32 +0200
Message-Id: <1335803613-1253-3-git-send-email-anisse@astier.eu> (sfid-20120430_183852_216489_C231E116)
In-Reply-To: <1335803613-1253-1-git-send-email-anisse@astier.eu>
References: <1335803613-1253-1-git-send-email-anisse@astier.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow a register to be unspecified, therefore not creating its debugfs
file entry.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   71 +++++++++++++++--------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 78787fc..5bb1221 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -624,22 +624,21 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	data += sprintf(data, "revision:\t%04x\n", intf->rt2x00dev->chip.rev);
 	data += sprintf(data, "\n");
 	data += sprintf(data, "register\tbase\twords\twordsize\n");
-	data += sprintf(data, "csr\t%d\t%d\t%d\n",
-			debug->csr.word_base,
-			debug->csr.word_count,
-			debug->csr.word_size);
-	data += sprintf(data, "eeprom\t%d\t%d\t%d\n",
-			debug->eeprom.word_base,
-			debug->eeprom.word_count,
-			debug->eeprom.word_size);
-	data += sprintf(data, "bbp\t%d\t%d\t%d\n",
-			debug->bbp.word_base,
-			debug->bbp.word_count,
-			debug->bbp.word_size);
-	data += sprintf(data, "rf\t%d\t%d\t%d\n",
-			debug->rf.word_base,
-			debug->rf.word_count,
-			debug->rf.word_size);
+#define RT2X00DEBUGFS_SPRINTF_REGISTER(__name)			\
+{								\
+	if(debug->__name.read)					\
+		data += sprintf(data, __stringify(__name)	\
+				"\t%d\t%d\t%d\n",		\
+				debug->__name.word_base,	\
+				debug->__name.word_count,	\
+				debug->__name.word_size);	\
+}
+	RT2X00DEBUGFS_SPRINTF_REGISTER(csr);
+	RT2X00DEBUGFS_SPRINTF_REGISTER(eeprom);
+	RT2X00DEBUGFS_SPRINTF_REGISTER(bbp);
+	RT2X00DEBUGFS_SPRINTF_REGISTER(rf);
+#undef RT2X00DEBUGFS_SPRINTF_REGISTER
+
 	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
@@ -694,25 +693,27 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->register_folder) || !intf->register_folder)
 		goto exit;
 
-#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)	\
-({								\
-	(__intf)->__name##_off_entry =				\
-	    debugfs_create_u32(__stringify(__name) "_offset",	\
-			       S_IRUSR | S_IWUSR,		\
-			       (__intf)->register_folder,	\
-			       &(__intf)->offset_##__name);	\
-	if (IS_ERR((__intf)->__name##_off_entry)		\
-			|| !(__intf)->__name##_off_entry)	\
-		goto exit;					\
-								\
-	(__intf)->__name##_val_entry =				\
-	    debugfs_create_file(__stringify(__name) "_value",	\
-				S_IRUSR | S_IWUSR,		\
-				(__intf)->register_folder,	\
-				(__intf), &rt2x00debug_fop_##__name);\
-	if (IS_ERR((__intf)->__name##_val_entry)		\
-			|| !(__intf)->__name##_val_entry)	\
-		goto exit;					\
+#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)			\
+({										\
+	if(debug->__name.read) {						\
+		(__intf)->__name##_off_entry =					\
+		debugfs_create_u32(__stringify(__name) "_offset",		\
+				       S_IRUSR | S_IWUSR,			\
+				       (__intf)->register_folder,		\
+				       &(__intf)->offset_##__name);		\
+		if (IS_ERR((__intf)->__name##_off_entry)			\
+				|| !(__intf)->__name##_off_entry)		\
+			goto exit;						\
+										\
+		(__intf)->__name##_val_entry =					\
+		debugfs_create_file(__stringify(__name) "_value",		\
+					S_IRUSR | S_IWUSR,			\
+					(__intf)->register_folder,		\
+					(__intf), &rt2x00debug_fop_##__name);	\
+		if (IS_ERR((__intf)->__name##_val_entry)			\
+				|| !(__intf)->__name##_val_entry)		\
+			goto exit;						\
+	}									\
 })
 
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, csr);
-- 
1.7.9.4

