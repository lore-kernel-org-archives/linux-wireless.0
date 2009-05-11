Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZEKOGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 10:06:38 -0400
Subject: [PATCH v2] wext: fix get_wireless_stats locking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090511125442.GB2721@tuxdriver.com>
References: <1241953217.12068.0.camel@johannes.local>
	 <20090511125442.GB2721@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 16:06:36 +0200
Message-Id: <1242050796.29777.9.camel@johannes.local>
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
v2: don't hold lock across open/release but rather start/stop

 net/wireless/wext.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/wext.c	2009-05-11 13:34:00.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-05-11 16:02:31.000000000 +0200
@@ -649,14 +649,28 @@ static int wireless_seq_show(struct seq_
 	return 0;
 }
 
+static void *wireless_dev_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(dev_base_lock)
+{
+	rtnl_lock();
+	return dev_seq_start(seq, pos);
+}
+
+static void wireless_dev_seq_stop(struct seq_file *seq, void *v)
+	__releases(dev_base_lock)
+{
+	dev_seq_stop(seq, v);
+	rtnl_unlock();
+}
+
 static const struct seq_operations wireless_seq_ops = {
-	.start = dev_seq_start,
+	.start = wireless_dev_seq_start,
 	.next  = dev_seq_next,
-	.stop  = dev_seq_stop,
+	.stop  = wireless_dev_seq_stop,
 	.show  = wireless_seq_show,
 };
 
-static int wireless_seq_open(struct inode *inode, struct file *file)
+static int seq_open_wireless(struct inode *inode, struct file *file)
 {
 	return seq_open_net(inode, file, &wireless_seq_ops,
 			    sizeof(struct seq_net_private));
@@ -664,7 +678,7 @@ static int wireless_seq_open(struct inod
 
 static const struct file_operations wireless_seq_fops = {
 	.owner	 = THIS_MODULE,
-	.open    = wireless_seq_open,
+	.open    = seq_open_wireless,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
 	.release = seq_release_net,


