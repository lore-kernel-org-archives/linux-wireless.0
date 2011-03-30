Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47173 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab1C3DHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 23:07:11 -0400
Received: by mail-yw0-f46.google.com with SMTP id 3so354559ywj.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 20:07:11 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v5 10/10] nl80211: return mesh capabilities
Date: Tue, 29 Mar 2011 19:06:07 -0700
Message-Id: <1301450767-27045-11-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
References: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_CMD_GET_MESH_CONFIG now returns an NL80211_ATTR_MESH_CAPS
containing the current capabilities of our mesh stack. This is useful
for forward compatibility between old kernels and new userspace tools.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/nl80211.h |   26 ++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   20 ++++++++++++++++----
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2c0bb8d..a1ff7c5 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -899,6 +899,9 @@ enum nl80211_commands {
  *	changed once the mesh is active.
  * @NL80211_ATTR_MESH_CONFIG: Mesh configuration parameters, a nested attribute
  *	containing attributes from &enum nl80211_meshconf_params.
+ * @NL80211_ATTR_MESH_CAPS: Mesh capabilities, nested flags from &enum
+ * nl80211_mesh_caps describing what our 11s stack supports. Returned by
+ * @NL80211_CMD_GET_MESH_CONFIG.  Read-only.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1087,6 +1090,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 
+	NL80211_ATTR_MESH_CAPS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1603,6 +1608,27 @@ enum nl80211_mntr_flags {
 };
 
 /**
+ * enume nl80211_mesh_caps - mesh capabilities flags
+ *
+ * Mesh stack capabilities flags.
+ *
+ * @__NL80211_MESH_CAP_INVALID: reserved
+ *
+ * @NL80211_MESH_CAP_SECURITY: stack supports 802.11s security.
+ *
+ * @__NL80211_MESH_CAP_AFTER_LAST: internal use
+ * @NL80211_MESH_CAP_MAX: highest possible monitor flag
+ */
+enum nl80211_mesh_caps {
+	__NL80211_MESH_CAP_INVALID,
+	NL80211_MESH_CAP_SECURITY,
+
+	/* keep last */
+	__NL80211_MESH_CAP_AFTER_LAST,
+	NL80211_MESH_CAP_MAX = __NL80211_MESH_CAP_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
  * Mesh configuration parameters. These can be changed while the mesh is
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ee6197..a4177e7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -124,6 +124,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_BSS_HT_OPMODE] = { .type = NLA_U16 },
 
 	[NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
+	[NL80211_ATTR_MESH_CAPS] = { .type = NLA_NESTED },
 
 	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HT_CAPABILITY_LEN },
@@ -2716,8 +2717,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	struct mesh_config cur_params;
 	int err = 0;
 	void *hdr;
-	struct nlattr *pinfoattr;
+	struct nlattr *container;
 	struct sk_buff *msg;
+	enum nl80211_mesh_caps capa;
 
 	if (wdev->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
@@ -2745,8 +2747,8 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			     NL80211_CMD_GET_MESH_CONFIG);
 	if (!hdr)
 		goto out;
-	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MESH_CONFIG);
-	if (!pinfoattr)
+	container = nla_nest_start(msg, NL80211_ATTR_MESH_CONFIG);
+	if (!container)
 		goto nla_put_failure;
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
 	NLA_PUT_U16(msg, NL80211_MESHCONF_RETRY_TIMEOUT,
@@ -2779,7 +2781,17 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 			cur_params.dot11MeshHWMPnetDiameterTraversalTime);
 	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_ROOTMODE,
 			cur_params.dot11MeshHWMPRootMode);
-	nla_nest_end(msg, pinfoattr);
+	nla_nest_end(msg, container);
+
+	/* report mesh capabilities */
+	container = nla_nest_start(msg, NL80211_ATTR_MESH_CAPS);
+	if (!container)
+		goto nla_put_failure;
+	for (capa = __NL80211_MESH_CAP_INVALID + 1;
+	     capa <= NL80211_MESH_CAP_MAX; capa++)
+		NLA_PUT_FLAG(msg, capa);
+	nla_nest_end(msg, container);
+
 	genlmsg_end(msg, hdr);
 	return genlmsg_reply(msg, info);
 
-- 
1.7.4.1

