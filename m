Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41077 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab2DMTGs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 15:06:48 -0400
From: <wey-yi.w.guy@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] mac80211: add function retrieve average rssi
Date: Fri, 13 Apr 2012 12:02:57 -0700
Message-Id: <1334343777-20798-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120413_210651_693608_C98CB9A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add utility function to provide the average rssi per vif

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 include/net/mac80211.h |    3 +++
 net/mac80211/util.c    |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 32cd517..20a2ddd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3800,4 +3800,7 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif,
 
 int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
 				struct sk_buff *skb, bool need_basic);
+
+int ieee80211_ave_rssi(struct ieee80211_vif *vif);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e67fe5c..f426fec 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1797,3 +1797,11 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
 	}
 	return 0;
 }
+
+int ieee80211_ave_rssi(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	return ifmgd->ave_beacon_signal;
+}
-- 
1.7.0.4

