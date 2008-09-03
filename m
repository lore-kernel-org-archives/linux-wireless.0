Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYICUmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 16:42:31 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] mac80211: Fix rate scale initialization in IBSS
Date: Wed,  3 Sep 2008 23:42:20 +0300
Message-Id: <1220474540-16737-4-git-send-email-tomas.winkler@intel.com> (sfid-20080903_224234_479499_BDB95EAC)
In-Reply-To: <1220474540-16737-3-git-send-email-tomas.winkler@intel.com>
References: <1220474540-16737-1-git-send-email-tomas.winkler@intel.com>
 <1220474540-16737-2-git-send-email-tomas.winkler@intel.com>
 <1220474540-16737-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch address some IBSS rate issues introduced
or not covered by
6bc37c06bc424bcf3f944e6a79e2d5bb537e02ed
and 8318d78a44d49ac1edf2bdec7299de3617c4232e patches.

This patch:
1. Moves addition of IBSS station from
prepare_for_handlers to ieee80211_rx_bss_info when triggered from beacon
eliminating bogus supported rates.
2. Initialize properly supported rates also in IBSS merging
3. Ensure that mandatory rates are always added into supported
rates. This is needed in case when station addition is triggered from
non beacon/probe packet. Some management frames need to be sent
4. Remove initialization of supported rates from self rates. This path
was dead code after 6bc37c06bc4 and in general incorrect.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Vladimir Koutny <vlado@work.ksp.sk>
---
 net/mac80211/mlme.c |   90 ++++++++++++++++++++++++++++++++++++---------------
 net/mac80211/rx.c   |    4 --
 2 files changed, 64 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 75510a9..c396c35 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2557,6 +2557,33 @@ u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 	return supp_rates;
 }
 
+static u64 ieee80211_sta_get_mandatory_rates(struct ieee80211_local *local,
+					enum ieee80211_band band)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	u64 mandatory_rates;
+	enum ieee80211_rate_flags mandatory_flag;
+	int i;
+
+	sband = local->hw.wiphy->bands[band];
+	if (!sband) {
+		WARN_ON(1);
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	}
+
+	if (band == IEEE80211_BAND_2GHZ)
+		mandatory_flag = IEEE80211_RATE_MANDATORY_B;
+	else
+		mandatory_flag = IEEE80211_RATE_MANDATORY_A;
+
+	bitrates = sband->bitrates;
+	mandatory_rates = 0;
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (bitrates[i].flags & mandatory_flag)
+			mandatory_rates |= BIT(i);
+	return mandatory_rates;
+}
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
@@ -2568,9 +2595,11 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	int freq, clen;
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
-	u64 beacon_timestamp, rx_timestamp;
 	struct ieee80211_channel *channel;
+	u64 beacon_timestamp, rx_timestamp;
+	u64 supp_rates = 0;
 	bool beacon = ieee80211_is_beacon(mgmt->frame_control);
+	enum ieee80211_band band = rx_status->band;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
@@ -2578,30 +2607,41 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
 	    elems->mesh_config && mesh_matches_local(elems, sdata)) {
-		u64 rates = ieee80211_sta_get_rates(local, elems,
-						rx_status->band);
+		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 
-		mesh_neighbour_update(mgmt->sa, rates, sdata,
+		mesh_neighbour_update(mgmt->sa, supp_rates, sdata,
 				      mesh_peer_accepts_plinks(elems));
 	}
 
 	rcu_read_lock();
 
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems->supp_rates &&
-	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
-	    (sta = sta_info_get(local, mgmt->sa))) {
-		u64 prev_rates;
-		u64 supp_rates = ieee80211_sta_get_rates(local, elems,
-							rx_status->band);
-
-		prev_rates = sta->supp_rates[rx_status->band];
-		sta->supp_rates[rx_status->band] = supp_rates;
-		if (sta->supp_rates[rx_status->band] == 0) {
-			/* No matching rates - this should not really happen.
-			 * Make sure that at least one rate is marked
-			 * supported to avoid issues with TX rate ctrl. */
-			sta->supp_rates[rx_status->band] =
-				sdata->u.sta.supp_rates_bits[rx_status->band];
+	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
+
+		supp_rates = ieee80211_sta_get_rates(local, elems, band);
+
+		sta = sta_info_get(local, mgmt->sa);
+		if (sta) {
+			u64 prev_rates;
+
+			prev_rates = sta->supp_rates[band];
+			/* make sure mandatory rates are always added */
+			sta->supp_rates[band] = supp_rates |
+				ieee80211_sta_get_mandatory_rates(local, band);
+
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+			if (sta->supp_rates[band] != prev_rates)
+				printk(KERN_DEBUG "%s: updated supp_rates set "
+				    "for %s based on beacon info (0x%llx | "
+				    "0x%llx -> 0x%llx)\n",
+				    sdata->dev->name, print_mac(mac, sta->addr),
+				    (unsigned long long) prev_rates,
+				    (unsigned long long) supp_rates,
+				    (unsigned long long) sta->supp_rates[band]);
+#endif
+		} else {
+			ieee80211_ibss_add_sta(sdata, NULL, mgmt->bssid,
+					       mgmt->sa, supp_rates);
 		}
 	}
 
@@ -2683,7 +2723,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		bss->supp_rates_len += clen;
 	}
 
-	bss->band = rx_status->band;
+	bss->band = band;
 
 	bss->timestamp = beacon_timestamp;
 	bss->last_update = jiffies;
@@ -2738,7 +2778,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			 * e.g: at 1 MBit that means mactime is 192 usec earlier
 			 * (=24 bytes * 8 usecs/byte) than the beacon timestamp.
 			 */
-			int rate = local->hw.wiphy->bands[rx_status->band]->
+			int rate = local->hw.wiphy->bands[band]->
 					bitrates[rx_status->rate_idx].bitrate;
 			rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
 		} else if (local && local->ops && local->ops->get_tsf)
@@ -2766,7 +2806,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss);
 			ieee80211_ibss_add_sta(sdata, NULL,
 					       mgmt->bssid, mgmt->sa,
-					       BIT(rx_status->rate_idx));
+					       supp_rates);
 		}
 	}
 
@@ -3032,7 +3072,6 @@ void ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *
 	kfree_skb(skb);
 }
 
-
 static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
@@ -4316,10 +4355,9 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 
 	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
-	if (supp_rates)
-		sta->supp_rates[band] = supp_rates;
-	else
-		sta->supp_rates[band] = sdata->u.sta.supp_rates_bits[band];
+	/* make sure mandatory rates are always added */
+	sta->supp_rates[band] = supp_rates |
+			ieee80211_sta_get_mandatory_rates(local, band);
 
 	rate_control_rate_init(sta, local);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fd83ef7..7e09b30 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1743,10 +1743,6 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 		if (!bssid)
 			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
-			if (!rx->sta)
-				rx->sta = ieee80211_ibss_add_sta(sdata,
-						rx->skb, bssid, hdr->addr2,
-						BIT(rx->status->rate_idx));
 			return 1;
 		}
 		else if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

