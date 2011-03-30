Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35828 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1C3DGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 23:06:50 -0400
Received: by mail-gw0-f46.google.com with SMTP id a18so357556gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 20:06:50 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com
Subject: [PATCH v5 02/10] nl80211: Add userspace authentication  flag to mesh setup
Date: Tue, 29 Mar 2011 19:05:59 -0700
Message-Id: <1301450767-27045-3-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
References: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

During mesh setup, use NL80211_MESH_SETUP_USERSPACE_AUTH flag to create
a secure mesh and route management frames to userspace.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/nl80211.h    |    4 ++++
 include/net/cfg80211.h     |    2 ++
 net/mac80211/cfg.c         |    1 +
 net/mac80211/ieee80211_i.h |    1 +
 net/wireless/nl80211.c     |    2 ++
 5 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 82ef17d..91e3a8d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1691,6 +1691,9 @@ enum nl80211_meshconf_params {
  * robust security network ie, or a vendor specific information element that
  * vendors will use to identify the path selection methods and metrics in use.
  *
+ * @NL80211_MESH_SETUP_USERSPACE_AUTH: Enable this option if an authentication
+ * daemon will be authenticating mesh candidates.
+ *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
@@ -1699,6 +1702,7 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL,
 	NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC,
 	NL80211_MESH_SETUP_IE,
+	NL80211_MESH_SETUP_USERSPACE_AUTH,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1714943..2334985 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -656,6 +656,7 @@ struct mesh_config {
  * @path_metric: which metric to use
  * @ie: vendor information elements (optional)
  * @ie_len: length of vendor information elements
+ * @is_secure: or not
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -666,6 +667,7 @@ struct mesh_setup {
 	u8  path_metric;
 	const u8 *ie;
 	u8 ie_len;
+	bool is_secure;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f2f345a..4f73085 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1042,6 +1042,7 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
 	memcpy(ifmsh->mesh_id, setup->mesh_id, ifmsh->mesh_id_len);
 	ifmsh->mesh_pp_id = setup->path_sel_proto;
 	ifmsh->mesh_pm_id = setup->path_metric;
+	ifmsh->is_secure = setup->is_secure;
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d0fafde..7d1cb36 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -490,6 +490,7 @@ struct ieee80211_if_mesh {
 	bool accepting_plinks;
 	const u8 *ie;
 	u8 ie_len;
+	bool is_secure;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f251089..5878f2b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2804,6 +2804,7 @@ static const struct nla_policy
 	nl80211_mesh_setup_params_policy[NL80211_MESH_SETUP_ATTR_MAX+1] = {
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL] = { .type = NLA_U8 },
 	[NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC] = { .type = NLA_U8 },
+	[NL80211_MESH_SETUP_USERSPACE_AUTH] = { .type = NLA_FLAG },
 	[NL80211_MESH_SETUP_IE] = { .type = NLA_BINARY,
 		.len = IEEE80211_MAX_DATA_LEN },
 };
@@ -2915,6 +2916,7 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
 		setup->ie = nla_data(ieattr);
 		setup->ie_len = nla_len(ieattr);
 	}
+	setup->is_secure = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_AUTH]);
 
 	return 0;
 }
-- 
1.7.4.1

