Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYIJWNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:13:18 -0400
Message-Id: <20080910220418.565468000@sipsolutions.net> (sfid-20080911_001323_306030_78CC41ED)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/18] mac80211: make bridge_packets a virtual interface
	option
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bridge_packets configuration really should be per virtual
interface (theoretically per AP/VLAN, but this is much easier);
there currently is no way to set it yet though. Also invert
the option to "NO_BRIDGE_PACKETS" so the default is to bridge.

While at it, also document the flags properly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs.c     |    4 ----
 net/mac80211/ieee80211_i.h |   29 +++++++++++++++++++----------
 net/mac80211/main.c        |    2 --
 net/mac80211/rx.c          |    5 +++--
 4 files changed, 22 insertions(+), 18 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:58:00.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:58:01.000000000 +0200
@@ -402,11 +402,25 @@ struct ieee80211_if_mesh {
 	do { } while (0)
 #endif
 
-/* flags used in struct ieee80211_sub_if_data.flags */
-#define IEEE80211_SDATA_ALLMULTI	BIT(0)
-#define IEEE80211_SDATA_PROMISC		BIT(1)
-#define IEEE80211_SDATA_USERSPACE_MLME	BIT(2)
-#define IEEE80211_SDATA_OPERATING_GMODE	BIT(3)
+/**
+ * enum ieee80211_sub_if_data_flags - virtual interface flags
+ *
+ * @IEEE80211_SDATA_ALLMULTI: interface wants all multicast packets
+ * @IEEE80211_SDATA_PROMISC: interface is promisc
+ * @IEEE80211_SDATA_USERSPACE_MLME: userspace MLME is active
+ * @IEEE80211_SDATA_OPERATING_GMODE: operating in G-only mode
+ * @IEEE80211_SDATA_DONT_BRIDGE_PACKETS: bridge packets between
+ *	associated stations and deliver multicast frames both
+ *	back to wireless media and to the local net stack.
+ */
+enum ieee80211_sub_if_data_flags {
+	IEEE80211_SDATA_ALLMULTI		= BIT(0),
+	IEEE80211_SDATA_PROMISC			= BIT(1),
+	IEEE80211_SDATA_USERSPACE_MLME		= BIT(2),
+	IEEE80211_SDATA_OPERATING_GMODE		= BIT(3),
+	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(4),
+};
+
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -635,10 +649,6 @@ struct ieee80211_local {
 	struct crypto_blkcipher *wep_rx_tfm;
 	u32 wep_iv;
 
-	int bridge_packets; /* bridge packets between associated stations and
-			     * deliver multicast frames both back to wireless
-			     * media and to the local net stack */
-
 	struct list_head interfaces;
 
 	/*
@@ -726,7 +736,6 @@ struct ieee80211_local {
 		struct dentry *frequency;
 		struct dentry *antenna_sel_tx;
 		struct dentry *antenna_sel_rx;
-		struct dentry *bridge_packets;
 		struct dentry *rts_threshold;
 		struct dentry *fragmentation_threshold;
 		struct dentry *short_retry_limit;
--- everything.orig/net/mac80211/main.c	2008-09-10 23:57:58.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-10 23:58:01.000000000 +0200
@@ -1280,8 +1280,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	local->hw.queues = 1; /* default */
 
-	local->bridge_packets = 1;
-
 	local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 	local->fragmentation_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
 	local->short_retry_limit = 7;
--- everything.orig/net/mac80211/rx.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-10 23:58:01.000000000 +0200
@@ -1221,8 +1221,9 @@ ieee80211_deliver_skb(struct ieee80211_r
 	skb = rx->skb;
 	xmit_skb = NULL;
 
-	if (local->bridge_packets && (sdata->vif.type == IEEE80211_IF_TYPE_AP ||
-				      sdata->vif.type == IEEE80211_IF_TYPE_VLAN) &&
+	if ((sdata->vif.type == IEEE80211_IF_TYPE_AP ||
+	     sdata->vif.type == IEEE80211_IF_TYPE_VLAN) &&
+	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
 	    (rx->flags & IEEE80211_RX_RA_MATCH)) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
--- everything.orig/net/mac80211/debugfs.c	2008-09-10 23:50:26.000000000 +0200
+++ everything/net/mac80211/debugfs.c	2008-09-10 23:58:01.000000000 +0200
@@ -51,8 +51,6 @@ DEBUGFS_READONLY_FILE(antenna_sel_tx, 20
 		      local->hw.conf.antenna_sel_tx);
 DEBUGFS_READONLY_FILE(antenna_sel_rx, 20, "%d",
 		      local->hw.conf.antenna_sel_rx);
-DEBUGFS_READONLY_FILE(bridge_packets, 20, "%d",
-		      local->bridge_packets);
 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
 		      local->rts_threshold);
 DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
@@ -206,7 +204,6 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(frequency);
 	DEBUGFS_ADD(antenna_sel_tx);
 	DEBUGFS_ADD(antenna_sel_rx);
-	DEBUGFS_ADD(bridge_packets);
 	DEBUGFS_ADD(rts_threshold);
 	DEBUGFS_ADD(fragmentation_threshold);
 	DEBUGFS_ADD(short_retry_limit);
@@ -263,7 +260,6 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_DEL(frequency);
 	DEBUGFS_DEL(antenna_sel_tx);
 	DEBUGFS_DEL(antenna_sel_rx);
-	DEBUGFS_DEL(bridge_packets);
 	DEBUGFS_DEL(rts_threshold);
 	DEBUGFS_DEL(fragmentation_threshold);
 	DEBUGFS_DEL(short_retry_limit);

-- 

