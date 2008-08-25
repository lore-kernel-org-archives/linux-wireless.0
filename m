Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:51564 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbYHYI57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 04:57:59 -0400
Date: Mon, 25 Aug 2008 11:57:06 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix debugfs file add/del for netdev
Message-ID: <20080825085706.GA9415@jm.kir.nu> (sfid-20080825_105803_086892_D49E5D07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous version was using incorrect union structures for non-AP
interfaces when adding and removing max_ratectrl_rateidx and
force_unicast_rateidx entries. Depending on the vif type, this ended
up in corrupting debugfs entries since the dentries inside different
union structures ended up going being on top of eachother.. As the
end result, debugfs files were being left behind with references to
freed data (instant kernel oops on access) and directories were not
removed properly when unloading mac80211 drivers. This patch fixes
those issues by using only a single union structure based on the vif
type.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/net/mac80211/debugfs_netdev.c
===================================================================
--- wireless-testing.orig/net/mac80211/debugfs_netdev.c
+++ wireless-testing/net/mac80211/debugfs_netdev.c
@@ -248,8 +248,8 @@ IEEE80211_IF_WFILE(min_discovery_timeout
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, sta);
-	DEBUGFS_ADD(force_unicast_rateidx, ap);
-	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
+	DEBUGFS_ADD(force_unicast_rateidx, sta);
+	DEBUGFS_ADD(max_ratectrl_rateidx, sta);
 
 	DEBUGFS_ADD(state, sta);
 	DEBUGFS_ADD(bssid, sta);
@@ -283,8 +283,8 @@ static void add_ap_files(struct ieee8021
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, wds);
-	DEBUGFS_ADD(force_unicast_rateidx, ap);
-	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
+	DEBUGFS_ADD(force_unicast_rateidx, wds);
+	DEBUGFS_ADD(max_ratectrl_rateidx, wds);
 
 	DEBUGFS_ADD(peer, wds);
 }
@@ -292,8 +292,8 @@ static void add_wds_files(struct ieee802
 static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted, vlan);
-	DEBUGFS_ADD(force_unicast_rateidx, ap);
-	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
+	DEBUGFS_ADD(force_unicast_rateidx, vlan);
+	DEBUGFS_ADD(max_ratectrl_rateidx, vlan);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
@@ -381,8 +381,8 @@ static void add_files(struct ieee80211_s
 static void del_sta_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_DEL(drop_unencrypted, sta);
-	DEBUGFS_DEL(force_unicast_rateidx, ap);
-	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
+	DEBUGFS_DEL(force_unicast_rateidx, sta);
+	DEBUGFS_DEL(max_ratectrl_rateidx, sta);
 
 	DEBUGFS_DEL(state, sta);
 	DEBUGFS_DEL(bssid, sta);
@@ -416,8 +416,8 @@ static void del_ap_files(struct ieee8021
 static void del_wds_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_DEL(drop_unencrypted, wds);
-	DEBUGFS_DEL(force_unicast_rateidx, ap);
-	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
+	DEBUGFS_DEL(force_unicast_rateidx, wds);
+	DEBUGFS_DEL(max_ratectrl_rateidx, wds);
 
 	DEBUGFS_DEL(peer, wds);
 }
@@ -425,8 +425,8 @@ static void del_wds_files(struct ieee802
 static void del_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_DEL(drop_unencrypted, vlan);
-	DEBUGFS_DEL(force_unicast_rateidx, ap);
-	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
+	DEBUGFS_DEL(force_unicast_rateidx, vlan);
+	DEBUGFS_DEL(max_ratectrl_rateidx, vlan);
 }
 
 static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
Index: wireless-testing/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-testing.orig/net/mac80211/ieee80211_i.h
+++ wireless-testing/net/mac80211/ieee80211_i.h
@@ -472,6 +472,8 @@ struct ieee80211_sub_if_data {
 			struct dentry *auth_transaction;
 			struct dentry *flags;
 			struct dentry *num_beacons_sta;
+			struct dentry *force_unicast_rateidx;
+			struct dentry *max_ratectrl_rateidx;
 		} sta;
 		struct {
 			struct dentry *drop_unencrypted;
@@ -485,9 +487,13 @@ struct ieee80211_sub_if_data {
 		struct {
 			struct dentry *drop_unencrypted;
 			struct dentry *peer;
+			struct dentry *force_unicast_rateidx;
+			struct dentry *max_ratectrl_rateidx;
 		} wds;
 		struct {
 			struct dentry *drop_unencrypted;
+			struct dentry *force_unicast_rateidx;
+			struct dentry *max_ratectrl_rateidx;
 		} vlan;
 		struct {
 			struct dentry *mode;

-- 
Jouni Malinen                                            PGP id EFC895FA
