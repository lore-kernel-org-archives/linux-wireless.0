Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38406 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1A2BF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 20:05:57 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/3] mac80211:  Show configured channel-type in netdev debugfs.
Date: Fri, 28 Jan 2011 17:05:42 -0800
Message-Id: <1296263143-12404-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1296263143-12404-1-git-send-email-greearb@candelatech.com>
References: <1296263143-12404-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 872adb8... 4cffbf6... M	net/mac80211/debugfs_netdev.c
 net/mac80211/debugfs_netdev.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 872adb8..4cffbf6 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -149,6 +149,7 @@ IEEE80211_IF_FILE(rc_rateidx_mask_5ghz, rc_rateidx_mask[IEEE80211_BAND_5GHZ],
 		  HEX);
 IEEE80211_IF_FILE(flags, flags, HEX);
 IEEE80211_IF_FILE(state, state, LHEX);
+IEEE80211_IF_FILE(channel_type, vif.bss_conf.channel_type, DEC);
 
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
@@ -289,6 +290,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(state);
+	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 
@@ -304,6 +306,7 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(state);
+	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 
@@ -317,6 +320,7 @@ static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(state);
+	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 
@@ -328,6 +332,7 @@ static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(state);
+	DEBUGFS_ADD(channel_type);
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 }
@@ -336,6 +341,7 @@ static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(state);
+	DEBUGFS_ADD(channel_type);
 }
 
 #ifdef CONFIG_MAC80211_MESH
-- 
1.7.2.3

