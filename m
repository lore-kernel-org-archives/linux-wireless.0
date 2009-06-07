Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZFGK0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 06:26:54 -0400
Subject: [PATCH] rfkill: print events when input handler is disabled/enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 12:26:52 +0200
Message-Id: <1244370412.2907.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is useful for debugging when we know if something disabled
the in-kernel rfkill input handler.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/rfkill/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/rfkill/core.c	2009-06-07 11:46:05.000000000 +0200
+++ wireless-testing/net/rfkill/core.c	2009-06-07 11:53:40.000000000 +0200
@@ -1134,7 +1134,8 @@ static int rfkill_fop_release(struct ino
 
 #ifdef CONFIG_RFKILL_INPUT
 	if (data->input_handler)
-		atomic_dec(&rfkill_input_disabled);
+		if (atomic_dec_return(&rfkill_input_disabled) == 0)
+			printk(KERN_DEBUG "rfkill: input handler enabled\n");
 #endif
 
 	kfree(data);
@@ -1157,7 +1158,8 @@ static long rfkill_fop_ioctl(struct file
 	mutex_lock(&data->mtx);
 
 	if (!data->input_handler) {
-		atomic_inc(&rfkill_input_disabled);
+		if (atomic_inc_return(&rfkill_input_disabled) == 1)
+			printk(KERN_DEBUG "rfkill: input handler disabled\n");
 		data->input_handler = true;
 	}
 


