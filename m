Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53076 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab1DGXJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:09:27 -0400
Received: by iwn34 with SMTP id 34so2939043iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:09:26 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v8 2/9] cfg80211/nl80211: Add userspace authentication flag to mesh setup
Date: Thu,  7 Apr 2011 15:08:28 -0700
Message-Id: <1302214115-3688-3-git-send-email-thomas@cozybit.com>
In-Reply-To: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
References: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

During mesh setup, use NL80211_MESH_SETUP_USERSPACE_AUTH flag to create
a secure mesh and route management frames to userspace.

Also, NL80211_CMD_GET_WIPHY now returns a flag NL80211_SUPPORT_MESH_AUTH
if the wiphy's mesh implementation supports routing of mesh auth frames
to userspace.  This is useful for forward compatibility between old
kernels and new userspace tools.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/nl80211.h |    9 +++++++++
 include/net/cfg80211.h  |    5 +++++
 net/wireless/mesh.c     |    4 ++++
 net/wireless/nl80211.c  |    5 +++++
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 82ef17d..59aa809 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -887,6 +887,9 @@ enum nl80211_commands {
  *	changed once the mesh is active.
  * @NL80211_ATTR_MESH_CONFIG: Mesh configuration parameters, a nested attribute
  *	containing attributes from &enum nl80211_meshconf_params.
+ * @NL80211_ATTR_SUPPORT_MESH_AUTH: Currently, this means the underlying driver
+ *	allows auth frames in a mesh to be passed to userspace for processing via
+ *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1075,6 +1078,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 
+	NL80211_ATTR_SUPPORT_MESH_AUTH,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1691,6 +1696,9 @@ enum nl80211_meshconf_params {
  * robust security network ie, or a vendor specific information element that
  * vendors will use to identify the path selection methods and metrics in use.
  *
+ * @NL80211_MESH_SETUP_USERSPACE_AUTH: Enable this option if an authentication
+ * daemon will be authenticating mesh candidates.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
@@ -1699,6 +1707,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC,
 	NL80211_MESH_SETUP_IE,
+	NL80211_MESH_SETUP_USERSPACE_AUTH,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a6c9b46..d5b2cef 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -657,6 +657,7 @@ struct mesh_config {
  * @path_metric: which metric to use
  * @ie: vendor information elements (optional)
  * @ie_len: length of vendor information elements
+ * @is_secure: or not
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -667,6 +668,7 @@ struct mesh_setup {
 	u8  path_metric;
 	const u8 *ie;
 	u8 ie_len;
+	bool is_secure;
 };
 
 /**
@@ -1417,6 +1419,8 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
  * @WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS: The device supports separate
  *	unicast and multicast TX keys.
+ * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
+ *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1429,6 +1433,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 	WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS= BIT(9),
+	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 };
 
 struct mac_address {
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0d4b226..0e5c122 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -72,6 +72,10 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_MESH_AUTH) &&
+	      setup->is_secure)
+		return -EOPNOTSUPP;
+
 	if (wdev->mesh_id_len)
 		return -EALREADY;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cc92fc5..4ce6e95 100644
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
@@ -2804,6 +2807,7 @@ static const struct nla_policy
 	nl80211_mesh_setup_params_policy[NL80211_MESH_SETUP_ATTR_MAX+1] = {
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
+	[NL80211_MESH_SETUP_USERSPACE_AUTH] = { .type = NLA_FLAG },
 	[NL80211_MESH_SETUP_IE] = { .type = NLA_BINARY,
 		.len = IEEE80211_MAX_DATA_LEN },
 };
@@ -2915,6 +2919,7 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 		setup->ie = nla_data(ieattr);
 		setup->ie_len = nla_len(ieattr);
 	}
+	setup->is_secure = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_AUTH]);
 
 	return 0;
 }
-- 
1.7.4.4

