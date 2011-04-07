Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab1DGXJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 19:09:36 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so2935734iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 16:09:36 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com
Subject: [PATCH v8 7/9] nl80211/mac80211: Perform PLINK_ACTION on new station
Date: Thu,  7 Apr 2011 15:08:33 -0700
Message-Id: <1302214115-3688-8-git-send-email-thomas@cozybit.com>
In-Reply-To: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
References: <1302214115-3688-1-git-send-email-thomas@cozybit.com>
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
index 7a7b954..f31c73b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2330,11 +2330,16 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
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
1.7.4.4

