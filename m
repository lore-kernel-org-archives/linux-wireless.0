Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:53898 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZBQNEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 08:04:33 -0500
Received: by nf-out-0910.google.com with SMTP id d21so248859nfb.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 05:04:31 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix RF offset
Date: Tue, 17 Feb 2009 14:04:29 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200902171404.29494.IvDoorn@gmail.com> (sfid-20090217_140446_107354_271D7B19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The word_base is in bytes instead of word index number,
this means that when using it, it should be transformed into
a word index first.

Otherwise RF register reading will fail through debugfs since
we would start reading 4 words starting with word 4 (which is the last
valid word for RF).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 1c0f8bf..07d378e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -435,11 +435,12 @@ static ssize_t rt2x00debug_read_##__name(struct file *file,	\
 	if (index >= debug->__name.word_count)			\
 		return -EINVAL;					\
 								\
+	index += (debug->__name.word_base /			\
+		  debug->__name.word_size);			\
+								\
 	if (debug->__name.flags & RT2X00DEBUGFS_OFFSET)		\
 		index *= debug->__name.word_size;		\
 								\
-	index += debug->__name.word_base;			\
-								\
 	debug->__name.read(intf->rt2x00dev, index, &value);	\
 								\
 	size = sprintf(line, __format, value);			\
@@ -476,11 +477,12 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 	size = strlen(line);					\
 	value = simple_strtoul(line, NULL, 0);			\
 								\
+	index += (debug->__name.word_base /			\
+		  debug->__name.word_size);			\
+								\
 	if (debug->__name.flags & RT2X00DEBUGFS_OFFSET)		\
 		index *= debug->__name.word_size;		\
 								\
-	index += debug->__name.word_base;			\
-								\
 	debug->__name.write(intf->rt2x00dev, index, value);	\
 								\
 	*offset += size;					\
