Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61115 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab0LPSfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 13:35:43 -0500
Received: by pva4 with SMTP id 4so543897pva.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 10:35:42 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/3 v2] mac80211: Let userspace enable and configure vendor specific path selection.
Date: Thu, 16 Dec 2010 10:29:59 -0800
Message-Id: <1292524200-14791-2-git-send-email-javier@cozybit.com>
In-Reply-To: <1292234643.3539.6.camel@jlt3.sipsolutions.net>
References: <1292234643.3539.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Userspace will now be allowed to toggle between the default path
selection algorithm (HWMP, implemented in the kernel), and a vendor
specific alternative.  Also in the same patch, allow userspace to add
information elements to mesh beacons.  This is accordance with the
Extensible Path Selection Framework specified in version 7.0 of the
802.11s draft.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v2: - don't substruct vendor_ie and mark as const (Johannes)
    - move vendor_ie to mesh_setup (Johannes)
    - rename MESH_PATH_* -> IEEE80211_PATH_* (Johannes)
    - define a new nested attribute NL80211_ATTR_MESH_SETUP for mesh setup
      parameters

 include/linux/ieee80211.h  |   25 ++++++++++++++++++
 include/linux/nl80211.h    |   47 +++++++++++++++++++++++++++++++---
 include/net/cfg80211.h     |    8 ++++++
 net/mac80211/cfg.c         |   41 ++++++++++++++++++++++++++---
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/mesh.c        |    6 ++++
 net/wireless/core.c        |   22 +++++++++++----
 net/wireless/core.h        |    5 ++-
 net/wireless/mesh.c        |   24 +++++++++--------
 net/wireless/nl80211.c     |   61 ++++++++++++++++++++++++++++++++++++++++---
 10 files changed, 209 insertions(+), 32 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7f23545..cd68168 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1291,6 +1291,31 @@ enum ieee80211_key_len {
 	WLAN_KEY_LEN_AES_CMAC = 16,
 };
 
