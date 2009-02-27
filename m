Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57420 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZB0EIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 23:08:49 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2009 20:08:48 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18855.26210.618690.891378@gargle.gargle.HOWL> (sfid-20090227_050902_022335_FE798F0F)
Date: Fri, 27 Feb 2009 09:34:50 +0530
To: <linux-wireless@vger.kernel.org>
Subject: IBSS issues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am seeing some strange behavior in IBSS mode with current wireless-testing.

Scenario:

 * Create a new cell using ath9k.
 * Wait for a while to do a background merge scan run.
 * Join the cell from another peer ( say, using ath5k ).
 * Station dump in peer1 1 doesn't show the new peer right away.
 * The merge runs are not supposed to happen if a cell has more than one peer.
   It didn't happen before, but it keeps running repeatedly now.
 * Ping from peer2 to peer1 doesn't go through - peer1 to peer2 works though.

Joining an existing IBSS network using ath9k works fine, no issues here.
Also, if the second peer joins the cell quickly, before the scan run, things are okay.

I identified one bug, where the timestamp in the beacon template was not updated.
Patch below. But it doesn't fix the issue.

Any clues ?

Sujith

In IBSS mode, the beacon timestamp has to be filled with the
BSS's timestamp when joining, and set to zero when creating
a new BSS.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

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
