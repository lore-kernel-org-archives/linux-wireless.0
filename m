Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab3CTNMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 09:12:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: ibss: disable beaconing before freeing beacon
Date: Wed, 20 Mar 2013 14:12:10 +0100
Message-Id: <1363785131-909-1-git-send-email-johannes@sipsolutions.net> (sfid-20130320_141218_695715_2F47CFC8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we don't disable beaconing, the driver might attempt
to continue, but would fail to request a beacon. That's
strange, so disable beaconing first.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 539d4a1..bd02fac 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -58,14 +58,6 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	/* Reset own TSF to allow time synchronization work. */
 	drv_reset_tsf(local, sdata);
 
-	skb = ifibss->skb;
-	RCU_INIT_POINTER(ifibss->presp, NULL);
-	synchronize_rcu();
-	skb->data = skb->head;
-	skb->len = 0;
-	skb_reset_tail_pointer(skb);
-	skb_reserve(skb, sdata->local->hw.extra_tx_headroom);
-
 	if (!ether_addr_equal(ifibss->bssid, bssid))
 		sta_info_flush(sdata);
 
@@ -73,10 +65,21 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.bss_conf.ibss_joined) {
 		sdata->vif.bss_conf.ibss_joined = false;
 		sdata->vif.bss_conf.ibss_creator = false;
+		sdata->vif.bss_conf.enable_beacon = false;
 		netif_carrier_off(sdata->dev);
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IBSS);
+		ieee80211_bss_info_change_notify(sdata,
+						 BSS_CHANGED_IBSS |
+						 BSS_CHANGED_BEACON_ENABLED);
 	}
 
+	skb = ifibss->skb;
+	RCU_INIT_POINTER(ifibss->presp, NULL);
+	synchronize_rcu();
+	skb->data = skb->head;
+	skb->len = 0;
+	skb_reset_tail_pointer(skb);
+	skb_reserve(skb, sdata->local->hw.extra_tx_headroom);
+
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	cfg80211_chandef_create(&chandef, chan, ifibss->channel_type);
-- 
1.8.0

