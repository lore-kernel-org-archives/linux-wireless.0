Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53059 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143Ab0LBXIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:08:24 -0500
Received: by qyk11 with SMTP id 11so114528qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:08:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291325893.3481.56.camel@jlt3.sipsolutions.net>
References: <20101201205939.009530439@sipsolutions.net> <20101201210226.159495600@sipsolutions.net>
 <1291279510.3481.17.camel@jlt3.sipsolutions.net> <AANLkTik_C90v-313Pq_dPY7fE1OFG2X0uv8Ys+uGQFRt@mail.gmail.com>
 <1291320849.3481.55.camel@jlt3.sipsolutions.net> <AANLkTi=8yikvhvbUS86FZabM5qXbZ1LNHeT+2JQGU+QS@mail.gmail.com>
 <1291325893.3481.56.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 2 Dec 2010 15:08:02 -0800
Message-ID: <AANLkTi=o08ZBhF6KmYZ-jvAzM7WoMEZztNz+0Fc+WQQi@mail.gmail.com>
Subject: Re: [RFC 5/5 v2] cfg80211/mac80211: add mesh join/leave commands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Steve Derosier <steve@cozybit.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Thu, Dec 2, 2010 at 1:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> So you're happy with the 1/5 patch as well now?

Not really.  Maybe this as PATCH 1/5 v3?


>From e2c1b17a9170580001643cef1ccba3ace8e1f23f Mon Sep 17 00:00:00 2001
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 2 Dec 2010 14:57:20 -0800
Subject: [PATCH] mac80211: Define element TTL for HWMP path selection elements

The TTL in path selection information elements is different from the
mesh ttl used in mesh data frames.  Version 7.03 of the 11s draft calls this
ttl 'Element TTL'.
---
 include/linux/nl80211.h       |    4 ++++
 include/net/cfg80211.h        |    2 ++
 net/mac80211/cfg.c            |    2 ++
 net/mac80211/debugfs_netdev.c |    2 ++
 net/mac80211/mesh.c           |    1 +
 net/mac80211/mesh.h           |    2 ++
 net/mac80211/mesh_hwmp.c      |    9 +++++----
 net/mac80211/mesh_pathtbl.c   |    7 ++++---
 net/wireless/nl80211.c        |    5 +++++
 9 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 5cfa579..d8884e2 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1547,6 +1547,9 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
  * point.
  *
+ * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
+ * source mesh point for path selection elements.
+ *
  * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
  * open peer links when we detect compatible mesh peers.
  *
@@ -1585,6 +1588,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_MAX_PEER_LINKS,
 	NL80211_MESHCONF_MAX_RETRIES,
 	NL80211_MESHCONF_TTL,
