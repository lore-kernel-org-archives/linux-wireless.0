Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:55182 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752303AbdEPJXj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 05:23:39 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/7] wireless: Require HANDLE_DFS flag to switch channel for non-AP mode
Date: Tue, 16 May 2017 11:23:12 +0200
Message-Id: <20170516092316.15636-4-sw@simonwunderlich.de> (sfid-20170516_112816_714596_F7018CF4)
In-Reply-To: <20170516092316.15636-1-sw@simonwunderlich.de>
References: <20170516092316.15636-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin@sipsolutions.net>

In the case the channel should be switched to one requiring DFS we need
to make sure that userspace will handle radar events when they happen.
For AP mode this is assumed to be the case, as a manager like hostapd
is required. However IBSS and MESH modes can work without further
userspace assistance, so refuse to use DFS channels unless userspace
vouches that it handles DFS.

NOTE: Userspace should have already flagged support earlier during mesh
or IBSS setup. However, this information is not readily accessible
currently.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
[sw: style cleanups]
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/wireless/nl80211.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d47e55e3f445..9eb59196a378 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7501,6 +7501,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
 	int err;
 	bool need_new_beacon = false;
+	bool need_handle_dfs_flag = true;
 	int len, i;
 	u32 cs_count;
 
@@ -7512,6 +7513,12 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 		need_new_beacon = true;
+		/* For all modes except AP the handle_dfs flag needs to be
+		 * supplied to tell the kernel that userspace will handle radar
+		 * events when they happen. Otherwise a switch to a channel
+		 * requiring DFS will be rejected.
+		 */
+		need_handle_dfs_flag = false;
 
 		/* useless if AP is not running */
 		if (!wdev->beacon_interval)
@@ -7634,8 +7641,13 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (err < 0)
 		return err;
 
-	if (err > 0)
+	if (err > 0) {
 		params.radar_required = true;
+		if (need_handle_dfs_flag &&
+		    !nla_get_flag(info->attrs[NL80211_ATTR_HANDLE_DFS])) {
+			return -EINVAL;
+		}
+	}
 
 	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
 		params.block_tx = true;
-- 
2.11.0
