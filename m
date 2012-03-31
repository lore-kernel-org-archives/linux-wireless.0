Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63924 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2CaSby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 14:31:54 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so816411dak.11
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 11:31:54 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] {nl,cfg}80211: Support for mesh synchronization
Date: Sat, 31 Mar 2012 11:31:33 -0700
Message-Id: <1333218693-30093-5-git-send-email-javier@cozybit.com> (sfid-20120331_203157_924645_4A9282C2)
In-Reply-To: <1333218693-30093-1-git-send-email-javier@cozybit.com>
References: <1333218693-30093-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report Toffset to userspace.
Let userspace select the mesh synchronization method.

Signed-off-by: Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
Signed-off-by: Pavel Zubarev <pavel.zubarev@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h |   12 ++++++++++++
 include/net/cfg80211.h  |   14 +++++++++++---
 net/mac80211/cfg.c      |    8 ++++++++
 net/wireless/mesh.c     |    3 +++
 net/wireless/nl80211.c  |   16 ++++++++++++++++
 5 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index e474f6e..b9b1f01 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1685,6 +1685,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
  * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
  * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
+ * @NL80211_STA_INFO_T_OFFSET: timing offset with respect to this STA (s64)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1708,6 +1709,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_CONNECTED_TIME,
 	NL80211_STA_INFO_STA_FLAGS,
 	NL80211_STA_INFO_BEACON_LOSS,
