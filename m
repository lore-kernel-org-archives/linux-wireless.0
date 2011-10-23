Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:46715 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab1JWTgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Oct 2011 15:36:16 -0400
Date: Sun, 23 Oct 2011 22:36:04 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: Fix TDLS support validation in add_station handler
Message-ID: <20111023193604.GA18257@jm.kir.nu> (sfid-20111023_213631_551869_0AD4E53C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to verify whether the command is successful before allocating
the station entry to avoid extra processing. This also fixes a memory
leak on the error path.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 net/mac80211/cfg.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e253afa..a9ded52 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -832,6 +832,12 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (is_multicast_ether_addr(mac))
 		return -EINVAL;
 
+	/* Only TDLS-supporting stations can add TDLS peers */
+	if ((params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
+	    !((wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
+	      sdata->vif.type == NL80211_IFTYPE_STATION))
+		return -ENOTSUPP;
+
 	sta = sta_info_alloc(sdata, mac, GFP_KERNEL);
 	if (!sta)
 		return -ENOMEM;
@@ -841,12 +847,6 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 
 	sta_apply_parameters(local, sta, params);
 
-	/* Only TDLS-supporting stations can add TDLS peers */
-	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
-	    !((wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
-	      sdata->vif.type == NL80211_IFTYPE_STATION))
-		return -ENOTSUPP;
-
 	rate_control_rate_init(sta);
 
 	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
