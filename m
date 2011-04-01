Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50778 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab1DAVg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 17:36:58 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so3925709iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 14:36:58 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v6 10/10] nl80211: report mesh capabilities
Date: Fri,  1 Apr 2011 13:35:51 -0700
Message-Id: <1301690151-14979-11-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
References: <1301690151-14979-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_CMD_GET_WIPHY now returns a flag NL80211_SUPPORT_MESH_AUTH if
the wiphy's mesh implementation supports routing of mesh auth frames to
userspace.  This is useful for forward compatibility between old kernels
and new userspace tools.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    3 +++
 net/mac80211/main.c     |    4 ++++
 net/wireless/mesh.c     |    4 ++++
 net/wireless/nl80211.c  |    3 +++
 5 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2c0bb8d..5a81b3c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -899,6 +899,9 @@ enum nl80211_commands {
  *	changed once the mesh is active.
  * @NL80211_ATTR_MESH_CONFIG: Mesh configuration parameters, a nested attribute
  *	containing attributes from &enum nl80211_meshconf_params.
+ * @NL80211_ATTR_SUPPORT_MESH_AUTH: Currently, this means the underlying driver
+ *	allows auth frames in a mesh to be passed to userspace for processing via
+ *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1087,6 +1090,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 
+	NL80211_ATTR_SUPPORT_MESH_AUTH,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2bbb89b..affdefd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1416,6 +1416,8 @@ struct cfg80211_ops {
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
+ * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
+ *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
  * @WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS: The device supports separate
  *	unicast and multicast TX keys.
  */
@@ -1430,6 +1432,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 	WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS= BIT(9),
+	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 };
 
 struct mac_address {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0ae9b22..55cc521 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -761,6 +761,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/* mesh depends on Kconfig, but drivers should set it if they want */
 	local->hw.wiphy->interface_modes &= ~BIT(NL80211_IFTYPE_MESH_POINT);
 #endif
+	/* if the underlying driver supports mesh, mac80211 will (at least)
+	 * provide routing of mesh authentication frames to userspace */
+	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_MESH_POINT))
+		local->hw.wiphy->flags |= WIPHY_FLAG_MESH_AUTH;
 
 	/* mac80211 supports control port protocol changing */
 	local->hw.wiphy->flags |= WIPHY_FLAG_CONTROL_PORT_PROTOCOL;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index ab036b5..5c11608 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -74,6 +74,10 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_MESH_AUTH) &&
+	      setup->is_secure)
+		return -EOPNOTSUPP;
+
 	if (wdev->mesh_id_len)
 		return -EALREADY;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ee6197..fda52da 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -124,6 +124,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_BSS_HT_OPMODE] = { .type = NLA_U16 },
 
 	[NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
+	[NL80211_ATTR_SUPPORT_MESH_AUTH] = { .type = NLA_FLAG },
 
 	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HT_CAPABILITY_LEN },
@@ -594,6 +595,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 
 	if (dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_IBSS_RSN);
+	if (dev->wiphy.flags & WIPHY_FLAG_MESH_AUTH)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_MESH_AUTH);
 
 	NLA_PUT(msg, NL80211_ATTR_CIPHER_SUITES,
 		sizeof(u32) * dev->wiphy.n_cipher_suites,
-- 
1.7.4.1

