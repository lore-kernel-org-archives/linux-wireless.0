Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:42898 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760354Ab3ECTMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 15:12:21 -0400
Received: by mail-pa0-f42.google.com with SMTP id bj3so1075544pad.29
        for <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 12:12:21 -0700 (PDT)
From: Colleen Twitty <colleen@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: Userspace may inform kernel of mesh auth method.
Date: Fri,  3 May 2013 12:11:47 -0700
Message-Id: <1367608308-588-1-git-send-email-colleen@cozybit.com> (sfid-20130503_211225_398231_CAB8C904)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Authentication takes place in userspace, but the beacon is
generated in the kernel.  Allow userspace to inform the
kernel of the authentication method so the appropriate
mesh config IE can be set prior to beacon generation when
joining the MBSS.

Signed-off-by: Colleen Twitty <colleen@cozybit.com>
---
 include/linux/ieee80211.h    |   20 ++++++++++++++++++++
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    4 ++++
 net/wireless/mesh.c          |    1 +
 net/wireless/nl80211.c       |   16 ++++++++++++++++
 5 files changed, 43 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 06b0ed0..e3b9509 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1899,6 +1899,26 @@ enum {
 };
 
 /**
+ * enum mesh_config_auth_proto - mesh authentication protocol identifier
+ *
+ * Ref IEEE 802.11-2012 8.4.2.100.6 Authentication Protocol Identifier
+ *
+ * This field indicates the type of authentication protocol used to secure the
+ * MBSS.
+ *
+ * @IEEE80211_AUTH_PROTO_NONE: the default mesh authentication protocol,
+ *	no authentication is required to establish peering within the MBSS
+ * @IEEE80211_AUTH_PROTO_SAE: SAE authentication
+ * @IEEE80211_AUTH_PROTO_8021X : IEEE 802.1X authentication
+ *
+ */
+enum mesh_config_auth_proto {
+	IEEE80211_AUTH_PROTO_NONE =		0x0,
+	IEEE80211_AUTH_PROTO_SAE =		0x1,
+	IEEE80211_AUTH_PROTO_8021X =		0x2,
+};
+
+/**
  * enum ieee80211_root_mode_identifier - root mesh STA mode identifier
  *
  * These attribute are used by dot11MeshHWMPRootMode to set root mesh STA mode
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26e9113..072e424 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1161,6 +1161,7 @@ struct mesh_config {
  * @sync_method: which synchronization method to use
  * @path_sel_proto: which path selection protocol to use
  * @path_metric: which metric to use
+ * @auth_id: which authentication method this mesh is using
  * @ie: vendor information elements (optional)
  * @ie_len: length of vendor information elements
  * @is_authenticated: this mesh requires authentication
@@ -1179,6 +1180,7 @@ struct mesh_setup {
 	u8 sync_method;
 	u8 path_sel_proto;
 	u8 path_metric;
+	enum mesh_config_auth_proto auth_id;
 	const u8 *ie;
 	u8 ie_len;
 	bool is_authenticated;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b484307..408bb56 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2645,6 +2645,9 @@ enum nl80211_meshconf_params {
  * @NL80211_MESH_SETUP_USERSPACE_MPM: Enable this option if userspace will
  *	implement an MPM which handles peer allocation and state.
  *
+ * @NL80211_MESH_SETUP_AUTH_PROTOCOL: Inform the kernel of the authentication
+ *	method.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
@@ -2658,6 +2661,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_USERSPACE_AMPE,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC,
 	NL80211_MESH_SETUP_USERSPACE_MPM,
+	NL80211_MESH_SETUP_AUTH_PROTOCOL,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0bb93f3..53bfe0e 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -82,6 +82,7 @@ const struct mesh_setup default_mesh_setup = {
 	.sync_method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
 	.path_sel_proto = IEEE80211_PATH_PROTOCOL_HWMP,
 	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
+	.auth_id = IEEE80211_AUTH_PROTO_NONE,
 	.ie = NULL,
 	.ie_len = 0,
 	.is_secure = false,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9cdcd9e..b75c789 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4672,6 +4672,7 @@ static const struct nla_policy
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_USERSPACE_AUTH] = { .type = NLA_FLAG },
+	[NL80211_MESH_SETUP_AUTH_PROTOCOL] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_USERSPACE_MPM] = { .type = NLA_FLAG },
 	[NL80211_MESH_SETUP_IE] = { .type = NLA_BINARY,
 				    .len = IEEE80211_MAX_DATA_LEN },
@@ -4857,6 +4858,21 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 	if (setup->is_secure)
 		setup->user_mpm = true;
 
+	if (tb[NL80211_MESH_SETUP_AUTH_PROTOCOL]) {
+		if (!setup->is_authenticated || !setup->is_secure)
+			return -EINVAL;
+		switch (nla_get_u8(tb[NL80211_MESH_SETUP_AUTH_PROTOCOL])) {
+		case NL80211_AUTHTYPE_SAE:
+			setup->auth_id = IEEE80211_AUTH_PROTO_SAE;
+			break;
+		case NL80211_AUTHTYPE_OPEN_SYSTEM:
+			setup->auth_id = IEEE80211_AUTH_PROTO_NONE;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5

