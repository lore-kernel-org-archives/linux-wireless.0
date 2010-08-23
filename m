Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lechat.rtp-net.org ([88.191.19.38]:33033 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab0HWVGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 17:06:09 -0400
Message-Id: <20100823210335.493454739@rtp-net.org>
Date: Mon, 23 Aug 2010 23:02:22 +0200
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [patch 1/1 v2] rt2x00: fix "buffer size not provably correct" build warning
References: <20100823210221.126521640@rtp-net.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 debugfs interface doesn't check the size of the data coming
from userspace, leading to a build warning. Fix That.

v2: return EINVAL if input is too long

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>

Index: rt2x00/drivers/net/wireless/rt2x00/rt2x00debug.c
===================================================================
--- rt2x00.orig/drivers/net/wireless/rt2x00/rt2x00debug.c	2010-08-23 18:03:31.414826113 +0200
+++ rt2x00/drivers/net/wireless/rt2x00/rt2x00debug.c	2010-08-23 20:37:24.894366547 +0200
@@ -480,6 +480,9 @@ static ssize_t rt2x00debug_write_##__nam
 	if (index >= debug->__name.word_count)			\
 		return -EINVAL;					\
 								\
+	if (length > sizeof(line))				\
+		return -EINVAL;					\
+								\
 	if (copy_from_user(line, buf, length))			\
 		return -EFAULT;					\
 								\