+	NL80211_STA_INFO_T_OFFSET,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -2142,6 +2144,9 @@ enum nl80211_mntr_flags {
  *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
+ * @NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR: maximum number of neighbors
+ * to synchronize to for 11s default synchronization method (see 11C.12.2.2)
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2166,6 +2171,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
 	NL80211_MESHCONF_FORWARDING,
 	NL80211_MESHCONF_RSSI_THRESHOLD,
+	NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
@@ -2205,6 +2211,11 @@ enum nl80211_meshconf_params {
  * complete (unsecured) mesh peering without the need of a userspace daemon.
  *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
+ *
+ * @NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC: Enable this option to use a
+ * vendor specific synchronization method or disable it to use the default
+ * neighbor offset synchronization
+ *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
 enum nl80211_mesh_setup_params {
@@ -2214,6 +2225,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_IE,
 	NL80211_MESH_SETUP_USERSPACE_AUTH,
 	NL80211_MESH_SETUP_USERSPACE_AMPE,
+	NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5ccac72..f394cda 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -520,6 +520,7 @@ struct station_parameters {
  * @STATION_INFO_ASSOC_REQ_IES: @assoc_req_ies filled
  * @STATION_INFO_STA_FLAGS: @sta_flags filled
  * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
+ * @STATION_INFO_T_OFFSET: @t_offset filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -541,7 +542,8 @@ enum station_info_flags {
 	STATION_INFO_CONNECTED_TIME	= 1<<16,
 	STATION_INFO_ASSOC_REQ_IES	= 1<<17,
 	STATION_INFO_STA_FLAGS		= 1<<18,
-	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19
+	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19,
+	STATION_INFO_T_OFFSET		= 1<<20,
 };
 
 /**
@@ -642,6 +644,7 @@ struct sta_bss_parameters {
  * @assoc_req_ies_len: Length of assoc_req_ies buffer in octets.
  * @sta_flags: station flags mask & values
  * @beacon_loss_count: Number of times beacon loss event has triggered.
+ * @t_offset: Time offset of the station relative to this host.
  */
 struct station_info {
 	u32 filled;
@@ -670,6 +673,7 @@ struct station_info {
 	size_t assoc_req_ies_len;
 
 	u32 beacon_loss_count;
+	s64 t_offset;
 
 	/*
 	 * Note: Add a new enum station_info_flags value for each new field and
@@ -797,6 +801,8 @@ struct mesh_config {
 	/* ttl used in path selection information elements */
 	u8  element_ttl;
 	bool auto_open_plinks;
+	/* neighbor offset synchronization */
+	u32 dot11MeshNbrOffsetMaxNeighbor;
 	/* HWMP parameters */
 	u8  dot11MeshHWMPmaxPREQretries;
 	u32 path_refresh_time;
@@ -820,6 +826,7 @@ struct mesh_config {
  * struct mesh_setup - 802.11s mesh setup configuration
  * @mesh_id: the mesh ID
  * @mesh_id_len: length of the mesh ID, at least 1 and at most 32 bytes
+ * @sync_method: which synchronization method to use
  * @path_sel_proto: which path selection protocol to use
  * @path_metric: which metric to use
  * @ie: vendor information elements (optional)
@@ -833,8 +840,9 @@ struct mesh_config {
 struct mesh_setup {
 	const u8 *mesh_id;
 	u8 mesh_id_len;
-	u8  path_sel_proto;
-	u8  path_metric;
+	u8 sync_method;
+	u8 path_sel_proto;
+	u8 path_metric;
 	const u8 *ie;
 	u8 ie_len;
 	bool is_authenticated;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 677d659..48b13c4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -412,6 +412,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->llid = le16_to_cpu(sta->llid);
 		sinfo->plid = le16_to_cpu(sta->plid);
 		sinfo->plink_state = sta->plink_state;
+		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
+			sinfo->filled |= STATION_INFO_T_OFFSET;
+			sinfo->t_offset = sta->t_offset;
+		}
 #endif
 	}
 
@@ -1235,6 +1239,7 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	/* now copy the rest of the setup parameters */
 	ifmsh->mesh_id_len = setup->mesh_id_len;
 	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
+	ifmsh->mesh_sp_id = setup->sync_method;
 	ifmsh->mesh_pp_id = setup->path_sel_proto;
 	ifmsh->mesh_pm_id = setup->path_metric;
 	ifmsh->security = IEEE80211_MESH_SEC_NONE;
@@ -1279,6 +1284,9 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->dot11MeshTTL = nconf->element_ttl;
 	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
 		conf->auto_open_plinks = nconf->auto_open_plinks;
+	if (_chg_mesh_attr(NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR, mask))
+		conf->dot11MeshNbrOffsetMaxNeighbor =
+			nconf->dot11MeshNbrOffsetMaxNeighbor;
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES, mask))
 		conf->dot11MeshHWMPmaxPREQretries =
 			nconf->dot11MeshHWMPmaxPREQretries;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index ba21ab2..8c747fa 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -38,6 +38,7 @@
 
 #define MESH_MAX_PREQ_RETRIES	4
 
+#define MESH_SYNC_NEIGHBOR_OFFSET_MAX 50
 
 const struct mesh_config default_mesh_config = {
 	.dot11MeshRetryTimeout = MESH_RET_T,
@@ -48,6 +49,7 @@ const struct mesh_config default_mesh_config = {
 	.element_ttl = MESH_DEFAULT_ELEMENT_TTL,
 	.auto_open_plinks = true,
 	.dot11MeshMaxPeerLinks = MESH_MAX_ESTAB_PLINKS,
+	.dot11MeshNbrOffsetMaxNeighbor = MESH_SYNC_NEIGHBOR_OFFSET_MAX,
 	.dot11MeshHWMPactivePathTimeout = MESH_PATH_TIMEOUT,
 	.dot11MeshHWMPpreqMinInterval = MESH_PREQ_MIN_INT,
 	.dot11MeshHWMPperrMinInterval = MESH_PERR_MIN_INT,
@@ -62,6 +64,7 @@ const struct mesh_config default_mesh_config = {
 };
 
 const struct mesh_setup default_mesh_setup = {
+	.sync_method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
 	.path_sel_proto = IEEE80211_PATH_PROTOCOL_HWMP,
 	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
 	.ie = NULL,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e49da27..dbd0aef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2487,6 +2487,9 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 		NLA_PUT(msg, NL80211_STA_INFO_STA_FLAGS,
 			sizeof(struct nl80211_sta_flag_update),
 			&sinfo->sta_flags);
+	if (sinfo->filled & STATION_INFO_T_OFFSET)
+		NLA_PUT_U64(msg, NL80211_STA_INFO_T_OFFSET,
+			    sinfo->t_offset);
 	nla_nest_end(msg, sinfoattr);
 
 	if (sinfo->filled & STATION_INFO_ASSOC_REQ_IES)
@@ -3285,6 +3288,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.element_ttl);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_AUTO_OPEN_PLINKS,
 			cur_params.auto_open_plinks);
+	NLA_PUT_U32(msg, NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
+			cur_params.dot11MeshNbrOffsetMaxNeighbor);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
 			cur_params.dot11MeshHWMPmaxPREQretries);
 	NLA_PUT_U32(msg, NL80211_MESHCONF_PATH_REFRESH_TIME,
@@ -3329,6 +3334,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_TTL] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_ELEMENT_TTL] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR] = { .type = NLA_U32 },
 
 	[NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES] = { .type = NLA_U8 },
 	[NL80211_MESHCONF_PATH_REFRESH_TIME] = { .type = NLA_U32 },
@@ -3346,6 +3352,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 
 static const struct nla_policy
 	nl80211_mesh_setup_params_policy[NL80211_MESH_SETUP_ATTR_MAX+1] = {
+	[NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_USERSPACE_AUTH] = { .type = NLA_FLAG },
@@ -3398,6 +3405,9 @@ do {\
 			mask, NL80211_MESHCONF_ELEMENT_TTL, nla_get_u8);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks,
 			mask, NL80211_MESHCONF_AUTO_OPEN_PLINKS, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshNbrOffsetMaxNeighbor,
+			mask, NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
+			nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries,
 			mask, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
 			nla_get_u8);
@@ -3455,6 +3465,12 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 			     nl80211_mesh_setup_params_policy))
 		return -EINVAL;
 
+	if (tb[NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC])
+		setup->sync_method =
+		(nla_get_u8(tb[NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC])) ?
+		 IEEE80211_SYNC_METHOD_VENDOR :
+		 IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET;
+
 	if (tb[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL])
 		setup->path_sel_proto =
 		(nla_get_u8(tb[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL])) ?
-- 
1.7.5.4

