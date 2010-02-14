Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:40319 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab0BNXeE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:34:04 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 1/2] mac80211: Improved IBSS merges
Date: Mon, 15 Feb 2010 00:33:54 +0100
Message-Id: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to $11.1.4 from IEEE 802.11-2007, TSF is reset (drv_reset_tsf)
on MLME-JOIN, ie only when a new IBSS is created or if an existing IBSS
is joined, but not on IBSS merges.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ibss.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 423befa..9328395 100644
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
@@ -579,6 +576,8 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 	else
 		sdata->drop_unencrypted = 0;
 
+	drv_reset_tsf(local);
+
 	__ieee80211_sta_join_ibss(sdata, bssid, sdata->vif.bss_conf.beacon_int,
 				  ifibss->channel, 3, /* first two are basic */
 				  capability, 0);
@@ -634,6 +633,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		       " based on configured SSID\n",
 		       sdata->name, cbss->bssid);
 
+		drv_reset_tsf(local);
 		ieee80211_sta_join_ibss(sdata, bss);
 		ieee80211_rx_bss_put(local, bss);
 		return;
-- 
1.5.6.5

