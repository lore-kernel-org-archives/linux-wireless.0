Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44891 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab2B0WjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 17:39:05 -0500
Received: by pbcup15 with SMTP id up15so2554251pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 14:39:04 -0800 (PST)
MIME-Version: 1.0
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, ashok@cozybit.com
Subject: [PATCH v2] {nl,cfg,mac}80211: Implement RSSI threshold for mesh peering
Date: Mon, 27 Feb 2012 14:38:54 -0800
Message-Id: <1330382334-3899-1-git-send-email-ashok@cozybit.com> (sfid-20120227_233912_786633_B303BFEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh peer links are established only if average rssi of the peer
candidate satisfies the threshold. This is not in 802.11s specification
but was requested by David Fulgham, an open80211s user. This is a way to avoid
marginal peer links with stations that are barely within range.

This patch adds a new mesh configuration parameter, mesh_rssi_threshold.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v2: create mesh-specific rssi_threshold parameter (Johannes)

 include/linux/nl80211.h       |    4 ++++
 include/net/cfg80211.h        |    1 +
 net/mac80211/cfg.c            |    2 ++
 net/mac80211/debugfs_netdev.c |    2 ++
 net/mac80211/mesh_plink.c     |   22 +++++++++++++++++++++-
 net/wireless/mesh.c           |    3 +++
 net/wireless/nl80211.c        |    5 +++++
 7 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index be35a68..0a05d17 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2112,6 +2112,9 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_FORWARDING: set Mesh STA as forwarding or non-forwarding
  * or forwarding entity (default is TRUE - forwarding entity)
  *
+ * @NL80211_MESHCONF_RSSI_THRESHOLD: specifies the threshold for average signal
+ * strength of candidate station to establish a peer link.
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -2137,6 +2140,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 	NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
 	NL80211_MESHCONF_FORWARDING,
+	NL80211_MESHCONF_RSSI_THRESHOLD,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 755a770..f22fba8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -809,6 +809,7 @@ struct mesh_config {
 	 * Still keeping the same nomenclature to be in sync with the spec. */
 	bool  dot11MeshGateAnnouncementProtocol;
 	bool dot11MeshForwarding;
+	int32_t  rssi_threshold;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f7eb25a..fcf8a98 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1314,6 +1314,8 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 	}
 	if (_chg_mesh_attr(NL80211_MESHCONF_FORWARDING, mask))
 		conf->dot11MeshForwarding = nconf->dot11MeshForwarding;
+	if (_chg_mesh_attr(NL80211_MESHCONF_RSSI_THRESHOLD, mask))
+		conf->rssi_threshold = nconf->rssi_threshold;
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 510ed1d..9f484d8 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -443,6 +443,7 @@ IEEE80211_IF_FILE(dot11MeshGateAnnouncementProtocol,
 IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 		u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
+IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
 #endif
 
 
@@ -581,6 +582,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPRootMode);
 	MESHPARAMS_ADD(dot11MeshHWMPRannInterval);
 	MESHPARAMS_ADD(dot11MeshGateAnnouncementProtocol);
+	MESHPARAMS_ADD(rssi_threshold);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8806e5e..f3ccbb6 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -31,6 +31,17 @@
 #define dot11MeshHoldingTimeout(s) (s->u.mesh.mshcfg.dot11MeshHoldingTimeout)
 #define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
 
+/*
+ * NOTE: Mesh peer links are established only if average rssi of the peer
+ * candidate satisfies the threshold.
+ * ewma_read reports average singal strength with polarity reversed.
+ */
+
+#define sta_meets_rssi_threshold(sta, sdata) \
+		(sdata->u.mesh.mshcfg.rssi_threshold == 0 ||\
+		(s8) -ewma_read(&sta->avg_signal) > \
+		sdata->u.mesh.mshcfg.rssi_threshold)
+
 enum plink_event {
 	PLINK_UNDEFINED,
 	OPN_ACPT,
@@ -301,7 +312,8 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 	if (mesh_peer_accepts_plinks(elems) &&
 			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
-			sdata->u.mesh.mshcfg.auto_open_plinks)
+			sdata->u.mesh.mshcfg.auto_open_plinks &&
+			sta_meets_rssi_threshold(sta, sdata))
 		mesh_plink_open(sta);
 
 	rcu_read_unlock();
@@ -531,6 +543,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
+	if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
+	    !sta_meets_rssi_threshold(sta, sdata)) {
+		mpl_dbg("Mesh plink: %pM does not meet rssi threshold\n",
+			sta->sta.addr);
+		rcu_read_unlock();
+		return;
+	}
+
 	if (sta && !test_sta_flag(sta, WLAN_STA_AUTH)) {
 		mpl_dbg("Mesh plink: Action frame from non-authed peer\n");
 		rcu_read_unlock();
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 9d3e3b6..ba21ab2 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -23,6 +23,8 @@
 #define MESH_PERR_MIN_INT	100
 #define MESH_DIAM_TRAVERSAL_TIME 50
 
+#define MESH_RSSI_THRESHOLD	0
+
 /*
  * A path will be refreshed if it is used PATH_REFRESH_TIME milliseconds
  * before timing out.  This way it will remain ACTIVE and no data frames
@@ -56,6 +58,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPRannInterval = MESH_RANN_INTERVAL,
 	.dot11MeshGateAnnouncementProtocol = false,
 	.dot11MeshForwarding = true,
+	.rssi_threshold = MESH_RSSI_THRESHOLD,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1998c36..25a470a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3290,6 +3290,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.dot11MeshGateAnnouncementProtocol);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_FORWARDING,
 			cur_params.dot11MeshForwarding);
+	NLA_PUT_U32(msg, NL80211_MESHCONF_RSSI_THRESHOLD,
+			cur_params.rssi_threshold);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
@@ -3322,6 +3324,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32},
 };
 
 static const struct nla_policy
@@ -3413,6 +3416,8 @@ do {\
 			nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding,
 			mask, NL80211_MESHCONF_FORWARDING, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold,
+			mask, NL80211_MESHCONF_RSSI_THRESHOLD, nla_get_u32);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.0.4

