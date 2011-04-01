Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43854 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1DAVgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 17:36:37 -0400
Received: by iyb14 with SMTP id 14so3915791iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 14:36:36 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v6 01/10] nl80211: rename NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE
Date: Fri,  1 Apr 2011 13:35:42 -0700
Message-Id: <1301690151-14979-2-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
References: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

To NL80211_MESH_SETUP_IE. This reflects our ability to insert any ie
into a mesh beacon, not simply path selection ies.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h    |    9 +++++----
 include/net/cfg80211.h     |    8 ++++----
 net/mac80211/cfg.c         |   15 +++++++--------
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mesh.c        |    6 +++---
 net/mac80211/mesh_plink.c  |    2 +-
 net/mac80211/tx.c          |    2 +-
 net/wireless/mesh.c        |    4 ++--
 net/wireless/nl80211.c     |   11 ++++++-----
 9 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3002218..82ef17d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -545,6 +545,7 @@ enum nl80211_commands {
 /* source-level API compatibility */
 #define NL80211_CMD_GET_MESH_PARAMS NL80211_CMD_GET_MESH_CONFIG
 #define NL80211_CMD_SET_MESH_PARAMS NL80211_CMD_SET_MESH_CONFIG
+#define NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE NL80211_MESH_SETUP_IE
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -1686,9 +1687,9 @@ enum nl80211_meshconf_params {
  * vendor specific path metric or disable it to use the default Airtime
  * metric.
  *
- * @NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE: A vendor specific information
- * element that vendors will use to identify the path selection methods and
- * metrics in use.
+ * @NL80211_MESH_SETUP_IE: Information elements for this mesh, for instance, a
+ * robust security network ie, or a vendor specific information element that
+ * vendors will use to identify the path selection methods and metrics in use.
  *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
@@ -1697,7 +1698,7 @@ enum nl80211_mesh_setup_params {
 	__NL80211_MESH_SETUP_INVALID,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC,
-	NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE,
+	NL80211_MESH_SETUP_IE,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 60f7876..1714943 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -654,8 +654,8 @@ struct mesh_config {
  * @mesh_id_len: length of the mesh ID, at least 1 and at most 32 bytes
  * @path_sel_proto: which path selection protocol to use
  * @path_metric: which metric to use
- * @vendor_ie: vendor information elements (optional)
- * @vendor_ie_len: length of vendor information elements
+ * @ie: vendor information elements (optional)
+ * @ie_len: length of vendor information elements
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -664,8 +664,8 @@ struct mesh_setup {
 	u8 mesh_id_len;
 	u8  path_sel_proto;
 	u8  path_metric;
-	const u8 *vendor_ie;
-	u8 vendor_ie_len;
+	const u8 *ie;
+	u8 ie_len;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3342135..f2f345a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1023,26 +1023,25 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	u8 *new_ie;
 	const u8 *old_ie;
 
-	/* first allocate the new vendor information element */
+	/* allocate information elements */
 	new_ie = NULL;
-	old_ie = ifmsh->vendor_ie;
+	old_ie = ifmsh->ie;
 
-	ifmsh->vendor_ie_len = setup->vendor_ie_len;
-	if (setup->vendor_ie_len) {
-		new_ie = kmemdup(setup->vendor_ie, setup->vendor_ie_len,
+	ifmsh->ie_len = setup->ie_len;
+	if (setup->ie_len) {
+		new_ie = kmemdup(setup->ie, setup->ie_len,
 				GFP_KERNEL);
 		if (!new_ie)
 			return -ENOMEM;
 	}
+	ifmsh->ie = new_ie;
+	kfree(old_ie);
 
 	/* now copy the rest of the setup parameters */
 	ifmsh->mesh_id_len = setup->mesh_id_len;
 	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
 	ifmsh->mesh_pp_id = setup->path_sel_proto;
 	ifmsh->mesh_pm_id = setup->path_metric;
-	ifmsh->vendor_ie = new_ie;
-
-	kfree(old_ie);
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a404017..d0fafde 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -488,8 +488,8 @@ struct ieee80211_if_mesh {
 	struct mesh_config mshcfg;
 	u32 mesh_seqnum;
 	bool accepting_plinks;
-	const u8 *vendor_ie;
-	u8 vendor_ie_len;
+	const u8 *ie;
+	u8 ie_len;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2a57cc0..1c244c0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -279,9 +279,9 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
 
-	if (sdata->u.mesh.vendor_ie) {
-		int len = sdata->u.mesh.vendor_ie_len;
-		const u8 *data = sdata->u.mesh.vendor_ie;
+	if (sdata->u.mesh.ie) {
+		int len = sdata->u.mesh.ie_len;
+		const u8 *data = sdata->u.mesh.ie;
 		if (skb_tailroom(skb) > len)
 			memcpy(skb_put(skb, len), data, len);
 	}
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 44b5393..c705b20 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -161,7 +161,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		__le16 reason) {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400 +
-			sdata->u.mesh.vendor_ie_len);
+			sdata->u.mesh.ie_len);
 	struct ieee80211_mgmt *mgmt;
 	bool include_plid = false;
 	static const u8 meshpeeringproto[] = { 0x00, 0x0F, 0xAC, 0x2A };
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 081dcaf..38f6c2d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2262,7 +2262,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 		/* headroom, head length, tail length and maximum TIM length */
 		skb = dev_alloc_skb(local->tx_headroom + 400 +
-				sdata->u.mesh.vendor_ie_len);
+				sdata->u.mesh.ie_len);
 		if (!skb)
 			goto out;
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 73e39c1..0d4b226 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -53,8 +53,8 @@ const struct mesh_config default_mesh_config = {
 const struct mesh_setup default_mesh_setup = {
 	.path_sel_proto = IEEE80211_PATH_PROTOCOL_HWMP,
 	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
-	.vendor_ie = NULL,
-	.vendor_ie_len = 0,
+	.ie = NULL,
+	.ie_len = 0,
 };
 
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4ebce42..f251089 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2804,7 +2804,7 @@ static const struct nla_policy
 	nl80211_mesh_setup_params_policy[NL80211_MESH_SETUP_ATTR_MAX+1] = {
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
-	[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE] = { .type = NLA_BINARY,
+	[NL80211_MESH_SETUP_IE] = { .type = NLA_BINARY,
 		.len = IEEE80211_MAX_DATA_LEN },
 };
 
@@ -2906,13 +2906,14 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 		 IEEE80211_PATH_METRIC_VENDOR :
 		 IEEE80211_PATH_METRIC_AIRTIME;
 
-	if (tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE]) {
+
+	if (tb[NL80211_MESH_SETUP_IE]) {
 		struct nlattr *ieattr =
-			tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE];
+			tb[NL80211_MESH_SETUP_IE];
 		if (!is_valid_ie_attr(ieattr))
 			return -EINVAL;
-		setup->vendor_ie = nla_data(ieattr);
-		setup->vendor_ie_len = nla_len(ieattr);
+		setup->ie = nla_data(ieattr);
+		setup->ie_len = nla_len(ieattr);
 	}
 
 	return 0;
-- 
1.7.4.1

