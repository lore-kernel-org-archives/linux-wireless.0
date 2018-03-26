Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:41470 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752712AbeCZRxH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:53:07 -0400
Received: by mail-oi0-f67.google.com with SMTP id 188-v6so354626oih.8
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 10:53:07 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v7 09/11] nl80211: Add control_port_over_nl80211 to mesh_setup
Date: Mon, 26 Mar 2018 12:52:49 -0500
Message-Id: <20180326175251.20666-10-denkenz@gmail.com> (sfid-20180326_195311_229773_6A6D819E)
In-Reply-To: <20180326175251.20666-1-denkenz@gmail.com>
References: <20180326175251.20666-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/net/cfg80211.h | 3 +++
 net/wireless/nl80211.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2a28f446648e..bdb1a3c2661e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1453,6 +1453,8 @@ struct mesh_config {
  * @userspace_handles_dfs: whether user space controls DFS operation, i.e.
  *	changes the channel when a radar is detected. This is required
  *	to operate on DFS channels.
+ * @control_port_over_nl80211: TRUE if userspace expects to exchange control
+ *	port frames over NL80211 instead of the network interface.
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -1475,6 +1477,7 @@ struct mesh_setup {
 	u32 basic_rates;
 	struct cfg80211_bitrate_mask beacon_rate;
 	bool userspace_handles_dfs;
+	bool control_port_over_nl80211;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 774f5d6ba8e4..3947ec7bc3a0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10166,6 +10166,15 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	setup.userspace_handles_dfs =
 		nla_get_flag(info->attrs[NL80211_ATTR_HANDLE_DFS]);
 
+	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
+		int r = validate_pae_over_nl80211(rdev, info);
+
+		if (r < 0)
+			return r;
+
+		setup.control_port_over_nl80211 = true;
+	}
+
 	err = cfg80211_join_mesh(rdev, dev, &setup, &cfg);
 
 	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
-- 
2.13.5
