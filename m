Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbZELGTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 02:19:00 -0400
Subject: [PATCH]
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Tue, 12 May 2009 08:18:49 +0200
Message-Id: <1242109130.3873.49.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: wext: remove seq_start/stop sparse annotations

Even though they are true, they cause sparse to complain
because it doesn't see the __acquires(dev_base_lock) on
dev_seq_start() because it is only added to the function
in net/core/dev.c, not the header file. To keep track of
the nesting correctly we should probably annotate those
functions publically, but for now let's just remove the
annotation I added to wext.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I guess I should have actually run sparse... This could be part of the
wext locking fix "wext: fix get_wireless_stats locking" instead of being
standalone, if you're so inclined.

 net/wireless/wext.c |    2 --
 1 file changed, 2 deletions(-)

--- wireless-testing.orig/net/wireless/wext.c	2009-05-12 08:12:23.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-05-12 08:13:16.000000000 +0200
@@ -650,14 +650,12 @@ static int wireless_seq_show(struct seq_
 }
 
 static void *wireless_dev_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(dev_base_lock)
 {
 	rtnl_lock();
 	return dev_seq_start(seq, pos);
 }
 
 static void wireless_dev_seq_stop(struct seq_file *seq, void *v)
-	__releases(dev_base_lock)
 {
 	dev_seq_stop(seq, v);
 	rtnl_unlock();


