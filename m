Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58097 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab3FCQxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 12:53:48 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so5937430pdj.29
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 09:53:48 -0700 (PDT)
From: Colleen Twitty <colleen@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 1/2] {nl,cfg}80211: make peer link expiration time configurable
Date: Mon,  3 Jun 2013 09:53:39 -0700
Message-Id: <1370278420-10135-1-git-send-email-colleen@cozybit.com> (sfid-20130603_185351_628053_DCD2040B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a STA has a peer that it hasn't seen any tx activity
from for a certain length of time, the peer link is
expired. This means the inactive STA is removed from the
list of peers and that STA is not considered a peer again
unless it re-peers.  Previously, this inactivity time was
always 30 minutes.  Now, add it to the mesh configuration
and allow it to be configured.  Retain 30 minutes as a
default value.

Signed-off-by: Colleen Twitty <colleen@cozybit.com>
---
 include/net/cfg80211.h       |    4 ++++
 include/uapi/linux/nl80211.h |    5 +++++
 net/wireless/mesh.c          |    2 ++
 net/wireless/nl80211.c       |    8 +++++++-
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26b5b69..684fa2e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1108,6 +1108,9 @@ struct bss_parameters {
  *	setting for new peer links.
  * @dot11MeshAwakeWindowDuration: The duration in TUs the STA will remain awake
  *	after transmitting its beacon.
+ * @plink_timeout: If no tx activity is seen from a STA we've established
+ *	peering with for longer than this time (in seconds), then remove it
+ *	from the STA's list of peers.  Default is 30 minutes.
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -1137,6 +1140,7 @@ struct mesh_config {
 	u16 dot11MeshHWMPconfirmationInterval;
 	enum nl80211_mesh_power_mode power_mode;
 	u16 dot11MeshAwakeWindowDuration;
+	u32 plink_timeout;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d1e48b5..302bc4b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2559,6 +2559,10 @@ enum nl80211_mesh_power_mode {
  *
  * @NL80211_MESHCONF_AWAKE_WINDOW: awake window duration (in TUs)
  *
+ * @NL80211_MESHCONF_PLINK_TIMEOUT: If no tx activity is seen from a STA we've
+ *	established peering with for longer than this time (in seconds), then
+ *	remove it from the STA's list of peers.  Default is 30 minutes.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2590,6 +2594,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
 	NL80211_MESHCONF_POWER_MODE,
 	NL80211_MESHCONF_AWAKE_WINDOW,
+	NL80211_MESHCONF_PLINK_TIMEOUT,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 0bb93f3..71e981e 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -18,6 +18,7 @@
 #define MESH_PATH_TO_ROOT_TIMEOUT      6000
 #define MESH_ROOT_INTERVAL     5000
 #define MESH_ROOT_CONFIRMATION_INTERVAL 2000
+#define MESH_DEFAULT_PLINK_TIMEOUT	1800 /* timeout in seconds */
 
 /*
  * Minimum interval between two consecutive PREQs originated by the same
@@ -75,6 +76,7 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
 	.power_mode = NL80211_MESH_POWER_ACTIVE,
 	.dot11MeshAwakeWindowDuration = MESH_DEFAULT_AWAKE_WINDOW,
+	.plink_timeout = MESH_DEFAULT_PLINK_TIMEOUT,
 };
 
 const struct mesh_setup default_mesh_setup = {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dfdb5e6..0bb3e65 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4585,7 +4585,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u32(msg, NL80211_MESHCONF_POWER_MODE,
 			cur_params.power_mode) ||
 	    nla_put_u16(msg, NL80211_MESHCONF_AWAKE_WINDOW,
-			cur_params.dot11MeshAwakeWindowDuration))
+			cur_params.dot11MeshAwakeWindowDuration) ||
+	    nla_put_u32(msg, NL80211_MESHCONF_PLINK_TIMEOUT,
+			cur_params.plink_timeout))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -4626,6 +4628,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_POWER_MODE] = { .type = NLA_U32 },
 	[NL80211_MESHCONF_AWAKE_WINDOW] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_PLINK_TIMEOUT] = { .type = NLA_U32 },
 };
 
 static const struct nla_policy
@@ -4762,6 +4765,9 @@ do {									    \
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration,
 				  0, 65535, mask,
 				  NL80211_MESHCONF_AWAKE_WINDOW, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 1, 0xffffffff,
+				  mask, NL80211_MESHCONF_PLINK_TIMEOUT,
+				  nla_get_u32);
 	if (mask_out)
 		*mask_out = mask;
 
-- 
1.7.9.5

