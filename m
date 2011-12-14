Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1LNLX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 06:23:58 -0500
Message-Id: <20111214112312.886236327@sipsolutions.net> (sfid-20111214_122402_992066_E28F8DA2)
Date: Wed, 14 Dec 2011 12:20:28 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] mac80211: remove duplicate TDLS peer verification
References: <20111214112026.409514167@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is already checked in cfg80211, so no need
to repeat the checks here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/net/mac80211/cfg.c	2011-12-14 10:54:15.000000000 +0100
+++ b/net/mac80211/cfg.c	2011-12-14 10:55:24.000000000 +0100
@@ -896,12 +896,6 @@ static int ieee80211_add_station(struct
 	if (is_multicast_ether_addr(mac))
 		return -EINVAL;
 
-	/* Only TDLS-supporting stations can add TDLS peers */
-	if ((params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
-	    !((wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
-	      sdata->vif.type == NL80211_IFTYPE_STATION))
-		return -ENOTSUPP;
-
 	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
 	if (!sta)
 		return -ENOMEM;
@@ -968,14 +962,6 @@ static int ieee80211_change_station(stru
 		return -ENOENT;
 	}
 
-	/* The TDLS bit cannot be toggled after the STA was added */
-	if ((params->sta_flags_mask & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
-	    !!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) !=
-	    !!test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
-		rcu_read_unlock();
-		return -EINVAL;
-	}
-
 	/* in station mode, supported rates are only valid with TDLS */
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    params->supported_rates &&


