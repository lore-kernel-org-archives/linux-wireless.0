Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61539 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab0LJXEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 18:04:32 -0500
Received: by ywl5 with SMTP id 5so2384704ywl.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 15:04:31 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: Let userspace enable and configure vendor specific path selection.
Date: Fri, 10 Dec 2010 15:04:10 -0800
Message-Id: <1292022251-12616-2-git-send-email-javier@cozybit.com>
In-Reply-To: <1292022251-12616-1-git-send-email-javier@cozybit.com>
References: <1292022251-12616-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Userspace will now be allowed to toggle between the default path
selection algorithm (HWMP, implemented in the kernel), and a vendor
specific alternative.  Also in the same patch, allow userspace to add
information elements to mesh beacons.
This is accordance with the Extensible Path Selection Framework
specified in version 7.0 of the 802.11s draft.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h |   19 ++++++++++++++++---
 include/net/cfg80211.h  |    6 ++++++
 net/mac80211/cfg.c      |   37 ++++++++++++++++++++++++++++++++++++-
 net/mac80211/mesh.c     |   10 ++++++++++
 net/mac80211/mesh.h     |   24 ++++++++++++++++++++++++
 net/wireless/mesh.c     |    3 +++
 net/wireless/nl80211.c  |   19 +++++++++++++++++++
 7 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3804212..1aafe4c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1561,9 +1561,6 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
  * point.
  *
- * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
- * source mesh point for path selection elements.
- *
  * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
  * open peer links when we detect compatible mesh peers.
  *
@@ -1590,6 +1587,19 @@ enum nl80211_mntr_flags {
  *
  * @NL80211_MESHCONF_ROOTMODE: whether root mode is enabled or not
  *
+ * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
+ * source mesh point for path selection elements.
+ *
+ * @NL80211_MESHCONF_ENABLE_VENDOR_PATH_SEL: Enable this option to use a vendor
+ * specific path selection algorithm or disable it to use the default HWMP.
+ *
+ * @NL80211_MESHCONF_ENABLE_VENDOR_METRIC: Enable this option to use a vendor
+ * specific path metric or disable it to use the default Airtime metric.
+ *
+ * @NL80211_MESHCONF_VENDOR_PATH_SEL_IE: A vendor specific information element
+ * that vendors will use to identify the path selection methods and metrics in
+ * use.
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -1611,6 +1621,9 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
 	NL80211_MESHCONF_HWMP_ROOTMODE,
 	NL80211_MESHCONF_ELEMENT_TTL,
+	NL80211_MESHCONF_ENABLE_VENDOR_PATH_SEL,
+	NL80211_MESHCONF_ENABLE_VENDOR_METRIC,
+	NL80211_MESHCONF_VENDOR_PATH_SEL_IE,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0d59799..c7f59e9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -643,6 +643,12 @@ struct mesh_config {
 	u16 dot11MeshHWMPpreqMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
 	u8  dot11MeshHWMPRootMode;
+	u8  vendor_path_sel_enabled;
+	u8  vendor_metric_enabled;
+	struct {
+		u8  *data;
+		u8  length;
+	} vendor_ie;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c30b8b7..4fee008 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -999,6 +999,34 @@ static inline bool _chg_mesh_attr(enum nl80211_meshconf_params parm, u32 mask)
 	return (mask >> (parm-1)) & 0x1;
 }
 
+static int copy_mesh_config(struct mesh_config *conf, const struct mesh_config
+		*nconf)
+{
+	u8 *new_ie, *old_ie;
+
+	/* first allocate the new vendor information element */
+	new_ie = NULL;
+	old_ie = conf->vendor_ie.data;
+
+	conf->vendor_ie.length = nconf->vendor_ie.length;
+	if (nconf->vendor_ie.length) {
+		new_ie = kmalloc(nconf->vendor_ie.length, GFP_KERNEL);
+		if (new_ie)
+			new_ie = memcpy(new_ie, nconf->vendor_ie.data,
+					nconf->vendor_ie.length);
+		else
+			return -ENOMEM;
+	}
+
+	/* now copy the rest of the configuration */
+	memcpy(conf, nconf, sizeof(struct mesh_config));
+	conf->vendor_ie.data = new_ie;
+
+	kfree(old_ie);
+
+	return 0;
+}
+
 static int ieee80211_update_mesh_params(struct wiphy *wiphy,
 					struct net_device *dev, u32 mask,
 					const struct mesh_config *nconf)
@@ -1049,6 +1077,13 @@ static int ieee80211_update_mesh_params(struct wiphy *wiphy,
 		conf->dot11MeshHWMPRootMode = nconf->dot11MeshHWMPRootMode;
 		ieee80211_mesh_root_setup(ifmsh);
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_ENABLE_VENDOR_PATH_SEL, mask))
+		conf->vendor_path_sel_enabled =
+			nconf->vendor_path_sel_enabled;
+	if (_chg_mesh_attr(NL80211_MESHCONF_ENABLE_VENDOR_METRIC, mask))
+		conf->vendor_metric_enabled = nconf->vendor_metric_enabled;
+	if (_chg_mesh_attr(NL80211_MESHCONF_VENDOR_PATH_SEL_IE, mask))
+		copy_mesh_config(conf, nconf);
 	return 0;
 }
 