+/**
+ * enum - mesh path selection protocol identifier
+ *
+ * @IEEE80211_PATH_PROTOCOL_HWMP: the default path selection protocol
+ * @IEEE80211_PATH_PROTOCOL_VENDOR: a vendor specific protocol that will
+ * be specified in a vendor specific information element
+ */
+enum {
+	IEEE80211_PATH_PROTOCOL_HWMP = 0,
+	IEEE80211_PATH_PROTOCOL_VENDOR = 255,
+};
+
+/**
+ * enum - mesh path selection metric identifier
+ *
+ * @IEEE80211_PATH_METRIC_AIRTIME: the default path selection metric
+ * @IEEE80211_PATH_METRIC_VENDOR: a vendor specific metric that will be
+ * specified in a vendor specific information element
+ */
+enum {
+	IEEE80211_PATH_METRIC_AIRTIME = 0,
+	IEEE80211_PATH_METRIC_VENDOR = 255,
+};
+
+
 /*
  * IEEE 802.11-2007 7.3.2.9 Country information element
  *
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 1d677c0..93d48fd 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -858,6 +858,9 @@ enum nl80211_commands {
  *	attributes, specifying what a key should be set as default as.
  *	See &enum nl80211_key_default_types.
  *
+ * @NL80211_ATTR_MESH_SETUP: Optional mesh setup parameters.  These cannot be
+ * changed once the mesh is active.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1040,6 +1043,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
 
+	NL80211_ATTR_MESH_SETUP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1549,7 +1554,8 @@ enum nl80211_mntr_flags {
 /**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
- * Mesh configuration parameters
+ * Mesh configuration parameters. These can be changed while the mesh is
+ * active.
  *
  * @__NL80211_MESHCONF_INVALID: internal use
  *
@@ -1572,9 +1578,6 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
  * point.
  *
- * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
- * source mesh point for path selection elements.
- *
  * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
  * open peer links when we detect compatible mesh peers.
  *
@@ -1601,6 +1604,9 @@ enum nl80211_mntr_flags {
  *
  * @NL80211_MESHCONF_ROOTMODE: whether root mode is enabled or not
  *
+ * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
+ * source mesh point for path selection elements.
+ *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
@@ -1629,6 +1635,39 @@ enum nl80211_meshconf_params {
 };
 
 /**
+ * enum nl80211_mesh_setup_params - mesh setup parameters
+ *
+ * Mesh setup parameters.  These are used to start/join a mesh and cannot be
+ * changed while the mesh is active.
+ *
+ * @__NL80211_MESH_SETUP_INVALID: Internal use
+ *
+ * @NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL: Enable this option to use a
+ * vendor specific path selection algorithm or disable it to use the default
+ * HWMP.
+ *
+ * @NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC: Enable this option to use a
+ * vendor specific path metric or disable it to use the default Airtime
+ * metric.
+ *
+ * @NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE: A vendor specific information
+ * element that vendors will use to identify the path selection methods and
+ * metrics in use.
+ *
+ * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
+ */
+enum nl80211_mesh_setup_params {
+	__NL80211_MESH_SETUP_INVALID,
+	NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL,
+	NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC,
+	NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE,
+
+	/* keep last */
+	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
+	NL80211_MESH_SETUP_ATTR_MAX = __NL80211_MESH_SETUP_ATTR_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_txq_attr - TX queue parameter attributes
  * @__NL80211_TXQ_ATTR_INVALID: Attribute number 0 is reserved
  * @NL80211_TXQ_ATTR_QUEUE: TX queue identifier (NL80211_TXQ_Q_*)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1bac74a..a6041a7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -649,12 +649,20 @@ struct mesh_config {
  * struct mesh_setup - 802.11s mesh setup configuration
  * @mesh_id: the mesh ID
  * @mesh_id_len: length of the mesh ID, at least 1 and at most 32 bytes
+ * @path_sel_proto: which path selection protocol to use
+ * @path_metric: which metric to use
+ * @vendor_ie: vendor information elements (optional)
+ * @vendor_ie_len: length of vendor information elements
  *
  * These parameters are fixed when the mesh is created.
  */
 struct mesh_setup {
 	const u8 *mesh_id;
 	u8 mesh_id_len;
+	u8  path_sel_proto;
+	u8  path_metric;
+	const u8 *vendor_ie;
+	u8 vendor_ie_len;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1c94a2a..6cdf113 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1000,6 +1000,38 @@ static inline bool _chg_mesh_attr(enum nl80211_meshconf_params parm, u32 mask)
 	return (mask >> (parm-1)) & 0x1;
 }
 
+static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
+		const struct mesh_setup *setup)
+{
+	u8 *new_ie;
+	const u8 *old_ie;
+
+	/* first allocate the new vendor information element */
+	new_ie = NULL;
+	old_ie = setup->vendor_ie;
+
+	ifmsh->vendor_ie_len = setup->vendor_ie_len;
+	if (setup->vendor_ie_len) {
+		new_ie = kmalloc(setup->vendor_ie_len, GFP_KERNEL);
+		if (new_ie)
+			new_ie = memcpy(new_ie, setup->vendor_ie,
+					setup->vendor_ie_len);
+		else
+			return -ENOMEM;
+	}
+
+	/* now copy the rest of the setup parameters */
+	ifmsh->mesh_id_len = setup->mesh_id_len;
+	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
+	ifmsh->mesh_pp_id = setup->path_sel_proto;
+	ifmsh->mesh_pm_id = setup->path_metric;
+	ifmsh->vendor_ie = new_ie;
+
+	kfree(old_ie);
+
+	return 0;
+}
+
 static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 					struct net_device *dev, u32 mask,
 					const struct mesh_config *nconf)
@@ -1059,11 +1091,12 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	int err;
 
