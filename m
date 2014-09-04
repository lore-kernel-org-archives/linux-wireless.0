Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:60284 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbaIDSGu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 14:06:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: clean up ieee80211_i.h
Date: Thu,  4 Sep 2014 21:04:36 +0300
Message-Id: <1409853877-12312-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140904_200653_209059_2D76F736)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not sure how the declaration of ieee80211_tdls_peer_del_work
landed after the double inclusion protection end.

Change-Id: I465fd6f00bb13bd598fe394e59b01ca842f19266
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c8482e0..95469c4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1950,6 +1950,7 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			size_t extra_ies_len);
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
+void ieee80211_tdls_peer_del_work(struct work_struct *wk);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
@@ -1960,4 +1961,3 @@ extern const struct ethtool_ops ieee80211_ethtool_ops;
 #endif
 
 #endif /* IEEE80211_I_H */
-void ieee80211_tdls_peer_del_work(struct work_struct *wk);
-- 
1.8.1.msysgit.1

