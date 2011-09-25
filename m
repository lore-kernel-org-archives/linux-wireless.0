Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40877 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1IYRHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Sep 2011 13:07:00 -0400
Received: by eya28 with SMTP id 28so3096767eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Sep 2011 10:06:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] cfg80211/mac80211: add netdev param to set_txq_params()
Date: Sun, 25 Sep 2011 20:06:53 +0300
Message-Id: <1316970415-23239-1-git-send-email-eliad@wizery.com> (sfid-20110925_190718_908856_D0F4FB63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx params are currently configured per hw, although they
should be configured per interface.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/cfg80211.h |    2 +-
 net/mac80211/cfg.c     |    1 +
 net/wireless/nl80211.c |    6 ++++++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ccfdf3f..1635e78 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1484,7 +1484,7 @@ struct cfg80211_ops {
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
 
-	int	(*set_txq_params)(struct wiphy *wiphy,
+	int	(*set_txq_params)(struct wiphy *wiphy, struct net_device *dev,
 				  struct ieee80211_txq_params *params);
 
 	int	(*set_channel)(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b57ddf9..805b40b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1271,6 +1271,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 }
 
 static int ieee80211_set_txq_params(struct wiphy *wiphy,
+				    struct net_device *dev,
 				    struct ieee80211_txq_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c26a1da..b43f354 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1235,6 +1235,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			goto bad_res;
 		}
 
+		if (!netdev) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
@@ -1247,6 +1252,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 				goto bad_res;
 
 			result = rdev->ops->set_txq_params(&rdev->wiphy,
+							   netdev,
 							   &txq_params);
 			if (result)
 				goto bad_res;
-- 
1.7.6.401.g6a319

