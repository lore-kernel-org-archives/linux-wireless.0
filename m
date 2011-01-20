Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42011 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab1ATJaJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:30:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PfqqD-0005VR-Bk
	for linux-wireless@vger.kernel.org; Thu, 20 Jan 2011 10:30:05 +0100
Received: from dslb-084-059-120-020.pools.arcor-ip.net ([84.59.120.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:30:05 +0100
Received: from alexander.simon by dslb-084-059-120-020.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 10:30:05 +0100
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: [RFC 3/4] mac80211: support for IEEE80211N in IBSS
Date: Thu, 20 Jan 2011 09:26:30 +0000 (UTC)
Message-ID: <loom.20110120T102202-752@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de> <1295447708.4685.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse a new stations HT IE.
ieee80211_ibss_add_sta is called with a new argument, ht capabilities of that
new station.
Luckily there was that function ieee80211_ht_cap_ie_to_sta_ht_cap that is
called. This inserts these HT capabilities into the sta_info struct that is eg
used by the rate algorithm.
As mentioned before, this parameter will be NULL when called from rx.c (main
receive path).

diff -Nrup compat-wireless-2011-01-17.2/net/mac80211/ibss.c
compat-wireless-2011-01-17.3//net/mac80211/ibss.c
--- compat-wireless-2011-01-17.2/net/mac80211/ibss.c	2011-01-20
10:02:16.000000000 +0100
+++ compat-wireless-2011-01-17.3//net/mac80211/ibss.c	2011-01-20
10:03:11.000000000 +0100
@@ -391,7 +391,7 @@ static void ieee80211_rx_bss_info(struct
 				}
 			} else
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
-						mgmt->sa, supp_rates,
+						mgmt->sa, supp_rates, elems->ht_cap_elem,
 						GFP_ATOMIC);
 		}
 
@@ -490,7 +490,7 @@ static void ieee80211_rx_bss_info(struct
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, GFP_KERNEL);
+				       supp_rates, elems->ht_cap_elem, GFP_KERNEL);
 	}
 
  put_bss:
@@ -503,8 +503,8 @@ static void ieee80211_rx_bss_info(struct
  * must be callable in atomic context.
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					u8 *bssid,u8 *addr, u32 supp_rates,
-					gfp_t gfp)
+					u8 *bssid, u8 *addr, u32 supp_rates,
+					struct ieee80211_ht_cap *ht_cap, gfp_t gfp)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -544,6 +544,10 @@ struct sta_info *ieee80211_ibss_add_sta(
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
 
+	if (ht_cap)
+		ieee80211_ht_cap_ie_to_sta_ht_cap(local->hw.wiphy->bands[band],
+				ht_cap, &sta->sta.ht_cap);
+
 	rate_control_rate_init(sta);
 
 	/* If it fails, maybe we raced another insertion? */
diff -Nrup compat-wireless-2011-01-17.2/net/mac80211/ieee80211_i.h
compat-wireless-2011-01-17.3//net/mac80211/ieee80211_i.h
--- compat-wireless-2011-01-17.2/net/mac80211/ieee80211_i.h	2011-01-20
10:01:56.000000000 +0100
+++ compat-wireless-2011-01-17.3//net/mac80211/ieee80211_i.h	2011-01-20
10:03:11.000000000 +0100
@@ -1111,7 +1111,7 @@ void ieee80211_ibss_notify_scan_complete
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
-					gfp_t gfp);
+					struct ieee80211_ht_cap *ht_cap, gfp_t gfp);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
diff -Nrup compat-wireless-2011-01-17.2/net/mac80211/rx.c
compat-wireless-2011-01-17.3//net/mac80211/rx.c
--- compat-wireless-2011-01-17.2/net/mac80211/rx.c	2011-01-17 21:03:26.000000000
+0100
+++ compat-wireless-2011-01-17.3//net/mac80211/rx.c	2011-01-20
10:03:11.000000000 +0100
@@ -2618,7 +2618,7 @@ static int prepare_for_handlers(struct i
 			else
 				rate_idx = status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
-					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
+					hdr->addr2, BIT(rate_idx), NULL, GFP_ATOMIC);
 		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:


