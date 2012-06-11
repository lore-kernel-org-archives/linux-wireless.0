Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63015 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2FKEAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 00:00:20 -0400
Received: by mail-ob0-f174.google.com with SMTP id tb18so6150962obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2012 21:00:20 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] {nl,cfg,mac}80211: fix the coding style related to mesh parameters
Date: Mon, 11 Jun 2012 11:59:36 +0800
Message-Id: <1339387176-7388-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120611_060025_313843_9C98F20A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix the coding style related to mesh parameters, especially the indentation,
as pointed out by Johannes Berg.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 include/linux/ieee80211.h     |    6 +-
 include/linux/nl80211.h       |   98 +++++++++++++++++++++-------------------
 include/net/cfg80211.h        |   12 +++---
 net/mac80211/cfg.c            |    3 +-
 net/mac80211/debugfs_netdev.c |   34 +++++++-------
 net/wireless/nl80211.c        |   97 ++++++++++++++++++++++-------------------
 6 files changed, 130 insertions(+), 120 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ce9af89..f831078 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1443,7 +1443,7 @@ enum ieee80211_tdls_actioncode {
  *
  * @IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET: the default synchronization method
  * @IEEE80211_SYNC_METHOD_VENDOR: a vendor specific synchronization method
- * that will be specified in a vendor specific information element
+ *	that will be specified in a vendor specific information element
  */
 enum {
 	IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET = 1,
@@ -1455,7 +1455,7 @@ enum {
  *
  * @IEEE80211_PATH_PROTOCOL_HWMP: the default path selection protocol
  * @IEEE80211_PATH_PROTOCOL_VENDOR: a vendor specific protocol that will
- * be specified in a vendor specific information element
+ *	be specified in a vendor specific information element
  */
 enum {
 	IEEE80211_PATH_PROTOCOL_HWMP = 1,
@@ -1467,7 +1467,7 @@ enum {
  *
  * @IEEE80211_PATH_METRIC_AIRTIME: the default path selection metric
  * @IEEE80211_PATH_METRIC_VENDOR: a vendor specific metric that will be
- * specified in a vendor specific information element
+ *	specified in a vendor specific information element
  */
 enum {
 	IEEE80211_PATH_METRIC_AIRTIME = 1,
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 970afdf..c61e162 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -2090,78 +2090,80 @@ enum nl80211_mntr_flags {
  * @__NL80211_MESHCONF_INVALID: internal use
  *
  * @NL80211_MESHCONF_RETRY_TIMEOUT: specifies the initial retry timeout in
- * millisecond units, used by the Peer Link Open message
+ *	millisecond units, used by the Peer Link Open message
  *
  * @NL80211_MESHCONF_CONFIRM_TIMEOUT: specifies the initial confirm timeout, in
- * millisecond units, used by the peer link management to close a peer link
+ *	millisecond units, used by the peer link management to close a peer link
  *
  * @NL80211_MESHCONF_HOLDING_TIMEOUT: specifies the holding timeout, in
- * millisecond units
+ *	millisecond units
  *
  * @NL80211_MESHCONF_MAX_PEER_LINKS: maximum number of peer links allowed
- * on this mesh interface
+ *	on this mesh interface
  *
  * @NL80211_MESHCONF_MAX_RETRIES: specifies the maximum number of peer link
- * open retries that can be sent to establish a new peer link instance in a
- * mesh
+ *	open retries that can be sent to establish a new peer link instance in a
+ *	mesh
  *
  * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
- * point.
+ *	point.
  *
  * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
- * open peer links when we detect compatible mesh peers.
+ *	open peer links when we detect compatible mesh peers.
  *
  * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
- * containing a PREQ that an MP can send to a particular destination (path
- * target)
+ *	containing a PREQ that an MP can send to a particular destination (path
+ *	target)
  *
  * @NL80211_MESHCONF_PATH_REFRESH_TIME: how frequently to refresh mesh paths
- * (in milliseconds)
+ *	(in milliseconds)
  *
  * @NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT: minimum length of time to wait
- * until giving up on a path discovery (in milliseconds)
+ *	until giving up on a path discovery (in milliseconds)
  *
  * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT: The time (in TUs) for which mesh
- * points receiving a PREQ shall consider the forwarding information from the
- * root to be valid. (TU = time unit)
+ *	points receiving a PREQ shall consider the forwarding information from
+ *	the root to be valid. (TU = time unit)
  *
  * @NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL: The minimum interval of time (in
- * TUs) during which an MP can send only one action frame containing a PREQ
- * reference element
+ *	TUs) during which an MP can send only one action frame containing a PREQ
+ *	reference element
  *
  * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
- * that it takes for an HWMP information element to propagate across the mesh
+ *	that it takes for an HWMP information element to propagate across the
+ *	mesh
  *
  * @NL80211_MESHCONF_HWMP_ROOTMODE: whether root mode is enabled or not
  *
  * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
- * source mesh point for path selection elements.
+ *	source mesh point for path selection elements.
  *
  * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
- * root announcements are transmitted.
+ *	root announcements are transmitted.
  *
  * @NL80211_MESHCONF_GATE_ANNOUNCEMENTS: Advertise that this mesh station has
- * access to a broader network beyond the MBSS.  This is done via Root
- * Announcement frames.
+ *	access to a broader network beyond the MBSS.  This is done via Root
+ *	Announcement frames.
  *
  * @NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL: The minimum interval of time (in
- * TUs) during which a mesh STA can send only one Action frame containing a
- * PERR element.
+ *	TUs) during which a mesh STA can send only one Action frame containing a
+ *	PERR element.
  *
  * @NL80211_MESHCONF_FORWARDING: set Mesh STA as forwarding or non-forwarding
- * or forwarding entity (default is TRUE - forwarding entity)
+ *	or forwarding entity (default is TRUE - forwarding entity)
  *
  * @NL80211_MESHCONF_RSSI_THRESHOLD: RSSI threshold in dBm. This specifies the
- * threshold for average signal strength of candidate station to establish
- * a peer link.
- *
- * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
+ *	threshold for average signal strength of candidate station to establish
+ *	a peer link.
  *
  * @NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR: maximum number of neighbors
- * to synchronize to for 11s default synchronization method (see 11C.12.2.2)
+ *	to synchronize to for 11s default synchronization method
+ *	(see 11C.12.2.2)
  *
  * @NL80211_MESHCONF_HT_OPMODE: set mesh HT protection mode.
  *
+ * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2203,34 +2205,36 @@ enum nl80211_meshconf_params {
  * @__NL80211_MESH_SETUP_INVALID: Internal use
  *
  * @NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL: Enable this option to use a
- * vendor specific path selection algorithm or disable it to use the default
- * HWMP.
+ *	vendor specific path selection algorithm or disable it to use the
+ *	default HWMP.
  *
  * @NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC: Enable this option to use a
- * vendor specific path metric or disable it to use the default Airtime
- * metric.
+ *	vendor specific path metric or disable it to use the default Airtime
+ *	metric.
  *
  * @NL80211_MESH_SETUP_IE: Information elements for this mesh, for instance, a
- * robust security network ie, or a vendor specific information element that
- * vendors will use to identify the path selection methods and metrics in use.
+ *	robust security network ie, or a vendor specific information element
+ *	that vendors will use to identify the path selection methods and
+ *	metrics in use.
  *
  * @NL80211_MESH_SETUP_USERSPACE_AUTH: Enable this option if an authentication
- * daemon will be authenticating mesh candidates.
+ *	daemon will be authenticating mesh candidates.
  *
  * @NL80211_MESH_SETUP_USERSPACE_AMPE: Enable this option if an authentication
- * daemon will be securing peer link frames.  AMPE is a secured version of Mesh
- * Peering Management (MPM) and is implemented with the assistance of a
- * userspace daemon.  When this flag is set, the kernel will send peer
- * management frames to a userspace daemon that will implement AMPE
- * functionality (security capabilities selection, key confirmation, and key
- * management).  When the flag is unset (default), the kernel can autonomously
- * complete (unsecured) mesh peering without the need of a userspace daemon.
- *
- * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
+ *	daemon will be securing peer link frames.  AMPE is a secured version of
+ *	Mesh Peering Management (MPM) and is implemented with the assistance of
+ *	a userspace daemon.  When this flag is set, the kernel will send peer
+ *	management frames to a userspace daemon that will implement AMPE
+ *	functionality (security capabilities selection, key confirmation, and
+ *	key management).  When the flag is unset (default), the kernel can
+ *	autonomously complete (unsecured) mesh peering without the need of a
+ *	userspace daemon.
  *
  * @NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC: Enable this option to use a
- * vendor specific synchronization method or disable it to use the default
- * neighbor offset synchronization
+ *	vendor specific synchronization method or disable it to use the default
+ *	neighbor offset synchronization
+ *
+ * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a129ee2..778e533 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -848,21 +848,21 @@ struct mesh_config {
 	u16 dot11MeshConfirmTimeout;
 	u16 dot11MeshHoldingTimeout;
 	u16 dot11MeshMaxPeerLinks;
-	u8  dot11MeshMaxRetries;
-	u8  dot11MeshTTL;
-	u8  element_ttl;
+	u8 dot11MeshMaxRetries;
+	u8 dot11MeshTTL;
+	u8 element_ttl;
 	bool auto_open_plinks;
 	u32 dot11MeshNbrOffsetMaxNeighbor;
-	u8  dot11MeshHWMPmaxPREQretries;
+	u8 dot11MeshHWMPmaxPREQretries;
 	u32 path_refresh_time;
 	u16 min_discovery_timeout;
 	u32 dot11MeshHWMPactivePathTimeout;
 	u16 dot11MeshHWMPpreqMinInterval;
 	u16 dot11MeshHWMPperrMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
-	u8  dot11MeshHWMPRootMode;
+	u8 dot11MeshHWMPRootMode;
 	u16 dot11MeshHWMPRannInterval;
-	bool  dot11MeshGateAnnouncementProtocol;
+	bool dot11MeshGateAnnouncementProtocol;
 	bool dot11MeshForwarding;
 	s32 rssi_threshold;
 	u16 ht_opmode;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 498c94e..f41f9be 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1571,10 +1571,9 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->dot11MeshGateAnnouncementProtocol =
 			nconf->dot11MeshGateAnnouncementProtocol;
 	}
-	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_RANN_INTERVAL, mask)) {
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_RANN_INTERVAL, mask))
 		conf->dot11MeshHWMPRannInterval =
 			nconf->dot11MeshHWMPRannInterval;
-	}
 	if (_chg_mesh_attr(NL80211_MESHCONF_FORWARDING, mask))
 		conf->dot11MeshForwarding = nconf->dot11MeshForwarding;
 	if (_chg_mesh_attr(NL80211_MESHCONF_RSSI_THRESHOLD, mask)) {
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index d4272ff..c429417 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -468,45 +468,45 @@ IEEE80211_IF_FILE(fwded_unicast, u.mesh.mshstats.fwded_unicast, DEC);
 IEEE80211_IF_FILE(fwded_frames, u.mesh.mshstats.fwded_frames, DEC);
 IEEE80211_IF_FILE(dropped_frames_ttl, u.mesh.mshstats.dropped_frames_ttl, DEC);
 IEEE80211_IF_FILE(dropped_frames_congestion,
-		u.mesh.mshstats.dropped_frames_congestion, DEC);
+		  u.mesh.mshstats.dropped_frames_congestion, DEC);
 IEEE80211_IF_FILE(dropped_frames_no_route,
-		u.mesh.mshstats.dropped_frames_no_route, DEC);
+		  u.mesh.mshstats.dropped_frames_no_route, DEC);
 IEEE80211_IF_FILE(estab_plinks, u.mesh.mshstats.estab_plinks, ATOMIC);
 
 /* Mesh parameters */
 IEEE80211_IF_FILE(dot11MeshMaxRetries,
-		u.mesh.mshcfg.dot11MeshMaxRetries, DEC);
+		  u.mesh.mshcfg.dot11MeshMaxRetries, DEC);
 IEEE80211_IF_FILE(dot11MeshRetryTimeout,
-		u.mesh.mshcfg.dot11MeshRetryTimeout, DEC);
+		  u.mesh.mshcfg.dot11MeshRetryTimeout, DEC);
 IEEE80211_IF_FILE(dot11MeshConfirmTimeout,
-		u.mesh.mshcfg.dot11MeshConfirmTimeout, DEC);
+		  u.mesh.mshcfg.dot11MeshConfirmTimeout, DEC);
 IEEE80211_IF_FILE(dot11MeshHoldingTimeout,
-		u.mesh.mshcfg.dot11MeshHoldingTimeout, DEC);
+		  u.mesh.mshcfg.dot11MeshHoldingTimeout, DEC);
 IEEE80211_IF_FILE(dot11MeshTTL, u.mesh.mshcfg.dot11MeshTTL, DEC);
 IEEE80211_IF_FILE(element_ttl, u.mesh.mshcfg.element_ttl, DEC);
 IEEE80211_IF_FILE(auto_open_plinks, u.mesh.mshcfg.auto_open_plinks, DEC);
 IEEE80211_IF_FILE(dot11MeshMaxPeerLinks,
-		u.mesh.mshcfg.dot11MeshMaxPeerLinks, DEC);
+		  u.mesh.mshcfg.dot11MeshMaxPeerLinks, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPactivePathTimeout,
-		u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout, DEC);
+		  u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPpreqMinInterval,
-		u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval, DEC);
+		  u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPperrMinInterval,
-		u.mesh.mshcfg.dot11MeshHWMPperrMinInterval, DEC);
+		  u.mesh.mshcfg.dot11MeshHWMPperrMinInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPnetDiameterTraversalTime,
-		u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime, DEC);
+		  u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPmaxPREQretries,
-		u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries, DEC);
+		  u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries, DEC);
 IEEE80211_IF_FILE(path_refresh_time,
-		u.mesh.mshcfg.path_refresh_time, DEC);
+		  u.mesh.mshcfg.path_refresh_time, DEC);
 IEEE80211_IF_FILE(min_discovery_timeout,
-		u.mesh.mshcfg.min_discovery_timeout, DEC);
+		  u.mesh.mshcfg.min_discovery_timeout, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
-		u.mesh.mshcfg.dot11MeshHWMPRootMode, DEC);
+		  u.mesh.mshcfg.dot11MeshHWMPRootMode, DEC);
 IEEE80211_IF_FILE(dot11MeshGateAnnouncementProtocol,
-		u.mesh.mshcfg.dot11MeshGateAnnouncementProtocol, DEC);
+		  u.mesh.mshcfg.dot11MeshGateAnnouncementProtocol, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPRannInterval,
-		u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
+		  u.mesh.mshcfg.dot11MeshHWMPRannInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshForwarding, u.mesh.mshcfg.dot11MeshForwarding, DEC);
 IEEE80211_IF_FILE(rssi_threshold, u.mesh.mshcfg.rssi_threshold, DEC);
 IEEE80211_IF_FILE(ht_opmode, u.mesh.mshcfg.ht_opmode, DEC);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ae54b8..dd94ee5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -115,7 +115,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
-				.len = IEEE80211_MAX_MESH_ID_LEN },
+				   .len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
 
 	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
@@ -3492,7 +3492,6 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_ELEMENT_TTL] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR] = { .type = NLA_U32 },
-
 	[NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_PATH_REFRESH_TIME] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT] = { .type = NLA_U16 },
@@ -3504,8 +3503,8 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_RANN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_GATE_ANNOUNCEMENTS] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_FORWARDING] = { .type = NLA_U8 },
-	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32},
-	[NL80211_MESHCONF_HT_OPMODE] = { .type = NLA_U16},
+	[NL80211_MESHCONF_RSSI_THRESHOLD] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_HT_OPMODE] = { .type = NLA_U16 },
 };
 
 static const struct nla_policy
@@ -3515,7 +3514,7 @@ static const struct nla_policy
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_USERSPACE_AUTH] = { .type = NLA_FLAG },
 	[NL80211_MESH_SETUP_IE] = { .type = NLA_BINARY,
-		.len = IEEE80211_MAX_DATA_LEN },
+				    .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_MESH_SETUP_USERSPACE_AMPE] = { .type = NLA_FLAG },
 };
 
@@ -3548,63 +3547,71 @@ do {\
 
 	/* Fill in the params struct */
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout,
-			mask, NL80211_MESHCONF_RETRY_TIMEOUT, nla_get_u16);
+				  mask, NL80211_MESHCONF_RETRY_TIMEOUT,
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConfirmTimeout,
-			mask, NL80211_MESHCONF_CONFIRM_TIMEOUT, nla_get_u16);
+				  mask, NL80211_MESHCONF_CONFIRM_TIMEOUT,
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHoldingTimeout,
-			mask, NL80211_MESHCONF_HOLDING_TIMEOUT, nla_get_u16);
+				  mask, NL80211_MESHCONF_HOLDING_TIMEOUT,
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxPeerLinks,
-			mask, NL80211_MESHCONF_MAX_PEER_LINKS, nla_get_u16);
+				  mask, NL80211_MESHCONF_MAX_PEER_LINKS,
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxRetries,
-			mask, NL80211_MESHCONF_MAX_RETRIES, nla_get_u8);
+				  mask, NL80211_MESHCONF_MAX_RETRIES,
+				  nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL,
-			mask, NL80211_MESHCONF_TTL, nla_get_u8);
+				  mask, NL80211_MESHCONF_TTL, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, element_ttl,
-			mask, NL80211_MESHCONF_ELEMENT_TTL, nla_get_u8);
+				  mask, NL80211_MESHCONF_ELEMENT_TTL,
+				  nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks,
-			mask, NL80211_MESHCONF_AUTO_OPEN_PLINKS, nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshNbrOffsetMaxNeighbor,
-			mask, NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
-			nla_get_u32);
+				  mask, NL80211_MESHCONF_AUTO_OPEN_PLINKS,
+				  nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshNbrOffsetMaxNeighbor, mask,
+				  NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
+				  nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries,
-			mask, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
-			nla_get_u8);
+				  mask, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
+				  nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, path_refresh_time,
-			mask, NL80211_MESHCONF_PATH_REFRESH_TIME, nla_get_u32);
+				  mask, NL80211_MESHCONF_PATH_REFRESH_TIME,
+				  nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, min_discovery_timeout,
-			mask, NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
-			nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathTimeout,
-			mask, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
-			nla_get_u32);
+				  mask, NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathTimeout, mask,
+				  NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
+				  nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPpreqMinInterval,
-			mask, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
-			nla_get_u16);
+				  mask, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPperrMinInterval,
-			mask, NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
-			nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-			dot11MeshHWMPnetDiameterTraversalTime,
-			mask, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
-			nla_get_u16);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-			dot11MeshHWMPRootMode, mask,
-			NL80211_MESHCONF_HWMP_ROOTMODE,
-			nla_get_u8);
+				  mask, NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-			dot11MeshHWMPRannInterval, mask,
-			NL80211_MESHCONF_HWMP_RANN_INTERVAL,
-			nla_get_u16);
+				  dot11MeshHWMPnetDiameterTraversalTime, mask,
+				  NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+				  nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRootMode, mask,
+				  NL80211_MESHCONF_HWMP_ROOTMODE, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPRannInterval, mask,
+				  NL80211_MESHCONF_HWMP_RANN_INTERVAL,
+				  nla_get_u16);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
-			dot11MeshGateAnnouncementProtocol, mask,
-			NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
-			nla_get_u8);
+				  dot11MeshGateAnnouncementProtocol, mask,
+				  NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
+				  nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding,
-			mask, NL80211_MESHCONF_FORWARDING, nla_get_u8);
+				  mask, NL80211_MESHCONF_FORWARDING,
+				  nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold,
-			mask, NL80211_MESHCONF_RSSI_THRESHOLD, nla_get_u32);
+				  mask, NL80211_MESHCONF_RSSI_THRESHOLD,
+				  nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode,
-			mask, NL80211_MESHCONF_HT_OPMODE, nla_get_u16);
+				  mask, NL80211_MESHCONF_HT_OPMODE,
+				  nla_get_u16);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.0.4

