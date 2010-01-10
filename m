Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0AJQMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 11:12:46 -0500
Subject: [PATCH] mac80211: remove unused type argument
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jan 2010 17:12:41 +0100
Message-ID: <1263139961.7773.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The type argument to DEBUGFS_ADD() isn't used
and can be removed, it's around from before
the conversion to debugfs_remove_recursive().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_netdev.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2010-01-10 17:10:08.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2010-01-10 17:10:44.000000000 +0100
@@ -253,7 +253,7 @@ IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
 #endif
 
 
-#define DEBUGFS_ADD(name, type) \
+#define DEBUGFS_ADD(name) \
 	debugfs_create_file(#name, 0400, sdata->debugfs.dir, \
 			    sdata, &name##_ops);
 
@@ -263,40 +263,40 @@ IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(drop_unencrypted, sta);
-	DEBUGFS_ADD(force_unicast_rateidx, sta);
-	DEBUGFS_ADD(max_ratectrl_rateidx, sta);
+	DEBUGFS_ADD(drop_unencrypted);
+	DEBUGFS_ADD(force_unicast_rateidx);
+	DEBUGFS_ADD(max_ratectrl_rateidx);
 
-	DEBUGFS_ADD(bssid, sta);
-	DEBUGFS_ADD(aid, sta);
+	DEBUGFS_ADD(bssid);
+	DEBUGFS_ADD(aid);
 	DEBUGFS_ADD_MODE(smps, 0600);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(drop_unencrypted, ap);
-	DEBUGFS_ADD(force_unicast_rateidx, ap);
-	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
-
-	DEBUGFS_ADD(num_sta_ps, ap);
-	DEBUGFS_ADD(dtim_count, ap);
-	DEBUGFS_ADD(num_buffered_multicast, ap);
+	DEBUGFS_ADD(drop_unencrypted);
+	DEBUGFS_ADD(force_unicast_rateidx);
+	DEBUGFS_ADD(max_ratectrl_rateidx);
+
+	DEBUGFS_ADD(num_sta_ps);
+	DEBUGFS_ADD(dtim_count);
+	DEBUGFS_ADD(num_buffered_multicast);
 }
 
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(drop_unencrypted, wds);
-	DEBUGFS_ADD(force_unicast_rateidx, wds);
-	DEBUGFS_ADD(max_ratectrl_rateidx, wds);
+	DEBUGFS_ADD(drop_unencrypted);
+	DEBUGFS_ADD(force_unicast_rateidx);
+	DEBUGFS_ADD(max_ratectrl_rateidx);
 
-	DEBUGFS_ADD(peer, wds);
+	DEBUGFS_ADD(peer);
 }
 
 static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(drop_unencrypted, vlan);
-	DEBUGFS_ADD(force_unicast_rateidx, vlan);
-	DEBUGFS_ADD(max_ratectrl_rateidx, vlan);
+	DEBUGFS_ADD(drop_unencrypted);
+	DEBUGFS_ADD(force_unicast_rateidx);
+	DEBUGFS_ADD(max_ratectrl_rateidx);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)