-	memcpy(&sdata->u.mesh.mshcfg, conf, sizeof(struct mesh_config));
-	ifmsh->mesh_id_len = setup->mesh_id_len;
-	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
-
+	memcpy(&ifmsh->mshcfg, conf, sizeof(struct mesh_config));
+	err = copy_mesh_setup(ifmsh, setup);
+	if (err)
+		return err;
 	ieee80211_start_mesh(sdata);
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0817ec6..cc7c367 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -485,6 +485,8 @@ struct ieee80211_if_mesh {
 	struct mesh_config mshcfg;
 	u32 mesh_seqnum;
 	bool accepting_plinks;
+	const u8 *vendor_ie;
+	u8 vendor_ie_len;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 63e1188..03430df 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -287,6 +287,12 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	*pos++ |= sdata->u.mesh.accepting_plinks ?
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
+
+	if (sdata->u.mesh.vendor_ie) {
+		int len = sdata->u.mesh.vendor_ie_len;
+		const u8 *data = sdata->u.mesh.vendor_ie;
+		memcpy(skb_put(skb, len), data, len);
+	}
 }
 
 u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata, struct mesh_table *tbl)
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 79772fc..e9a5f8c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -789,13 +789,23 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 			cfg80211_mgd_wext_connect(rdev, wdev);
 			break;
 #endif
+#ifdef CONFIG_MAC80211_MESH
 		case NL80211_IFTYPE_MESH_POINT:
-			/* backward compat code ... */
-			if (wdev->mesh_id_up_len)
-				__cfg80211_join_mesh(rdev, dev, wdev->ssid,
-						     wdev->mesh_id_up_len,
-						     &default_mesh_config);
-			break;
+			{
+				/* backward compat code... */
+				struct mesh_setup setup;
+				memcpy(&setup, &default_mesh_setup,
+						sizeof(setup));
+				 /* back compat only needed for mesh_id */
+				setup.mesh_id = wdev->ssid;
+				setup.mesh_id_len = wdev->mesh_id_up_len;
+				if (wdev->mesh_id_up_len)
+					__cfg80211_join_mesh(rdev, dev,
+							&setup,
+							&default_mesh_config);
+				break;
+			}
+#endif
 		default:
 			break;
 		}
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 743203b..26a0a08 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -287,13 +287,14 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 
 /* mesh */
 extern const struct mesh_config default_mesh_config;
+extern const struct mesh_setup default_mesh_setup;
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev,
-			 const u8 *mesh_id, u8 mesh_id_len,
+			 const struct mesh_setup *setup,
 			 const struct mesh_config *conf);
 int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
-		       const u8 *mesh_id, u8 mesh_id_len,
+		       const struct mesh_setup *setup,
 		       const struct mesh_config *conf);
 int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 			struct net_device *dev);
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index e0b9747..73e39c1 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -50,17 +50,19 @@ const struct mesh_config default_mesh_config = {
 	.min_discovery_timeout = MESH_MIN_DISCOVERY_TIMEOUT,
 };
 
+const struct mesh_setup default_mesh_setup = {
+	.path_sel_proto = IEEE80211_PATH_PROTOCOL_HWMP,
+	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
+	.vendor_ie = NULL,
+	.vendor_ie_len = 0,
+};
 
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev,
-			 const u8 *mesh_id, u8 mesh_id_len,
+			 const struct mesh_setup *setup,
 			 const struct mesh_config *conf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct mesh_setup setup = {
-		.mesh_id = mesh_id,
-		.mesh_id_len = mesh_id_len,
-	};
 	int err;
 
 	BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN != IEEE80211_MAX_MESH_ID_LEN);
@@ -73,16 +75,16 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (wdev->mesh_id_len)
 		return -EALREADY;
 
-	if (!mesh_id_len)
+	if (!setup->mesh_id_len)
 		return -EINVAL;
 
 	if (!rdev->ops->join_mesh)
 		return -EOPNOTSUPP;
 
-	err = rdev->ops->join_mesh(&rdev->wiphy, dev, conf, &setup);
+	err = rdev->ops->join_mesh(&rdev->wiphy, dev, conf, setup);
 	if (!err) {
-		memcpy(wdev->ssid, mesh_id, mesh_id_len);
-		wdev->mesh_id_len = mesh_id_len;
+		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
+		wdev->mesh_id_len = setup->mesh_id_len;
 	}
 
 	return err;
@@ -90,14 +92,14 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 
 int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
