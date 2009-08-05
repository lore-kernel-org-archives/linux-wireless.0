Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61980 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbZHEJ0y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 05:26:54 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] nl80211: fix attrtype and value for NL80211_ATTR_SUPPORTED_COMMANDS
Date: Wed,  5 Aug 2009 17:28:30 +0800
Message-Id: <1249464510-21539-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the misuse between attrtype and value for the
CMD list nested in NL80211_ATTR_SUPPORTED_COMMANDS attribute.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/wireless/nl80211.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0cd5482..086d3fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -520,7 +520,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	 do {							\
 		if (dev->ops->op) {				\
 			i++;					\
-			NLA_PUT_U32(msg, i, NL80211_CMD_ ## n);	\
+			NLA_PUT_U32(msg, NL80211_CMD_ ## n, i);	\
 		}						\
 	} while (0)
 
@@ -539,19 +539,19 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	CMD(join_ibss, JOIN_IBSS);
 	if (dev->wiphy.netnsok) {
 		i++;
-		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
+		NLA_PUT_U32(msg, NL80211_CMD_SET_WIPHY_NETNS, i);
 	}
 
 #undef CMD
 
 	if (dev->ops->connect || dev->ops->auth) {
 		i++;
-		NLA_PUT_U32(msg, i, NL80211_CMD_CONNECT);
+		NLA_PUT_U32(msg, NL80211_CMD_CONNECT, i);
 	}
 
 	if (dev->ops->disconnect || dev->ops->deauth) {
 		i++;
-		NLA_PUT_U32(msg, i, NL80211_CMD_DISCONNECT);
+		NLA_PUT_U32(msg, NL80211_CMD_DISCONNECT, i);
 	}
 
 	nla_nest_end(msg, nl_cmds);
-- 
1.6.0.4

