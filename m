Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2IKH7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 03:59:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove unneeded CONFIG_PM ifdef
Date: Tue, 11 Sep 2012 09:59:43 +0200
Message-Id: <1347350383-23349-1-git-send-email-johannes@sipsolutions.net> (sfid-20120911_095912_518897_A3019C15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The functions are only called if CONFIG_PM is set
as the callers are under an ifdef, so there's no
need to also define no-op functions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d40e604..ddfca10 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1414,7 +1414,6 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 int ieee80211_reconfig(struct ieee80211_local *local);
 void ieee80211_stop_device(struct ieee80211_local *local);
 
-#ifdef CONFIG_PM
 int __ieee80211_suspend(struct ieee80211_hw *hw,
 			struct cfg80211_wowlan *wowlan);
 
@@ -1428,18 +1427,6 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 
 	return ieee80211_reconfig(hw_to_local(hw));
 }
-#else
-static inline int __ieee80211_suspend(struct ieee80211_hw *hw,
-				      struct cfg80211_wowlan *wowlan)
-{
-	return 0;
-}
-
-static inline int __ieee80211_resume(struct ieee80211_hw *hw)
-{
-	return 0;
-}
-#endif
 
 /* utility functions/constants */
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
-- 
1.7.10.4