-		       const u8 *mesh_id, u8 mesh_id_len,
+		       const struct mesh_setup *setup,
 		       const struct mesh_config *conf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	wdev_lock(wdev);
-	err = __cfg80211_join_mesh(rdev, dev, mesh_id, mesh_id_len, conf);
+	err = __cfg80211_join_mesh(rdev, dev, setup, conf);
 	wdev_unlock(wdev);
 
 	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d783dca..b4dc191 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2773,6 +2773,14 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
 };
 
+static const struct nla_policy
+	nl80211_mesh_setup_params_policy[NL80211_MESH_SETUP_ATTR_MAX+1] = {
+	[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL] = { .type = NLA_U8 },
+	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
+	[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE] = { .type = NLA_BINARY,
+		.len = IEEE80211_MAX_DATA_LEN },
+};
+
 static int nl80211_parse_mesh_config(struct genl_info *info,
 				     struct mesh_config *cfg,
 				     u32 *mask_out)
@@ -2839,14 +2847,48 @@ do {\
 			dot11MeshHWMPRootMode, mask,
 			NL80211_MESHCONF_HWMP_ROOTMODE,
 			nla_get_u8);
-
 	if (mask_out)
 		*mask_out = mask;
+
 	return 0;
 
 #undef FILL_IN_MESH_PARAM_IF_SET
 }
 
+static int nl80211_parse_mesh_setup(struct genl_info *info,
+				     struct mesh_setup *setup)
+{
+	struct nlattr *tb[NL80211_MESH_SETUP_ATTR_MAX + 1];
+
+	if (!info->attrs[NL80211_ATTR_MESH_SETUP])
+		return -EINVAL;
+	if (nla_parse_nested(tb, NL80211_MESH_SETUP_ATTR_MAX,
+			     info->attrs[NL80211_ATTR_MESH_SETUP],
+			     nl80211_mesh_setup_params_policy))
+		return -EINVAL;
+
+	if (tb[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL])
+		setup->path_sel_proto =
+		(nla_get_u8(tb[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL])) ?
+		 IEEE80211_PATH_PROTOCOL_VENDOR :
+		 IEEE80211_PATH_PROTOCOL_HWMP;
+
+	if (tb[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC])
+		setup->path_metric =
+		(nla_get_u8(tb[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC])) ?
+		 IEEE80211_PATH_METRIC_VENDOR :
+		 IEEE80211_PATH_METRIC_AIRTIME;
+
+	if (tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE]) {
+		setup->vendor_ie =
+			nla_data(tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE]);
+		setup->vendor_ie_len =
+			nla_len(tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE]);
+	}
+
+	return 0;
+}
+
 static int nl80211_update_mesh_config(struct sk_buff *skb,
 				      struct genl_info *info)
 {
@@ -4667,10 +4709,12 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct mesh_config cfg;
+	struct mesh_setup setup;
 	int err;
 
 	/* start with default */
 	memcpy(&cfg, &default_mesh_config, sizeof(cfg));
+	memcpy(&setup, &default_mesh_setup, sizeof(setup));
 
 	if (info->attrs[NL80211_ATTR_MESH_CONFIG]) {
 		/* and parse parameters if given */
@@ -4683,10 +4727,17 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	    !nla_len(info->attrs[NL80211_ATTR_MESH_ID]))
 		return -EINVAL;
 
-	return cfg80211_join_mesh(rdev, dev,
-				  nla_data(info->attrs[NL80211_ATTR_MESH_ID]),
-				  nla_len(info->attrs[NL80211_ATTR_MESH_ID]),
-				  &cfg);
+	setup.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
+	setup.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
+
+	if (info->attrs[NL80211_ATTR_MESH_SETUP]) {
+		/* parse additional setup parameters if given */
+		err = nl80211_parse_mesh_setup(info, &setup);
+		if (err)
+			return err;
+	}
+
+	return cfg80211_join_mesh(rdev, dev, &setup, &cfg);
 }
 
 static int nl80211_leave_mesh(struct sk_buff *skb, struct genl_info *info)
-- 
1.7.1

