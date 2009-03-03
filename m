Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:57809 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbZCCROY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:14:24 -0500
Received: by ewy25 with SMTP id 25so2411001ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2009 09:14:22 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Export all register stats through debugfs
Date: Tue, 3 Mar 2009 18:14:18 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903031814.19074.IvDoorn@gmail.com> (sfid-20090303_181448_381445_3B2B9523)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By exporting the register base, and word size to userspace
through debugfs it will be easier to create scripts which
parse the register information. This makes debugging and
register dumps information easier.

This will break my previous scripts which dumped and parsed
all information, but since this is only for debugging purposes
this change should not be a problem.

Dumpfiles created with the old version can be easily manually
edited to make them compatible with this new approach, which
means there will be no problems comparing dumps from the
different versions either.

Also be more consistent with using tabs to seperate different
fields.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   33 ++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index dcdce7f..1c0f8bf 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -545,9 +545,9 @@ static struct dentry *rt2x00debug_create_file_driver(const char *name,
 		return NULL;
 
 	blob->data = data;
-	data += sprintf(data, "driver: %s\n", intf->rt2x00dev->ops->name);
-	data += sprintf(data, "version: %s\n", DRV_VERSION);
-	data += sprintf(data, "compiled: %s %s\n", __DATE__, __TIME__);
+	data += sprintf(data, "driver:\t%s\n", intf->rt2x00dev->ops->name);
+	data += sprintf(data, "version:\t%s\n", DRV_VERSION);
+	data += sprintf(data, "compiled:\t%s %s\n", __DATE__, __TIME__);
 	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
@@ -568,14 +568,27 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 		return NULL;
 
 	blob->data = data;
-	data += sprintf(data, "rt chip: %04x\n", intf->rt2x00dev->chip.rt);
-	data += sprintf(data, "rf chip: %04x\n", intf->rt2x00dev->chip.rf);
-	data += sprintf(data, "revision:%08x\n", intf->rt2x00dev->chip.rev);
+	data += sprintf(data, "rt chip:\t%04x\n", intf->rt2x00dev->chip.rt);
+	data += sprintf(data, "rf chip:\t%04x\n", intf->rt2x00dev->chip.rf);
+	data += sprintf(data, "revision:\t%08x\n", intf->rt2x00dev->chip.rev);
 	data += sprintf(data, "\n");
-	data += sprintf(data, "csr length: %d\n", debug->csr.word_count);
-	data += sprintf(data, "eeprom length: %d\n", debug->eeprom.word_count);
-	data += sprintf(data, "bbp length: %d\n", debug->bbp.word_count);
-	data += sprintf(data, "rf length: %d\n", debug->rf.word_count);
+	data += sprintf(data, "register\tbase\twords\twordsize\n");
+	data += sprintf(data, "csr\t%d\t%d\t%d\n",
+			debug->csr.word_base,
+			debug->csr.word_count,
+			debug->csr.word_size);
+	data += sprintf(data, "eeprom\t%d\t%d\t%d\n",
+			debug->eeprom.word_base,
+			debug->eeprom.word_count,
+			debug->eeprom.word_size);
+	data += sprintf(data, "bbp\t%d\t%d\t%d\n",
+			debug->bbp.word_base,
+			debug->bbp.word_count,
+			debug->bbp.word_size);
+	data += sprintf(data, "rf\t%d\t%d\t%d\n",
+			debug->rf.word_base,
+			debug->rf.word_count,
+			debug->rf.word_size);
 	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
-- 
1.5.6.1

