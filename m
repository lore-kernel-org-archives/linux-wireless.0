Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZEJLAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 07:00:24 -0400
Subject: [PATCH] wext: fix get_wireless_stats locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 10 May 2009 13:00:17 +0200
Message-Id: <1241953217.12068.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, get_wireless_stats is racy by _design_. This is
because it returns a buffer, which needs to be statically
allocated since it cannot be freed if it was allocated
dynamically. Also, SIOCGIWSTATS and /proc/net/wireless use
no common lock, and /proc/net/wireless accesses are not
synchronised against each other. This is a design flaw in
get_wireless_stats since the beginning.

This patch fixes it by wrapping /proc/net/wireless accesses
with the RTNL so they are protected against each other and
SIOCGIWSTATS. The more correct method of fixing this would
be to pass in the buffer instead of returning it and have
the caller take care of synchronisation of the buffer, but
even then most drivers probably assume that their callback
is protected by the RTNL like all other wext callbacks.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Kudos to Jean for the great wireless extensions design. NOT!

 net/wireless/wext.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/wext.c	2009-05-10 11:44:34.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-05-10 12:26:58.000000000 +0200
@@ -656,18 +656,32 @@ static const struct seq_operations wirel
 	.show  = wireless_seq_show,
 };
 
-static int wireless_seq_open(struct inode *inode, struct file *file)
+static int seq_open_wireless(struct inode *ino, struct file *f)
 {
-	return seq_open_net(inode, file, &wireless_seq_ops,
-			    sizeof(struct seq_net_private));
+	int err;
+
+	rtnl_lock();
+	err = seq_open_net(ino, f, &wireless_seq_ops,
+			   sizeof(struct seq_net_private));
+	if (err)
+		rtnl_unlock();
+
+	return 0;
+}
+
+static int seq_release_wireless(struct inode *ino, struct file *f)
+{
+	seq_release_net(ino, f);
+	rtnl_unlock();
+	return 0;
 }
 
 static const struct file_operations wireless_seq_fops = {
 	.owner	 = THIS_MODULE,
-	.open    = wireless_seq_open,
+	.open    = seq_open_wireless,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release_net,
+	.release = seq_release_wireless,
 };
 
 int wext_proc_init(struct net *net)


