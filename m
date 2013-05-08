Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:46907 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3EHSqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 14:46:07 -0400
Received: by mail-da0-f48.google.com with SMTP id h32so1130558dak.7
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 11:46:06 -0700 (PDT)
From: Colleen Twitty <colleen@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 1/2] cfg80211: Userspace may inform kernel of mesh auth method.
Date: Wed,  8 May 2013 11:45:59 -0700
Message-Id: <1368038760-17752-1-git-send-email-colleen@cozybit.com> (sfid-20130508_204613_051522_EB773891)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Authentication takes place in userspace, but the beacon is
generated in the kernel.  Allow userspace to inform the
kernel of the authentication method so the appropriate
mesh config IE can be set prior to beacon generation when
joining the MBSS.

Signed-off-by: Colleen Twitty <colleen@cozybit.com>
---
  If user_mpm is set, allow userspace to set authentication bit.  (Johannes)

 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    5 +++++
 net/wireless/mesh.c          |    1 +
 net/wireless/nl80211.c       |    8 ++++++++
 4 files changed, 16 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26e9113..32a2f1b 100644
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
+	u8 auth_id;
 	const u8 *ie;
 	u8 ie_len;
 	bool is_authenticated;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b484307..0632071 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2645,6 +2645,10 @@ enum nl80211_meshconf_params {
  * @NL80211_MESH_SETUP_USERSPACE_MPM: Enable this option if userspace will
  *	implement an MPM which handles peer allocation and state.
  *
+ * @NL80211_MESH_SETUP_AUTH_PROTOCOL: Inform the kernel of the authentication
+ *	method (u8, as defined in IEEE 8.4.2.100.6, e.g. 0x1 for SAE).
+ *	Default is no authentication method required.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
@@ -2658,6 +2662,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_USERSPACE_AMPE,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC,
 	NL80211_MESH_SETUP_USERSPACE_MPM,
+	NL80211_MESH_SETUP_AUTH_PROTOCOL,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0bb93f3..9546ad2 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -82,6 +82,7 @@ const struct mesh_setup default_mesh_setup = {
 	.sync_method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
 	.path_sel_proto = IEEE80211_PATH_PROTOCOL_HWMP,
 	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
+	.auth_id = 0, /* open */
 	.ie = NULL,
 	.ie_len = 0,
 	.is_secure = false,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9cdcd9e..5f10f7a 100644
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
@@ -4857,6 +4858,13 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 	if (setup->is_secure)
 		setup->user_mpm = true;
 
+	if (tb[NL80211_MESH_SETUP_AUTH_PROTOCOL]) {
+		if (!setup->user_mpm)
+			return -EINVAL;
+		setup->auth_id =
+			nla_get_u8(tb[NL80211_MESH_SETUP_AUTH_PROTOCOL]);
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5

