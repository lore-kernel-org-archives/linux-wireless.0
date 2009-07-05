Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbZGEMvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 08:51:07 -0400
Subject: [PATCH] rfkill: prep for rfkill API changes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 14:51:06 +0200
Message-Id: <1246798266.4411.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've designed the /dev/rfkill API in a way that we
can increase the event struct by adding members at
the end, should it become necessary. To validate the
events, userspace and the kernel need to have the
proper event size to check for -- when reading from
the other end they need to verify that it's at least
version 1 of the event API, with the current struct
size, so define a constant for that and make the
code a little more 'future proof'.

Not that I expect that we'll have to change the event
size any time soon, but it's better to write the code
in a way that lends itself to extending.

Due to the current size of the event struct, the code
is currently equivalent, but should the event struct
ever need to be increased the new code might not need
changing.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/rfkill.h |   14 ++++++++++++++
 net/rfkill/core.c      |   10 ++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/linux/rfkill.h	2009-07-05 14:39:09.000000000 +0200
+++ wireless-testing/include/linux/rfkill.h	2009-07-05 14:41:58.000000000 +0200
@@ -82,6 +82,20 @@ struct rfkill_event {
 	__u8  soft, hard;
 } __packed;
 
+/*
+ * We are planning to be backward and forward compatible with changes
+ * to the event struct, by adding new, optional, members at the end.
+ * When reading an event (whether the kernel from userspace or vice
+ * versa) we need to accept anything that's at least as large as the
+ * version 1 event size, but might be able to accept other sizes in
+ * the future.
+ *
+ * One exception is the kernel -- we already have two event sizes in
+ * that we've made the 'hard' member optional since our only option
+ * is to ignore it anyway.
+ */
+#define RFKILL_EVENT_SIZE_V1	8
+
 /* ioctl for turning off rfkill-input (if present) */
 #define RFKILL_IOC_MAGIC	'R'
 #define RFKILL_IOC_NOINPUT	1
--- wireless-testing.orig/net/rfkill/core.c	2009-07-05 14:40:13.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-07-05 14:49:41.000000000 +0200
@@ -1076,10 +1076,16 @@ static ssize_t rfkill_fop_write(struct f
 	struct rfkill_event ev;
 
 	/* we don't need the 'hard' variable but accept it */
-	if (count < sizeof(ev) - 1)
+	if (count < RFKILL_EVENT_SIZE_V1 - 1)
 		return -EINVAL;
 
-	if (copy_from_user(&ev, buf, sizeof(ev) - 1))
+	/*
+	 * Copy as much data as we can accept into our 'ev' buffer,
+	 * but tell userspace how much we've copied so it can determine
+	 * our API version even in a write() call, if it cares.
+	 */
+	count = min(count, sizeof(ev));
+	if (copy_from_user(&ev, buf, count))
 		return -EFAULT;
 
 	if (ev.op != RFKILL_OP_CHANGE && ev.op != RFKILL_OP_CHANGE_ALL)


