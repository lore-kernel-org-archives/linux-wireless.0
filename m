Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f180.google.com ([209.85.161.180]:46892 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab0LJXEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 18:04:41 -0500
Received: by gxk19 with SMTP id 19so2683582gxk.11
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 15:04:40 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: Send mesh non-HWMP path selection frames to userspace
Date: Fri, 10 Dec 2010 15:04:11 -0800
Message-Id: <1292022251-12616-3-git-send-email-javier@cozybit.com>
In-Reply-To: <1292022251-12616-1-git-send-email-javier@cozybit.com>
References: <1292022251-12616-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let path selection frames for protocols other than HWMP be sent to
userspace via NL80211_CMD_REGISTER_FRAME.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 lib/nlattr.c           |    1 -
 net/mac80211/cfg.c     |    1 +
 net/mac80211/main.c    |    4 ++++
 net/mac80211/mesh.c    |   12 ++++++++++--
 net/mac80211/mesh.h    |    4 +++-
 net/mac80211/rx.c      |    7 ++++++-
 net/wireless/nl80211.c |    1 +
 7 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index c4706eb..1a3c169 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -94,7 +94,6 @@ static int validate_nla(struct nlattr *nla, int maxtype,
 			minlen = pt->len;
 		else if (pt->type != NLA_UNSPEC)
 			minlen = nla_attr_minlen[pt->type];
-
 		if (attrlen < minlen)
 			return -ERANGE;
 	}
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4fee008..8093439 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1673,6 +1673,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (!ieee80211_is_action(mgmt->frame_control) ||
 		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)
 			break;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 973fee9..ba0919e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -484,6 +484,10 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
 			BIT(IEEE80211_STYPE_ACTION >> 4),
 	},
+	[NL80211_IFTYPE_MESH_POINT] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4),
+	},
 };
 
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 80723d8..c38c833 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -126,13 +126,21 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 
 void mesh_ids_set_default(struct ieee80211_if_mesh *sta)
 {
-	sta->mesh_pp_id = 0;	/* HWMP */
-	sta->mesh_pm_id = 0;	/* Airtime */
+	sta->mesh_pp_id = MESH_PATH_PROTOCOL_HWMP;
+	sta->mesh_pm_id = MESH_PATH_PROTOCOL_VENDOR;
 	sta->mesh_cc_id = 0;	/* Disabled */
 	sta->mesh_sp_id = 0;	/* Neighbor Offset */
 	sta->mesh_auth_id = 0;	/* Disabled */
 }
 
+
+bool mesh_path_sel_match(struct ieee80211_sub_if_data *sdata, enum
+		mesh_path_sel_id psid)
+{
+	return (sdata->u.mesh.mesh_pp_id == psid);
+
+}
+
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
 {
 	int i;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 4a1cd4a..fd89b63 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -50,7 +50,7 @@ enum mesh_path_flags {
  * @MESH_PATH_PROTOCOL_VENDOR: a vendor specific protocol that will be
  * specified in a vendor specific information element
  */
-enum {
+enum mesh_path_sel_id {
 	MESH_PATH_PROTOCOL_HWMP = 0,
 	MESH_PATH_PROTOCOL_VENDOR = 255,
 };
@@ -229,6 +229,8 @@ int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
 bool mesh_matches_local(struct ieee802_11_elems *ie,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
+bool mesh_path_sel_match(struct ieee80211_sub_if_data *sdata, enum
+		mesh_path_sel_id psid);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2fe8f5f..ba6b947 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2124,10 +2124,15 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		}
 		break;
 	case WLAN_CATEGORY_MESH_PLINK:
-	case WLAN_CATEGORY_MESH_PATH_SEL:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
 		goto queue;
+	case WLAN_CATEGORY_MESH_PATH_SEL:
+		if (!ieee80211_vif_is_mesh(&sdata->vif) ||
+				!mesh_path_sel_match(sdata,
+					MESH_PATH_PROTOCOL_HWMP))
+			break;
+		goto queue;
 	}
 
 	return RX_CONTINUE;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bbef129..96b6890 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4315,6 +4315,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
-- 
1.7.1

