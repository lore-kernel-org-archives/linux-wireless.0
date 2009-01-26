Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:40900 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752215AbZAZUjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 15:39:19 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 4/6] mac80211: More small changes for modularization
Date: Mon, 26 Jan 2009 21:39:13 +0100
Message-Id: <79a59b62a4378b8b88cb3a33b1ec3cbd3808906e.1233001802.git.flomaillist@cosetrain.com> (sfid-20090126_213927_757374_C1421A9C)
In-Reply-To: <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
 <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>
In-Reply-To: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
References: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some rather small changes in various files.
After this patch, i was able to do a clean compile.

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 include/net/cfg80211.h     |    4 ++++
 net/mac80211/Makefile      |    8 ++++++--
 net/mac80211/ieee80211_i.h |    5 +++++
 net/mac80211/sta_info.c    |    1 +
 net/mac80211/util.c        |    2 ++
 5 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dd1fd51..83eb2a1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -458,6 +458,10 @@ struct mesh_config {
 	u32 dot11MeshHWMPactivePathTimeout;
 	u16 dot11MeshHWMPpreqMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
+	/* Mesh IDs */
+	u32 mesh_path_selection_protocol_id;
+	u32 mesh_path_selection_metric_id;
+	u32 mesh_congestion_control_mode_id;
 };
 
 /**
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 58c94bb..796e7a6 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -35,8 +35,12 @@ mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
 mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh.o \
 	mesh_pathtbl.o \
-	mesh_plink.o \
-	mesh_hwmp.o
+	mesh_plink.o
+
+# HWMP routing is a requirement for 80211s
+ifdef CONFIG_MAC80211_MESH
+obj-m += mesh_hwmp.o
+endif
 
 mac80211-$(CONFIG_PM) += pm.o
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index eaf3603..5490ba1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -365,6 +365,8 @@ struct ieee80211_if_mesh {
 	u8 mesh_pm_id[4];
 	/* Congestion Control Mode Identifier */
 	u8 mesh_cc_id[4];
+	/* Active Path Selection Protocol */
+	struct mesh_path_sel_algo* mesh_pp;
 	/* Local mesh Destination Sequence Number */
 	u32 dsn;
 	/* Last used PREQ ID */
@@ -534,6 +536,9 @@ struct ieee80211_sub_if_data {
 		struct dentry *dot11MeshHWMPmaxPREQretries;
 		struct dentry *path_refresh_time;
 		struct dentry *min_discovery_timeout;
+		struct dentry *mesh_path_selection_protocol_id;
+		struct dentry *mesh_path_selection_metric_id;
+		struct dentry *mesh_congestion_mode_control_id;
 	} mesh_config;
 #endif
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 10c5539..b10d754 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -105,6 +105,7 @@ struct sta_info *sta_info_get(struct ieee80211_local *local, const u8 *addr)
 	}
 	return sta;
 }
+EXPORT_SYMBOL(sta_info_get);
 
 struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
 				     struct net_device *dev)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 73c7d73..c579606 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -674,6 +674,7 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 		pos += elen;
 	}
 }
+EXPORT_SYMBOL(ieee802_11_parse_elems);
 
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 {
@@ -714,6 +715,7 @@ void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 
 	dev_queue_xmit(skb);
 }
+EXPORT_SYMBOL(ieee80211_tx_skb);
 
 int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
 {
-- 
1.5.6.5

