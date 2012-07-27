Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2G0LIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:08:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/6] mac80211: use oper_channel in ibss
Date: Fri, 27 Jul 2012 13:07:57 +0200
Message-Id: <1343387281-7252-3-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130812_562937_B28802F4)
In-Reply-To: <1343387281-7252-1-git-send-email-johannes@sipsolutions.net>
References: <1343387281-7252-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using hw.conf.channel is wrong as it could be the
temporary channel if any function like the beacon
get function is called while scanning or during
other temporary out-of-channel activities.

Use oper_channel instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5746d62..d062085 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -205,7 +205,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
-	bss = cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
+	bss = cfg80211_inform_bss_frame(local->hw.wiphy, chan,
 					mgmt, skb->len, 0, GFP_KERNEL);
 	cfg80211_put_bss(bss);
 	netif_carrier_on(sdata->dev);
@@ -294,7 +294,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	int band = local->hw.conf.channel->band;
+	int band = local->oper_channel->band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -561,7 +561,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	int band = local->hw.conf.channel->band;
+	int band = local->oper_channel->band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -759,7 +759,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 				return;
 			}
 			sdata_info(sdata, "IBSS not allowed on %d MHz\n",
-				   local->hw.conf.channel->center_freq);
+				   local->oper_channel->center_freq);
 
 			/* No IBSS found - decrease scan interval and continue
 			 * scanning. */
-- 
1.7.10.4

