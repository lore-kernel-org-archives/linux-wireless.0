Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYDDVdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 17:33:42 -0400
Subject: [PATCH] mac80211: make debugfs files root-only
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 23:33:37 +0200
Message-Id: <1207344817.3625.11.camel@johannes.berg> (sfid-20080404_223344_789952_6BE1FC94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately, debugfs can be made to access invalid memory by
open()ing a file and then waiting until the corresponding debugfs
file has been removed (and, probably, the underlying object.)

That could be exploited by any user if the user is able to open
debugfs files and can cause networking devices, STA entries or
similar to disappear which is quite easy to do.

Hence, all debugfs files should be root-only.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Others may want to investigate whether the same should be done for their
debugfs code.

 net/mac80211/debugfs.c        |    4 ++--
 net/mac80211/debugfs_netdev.c |    6 +++---
 net/mac80211/debugfs_sta.c    |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- everything.orig/net/mac80211/debugfs.c	2008-04-04 23:28:37.000000000 +0200
+++ everything/net/mac80211/debugfs.c	2008-04-04 23:28:52.000000000 +0200
@@ -37,7 +37,7 @@ static const struct file_operations name
 };
 
 #define DEBUGFS_ADD(name)						\
-	local->debugfs.name = debugfs_create_file(#name, 0444, phyd,	\
+	local->debugfs.name = debugfs_create_file(#name, 0400, phyd,	\
 						  local, &name## _ops);
 
 #define DEBUGFS_DEL(name)						\
@@ -130,7 +130,7 @@ static const struct file_operations stat
 };
 
 #define DEBUGFS_STATS_ADD(name)						\
-	local->debugfs.stats.name = debugfs_create_file(#name, 0444, statsd,\
+	local->debugfs.stats.name = debugfs_create_file(#name, 0400, statsd,\
 		local, &stats_ ##name## _ops);
 
 #define DEBUGFS_STATS_DEL(name)						\
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-04-04 23:28:38.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-04-04 23:29:24.000000000 +0200
@@ -243,7 +243,7 @@ IEEE80211_IF_WFILE(min_discovery_timeout
 
 
 #define DEBUGFS_ADD(name, type)\
-	sdata->debugfs.type.name = debugfs_create_file(#name, 0444,\
+	sdata->debugfs.type.name = debugfs_create_file(#name, 0400,\
 		sdata->debugfsdir, sdata, &name##_ops);
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
@@ -298,7 +298,7 @@ static void add_monitor_files(struct iee
 
 #ifdef CONFIG_MAC80211_MESH
 #define MESHSTATS_ADD(name)\
-	sdata->mesh_stats.name = debugfs_create_file(#name, 0444,\
+	sdata->mesh_stats.name = debugfs_create_file(#name, 0400,\
 		sdata->mesh_stats_dir, sdata, &name##_ops);
 
 static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
@@ -312,7 +312,7 @@ static void add_mesh_stats(struct ieee80
 }
 
 #define MESHPARAMS_ADD(name)\
-	sdata->mesh_config.name = debugfs_create_file(#name, 0644,\
+	sdata->mesh_config.name = debugfs_create_file(#name, 0600,\
 		sdata->mesh_config_dir, sdata, &name##_ops);
 
 static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
--- everything.orig/net/mac80211/debugfs_sta.c	2008-04-04 23:28:38.000000000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-04-04 23:29:42.000000000 +0200
@@ -267,7 +267,7 @@ static ssize_t sta_agg_status_write(stru
 STA_OPS_WR(agg_status);
 
 #define DEBUGFS_ADD(name) \
-	sta->debugfs.name = debugfs_create_file(#name, 0444, \
+	sta->debugfs.name = debugfs_create_file(#name, 0400, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
 
 #define DEBUGFS_DEL(name) \


