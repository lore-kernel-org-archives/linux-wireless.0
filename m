Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3FCLx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 07:53:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: kubakici@wp.pl, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix sdata locking around __ieee80211_request_smps
Date: Mon,  3 Jun 2013 13:53:20 +0200
Message-Id: <1370260400-12149-1-git-send-email-johannes@sipsolutions.net> (sfid-20130603_135330_396658_85AC8BB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My cfg80211/mac80211 locking unification broke the sdata
locking in ieee80211_set_power_mgmt, it needs to acquire
the lock for __ieee80211_request_smps(). Add the locking.

Reported-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9034da1..3062210 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2378,7 +2378,9 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	local->dynamic_ps_forced_timeout = timeout;
 
 	/* no change, but if automatic follow powersave */
+	sdata_lock(sdata);
 	__ieee80211_request_smps(sdata, sdata->u.mgd.req_smps);
+	sdata_unlock(sdata);
 
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-- 
1.8.0

