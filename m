Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57765 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187Ab2ATIOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 03:14:08 -0500
Received: by obcva7 with SMTP id va7so386247obc.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 00:14:07 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] {nl,cfg,mac}80211: Add support of setting non-forwarding entity in Mesh
Date: Sat, 21 Jan 2012 01:02:16 +0800
Message-Id: <1327078936-27576-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120120_091432_482904_91AA3317)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A mesh node that joins the mesh network is by default a forwarding entity. This patch allows
the mesh node to set as non-forwarding entity. Whenever dot11MeshForwarding is set to 0, the
mesh node can prevent itself from forwarding the traffic which is not destined to him.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 include/linux/nl80211.h       |    4 ++++
 include/net/cfg80211.h        |    1 +
 net/mac80211/cfg.c            |    2 ++
 net/mac80211/debugfs_netdev.c |    1 +
 net/mac80211/mesh_hwmp.c      |    2 +-
 net/wireless/mesh.c           |    1 +
 net/wireless/nl80211.c        |    5 +++++
 7 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index a187606..92a1cc5 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2098,6 +2098,9 @@ enum nl80211_mntr_flags {
  * TUs) during which a mesh STA can send only one Action frame containing a
  * PERR element.
  *
+ * @NL80211_MESHCONF_FORWARDING: set Mesh STA as forwarding or non-forwarding
+ * or forwarding entity (default is TRUE - forwarding entity)
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -2122,6 +2125,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 	NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
+	NL80211_MESHCONF_FORWARDING,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3de1c39..8f78acb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -791,6 +791,7 @@ struct mesh_config {
 	 * mesh gate, but not necessarily using the gate announcement protocol.
 	 * Still keeping the same nomenclature to be in sync with the spec. */
 	bool  dot11MeshGateAnnouncementProtocol;
+	bool dot11MeshForwarding;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 393b2a4..6252bee 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1299,6 +1299,8 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->dot11MeshHWMPRannInterval =
 			nconf->dot11MeshHWMPRannInterval;
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_FORWARDING, mask))
+		conf->dot11MeshForwarding = nconf->dot11MeshForwarding;
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 8df2891..5b7c57f 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -421,6 +421,7 @@ IEEE80211_IF_FILE(dot11MeshGateAnnouncementProtocol,
 		u.mesh.mshcfg.dot11MeshGateAnnouncementProtocol, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
 		u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
+IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 #endif
 
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 73abb75..cae4071 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -575,7 +575,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			ifmsh->mshstats.dropped_frames_ttl++;
 	}
 
-	if (forward) {
+	if (forward && ifmsh->mshcfg.dot11MeshForwarding) {
 		u32 preq_id;
 		u8 hopcount, flags;
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 8c550df..9d3e3b6 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -55,6 +55,7 @@ const struct mesh_config default_mesh_config = {
 	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
 	.dot11MeshHWMPRannInterval = MESH_RANN_INTERVAL,
 	.dot11MeshGateAnnouncementProtocol = false,
+	.dot11MeshForwarding = true,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba43966..d88ec25 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3205,6 +3205,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPRannInterval);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 			cur_params.dot11MeshGateAnnouncementProtocol);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_FORWARDING,
+			cur_params.dot11MeshForwarding);
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
@@ -3236,6 +3238,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_ROOTMODE] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -3325,6 +3328,8 @@ do {\
 			dot11MeshGateAnnouncementProtocol, mask,
 			NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
 			nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding,
+			mask, NL80211_MESHCONF_FORWARDING, nla_get_u8);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.0.4

