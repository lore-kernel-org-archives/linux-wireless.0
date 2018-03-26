Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35736 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbeCZRxG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:53:06 -0400
Received: by mail-oi0-f65.google.com with SMTP id x20-v6so16586637oie.2
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 10:53:06 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v7 08/11] nl80211: Add control_port_over_nl80211 for ibss
Date: Mon, 26 Mar 2018 12:52:48 -0500
Message-Id: <20180326175251.20666-9-denkenz@gmail.com> (sfid-20180326_195318_170667_7B798C7E)
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
index 2e7f30c66913..2a28f446648e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2033,6 +2033,8 @@ struct cfg80211_disassoc_request {
  *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
  *	required to assume that the port is unauthorized until authorized by
  *	user space. Otherwise, port is marked authorized by default.
+ * @control_port_over_nl80211: TRUE if userspace expects to exchange control
+ *	port frames over NL80211 instead of the network interface.
  * @userspace_handles_dfs: whether user space controls DFS operation, i.e.
  *	changes the channel when a radar is detected. This is required
  *	to operate on DFS channels.
@@ -2056,6 +2058,7 @@ struct cfg80211_ibss_params {
 	bool channel_fixed;
 	bool privacy;
 	bool control_port;
+	bool control_port_over_nl80211;
 	bool userspace_handles_dfs;
 	int mcast_rate[NUM_NL80211_BANDS];
 	struct ieee80211_ht_cap ht_capa;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 34e8435f0c43..774f5d6ba8e4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8702,6 +8702,15 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	ibss.control_port =
 		nla_get_flag(info->attrs[NL80211_ATTR_CONTROL_PORT]);
 
+	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
+		int r = validate_pae_over_nl80211(rdev, info);
+
+		if (r < 0)
+			return r;
+
+		ibss.control_port_over_nl80211 = true;
+	}
+
 	ibss.userspace_handles_dfs =
 		nla_get_flag(info->attrs[NL80211_ATTR_HANDLE_DFS]);
 
-- 
2.13.5
