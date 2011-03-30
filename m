Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35828 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab1C3DHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 23:07:03 -0400
Received: by mail-gw0-f46.google.com with SMTP id a18so357556gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 20:07:03 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	linville@tuxdriver.com
Subject: [PATCH v5 07/10] mac80211: Perform PLINK_ACTION on new station
Date: Tue, 29 Mar 2011 19:06:04 -0700
Message-Id: <1301450767-27045-8-git-send-email-thomas@cozybit.com>
In-Reply-To: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
References: <1301450767-27045-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Modify the NEW_STATION command to accept PLINK_ACTIONS, in case
userspace wants to create stations and initiate a peer link right away
(for authenticated stations) or create a blocked station (for
debugging).

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_plink.c |    2 +-
 net/wireless/nl80211.c    |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 5d0dd92..b327e0e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -105,7 +105,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return NULL;
 
-	sta->flags = WLAN_STA_AUTHORIZED;
+	sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	rate_control_rate_init(sta);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e76dc79..5854366 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2327,11 +2327,16 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 
+	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
+		params.plink_action =
+		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
+
 	if (parse_station_flags(info, &params))
 		return -EINVAL;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EINVAL;
 
-- 
1.7.4.1

