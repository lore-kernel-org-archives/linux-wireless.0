Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZESPUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 11:20:10 -0400
Subject: [PATCH] wext: remove atomic requirement for wireless stats
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 May 2009 17:19:36 +0200
Message-Id: <1242746376.4797.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The requirement for wireless stats to be atomic is now mostly
artificial since we hold the rtnl _and_ the dev_base_lock for
iterating the device list. Doing that is not required, just the
rtnl is sufficient (and the rtnl is required for other reasons
outlined in commit "wext: fix get_wireless_stats locking").

This will fix http://bugzilla.kernel.org/show_bug.cgi?id=13344
and make things easier for drivers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/wext.c	2009-05-19 16:57:34.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-05-19 17:07:24.000000000 +0200
@@ -636,8 +636,10 @@ static void wireless_seq_printf_stats(st
 /*
  * Print info for /proc/net/wireless (print all entries)
  */
-static int wireless_seq_show(struct seq_file *seq, void *v)
+static int wireless_dev_seq_show(struct seq_file *seq, void *v)
 {
+	might_sleep();
+
 	if (v == SEQ_START_TOKEN)
 		seq_printf(seq, "Inter-| sta-|   Quality        |   Discarded "
 				"packets               | Missed | WE\n"
@@ -651,21 +653,41 @@ static int wireless_seq_show(struct seq_
 
 static void *wireless_dev_seq_start(struct seq_file *seq, loff_t *pos)
 {
+	struct net *net = seq_file_net(seq);
+	loff_t off;
+	struct net_device *dev;
+
 	rtnl_lock();
-	return dev_seq_start(seq, pos);
+	if (!*pos)
+		return SEQ_START_TOKEN;
+
+	off = 1;
+	for_each_netdev(net, dev)
+		if (off++ == *pos)
+			return dev;
+	return NULL;
+}
+
+static void *wireless_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct net *net = seq_file_net(seq);
+
+	++*pos;
+
+	return v == SEQ_START_TOKEN ?
+		first_net_device(net) : next_net_device(v);
 }
 
 static void wireless_dev_seq_stop(struct seq_file *seq, void *v)
 {
-	dev_seq_stop(seq, v);
 	rtnl_unlock();
 }
 
 static const struct seq_operations wireless_seq_ops = {
 	.start = wireless_dev_seq_start,
-	.next  = dev_seq_next,
+	.next  = wireless_dev_seq_next,
 	.stop  = wireless_dev_seq_stop,
-	.show  = wireless_seq_show,
+	.show  = wireless_dev_seq_show,
 };
 
 static int seq_open_wireless(struct inode *inode, struct file *file)


