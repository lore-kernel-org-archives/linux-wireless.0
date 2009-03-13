Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZCMKov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:44:51 -0400
Subject: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <1236939917.5235.7.camel@johannes.local> (sfid-20090313_112555_620577_8A85228F)
References: <1236939917.5235.7.camel@johannes.local>
	 (sfid-20090313_112555_620577_8A85228F)
Content-Type: text/plain
Date: Fri, 13 Mar 2009 11:44:18 +0100
Message-Id: <1236941058.5235.12.camel@johannes.local> (sfid-20090313_114453_238290_13C307AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 resumes, it currently doesn't reconfigure the interfaces
entirely and also doesn't reconfigure BSS information -- fix this.

Also, to be able to test this, add a debugfs file that just calls
the suspend/resume code to see what happens when we go through that,
without needing the time-consuming suspend/resume cycle.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: rebased on top of "stop queues across suspend/resume"

zd1211rw currently doesn't survive this properly, I'm not sure why,
but it keeps saying
	zd1211rw 1-1:1.0: error ioread32(CR_REG1): -11

Please test with other hardware, we need to figure out whether or
not something is missing in mac80211.

 net/mac80211/debugfs.c     |   24 ++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/pm.c          |   29 +++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

--- wireless-testing.orig/net/mac80211/pm.c	2009-03-13 11:40:56.000000000 +0100
+++ wireless-testing/net/mac80211/pm.c	2009-03-13 11:42:15.000000000 +0100
@@ -116,6 +116,35 @@ int __ieee80211_resume(struct ieee80211_
 	ieee80211_configure_filter(local);
 	netif_addr_unlock_bh(local->mdev);
 
+	/* Finally also reconfigure all the BSS information */
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		u32 changed = ~0;
+		if (!netif_running(sdata->dev))
+			continue;
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_STATION:
+			/* disable beacon change bits */
+			changed &= ~IEEE80211_IFCC_BEACON;
+			/* fall through */
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_MESH_POINT:
+			WARN_ON(ieee80211_if_config(sdata, changed));
+			ieee80211_bss_info_change_notify(sdata, ~0);
+			break;
+		case NL80211_IFTYPE_WDS:
+			break;
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_MONITOR:
+			/* ignore virtual */
+			break;
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case __NL80211_IFTYPE_AFTER_LAST:
+			WARN_ON(1);
+			break;
+		}
+	}
+
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-03-13 11:36:57.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs.c	2009-03-13 11:41:53.000000000 +0100
@@ -40,6 +40,10 @@ static const struct file_operations name
 	local->debugfs.name = debugfs_create_file(#name, 0400, phyd,	\
 						  local, &name## _ops);
 
+#define DEBUGFS_ADD_MODE(name, mode)					\
+	local->debugfs.name = debugfs_create_file(#name, mode, phyd,	\
+						  local, &name## _ops);
+
 #define DEBUGFS_DEL(name)						\
 	debugfs_remove(local->debugfs.name);				\
 	local->debugfs.name = NULL;
@@ -113,6 +117,24 @@ static const struct file_operations tsf_
 	.open = mac80211_open_file_generic
 };
 
+static ssize_t reset_write(struct file *file, const char __user *user_buf,
+			   size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+
+	rtnl_lock();
+	__ieee80211_suspend(&local->hw);
+	__ieee80211_resume(&local->hw);
+	rtnl_unlock();
+
+	return count;
+}
+
+static const struct file_operations reset_ops = {
+	.write = reset_write,
+	.open = mac80211_open_file_generic,
+};
+
 /* statistics stuff */
 
 #define DEBUGFS_STATS_FILE(name, buflen, fmt, value...)			\
@@ -254,6 +276,7 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(tsf);
+	DEBUGFS_ADD_MODE(reset, 0200);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 	local->debugfs.statistics = statsd;
@@ -308,6 +331,7 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_DEL(total_ps_buffered);
 	DEBUGFS_DEL(wep_iv);
 	DEBUGFS_DEL(tsf);
+	DEBUGFS_DEL(reset);
 
 	DEBUGFS_STATS_DEL(transmitted_fragment_count);
 	DEBUGFS_STATS_DEL(multicast_transmitted_frame_count);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-13 11:40:41.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-13 11:41:53.000000000 +0100
@@ -775,6 +775,7 @@ struct ieee80211_local {
 		struct dentry *total_ps_buffered;
 		struct dentry *wep_iv;
 		struct dentry *tsf;
+		struct dentry *reset;
 		struct dentry *statistics;
 		struct local_debugfsdentries_statsdentries {
 			struct dentry *transmitted_fragment_count;


