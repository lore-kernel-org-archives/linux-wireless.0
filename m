Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39183 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab2CQXBI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 19:01:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 2/3] mac80211: reduce code duplication in debugfs code
Date: Sun, 18 Mar 2012 00:00:53 +0100
Message-Id: <1332025254-5048-2-git-send-email-nbd@openwrt.org> (sfid-20120318_000116_673371_12B113B7)
In-Reply-To: <1332025254-5048-1-git-send-email-nbd@openwrt.org>
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/debugfs_netdev.c |   71 +++++++---------------------------------
 1 files changed, 13 insertions(+), 58 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index a32eeda..6ed0455 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -499,26 +499,23 @@ IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
 #endif
 
-
-#define DEBUGFS_ADD(name) \
-	debugfs_create_file(#name, 0400, sdata->debugfs.dir, \
-			    sdata, &name##_ops);
-
 #define DEBUGFS_ADD_MODE(name, mode) \
 	debugfs_create_file(#name, mode, sdata->debugfs.dir, \
 			    sdata, &name##_ops);
 
-static void add_sta_files(struct ieee80211_sub_if_data *sdata)
+#define DEBUGFS_ADD(name) DEBUGFS_ADD_MODE(name, 0400)
+
+static void add_common_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
-	DEBUGFS_ADD(flags);
-	DEBUGFS_ADD(state);
-	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
+}
 
+static void add_sta_files(struct ieee80211_sub_if_data *sdata)
+{
 	DEBUGFS_ADD(bssid);
 	DEBUGFS_ADD(aid);
 	DEBUGFS_ADD(last_beacon);
@@ -531,15 +528,6 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(drop_unencrypted);
-	DEBUGFS_ADD(flags);
-	DEBUGFS_ADD(state);
-	DEBUGFS_ADD(channel_type);
-	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
-	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
-	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
-	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
-
 	DEBUGFS_ADD(num_sta_authorized);
 	DEBUGFS_ADD(num_sta_ps);
 	DEBUGFS_ADD(dtim_count);
@@ -549,48 +537,14 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 
 static void add_ibss_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(channel_type);
-	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
-	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
-	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
-	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
-
 	DEBUGFS_ADD_MODE(tsf, 0600);
 }
 
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(drop_unencrypted);
-	DEBUGFS_ADD(flags);
-	DEBUGFS_ADD(state);
-	DEBUGFS_ADD(channel_type);
-	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
-	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
-	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
-	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
-
 	DEBUGFS_ADD(peer);
 }
 
-static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
-{
-	DEBUGFS_ADD(drop_unencrypted);
-	DEBUGFS_ADD(flags);
-	DEBUGFS_ADD(state);
-	DEBUGFS_ADD(channel_type);
-	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
-	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
-	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
-	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
-}
-
-static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
-{
-	DEBUGFS_ADD(flags);
-	DEBUGFS_ADD(state);
-	DEBUGFS_ADD(channel_type);
-}
-
 #ifdef CONFIG_MAC80211_MESH
 
 static void add_mesh_files(struct ieee80211_sub_if_data *sdata)
@@ -651,6 +605,13 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 	if (!sdata->debugfs.dir)
 		return;
 
+	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(state);
+	DEBUGFS_ADD(channel_type);
+
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		add_common_files(sdata);
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_MESH_POINT:
 #ifdef CONFIG_MAC80211_MESH
@@ -671,12 +632,6 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 	case NL80211_IFTYPE_WDS:
 		add_wds_files(sdata);
 		break;
-	case NL80211_IFTYPE_MONITOR:
-		add_monitor_files(sdata);
-		break;
-	case NL80211_IFTYPE_AP_VLAN:
-		add_vlan_files(sdata);
-		break;
 	default:
 		break;
 	}
-- 
1.7.3.2

