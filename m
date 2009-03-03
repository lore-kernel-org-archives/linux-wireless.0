Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39996 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZCCEtM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:49:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 20:49:11 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.46550.551064.448896@gargle.gargle.HOWL> (sfid-20090303_054925_305807_D0C61226)
Date: Tue, 3 Mar 2009 10:15:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Jouni.Malinen@Atheros.com>
Subject: [PATCH] mac80211: Update IBSS beacon timestamp properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In IBSS mode, the beacon timestamp has to be filled with the
BSS's timestamp when joining, and set to zero when creating
a new BSS.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/ibss.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a96ce9d..f4becc1 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -64,7 +64,7 @@ static int __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				     const int freq,
 				     const size_t supp_rates_len,
 				     const u8 *supp_rates,
-				     const u16 capability)
+				     const u16 capability, u64 tsf)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -127,6 +127,7 @@ static int __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
 	mgmt->u.beacon.beacon_int =
 		cpu_to_le16(local->hw.conf.beacon_int);
+	mgmt->u.beacon.timestamp = cpu_to_le64(tsf);
 	mgmt->u.beacon.capab_info = cpu_to_le16(capability);
 
 	pos = skb_put(skb, 2 + ifibss->ssid_len);
@@ -199,7 +200,8 @@ static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 					 bss->cbss.beacon_interval,
 					 bss->cbss.channel->center_freq,
 					 bss->supp_rates_len, bss->supp_rates,
-					 bss->cbss.capability);
+					 bss->cbss.capability,
+					 bss->cbss.tsf);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -502,7 +504,7 @@ static int ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 					 bssid, local->hw.conf.beacon_int,
 					 local->hw.conf.channel->center_freq,
 					 sband->n_bitrates, supp_rates,
-					 capability);
+					 capability, 0);
 }
 
 static int ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
-- 
1.6.1

