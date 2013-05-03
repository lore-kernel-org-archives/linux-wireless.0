Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64063 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab3ECCgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:35 -0400
Received: by mail-pb0-f44.google.com with SMTP id wz17so660020pbc.31
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:34 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 11/12] {nl,mac}80211: specify MBSS sharing on/off
Date: Thu,  2 May 2013 19:34:01 -0700
Message-Id: <1367548442-8229-12-git-send-email-thomas@cozybit.com> (sfid-20130503_043638_271293_C3FECEC1)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/cfg80211.h       |    3 +++
 include/uapi/linux/nl80211.h |    5 +++++
 net/mac80211/cfg.c           |    1 +
 net/mac80211/ieee80211_i.h   |    1 +
 net/mac80211/mesh.c          |    4 +++-
 net/wireless/mesh.c          |    1 +
 net/wireless/nl80211.c       |    3 +++
 7 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26e9113..21007e7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1169,6 +1169,8 @@ struct mesh_config {
  * @dtim_period: DTIM period to use
  * @beacon_interval: beacon interval to use
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
+ * @shared: MBSS sharing and intra-vif data forwarding may take place for
+ *	this mesh setup.
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -1187,6 +1189,7 @@ struct mesh_setup {
 	u8 dtim_period;
 	u16 beacon_interval;
 	int mcast_rate[IEEE80211_NUM_BANDS];
+	bool shared;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b484307..549ce133 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2645,6 +2645,10 @@ enum nl80211_meshconf_params {
  * @NL80211_MESH_SETUP_USERSPACE_MPM: Enable this option if userspace will
  *	implement an MPM which handles peer allocation and state.
  *
+ * @NL80211_MESH_SETUP_CAN_SHARE: Enable this option to allow sharing an MBSS
+ *	profile and frame forwarding across multiple virtual interfaces with the
+ *	same profile. Defaults to off.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
@@ -2658,6 +2662,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_USERSPACE_AMPE,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC,
 	NL80211_MESH_SETUP_USERSPACE_MPM,
+	NL80211_MESH_SETUP_CAN_SHARE,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 76e9575..398df0a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1742,6 +1742,7 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	/* now copy the rest of the setup parameters */
 	ifmsh->mesh_id_len = setup->mesh_id_len;
 	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
+	ifmsh->share_mbss = setup->shared;
 	ifmsh->mesh_sp_id = setup->sync_method;
 	ifmsh->mesh_pp_id = setup->path_sel_proto;
 	ifmsh->mesh_pm_id = setup->path_metric;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a8b33d2..19c0ff4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -632,6 +632,7 @@ struct ieee80211_if_mesh {
 	struct ps_data ps;
 
 	/* mbss sharing */
+	bool share_mbss;
 	struct mesh_local_bss *mesh_bss;
 	struct list_head if_list;
 };
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9445f02..08d3171 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -60,6 +60,7 @@ mesh_bss_matches(struct ieee80211_sub_if_data *sdata,
 		 struct mesh_local_bss *mbss)
 {
 	return mbss->can_share &&
+	       setup->shared &&
 	       mbss->mesh_id_len == setup->mesh_id_len &&
 	       memcmp(mbss->mesh_id, setup->mesh_id, mbss->mesh_id_len) == 0 &&
 	       mbss->path_sel_proto == setup->path_sel_proto &&
@@ -109,7 +110,7 @@ mesh_bss_create(struct ieee80211_sub_if_data *sdata, struct mesh_setup *setup)
 
 	mbss->mesh_id_len = setup->mesh_id_len;
 	memcpy(mbss->mesh_id, setup->mesh_id, setup->mesh_id_len);
-	mbss->can_share = false;
+	mbss->can_share = setup->shared;
 	mbss->path_metric = setup->path_metric;
 	mbss->path_sel_proto = setup->path_sel_proto;
 	mbss->sync_method = setup->sync_method;
@@ -994,6 +995,7 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	setup.sync_method = ifmsh->mesh_pm_id;
 	setup.path_metric = ifmsh->mesh_cc_id;
 	setup.is_secure = ifmsh->security & IEEE80211_MESH_SEC_SECURED;
+	setup.shared = ifmsh->share_mbss;
 
 	ret = mesh_bss_add(sdata, &setup);
 	if (ret) {
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0bb93f3..cb1e360 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -88,6 +88,7 @@ const struct mesh_setup default_mesh_setup = {
 	.user_mpm = false,
 	.beacon_interval = MESH_DEFAULT_BEACON_INTERVAL,
 	.dtim_period = MESH_DEFAULT_DTIM_PERIOD,
+	.shared = false,
 };
 
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9cdcd9e..5925b13 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4857,6 +4857,9 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 	if (setup->is_secure)
 		setup->user_mpm = true;
 
+	if (tb[NL80211_MESH_SETUP_CAN_SHARE])
+		setup->shared = nla_get_u8(tb[NL80211_MESH_SETUP_CAN_SHARE]);
+
 	return 0;
 }
 
-- 
1.7.10.4

