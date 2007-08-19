Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbXHSSat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:49 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446949ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:48 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/30] Fix off-by-one error in debugfs helpers
Date: Sun, 19 Aug 2007 20:26:30 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192026.31064.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 089bfb50f6f9426f1dfd48bfb07455224484b847 Mon Sep 17 00:00:00 2001
From: Luca Tettamanti <kronos.it@gmail.com>
Date: Thu, 9 Aug 2007 21:19:49 +0200
Subject: [PATCH 14/30] Fix off-by-one error in debugfs helpers

Fix an off-by-on error in debugfs code which may lead to read/write past
the end of the data.

Signed-Off-By: Luca Tettamanti <kronos.it@gmail.com>

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00debug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00debug.c b/drivers/net/wireless/rt2x00debug.c
index d6c4cfe..c7b331c 100644
--- a/drivers/net/wireless/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00debug.c
@@ -127,7 +127,7 @@ static ssize_t rt2x00debug_read_##__name(struct file *file,	\
 	if (*offset)						\
 		return 0;					\
 								\
-	if (intf->offset_##__name > debug->__name.word_count)	\
+	if (intf->offset_##__name >= debug->__name.word_count)	\
 		return -EINVAL;					\
 								\
 	debug->__name.read(intf->rt2x00dev,			\
@@ -160,7 +160,7 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 	if (!capable(CAP_NET_ADMIN))				\
 		return -EPERM;					\
 								\
-	if (intf->offset_##__name > debug->__name.word_count)	\
+	if (intf->offset_##__name >= debug->__name.word_count)	\
 		return -EINVAL;					\
 								\
 	if (copy_from_user(line, buf, length))			\
-- 
1.5.3.rc5

