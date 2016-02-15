Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44892 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbcBOTFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 14:05:08 -0500
Subject: [PATCH] rt2x00: unterminated strlen of user data
From: Alan <gnomes@lxorguk.ukuu.org.uk>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Date: Mon, 15 Feb 2016 19:04:56 +0000
Message-ID: <20160215190451.19883.12408.stgit@localhost.localdomain> (sfid-20160215_200512_820909_F3A9947B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The buffer needs to be zero terminated in case the user data is not.
Otherwise we run off the end of the buffer.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index 25ee3cb..72ae530 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -478,7 +478,7 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 {								\
 	struct rt2x00debug_intf *intf = file->private_data;	\
 	const struct rt2x00debug *debug = intf->debug;		\
-	char line[16];						\
+	char line[17];						\
 	size_t size;						\
 	unsigned int index = intf->offset_##__name;		\
 	__type value;						\
@@ -494,7 +494,8 @@ static ssize_t rt2x00debug_write_##__name(struct file *file,	\
 								\
 	if (copy_from_user(line, buf, length))			\
 		return -EFAULT;					\
-								\
+	line[16] = 0;						\
+						\
 	size = strlen(line);					\
 	value = simple_strtoul(line, NULL, 0);			\
 								\

