Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35934 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1A1GJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 01:09:43 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Add sdata state and flags to debugfs.
Date: Thu, 27 Jan 2011 22:09:34 -0800
Message-Id: <1296194974-12082-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2dabdf7... 872adb8... M	net/mac80211/debugfs_netdev.c
 net/mac80211/debugfs_netdev.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 2dabdf7..872adb8 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -81,6 +81,8 @@ static ssize_t ieee80211_if_fmt_##name(					\
 		IEEE80211_IF_FMT(name, field, "%d\n")
 #define IEEE80211_IF_FMT_HEX(name, field)				\
 		IEEE80211_IF_FMT(name, field, "%#x\n")
+#define IEEE80211_IF_FMT_LHEX(name, field)				\
+		IEEE80211_IF_FMT(name, field, "%#lx\n")
 #define IEEE80211_IF_FMT_SIZE(name, field)				\
 		IEEE80211_IF_FMT(name, field, "%zd\n")
 
@@ -145,6 +147,8 @@ IEEE80211_IF_FILE(rc_rateidx_mask_2ghz, rc_rateidx_mask[IEEE80211_BAND_2GHZ],
 		  HEX);
 IEEE80211_IF_FILE(rc_rateidx_mask_5ghz, rc_rateidx_mask[IEEE80211_BAND_5GHZ],
 		  HEX);
+IEEE80211_IF_FILE(flags, flags, HEX);
+IEEE80211_IF_FILE(state, state, LHEX);
 
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
@@ -283,6 +287,8 @@ IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
+	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(state);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 
@@ -296,6 +302,8 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
+	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(state);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 
@@ -307,6 +315,8 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
+	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(state);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 
@@ -316,12 +326,16 @@ static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
+	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(state);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 }
 
 static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
+	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(state);
 }
 
 #ifdef CONFIG_MAC80211_MESH
-- 
1.7.2.3

