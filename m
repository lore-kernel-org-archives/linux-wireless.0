Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lechat.rtp-net.org ([88.191.19.38]:55004 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0HVWre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 18:47:34 -0400
Message-Id: <20100822223718.431624390@rtp-net.org>
Date: Mon, 23 Aug 2010 00:37:11 +0200
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [patch 1/1] rt2x00: fix "buffer size not provably correct" build warning
References: <20100822223710.865969746@rtp-net.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 debugfs interface doesn't check the size of the data coming
from userspace, leading to a build warning. Fix That.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>

Index: rt2x00/drivers/net/wireless/rt2x00/rt2x00debug.c
===================================================================
--- rt2x00.orig/drivers/net/wireless/rt2x00/rt2x00debug.c	2010-08-23 00:21:42.637941244 +0200
+++ rt2x00/drivers/net/wireless/rt2x00/rt2x00debug.c	2010-08-23 00:33:41.237941022 +0200
@@ -480,6 +480,8 @@ static ssize_t rt2x00debug_write_##__nam
 	if (index >= debug->__name.word_count)			\
 		return -EINVAL;					\
 								\
+	if (length > sizeof(line))				\
+		length = sizeof(line);				\
 	if (copy_from_user(line, buf, length))			\
 		return -EFAULT;					\
 								\


