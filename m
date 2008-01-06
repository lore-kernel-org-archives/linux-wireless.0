Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:28092 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958AbYAFWjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:39:51 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071048ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:39:49 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/12] rt2x00: Fix chipset debugfs file
Date: Sun, 6 Jan 2008 23:38:10 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062338.11124.IvDoorn@gmail.com> (sfid-20080106_224004_907943_88691AE1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize blob->data before moving the data pointer
Initialize blob->size based on blob->data size

This fixes the empty chipset file in debugfs.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index e72c981..c55bf0e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -417,6 +417,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	if (!data)
 		return NULL;
 
+	blob->data = data;
 	data += sprintf(data, "rt chip: %04x\n", intf->rt2x00dev->chip.rt);
 	data += sprintf(data, "rf chip: %04x\n", intf->rt2x00dev->chip.rf);
 	data += sprintf(data, "revision:%08x\n", intf->rt2x00dev->chip.rev);
@@ -425,9 +426,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	data += sprintf(data, "eeprom length: %d\n", debug->eeprom.word_count);
 	data += sprintf(data, "bbp length: %d\n", debug->bbp.word_count);
 	data += sprintf(data, "rf length: %d\n", debug->rf.word_count);
-
-	blob->data = data;
-	blob->size = strlen(data);
+	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUGO, intf->driver_folder, blob);
 }
-- 
1.5.3.7

