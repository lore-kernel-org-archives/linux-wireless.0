Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:23631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXK0Tjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:39:46 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1321058ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:39:45 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/11] rt2x00: Add chipset version to chipset debugfs entry
Date: Tue, 27 Nov 2007 21:48:37 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272148.37470.IvDoorn@gmail.com> (sfid-20071127_194249_297375_B1DC2E0C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chipset debugfs entry already indicates it is about the chipset,
it only makes sense to also display the chipset version in there.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 92efc5a..3aa7e0a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -251,16 +251,21 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	const struct rt2x00debug *debug = intf->debug;
 	char *data;
 
-	data = kzalloc(4 * PRINT_LINE_LEN_MAX, GFP_KERNEL);
+	data = kzalloc(8 * PRINT_LINE_LEN_MAX, GFP_KERNEL);
 	if (!data)
 		return NULL;
 
-	blob->data = data;
+	data += sprintf(data, "rt chip: %04x\n", intf->rt2x00dev->chip.rt);
+	data += sprintf(data, "rf chip: %04x\n", intf->rt2x00dev->chip.rf);
+	data += sprintf(data, "revision:%08x\n", intf->rt2x00dev->chip.rev);
+	data += sprintf(data, "\n");
 	data += sprintf(data, "csr length: %d\n", debug->csr.word_count);
 	data += sprintf(data, "eeprom length: %d\n", debug->eeprom.word_count);
 	data += sprintf(data, "bbp length: %d\n", debug->bbp.word_count);
 	data += sprintf(data, "rf length: %d\n", debug->rf.word_count);
-	blob->size = strlen(blob->data);
+
+	blob->data = data;
+	blob->size = strlen(data);
 
 	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
 }
-- 
1.5.3.6

