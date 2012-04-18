Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49570 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2DRRMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 13:12:20 -0400
Received: by wejx9 with SMTP id x9so4862925wej.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 10:12:19 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Cc: linville@tuxdriver.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH RFC 2/2] rt2x00: Add debugfs access for rfcsr register
Date: Wed, 18 Apr 2012 19:07:43 +0200
Message-Id: <1334768863-26839-2-git-send-email-anisse@astier.eu> (sfid-20120418_191223_373446_14AD6E69)
In-Reply-To: <1334768863-26839-1-git-send-email-anisse@astier.eu>
References: <1334768863-26839-1-git-send-email-anisse@astier.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RFCSR is only used on rt2800, use a stub for other chipsets

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
Please test this patch, I'd especially like feedback on chipsets other than rt2800pci.

Test procedure:

mount -t debugfs none /sys/kernel/debug/
cd /sys/kernel/debug/ieee80211/phy0/rt2800pci/register/
cat ../chipset
cat rfcsr_offset
cat rfcsr_value
#should fail:
echo 2 > rfcsr_offset


---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    7 +++++++
 drivers/net/wireless/rt2x00/rt2500pci.c   |    7 +++++++
 drivers/net/wireless/rt2x00/rt2500usb.c   |    7 +++++++
 drivers/net/wireless/rt2x00/rt2800.h      |    2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c   |    7 +++++++
 drivers/net/wireless/rt2x00/rt2x00debug.c |   12 ++++++++++++
 drivers/net/wireless/rt2x00/rt2x00debug.h |    1 +
 drivers/net/wireless/rt2x00/rt61pci.c     |    7 +++++++
 drivers/net/wireless/rt2x00/rt73usb.c     |    7 +++++++
 9 files changed, 57 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 3a6b402..3dba64c 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -197,6 +197,13 @@ static const struct rt2x00debug rt2400pci_rt2x00debug = {
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
+	.rfcsr	= {
+		.read		= NULL,
+		.write		= NULL,
+		.word_base	= 0,
+		.word_size	= 1,
+		.word_count	= 0,
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index dcc0e1f..9154dc1 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -197,6 +197,13 @@ static const struct rt2x00debug rt2500pci_rt2x00debug = {
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
+	.rfcsr	= {
+		.read		= NULL,
+		.write		= NULL,
+		.word_base	= 0,
+		.word_size	= 1,
+		.word_count	= 0,
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1de9c75..cd0b572 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -275,6 +275,13 @@ static const struct rt2x00debug rt2500usb_rt2x00debug = {
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
+	.rfcsr	= {
+		.read		= NULL,
+		.write		= NULL,
+		.word_base	= 0,
+		.word_size	= 1,
+		.word_count	= 0,
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index d91f4f6..a2321e9 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -102,6 +102,8 @@
 #define BBP_SIZE			0x00ff
 #define RF_BASE				0x0004
 #define RF_SIZE				0x0010
+#define RFCSR_BASE			0x0000
+#define RFCSR_SIZE			0x0000
 
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
index 78787fc..aa6d1f7 100644
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
@@ -640,6 +645,10 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 			debug->rf.word_base,
 			debug->rf.word_count,
 			debug->rf.word_size);
+	data += sprintf(data, "rfcsr\t%d\t%d\t%d\n",
+			debug->rf.word_base,
+			debug->rf.word_count,
+			debug->rf.word_size);
 	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
@@ -719,6 +728,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, eeprom);
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, bbp);
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, rf);
+	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, rfcsr);
 
 #undef RT2X00DEBUGFS_CREATE_REGISTER_ENTRY
 
@@ -770,6 +780,8 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
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
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index e0c6d11..1d5b0d9 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -235,6 +235,13 @@ static const struct rt2x00debug rt61pci_rt2x00debug = {
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
+	.rfcsr	= {
+		.read		= NULL,
+		.write		= NULL,
+		.word_base	= 0,
+		.word_size	= 1,
+		.word_count	= 0,
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e477a96..1ecc54d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -181,6 +181,13 @@ static const struct rt2x00debug rt73usb_rt2x00debug = {
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
 	},
+	.rfcsr	= {
+		.read		= NULL,
+		.write		= NULL,
+		.word_base	= 0,
+		.word_size	= 1,
+		.word_count	= 0,
+	},
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-- 
1.7.9.4

