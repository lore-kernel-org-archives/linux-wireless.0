Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58326 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab3LHHn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Dec 2013 02:43:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH] mac80211: make ieee80211_assign_beacon() static
Date: Sun,  8 Dec 2013 09:42:25 +0200
Message-Id: <1386488545-15901-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131208_084346_998664_C0FF2CAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

This function is not used anywhere else than in cfg.c, so there's no
need to export it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 4 ++--
 net/mac80211/ieee80211_i.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a30aa95..b61c594 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -873,8 +873,8 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
-			    struct cfg80211_beacon_data *params)
+static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
+				   struct cfg80211_beacon_data *params)
 {
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0a16e2c..44cd681 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1438,8 +1438,6 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
-int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
-			    struct cfg80211_beacon_data *params);
 
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
-- 
1.8.3.2

