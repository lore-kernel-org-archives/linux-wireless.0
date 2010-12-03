Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab0LCI10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 03:27:26 -0500
Message-Id: <20101203082348.277663159@sipsolutions.net>
Date: Fri, 03 Dec 2010 09:20:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] nl80211/mac80211: define and allow configuring mesh
 element TTL
References: <20101203082039.131181927@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

The TTL in path selection information elements is different from
the mesh ttl used in mesh data frames.  Version 7.03 of the 11s
draft calls this ttl 'Element TTL'.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
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

--- wireless-testing.orig/include/linux/nl80211.h	2010-12-03 09:09:28.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2010-12-03 09:12:23.000000000 +0100
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
@@ -1593,6 +1596,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 	NL80211_MESHCONF_HWMP_ROOTMODE,
+	NL80211_MESHCONF_ELEMENT_TTL,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2010-12-03 09:09:29.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-12-03 09:11:52.000000000 +0100
@@ -624,6 +624,8 @@ struct mesh_config {
 	u16 dot11MeshMaxPeerLinks;
 	u8  dot11MeshMaxRetries;
 	u8  dot11MeshTTL;
+	/* ttl used in path selection information elements */
+	u8  element_ttl;
 	bool auto_open_plinks;
 	/* HWMP parameters */
 	u8  dot11MeshHWMPmaxPREQretries;
--- wireless-testing.orig/net/mac80211/cfg.c	2010-12-03 09:09:29.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-12-03 09:11:52.000000000 +0100
@@ -1024,6 +1024,8 @@ static int ieee80211_set_mesh_params(str
 		conf->dot11MeshMaxRetries = nconf->dot11MeshMaxRetries;
 	if (_chg_mesh_attr(NL80211_MESHCONF_TTL, mask))
 		conf->dot11MeshTTL = nconf->dot11MeshTTL;
+	if (_chg_mesh_attr(NL80211_MESHCONF_ELEMENT_TTL, mask))
+		conf->dot11MeshTTL = nconf->element_ttl;
 	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
 		conf->auto_open_plinks = nconf->auto_open_plinks;
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES, mask))
--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2010-10-27 07:39:33.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2010-12-03 09:11:52.000000000 +0100
@@ -251,6 +251,7 @@ IEEE80211_IF_FILE(dot11MeshConfirmTimeou
 IEEE80211_IF_FILE(dot11MeshHoldingTimeout,
 		u.mesh.mshcfg.dot11MeshHoldingTimeout, DEC);
 IEEE80211_IF_FILE(dot11MeshTTL, u.mesh.mshcfg.dot11MeshTTL, DEC);
+IEEE80211_IF_FILE(element_ttl, u.mesh.mshcfg.element_ttl, DEC);
 IEEE80211_IF_FILE(auto_open_plinks, u.mesh.mshcfg.auto_open_plinks, DEC);
 IEEE80211_IF_FILE(dot11MeshMaxPeerLinks,
 		u.mesh.mshcfg.dot11MeshMaxPeerLinks, DEC);
@@ -355,6 +356,7 @@ static void add_mesh_config(struct ieee8
 	MESHPARAMS_ADD(dot11MeshConfirmTimeout);
 	MESHPARAMS_ADD(dot11MeshHoldingTimeout);
 	MESHPARAMS_ADD(dot11MeshTTL);
+	MESHPARAMS_ADD(element_ttl);
 	MESHPARAMS_ADD(auto_open_plinks);
 	MESHPARAMS_ADD(dot11MeshMaxPeerLinks);
 	MESHPARAMS_ADD(dot11MeshHWMPactivePathTimeout);
--- wireless-testing.orig/net/mac80211/mesh.c	2010-12-03 09:09:29.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.c	2010-12-03 09:11:52.000000000 +0100
@@ -668,6 +668,7 @@ void ieee80211_mesh_init_sdata(struct ie
 	ifmsh->mshcfg.dot11MeshHoldingTimeout = MESH_HOLD_T;
 	ifmsh->mshcfg.dot11MeshMaxRetries = MESH_MAX_RETR;
 	ifmsh->mshcfg.dot11MeshTTL = MESH_TTL;
+	ifmsh->mshcfg.element_ttl = MESH_DEFAULT_ELEMENT_TTL;
 	ifmsh->mshcfg.auto_open_plinks = true;
 	ifmsh->mshcfg.dot11MeshMaxPeerLinks =
 		MESH_MAX_ESTAB_PLINKS;
--- wireless-testing.orig/net/mac80211/mesh.h	2010-12-03 09:11:03.000000000 +0100
+++ wireless-testing/net/mac80211/mesh.h	2010-12-03 09:11:52.000000000 +0100
@@ -216,6 +216,8 @@ struct mesh_rmc {
 #define PERR_RCODE_NO_ROUTE     12
 #define PERR_RCODE_DEST_UNREACH 13
 
+#define MESH_DEFAULT_ELEMENT_TTL 31
+
 /* Public interfaces */
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2010-12-03 09:11:03.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2010-12-03 09:11:52.000000000 +0100
@@ -232,7 +232,7 @@ int mesh_path_error_tx(u8 ttl, u8 *targe
 	*pos++ = WLAN_EID_PERR;
 	*pos++ = ie_len;
 	/* ttl */
-	*pos++ = MESH_TTL;
+	*pos++ = ttl;
 	/* number of destinations */
 	*pos++ = 1;
 	/*
@@ -522,7 +522,7 @@ static void hwmp_preq_frame_process(stru
 
 	if (reply) {
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
-		ttl = ifmsh->mshcfg.dot11MeshTTL;
+		ttl = ifmsh->mshcfg.element_ttl;
 		if (ttl != 0) {
 			mhwmp_dbg("replying to the PREQ\n");
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, target_addr,
@@ -877,7 +877,7 @@ void mesh_path_start_discovery(struct ie
 		sdata->u.mesh.last_sn_update = jiffies;
 	}
 	lifetime = default_lifetime(sdata);
-	ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
+	ttl = sdata->u.mesh.mshcfg.element_ttl;
 	if (ttl == 0) {
 		sdata->u.mesh.mshstats.dropped_frames_ttl++;
 		spin_unlock_bh(&mpath->state_lock);
@@ -1013,5 +1013,6 @@ mesh_path_tx_root_frame(struct ieee80211
 	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->vif.addr,
 			       cpu_to_le32(++ifmsh->sn),
 			       0, NULL, 0, broadcast_addr,
-			       0, MESH_TTL, 0, 0, 0, sdata);
+			       0, sdata->u.mesh.mshcfg.element_ttl,
+			       0, 0, 0, sdata);
 }
--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2010-12-03 09:11:03.000000000 +0100
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2010-12-03 09:11:52.000000000 +0100
@@ -467,8 +467,8 @@ void mesh_plink_broken(struct sta_info *
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
@@ -614,7 +614,8 @@ void mesh_path_discard_frame(struct sk_b
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			sn = ++mpath->sn;
-		mesh_path_error_tx(MESH_TTL, skb->data, cpu_to_le32(sn),
+		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, skb->data,
+				   cpu_to_le32(sn),
 				   cpu_to_le16(PERR_RCODE_NO_ROUTE), ra, sdata);
 	}
 
--- wireless-testing.orig/net/wireless/nl80211.c	2010-12-03 09:09:29.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-12-03 09:11:52.000000000 +0100
@@ -2582,6 +2582,8 @@ static int nl80211_get_mesh_params(struc
 			cur_params.dot11MeshMaxRetries);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_TTL,
 			cur_params.dot11MeshTTL);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_ELEMENT_TTL,
+			cur_params.element_ttl);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_AUTO_OPEN_PLINKS,
 			cur_params.auto_open_plinks);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
@@ -2623,6 +2625,7 @@ static const struct nla_policy nl80211_m
 	[NL80211_MESHCONF_MAX_PEER_LINKS] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_MAX_RETRIES] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_TTL] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_ELEMENT_TTL] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = { .type = NLA_U8 },
 
 	[NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES] = { .type = NLA_U8 },
@@ -2670,6 +2673,8 @@ static int nl80211_set_mesh_params(struc
 			mask, NL80211_MESHCONF_MAX_RETRIES, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL,
 			mask, NL80211_MESHCONF_TTL, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, element_ttl,
+			mask, NL80211_MESHCONF_ELEMENT_TTL, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks,
 			mask, NL80211_MESHCONF_AUTO_OPEN_PLINKS, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries,