@@ -1059,7 +1094,7 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	memcpy(&sdata->u.mesh.mshcfg, conf, sizeof(struct mesh_config));
+	copy_mesh_config(&ifmsh->mshcfg, conf);
 	ifmsh->mesh_id_len = setup->mesh_id_len;
 	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 63e1188..80723d8 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -287,6 +287,12 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	*pos++ |= sdata->u.mesh.accepting_plinks ?
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
+
+	if (sdata->u.mesh.mshcfg.vendor_ie.data) {
+		int len = sdata->u.mesh.mshcfg.vendor_ie.length;
+		u8 *data = sdata->u.mesh.mshcfg.vendor_ie.data;
+		memcpy(skb_put(skb, len), data, len);
+	}
 }
 
 u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata, struct mesh_table *tbl)
@@ -522,6 +528,10 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
+	sdata->u.mesh.mesh_pp_id = ifmsh->mshcfg.vendor_path_sel_enabled ?
+		MESH_PATH_PROTOCOL_VENDOR : MESH_PATH_PROTOCOL_HWMP;
+	sdata->u.mesh.mesh_pm_id = ifmsh->mshcfg.vendor_metric_enabled ?
+		MESH_PATH_METRIC_VENDOR : MESH_PATH_METRIC_AIRTIME;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_BEACON_INT);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 039d7fa..4a1cd4a 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -44,6 +44,30 @@ enum mesh_path_flags {
 };
 
 /**
+ * enum - mesh path selection protocol identifier
+ *
+ * @MESH_PATH_PROTOCOL_HWMP: the default path selection protocol
+ * @MESH_PATH_PROTOCOL_VENDOR: a vendor specific protocol that will be
+ * specified in a vendor specific information element
+ */
+enum {
+	MESH_PATH_PROTOCOL_HWMP = 0,
+	MESH_PATH_PROTOCOL_VENDOR = 255,
+};
+
+/**
+ * enum - mesh path selection metric identifier
+ *
+ * @MESH_PATH_METRIC_AIRTIME: the default path selection metric
+ * @MESH_PATH_METRIC_VENDOR: a vendor specific metric that will be
+ * specified in a vendor specific information element
+ */
+enum {
+	MESH_PATH_METRIC_AIRTIME = 0,
+	MESH_PATH_METRIC_VENDOR = 255,
+};
+
+/**
  * enum mesh_deferred_task_flags - mac80211 mesh deferred tasks
  *
  *
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index e0b9747..13cc695 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -48,6 +48,9 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPmaxPREQretries = MESH_MAX_PREQ_RETRIES,
 	.path_refresh_time = MESH_PATH_REFRESH_TIME,
 	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
+	.vendor_path_sel_enabled = false,
+	.vendor_metric_enabled = false,
+	.vendor_ie = { .data = NULL, .length = 0 },
 };
 
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c3f80e5..bbef129 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2667,6 +2667,10 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_ENABLE_VENDOR_PATH_SEL] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_VENDOR_PATH_SEL_IE] = { .type = NLA_BINARY,
+		.len = IEEE80211_MAX_DATA_LEN },
 };
 
 static int nl80211_parse_mesh_params(struct genl_info *info,
@@ -2735,6 +2739,21 @@ do {\
 			dot11MeshHWMPRootMode, mask,
 			NL80211_MESHCONF_HWMP_ROOTMODE,
 			nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			vendor_path_sel_enabled, mask,
+			NL80211_MESHCONF_ENABLE_VENDOR_PATH_SEL,
+			nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			vendor_metric_enabled, mask,
+			NL80211_MESHCONF_ENABLE_VENDOR_METRIC,
+			nla_get_u8);
+	if (tb[NL80211_MESHCONF_VENDOR_PATH_SEL_IE]) {
+		cfg->vendor_ie.data =
+			nla_data(tb[NL80211_MESHCONF_VENDOR_PATH_SEL_IE]);
+		cfg->vendor_ie.length =
+			nla_len(tb[NL80211_MESHCONF_VENDOR_PATH_SEL_IE]);
+		mask |= (1 << (NL80211_MESHCONF_VENDOR_PATH_SEL_IE - 1));
+	}
 
 	if (mask_out)
 		*mask_out = mask;
-- 
1.7.1

