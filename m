Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37030 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1BZBdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 20:33:19 -0500
Received: by yia27 with SMTP id 27so63293yia.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 17:33:19 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>
Subject: [PATCH 1/5] mac80211: Support RSN information element on mesh interfaces
Date: Fri, 25 Feb 2011 17:32:36 -0800
Message-Id: <1298683960-20835-2-git-send-email-thomas@cozybit.com>
In-Reply-To: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Add RSN information element as a mesh setup parameter.
---
 include/linux/nl80211.h    |    4 ++++
 include/net/cfg80211.h     |    4 ++++
 net/mac80211/cfg.c         |   19 ++++++++++++++++---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mesh.c        |    7 +++++++
 net/mac80211/tx.c          |    3 ++-
 net/wireless/nl80211.c     |   13 +++++++++++++
 7 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 821ffb9..7f53bdf 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1687,6 +1687,9 @@ enum nl80211_meshconf_params {
  * element that vendors will use to identify the path selection methods and
  * metrics in use.
  *
+ * @NL80211_MESH_SETUP_RSN_IE: The Robust Security Network information element
+ * use to advertise security capabilities of this mesh network.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
@@ -1695,6 +1698,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC,
 	NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE,
+	NL80211_MESH_SETUP_RSN_IE,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 679a049..5d3f0e8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -653,6 +653,8 @@ struct mesh_config {
  * @path_metric: which metric to use
  * @vendor_ie: vendor information elements (optional)
  * @vendor_ie_len: length of vendor information elements
+ * @rsn_ie: robust secure network information elements (for SAE)
+ * @rsn_ie_len: length of rsn_ie
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -663,6 +665,8 @@ struct mesh_setup {
 	u8  path_metric;
 	const u8 *vendor_ie;
 	u8 vendor_ie_len;
+	const u8 *rsn_ie;
+	u8 rsn_ie_len;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2ba3af8..b70e2a6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1017,15 +1017,28 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 		if (!new_ie)
 			return -ENOMEM;
 	}
+	ifmsh->vendor_ie = new_ie;
+	kfree(old_ie);
+
+	/* then allocate the new rsn information element */
+	new_ie = NULL;
+	old_ie = ifmsh->rsn_ie;
+
+	ifmsh->rsn_ie_len = setup->rsn_ie_len;
+	if (setup->rsn_ie_len) {
+		new_ie = kmemdup(setup->rsn_ie, setup->rsn_ie_len,
+				GFP_KERNEL);
+		if (!new_ie)
+			return -ENOMEM;
+	}
+	ifmsh->rsn_ie = new_ie;
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
index f2ef15d..4df7b69 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -490,6 +490,8 @@ struct ieee80211_if_mesh {
 	bool accepting_plinks;
 	const u8 *vendor_ie;
 	u8 vendor_ie_len;
+	const u8 *rsn_ie;
+	u8 rsn_ie_len;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2a57cc0..c0635c5 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -279,6 +279,13 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
 
+	if (sdata->u.mesh.rsn_ie) {
+		int len = sdata->u.mesh.rsn_ie_len;
+		const u8 *data = sdata->u.mesh.rsn_ie;
+		if (skb_tailroom(skb) > len)
+			memcpy(skb_put(skb, len), data, len);
+	}
+
 	if (sdata->u.mesh.vendor_ie) {
 		int len = sdata->u.mesh.vendor_ie_len;
 		const u8 *data = sdata->u.mesh.vendor_ie;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 17ef4f4..5e643fe 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2313,7 +2313,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 		/* headroom, head length, tail length and maximum TIM length */
 		skb = dev_alloc_skb(local->tx_headroom + 400 +
-				sdata->u.mesh.vendor_ie_len);
+				sdata->u.mesh.vendor_ie_len +
+				sdata->u.mesh.rsn_ie_len);
 		if (!skb)
 			goto out;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 864ddfb..dc21ab5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2788,6 +2788,8 @@ static const struct nla_policy
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE] = { .type = NLA_BINARY,
 		.len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_MESH_SETUP_RSN_IE] = { .type = NLA_BINARY,
+		.len = IEEE80211_MAX_DATA_LEN },
 };
 
 static int nl80211_parse_mesh_config(struct genl_info *info,
@@ -2897,6 +2899,17 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 		setup->vendor_ie_len = nla_len(ieattr);
 	}
 
+	if (tb[NL80211_MESH_SETUP_RSN_IE]) {
+		struct nlattr *ieattr = tb[NL80211_MESH_SETUP_RSN_IE];
+		u8 *eid = nla_data(ieattr);
+		if (eid[0] != WLAN_EID_RSN)
+			return -EINVAL;
+		if (!is_valid_ie_attr(ieattr))
+			return -EINVAL;
+		setup->rsn_ie = nla_data(ieattr);
+		setup->rsn_ie_len = nla_len(ieattr);
+	}
+
 	return 0;
 }
 
-- 
1.7.0.4