+	NL80211_MESHCONF_ELEMENT_TTL,
 	NL80211_MESHCONF_AUTO_OPEN_PLINKS,
 	NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
 	NL80211_MESHCONF_PATH_REFRESH_TIME,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 49a7c53..b34dbc5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -624,6 +624,8 @@ struct mesh_config {
 	u16 dot11MeshMaxPeerLinks;
 	u8  dot11MeshMaxRetries;
 	u8  dot11MeshTTL;
+	/* ttl used in path selection information elements */
+	u8  element_ttl;
 	bool auto_open_plinks;
 	/* HWMP parameters */
 	u8  dot11MeshHWMPmaxPREQretries;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index db134b5..ce69368 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1024,6 +1024,8 @@ static int ieee80211_set_mesh_params(struct wiphy *wiphy,
 		conf->dot11MeshMaxRetries = nconf->dot11MeshMaxRetries;
 	if (_chg_mesh_attr(NL80211_MESHCONF_TTL, mask))
 		conf->dot11MeshTTL = nconf->dot11MeshTTL;
+	if (_chg_mesh_attr(NL80211_MESHCONF_ELEMENT_TTL, mask))
+		conf->dot11MeshTTL = nconf->element_ttl;
 	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
 		conf->auto_open_plinks = nconf->auto_open_plinks;
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES, mask))
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index cbdf36d..2dabdf7 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -251,6 +251,7 @@ IEEE80211_IF_FILE(dot11MeshConfirmTimeout,
 IEEE80211_IF_FILE(dot11MeshHoldingTimeout,
 		u.mesh.mshcfg.dot11MeshHoldingTimeout, DEC);
 IEEE80211_IF_FILE(dot11MeshTTL, u.mesh.mshcfg.dot11MeshTTL, DEC);
+IEEE80211_IF_FILE(element_ttl, u.mesh.mshcfg.element_ttl, DEC);
 IEEE80211_IF_FILE(auto_open_plinks, u.mesh.mshcfg.auto_open_plinks, DEC);
 IEEE80211_IF_FILE(dot11MeshMaxPeerLinks,
 		u.mesh.mshcfg.dot11MeshMaxPeerLinks, DEC);
@@ -355,6 +356,7 @@ static void add_mesh_config(struct
ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshConfirmTimeout);
 	MESHPARAMS_ADD(dot11MeshHoldingTimeout);
 	MESHPARAMS_ADD(dot11MeshTTL);
+	MESHPARAMS_ADD(element_ttl);
 	MESHPARAMS_ADD(auto_open_plinks);
 	MESHPARAMS_ADD(dot11MeshMaxPeerLinks);
 	MESHPARAMS_ADD(dot11MeshHWMPactivePathTimeout);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c8a4f19..78a36c7 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -668,6 +668,7 @@ void ieee80211_mesh_init_sdata(struct
ieee80211_sub_if_data *sdata)
 	ifmsh->mshcfg.dot11MeshHoldingTimeout = MESH_HOLD_T;
 	ifmsh->mshcfg.dot11MeshMaxRetries = MESH_MAX_RETR;
 	ifmsh->mshcfg.dot11MeshTTL = MESH_TTL;
+	ifmsh->mshcfg.element_ttl = MESH_DEFAULT_ELEMENT_TTL;
 	ifmsh->mshcfg.auto_open_plinks = true;
 	ifmsh->mshcfg.dot11MeshMaxPeerLinks =
 		MESH_MAX_ESTAB_PLINKS;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 58e7411..182942e 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -216,6 +216,8 @@ struct mesh_rmc {
 #define PERR_RCODE_NO_ROUTE     12
 #define PERR_RCODE_DEST_UNREACH 13

+#define MESH_DEFAULT_ELEMENT_TTL 31
+
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 829e08a..5bf64d7 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -232,7 +232,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 	*pos++ = WLAN_EID_PERR;
 	*pos++ = ie_len;
 	/* ttl */
-	*pos++ = MESH_TTL;
+	*pos++ = ttl;
 	/* number of destinations */
 	*pos++ = 1;
 	/*
@@ -522,7 +522,7 @@ static void hwmp_preq_frame_process(struct
ieee80211_sub_if_data *sdata,

 	if (reply) {
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
-		ttl = ifmsh->mshcfg.dot11MeshTTL;
+		ttl = ifmsh->mshcfg.element_ttl;
 		if (ttl != 0) {
 			mhwmp_dbg("replying to the PREQ\n");
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, target_addr,
@@ -877,7 +877,7 @@ void mesh_path_start_discovery(struct
ieee80211_sub_if_data *sdata)
 		sdata->u.mesh.last_sn_update = jiffies;
 	}
 	lifetime = default_lifetime(sdata);
-	ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
+	ttl = sdata->u.mesh.mshcfg.element_ttl;
 	if (ttl == 0) {
 		sdata->u.mesh.mshstats.dropped_frames_ttl++;
 		spin_unlock_bh(&mpath->state_lock);
@@ -1013,5 +1013,6 @@ mesh_path_tx_root_frame(struct
ieee80211_sub_if_data *sdata)
 	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
-			       0, MESH_TTL, 0, 0, 0, sdata);
+			       0, sdata->u.mesh.mshcfg.element_ttl,
+			       0, 0, 0, sdata);
 }
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 349e466..8d65b47 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -467,8 +467,8 @@ void mesh_plink_broken(struct sta_info *sta)
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			++mpath->sn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(MESH_TTL, mpath->dst,
-					cpu_to_le32(mpath->sn),
+			mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
+					mpath->dst, cpu_to_le32(mpath->sn),
 					cpu_to_le16(PERR_RCODE_DEST_UNREACH),
 					bcast, sdata);
 		} else
@@ -614,7 +614,8 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			sn = ++mpath->sn;
-		mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(sn),
+		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, skb->data,
+				   cpu_to_le32(sn),
 				   cpu_to_le16(PERR_RCODE_NO_ROUTE), ra, sdata);
 	}

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 960be4e..0b90cab 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2582,6 +2582,8 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
 			cur_params.dot11MeshMaxRetries);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_TTL,
 			cur_params.dot11MeshTTL);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_ELEMENT_TTL,
+			cur_params.element_ttl);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_AUTO_OPEN_PLINKS,
 			cur_params.auto_open_plinks);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
@@ -2623,6 +2625,7 @@ static const struct nla_policy
nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_MAX_PEER_LINKS] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_MAX_RETRIES] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_TTL] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_ELEMENT_TTL] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = { .type = NLA_U8 },

 	[NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES] = { .type = NLA_U8 },
@@ -2670,6 +2673,8 @@ static int nl80211_set_mesh_params(struct
sk_buff *skb, struct genl_info *info)
 			mask, NL80211_MESHCONF_MAX_RETRIES, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL,
 			mask, NL80211_MESHCONF_TTL, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, element_ttl,
+			mask, NL80211_MESHCONF_ELEMENT_TTL, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks,
 			mask, NL80211_MESHCONF_AUTO_OPEN_PLINKS, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries,
-- 
1.7.1



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
