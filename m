Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65306 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab2DSN5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:57:45 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so8656426wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 06:57:44 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: Ivo van Doorn <IvDoorn@gmail.com>, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Cc: linville@tuxdriver.com, Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH v3 2/2] rt2x00: Add debugfs access for rfcsr register
Date: Thu, 19 Apr 2012 15:53:10 +0200
Message-Id: <1334843590-7920-2-git-send-email-anisse@astier.eu> (sfid-20120419_155748_694119_69B6348C)
In-Reply-To: <1334843590-7920-1-git-send-email-anisse@astier.eu>
References: <CAOZOX0UXc0OwhWOiM0PWbGfyynmrQ4kZRAVFJyxtiHe-veUg=g@mail.gmail.com>
 <1334843590-7920-1-git-send-email-anisse@astier.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RFCSR is only used in rt2800. For other chipsets, the debug struct
for rfcsr should be zeroed, which isn't be an issue, since the code
can now cope with that.

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
 drivers/net/wireless/rt2x00/rt2800.h      |    2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c   |    7 +++++++
 drivers/net/wireless/rt2x00/rt2x00debug.c |   11 ++++++++++-
 drivers/net/wireless/rt2x00/rt2x00debug.h |    1 +
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index d91f4f6..9348521 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -102,6 +102,8 @@
 #define BBP_SIZE			0x00ff
 #define RF_BASE				0x0004
 #define RF_SIZE				0x0010
+#define RFCSR_BASE			0x0000
+#define RFCSR_SIZE			0x0040
 
 /*
  * Number of TX queues.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6c95101..0cdbf2b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -836,6 +836,13 @@ const struct rt2x00debug rt2800_rt2x00debug = {
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
+	.rfcsr	= {
+		.read		= rt2800_rfcsr_read,
+		.write		= rt2800_rfcsr_write,
+		.word_base	= RFCSR_BASE,
+		.word_size	= sizeof(u8),
+		.word_count	= RFCSR_SIZE / sizeof(u8),
+	},
 };
 EXPORT_SYMBOL_GPL(rt2800_rt2x00debug);
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index ac898c4..74f6ed5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -70,6 +70,7 @@ struct rt2x00debug_intf {
 	 *     - eeprom offset/value files
 	 *     - bbp offset/value files
 	 *     - rf offset/value files
+	 *     - rfcsr offset/value files
 	 *   - queue folder
 	 *     - frame dump file
 	 *     - queue stats file
@@ -89,6 +90,8 @@ struct rt2x00debug_intf {
 	struct dentry *bbp_val_entry;
 	struct dentry *rf_off_entry;
 	struct dentry *rf_val_entry;
+	struct dentry *rfcsr_off_entry;
+	struct dentry *rfcsr_val_entry;
 	struct dentry *queue_folder;
 	struct dentry *queue_frame_dump_entry;
 	struct dentry *queue_stats_entry;
@@ -131,6 +134,7 @@ struct rt2x00debug_intf {
 	unsigned int offset_eeprom;
 	unsigned int offset_bbp;
 	unsigned int offset_rf;
+	unsigned int offset_rfcsr;
 };
 
 void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
@@ -525,6 +529,7 @@ RT2X00DEBUGFS_OPS(csr, "0x%.8x\n", u32);
 RT2X00DEBUGFS_OPS(eeprom, "0x%.4x\n", u16);
 RT2X00DEBUGFS_OPS(bbp, "0x%.2x\n", u8);
 RT2X00DEBUGFS_OPS(rf, "0x%.8x\n", u32);
+RT2X00DEBUGFS_OPS(rfcsr, "0x%.2x\n", u8);
 
 static ssize_t rt2x00debug_read_dev_flags(struct file *file,
 					  char __user *buf,
@@ -614,7 +619,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	const struct rt2x00debug *debug = intf->debug;
 	char *data;
 
-	data = kzalloc(8 * MAX_LINE_LENGTH, GFP_KERNEL);
+	data = kzalloc(9 * MAX_LINE_LENGTH, GFP_KERNEL);
 	if (!data)
 		return NULL;
 
@@ -637,6 +642,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	RT2X00DEBUGFS_SPRINTF_REGISTER(eeprom);
 	RT2X00DEBUGFS_SPRINTF_REGISTER(bbp);
 	RT2X00DEBUGFS_SPRINTF_REGISTER(rf);
+	RT2X00DEBUGFS_SPRINTF_REGISTER(rfcsr);
 #undef RT2X00DEBUGFS_SPRINTF_REGISTER
 
 	blob->size = strlen(blob->data);
@@ -722,6 +728,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, eeprom);
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, bbp);
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, rf);
+	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, rfcsr);
 
 #undef RT2X00DEBUGFS_CREATE_REGISTER_ENTRY
 
@@ -773,6 +780,8 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 	debugfs_remove(intf->queue_stats_entry);
 	debugfs_remove(intf->queue_frame_dump_entry);
 	debugfs_remove(intf->queue_folder);
+	debugfs_remove(intf->rfcsr_val_entry);
+	debugfs_remove(intf->rfcsr_off_entry);
 	debugfs_remove(intf->rf_val_entry);
 	debugfs_remove(intf->rf_off_entry);
 	debugfs_remove(intf->bbp_val_entry);
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.h b/drivers/net/wireless/rt2x00/rt2x00debug.h
index fa11409..e11d39b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.h
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.h
@@ -65,6 +65,7 @@ struct rt2x00debug {
 	RT2X00DEBUGFS_REGISTER_ENTRY(eeprom, u16);
 	RT2X00DEBUGFS_REGISTER_ENTRY(bbp, u8);
 	RT2X00DEBUGFS_REGISTER_ENTRY(rf, u32);
+	RT2X00DEBUGFS_REGISTER_ENTRY(rfcsr, u8);
 };
 
 #endif /* RT2X00DEBUG_H */
-- 
1.7.9.4

