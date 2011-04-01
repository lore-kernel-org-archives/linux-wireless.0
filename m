Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41195 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1DACtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 22:49:49 -0400
Received: by iwn34 with SMTP id 34so3027879iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 19:49:48 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org, javier@cozybit.com
Cc: Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] nl80211: report mesh capabilities
Date: Thu, 31 Mar 2011 18:49:09 -0700
Message-Id: <1301622549-16788-1-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301472903.3935.3.camel@jlt3.sipsolutions.net>
References: <1301472903.3935.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_CMD_GET_WIPHY now returns a flag NL80211_SUPPORT_MESH_AUTH if
the wiphy's mesh implementation supports routing of mesh auth frames to
userspace.  This is useful for forward compatibility between old kernels
and new userspace tools.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

Johannes, 

Thanks for your comments, I've tried to implement the necessary changes below.
wiphy->flags now gets a WIPHY_FLAG_MESH_AUTH flag in case the mesh
implementation supports routing of mesh auth frames to userspace. If you know
of a better place to put this (rdev maybe?), please let me know. Also, it would
be nice if all you have is the ifindex; not having to send a command to
nl80211, parse the response, then get the wiphy index so you can request
capabilities from the stack. I'd like to be able to get capabilities directly
from an interface, should this happen in CMD_GET_MESH_CONFIG,
CMD_GET_INTERFACE, or maybe somewhere else?

v2:

- return capabilities for a wiphy (Johannes)
- WIPHY_FLAG_MESH_AUTH is now set by the cfg80211 driver to indicate support
  for routing mesh auth frames to userspace (Johannes)
---
 include/linux/nl80211.h |    5 +++++
 include/net/cfg80211.h  |    3 +++
 net/mac80211/main.c     |    4 ++++
 net/wireless/nl80211.c  |    3 +++
 4 files changed, 15 insertions(+), 0 deletions(-)

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

