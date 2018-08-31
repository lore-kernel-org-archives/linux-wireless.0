Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45308 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727599AbeHaMiA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:38:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 31 Aug 2018 11:31:05 +0300
Message-Id: <20180831083130.15525-4-luca@coelho.fi> (sfid-20180831_103151_839699_A3E47D69)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 03/28] mac80211: remove pointless 'params' NULL checks
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These checks aren't necessary, cfg80211 never passes NULL.
Some static checkers complain about the missing checks on
the next line, but really the NULL checks are unnecessary.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index da1b85de7930..1813c6f148bb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -158,12 +158,10 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	if (ret)
 		return ret;
 
-	if (type == NL80211_IFTYPE_AP_VLAN &&
-	    params && params->use_4addr == 0) {
+	if (type == NL80211_IFTYPE_AP_VLAN && params->use_4addr == 0) {
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 		ieee80211_check_fast_rx_iface(sdata);
-	} else if (type == NL80211_IFTYPE_STATION &&
-		   params && params->use_4addr >= 0) {
+	} else if (type == NL80211_IFTYPE_STATION && params->use_4addr >= 0) {
 		sdata->u.mgd.use_4addr = params->use_4addr;
 	}
 
-- 
2.18.0
