Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:52853 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab0BDVxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 16:53:48 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] mac80211: Improved IBSS merges
Date: Thu,  4 Feb 2010 22:46:30 +0100
Message-Id: <1265319990-25583-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to $11.1.4 from IEEE 802.11-2007, TSF is reset (drv_reset_tsf)
on MLME-JOIN, ie only when a new IBSS is created or if an existing IBSS
is joined, but not on IBSS merges.

Next, we merge even if the BSSID from the received beacon is the same as
our since merge can update more things that BSSID itself. This is
specifically true for ath9k where the merge updates TBTT timers as a
side effect and this is indeed needed if the TSF has been updated (if
TSF is updated, we need to update TBTT timers as well).

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ibss.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e905c45..5f0c246 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -77,9 +77,6 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 
-	/* Reset own TSF to allow time synchronization work. */
-	drv_reset_tsf(local);
-
 	skb = ifibss->skb;
 	rcu_assign_pointer(ifibss->presp, NULL);
 	synchronize_rcu();
@@ -373,10 +370,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				sdata->u.ibss.ssid_len))
 		goto put_bss;
 
-	/* same BSSID */
-	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
-		goto put_bss;
-
 	if (rx_status->flag & RX_FLAG_TSFT) {
 		/*
 		 * For correct IBSS merging we need mactime; since mactime is
@@ -575,6 +568,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 	else
 		sdata->drop_unencrypted = 0;
 
+	drv_reset_tsf(local);
+
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
 				  ifibss->channel, 3, /* first two are basic */
 				  capability, 0);
@@ -630,6 +625,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		       " based on configured SSID\n",
 		       sdata->name, cbss->bssid);
 
+		drv_reset_tsf(local);
 		ieee80211_sta_join_ibss(sdata, bss);
 		ieee80211_rx_bss_put(local, bss);
 		return;
-- 
1.6.3.3

