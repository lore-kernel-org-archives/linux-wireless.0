Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:11277 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbYLKMA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 07:00:26 -0500
Received: by rv-out-0506.google.com with SMTP id k40so853762rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 04:00:25 -0800 (PST)
Message-ID: <eb3ff54b0812110400y2305c5abp9955a325b3372215@mail.gmail.com> (sfid-20081211_130029_330475_C5AE4BDD)
Date: Thu, 11 Dec 2008 14:00:25 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 1/2] mac80211: misc cleanups
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unneeded member (skbuff) from
ieee80211_ibss_add_sta() method in its declaration (in ieee80211_i.h)
and its callers (in rx.c and mlme.c)

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 527205f..a3858e7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -864,8 +864,7 @@ int ieee80211_sta_set_bssid(struct
ieee80211_sub_if_data *sdata, u8 *bssid);
 void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_if_sta *ifsta);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					struct sk_buff *skb, u8 *bssid,
-					u8 *addr, u64 supp_rates);
+					u8 *bssid, u8 *addr, u64 supp_rates);
 int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata,
u16 reason);
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata,
u16 reason);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 07b0cc3..98e03e3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1580,8 +1580,7 @@ static void ieee80211_rx_bss_info(struct
ieee80211_sub_if_data *sdata,
 				    (unsigned long long) sta->sta.supp_rates[band]);
 #endif
 		} else {
-			ieee80211_ibss_add_sta(sdata, NULL, mgmt->bssid,
-					       mgmt->sa, supp_rates);
+			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
 		}

 		rcu_read_unlock();
@@ -1654,9 +1653,7 @@ static void ieee80211_rx_bss_info(struct
ieee80211_sub_if_data *sdata,
 			       sdata->dev->name, print_mac(mac, mgmt->bssid));
 #endif
 			ieee80211_sta_join_ibss(sdata, &sdata->u.sta, bss);
-			ieee80211_ibss_add_sta(sdata, NULL,
-					       mgmt->bssid, mgmt->sa,
-					       supp_rates);
+			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, supp_rates);
 		}
 	}

@@ -2399,8 +2396,7 @@ void ieee80211_sta_setup_sdata(struct
ieee80211_sub_if_data *sdata)
  * must be callable in atomic context.
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
-					struct sk_buff *skb, u8 *bssid,
-					u8 *addr, u64 supp_rates)
+					u8 *bssid,u8 *addr, u64 supp_rates)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 59f356a..3d931a8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1864,9 +1864,8 @@ static int prepare_for_handlers(struct
ieee80211_sub_if_data *sdata,
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!rx->sta)
-			rx->sta = ieee80211_ibss_add_sta(sdata, rx->skb,
-						bssid, hdr->addr2,
-						BIT(rx->status->rate_idx));
+			rx->sta = ieee80211_ibss_add_sta(sdata, bssid, hdr->addr2,
+				BIT(rx->status->rate_idx));
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!multicast &&
