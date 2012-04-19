Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65306 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab2DSN5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:57:42 -0400
Received: by wgbdr13 with SMTP id dr13so8656426wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 06:57:41 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: Ivo van Doorn <IvDoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Cc: linville@tuxdriver.com, Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH v3 1/2] rt2x00: debugfs support - allow a register to be empty
Date: Thu, 19 Apr 2012 15:53:09 +0200
Message-Id: <1334843590-7920-1-git-send-email-anisse@astier.eu> (sfid-20120419_155746_461265_BE5DB72B)
In-Reply-To: <CAOZOX0UXc0OwhWOiM0PWbGfyynmrQ4kZRAVFJyxtiHe-veUg=g@mail.gmail.com>
References: <CAOZOX0UXc0OwhWOiM0PWbGfyynmrQ4kZRAVFJyxtiHe-veUg=g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow a register to be unspecified, therefore not creating its debugfs
file entry.

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
Changes since v2:
Acked patch not resent (BBP size), and split the second patch in two to
incorporate changes suggested by Ivo Van Doorn (thanks for the review!) :
 - first part (this patch) now is only a small rewrite of the code to
   initialize only the supported register. Any unsupported register wouldn't
   have its files created.
 - first patch best viewed ignoring spaces ((git) diff -w)
 - second part is effectively adding RFCSR support.
 - we allocate more data for sprintf since we add a new register.
 - Updated test procedure (see below)
Changes since v1:
 - removed initialization in chipsets other than rt2800, we now rely on
   default initialization.
 - added comments to make this explicit
 - fix rfcsr size (64)
 - fix pre-review bug thanks to Ivo Van Doorn


How to test ?
I'd like feedback on chipsets other than rt2800pci.

Test procedure:
mount -t debugfs none /sys/kernel/debug/
cd /sys/kernel/debug/ieee80211/phy0/rt2800pci/
cat chipset # shouldn't have any "rfcsr" line if not rt2800
ls register # shouldn't have any rfcsr_* file if not rt2800

---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   73 +++++++++++++++--------------
 1 file changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 78787fc..ac898c4 100644
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
@@ -694,25 +693,29 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
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
+	} else									\
+		DEBUG(rt2x00dev, "Unsupported register on this device: "	\
+			__stringify(__name) "\n");				\
 })
 
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, csr);
-- 
1.7.9.4

