Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59058 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab1ECX5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 19:57:31 -0400
Received: by pvg12 with SMTP id 12so258431pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 16:57:31 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH 01/13] nl80211: Introduce NL80211_MESH_SETUP_USERSPACE_AMPE
Date: Tue,  3 May 2011 16:57:07 -0700
Message-Id: <1304467039-7730-2-git-send-email-javier@cozybit.com> (sfid-20110504_015737_521520_177F332C)
In-Reply-To: <1304467039-7730-1-git-send-email-javier@cozybit.com>
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce a new configuration option to support AMPE from userspace.

Prior to this series we only supported authentication in userspace: an
authentication daemon would authenticate peer candidates in userspace
and hand them over to the kernel.  From that point the mesh stack would
take over and establish a peer link (Mesh Peering Management).

These patches introduce support for Authenticated Mesh Peering Exchange
in userspace.  The userspace daemon implements the AMPE protocol and on
successfull completion create mesh peers and install encryption keys.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h    |   10 ++++++++++
 include/net/cfg80211.h     |    4 +++-
 net/mac80211/cfg.c         |    6 +++++-
 net/mac80211/ieee80211_i.h |    6 +++++-
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mesh_plink.c  |    5 +++--
 net/wireless/nl80211.c     |    4 +++-
 7 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 216b1d8..8684c0a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1748,6 +1748,15 @@ enum nl80211_meshconf_params {
  * @NL80211_MESH_SETUP_USERSPACE_AUTH: Enable this option if an authentication
  * daemon will be authenticating mesh candidates.
  *
+ * @NL80211_MESH_SETUP_USERSPACE_AMPE: Enable this option if an authentication
+ * daemon will be securing peer link frames.  AMPE is a secured version of Mesh
+ * Peering Management (MPM) and is implemented with the assistance of a
+ * userspace daemon.  When this flag is set, the kernel will send peer
+ * management frames to a userspace daemon that will implement AMPE
+ * functionality (security capabilities selection, key confirmation, and key
+ * management).  When the flag is unset (default), the kernel can autonomously
+ * complete (unsecured) mesh peering without the need of a userspace daemon.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
@@ -1757,6 +1766,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC,
 	NL80211_MESH_SETUP_IE,
 	NL80211_MESH_SETUP_USERSPACE_AUTH,
+	NL80211_MESH_SETUP_USERSPACE_AMPE,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d30eada..5e4f87b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -695,7 +695,8 @@ struct mesh_config {
  * @path_metric: which metric to use
  * @ie: vendor information elements (optional)
  * @ie_len: length of vendor information elements
- * @is_secure: or not
+ * @is_authenticated: this mesh requires authentication
+ * @is_secure: this mesh uses security
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -706,6 +707,7 @@ struct mesh_setup {
 	u8  path_metric;
 	const u8 *ie;
 	u8 ie_len;
+	bool is_authenticated;
 	bool is_secure;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 12d52ce..7ea13d3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1064,7 +1064,11 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
 	ifmsh->mesh_pp_id = setup->path_sel_proto;
 	ifmsh->mesh_pm_id = setup->path_metric;
-	ifmsh->is_secure = setup->is_secure;
+	ifmsh->security = IEEE80211_MESH_SEC_NONE;
+	if (setup->is_authenticated)
+		ifmsh->security |= IEEE80211_MESH_SEC_AUTHED;
+	if (setup->is_secure)
+		ifmsh->security |= IEEE80211_MESH_SEC_SECURED;
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 027c046..ec360fb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -490,7 +490,11 @@ struct ieee80211_if_mesh {
 	bool accepting_plinks;
 	const u8 *ie;
 	u8 ie_len;
-	bool is_secure;
+	enum {
+		IEEE80211_MESH_SEC_NONE = 0x0,
+		IEEE80211_MESH_SEC_AUTHED = 0x1,
+		IEEE80211_MESH_SEC_SECURED = 0x2,
+	} security;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c1299e2..2a59eb3 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -574,7 +574,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			       &elems);
 
 	/* ignore beacons from secure mesh peers if our security is off */
-	if (elems.rsn_len && !sdata->u.mesh.is_secure)
+	if (elems.rsn_len && sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE)
 		return;
 
 	if (elems.ds_params && elems.ds_params_len == 1)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 84e5b05..87abf8d 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -251,7 +251,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 		rcu_read_unlock();
 		/* Userspace handles peer allocation when security is enabled
 		 * */
-		if (sdata->u.mesh.is_secure)
+		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED)
 			cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
 					elems->ie_start, elems->total_len,
 					GFP_KERNEL);
@@ -460,7 +460,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		mpl_dbg("Mesh plink: missing necessary peer link ie\n");
 		return;
 	}
-	if (elems.rsn_len && !sdata->u.mesh.is_secure) {
+	if (elems.rsn_len &&
+			sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) {
 		mpl_dbg("Mesh plink: can't establish link with secure peer\n");
 		return;
 	}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0efa7fd..7c1c4de 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2840,6 +2840,7 @@ static const struct nla_policy
 	[NL80211_MESH_SETUP_USERSPACE_AUTH] = { .type = NLA_FLAG },
 	[NL80211_MESH_SETUP_IE] = { .type = NLA_BINARY,
 		.len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_MESH_SETUP_USERSPACE_AMPE] = { .type = NLA_FLAG },
 };
 
 static int nl80211_parse_mesh_config(struct genl_info *info,
@@ -2949,7 +2950,8 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 		setup->ie = nla_data(ieattr);
 		setup->ie_len = nla_len(ieattr);
 	}
-	setup->is_secure = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_AUTH]);
+	setup->is_authenticated = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_AUTH]);
+	setup->is_secure = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_AMPE]);
 
 	return 0;
 }
-- 
1.7.1

