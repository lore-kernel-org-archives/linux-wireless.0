Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34619 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1HYBlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:41:09 -0400
Received: by gya6 with SMTP id 6so1340575gya.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2011 18:41:09 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Larbig <pedro.larbig@carhs.de>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 2/9] mac80211: Limit amount of HWMP frames and forwarded data packets in queues on mesh interfaces
Date: Wed, 24 Aug 2011 18:40:45 -0700
Message-Id: <1314236452-7226-3-git-send-email-thomas@cozybit.com> (sfid-20110825_034113_732474_E12CC516)
In-Reply-To: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pedro Larbig <pedro.larbig@carhs.de>

To avoid contention problems in a mesh network's high load areas, this patch
adds a 2-stage packet dropping mechanism:
* If the transmit queue for HWMP frames is filled with 256 or more packets,
additional HWMP frames will be dropped
* If the transmit queue for forwarded packets is at 384 or more, drop those,
too

This way, if a node runs into contention issues, it first reduces the amount
of HWMP messages, and only if this is not enough, starts also dropping data
packets from other nodes.

So, instead of eating up memory and crashing, a node does only behave selfish
in such situations.
This patch has been tested several hours in a 20-node testbed under heavy
iperf load.

Signed-off-by: Pedro Larbig <pedro.larbig@carhs.de>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/debugfs.c     |    4 ++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mesh.h        |    5 +++++
 net/mac80211/mesh_hwmp.c   |   21 +++++++++++++++++++--
 net/mac80211/rx.c          |   13 ++++++++++++-
 5 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 186e02f..8aefd2e 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -496,6 +496,10 @@ void debugfs_hw_add(struct ieee80211_local *local)
 		local->tx_handlers_drop_not_assoc);
 	DEBUGFS_STATS_ADD(tx_handlers_drop_unauth_port,
 		local->tx_handlers_drop_unauth_port);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_mesh_mgmt,
+		local->tx_handlers_drop_mesh_mgmt);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_mesh_fwd,
+		local->tx_handlers_drop_mesh_fwd);
 	DEBUGFS_STATS_ADD(rx_handlers_drop, local->rx_handlers_drop);
 	DEBUGFS_STATS_ADD(rx_handlers_queued, local->rx_handlers_queued);
 	DEBUGFS_STATS_ADD(rx_handlers_drop_nullfunc,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c204cee..12ad787 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -922,6 +922,8 @@ struct ieee80211_local {
 	unsigned int tx_handlers_drop_wep;
 	unsigned int tx_handlers_drop_not_assoc;
 	unsigned int tx_handlers_drop_unauth_port;
+	unsigned int tx_handlers_drop_mesh_mgmt;
+	unsigned int tx_handlers_drop_mesh_fwd;
 	unsigned int rx_handlers_drop;
 	unsigned int rx_handlers_queued;
 	unsigned int rx_handlers_drop_nullfunc;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2027207..6b57b11 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -186,6 +186,11 @@ struct mesh_rmc {
 /* Maximum number of paths per interface */
 #define MESH_MAX_MPATHS		1024
 
+/* Maximum number of data frames to be forwarded in tx queue */
+#define MESH_MAX_FWDING_QUEUE  384
+/* Maximum number of HWMP management frames in tx queue */
+#define MESH_MGMT_QUEUE_LEN    256
+
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fd4f76a..f09e5e8 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -105,6 +105,23 @@ enum mpath_frame_type {
 
 static const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
+static void mesh_tx_skb(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	/* Frames going through ieee80211_tx_skb will be on the voice queue,
+	 * Therefor we need to check only IEEE80211_AC_VO */
+	if (unlikely(skb_queue_len(&local->pending[IEEE80211_AC_VO]) >=
+	   MESH_MGMT_QUEUE_LEN)) {
+		kfree_skb(skb);
+		I802_DEBUG_INC(local->tx_handlers_drop_mesh_mgmt);
+		return;
+	}
+
+	ieee80211_tx_skb(sdata, skb);
+}
+
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		u8 *orig_addr, __le32 orig_sn, u8 target_flags, u8 *target,
 		__le32 target_sn, const u8 *da, u8 hop_count, u8 ttl,
@@ -198,7 +215,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		pos += 4;
 	}
 
-	ieee80211_tx_skb(sdata, skb);
+	mesh_tx_skb(sdata, skb);
 	return 0;
 }
 
@@ -263,7 +280,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 	pos += 4;
 	memcpy(pos, &target_rcode, 2);
 
-	ieee80211_tx_skb(sdata, skb);
+	mesh_tx_skb(sdata, skb);
 	return 0;
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c4453fd..9b5daa1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1817,7 +1817,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211s_hdr *mesh_hdr;
-	unsigned int hdrlen;
+	unsigned int hdrlen, q;
 	struct sk_buff *skb = rx->skb, *fwd_skb;
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
@@ -1915,6 +1915,17 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			}
 			IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 						     fwded_frames);
+
+			/* Check selected queue's size and drop if full */
+			q = skb_get_queue_mapping(fwd_skb);
+			if (unlikely(skb_queue_len(&local->pending[q]) >=
+			    MESH_MAX_FWDING_QUEUE)) {
+				kfree_skb(fwd_skb);
+				I802_DEBUG_INC(local->
+					       tx_handlers_drop_mesh_fwd);
+				return RX_DROP_MONITOR;
+			}
+
 			ieee80211_add_pending_skb(local, fwd_skb);
 		}
 	}
-- 
1.7.4.1

