Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38307 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1FZHcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 03:32:24 -0400
Received: by wyg8 with SMTP id 8so542079wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jun 2011 00:32:23 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 1/2] mac80211: propagate information about STA WME support down
Date: Sun, 26 Jun 2011 10:32:17 +0300
Message-Id: <1309073538-24071-1-git-send-email-arik@wizery.com> (sfid-20110626_093235_082298_49A85F61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a memeber to the ieee80211_sta structure to indicate whether the STA
supports WME.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->2: made member valid for drivers operating as STA or IBSS, in addition
to AP mode.

 include/net/mac80211.h     |    2 ++
 net/mac80211/cfg.c         |    5 ++++-
 net/mac80211/ibss.c        |   15 ++++++++++++---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |    4 +++-
 net/mac80211/rx.c          |    3 ++-
 6 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c7189c..c07c328 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -933,6 +933,7 @@ enum set_key_cmd {
  * @aid: AID we assigned to the station if we're an AP
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own TX capabilities
+ * @wme: indicates whether the STA supports WME
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
@@ -941,6 +942,7 @@ struct ieee80211_sta {
 	u8 addr[ETH_ALEN];
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
+	bool wme;
 
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index be70c70..e6e6b35 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -674,8 +674,11 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 
 	if (mask & BIT(NL80211_STA_FLAG_WME)) {
 		sta->flags &= ~WLAN_STA_WME;
-		if (set & BIT(NL80211_STA_FLAG_WME))
+		sta->sta.wme = false;
+		if (set & BIT(NL80211_STA_FLAG_WME)) {
 			sta->flags |= WLAN_STA_WME;
+			sta->sta.wme = true;
+		}
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 421eaa6..efa1d86 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -310,11 +310,14 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 			} else
 				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
 						mgmt->sa, supp_rates,
+						elems->wmm_info != NULL,
 						GFP_ATOMIC);
 		}
 
-		if (sta && elems->wmm_info)
+		if (sta && elems->wmm_info) {
 			set_sta_flags(sta, WLAN_STA_WME);
+			sta->sta.wme = true;
+		}
 
 		rcu_read_unlock();
 	}
@@ -404,7 +407,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_join_ibss(sdata, bss);
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
 		ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa,
-				       supp_rates, GFP_KERNEL);
+				       supp_rates, elems->wmm_info != NULL,
+				       GFP_KERNEL);
 	}
 
  put_bss:
@@ -418,7 +422,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
  */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid,u8 *addr, u32 supp_rates,
-					gfp_t gfp)
+					bool wme, gfp_t gfp)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -454,6 +458,11 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	sta->last_rx = jiffies;
 	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
+	if (wme) {
+		set_sta_flags(sta, WLAN_STA_WME);
+		sta->sta.wme = true;
+	}
+
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
 			ieee80211_mandatory_rates(local, band);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2025af5..8e4eb95 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1119,7 +1119,7 @@ void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
-					gfp_t gfp);
+					bool wme, gfp_t gfp);
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4f6b267..749e649 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1535,8 +1535,10 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
 		set_sta_flags(sta, WLAN_STA_MFP);
 
-	if (elems.wmm_param)
+	if (elems.wmm_param) {
 		set_sta_flags(sta, WLAN_STA_WME);
+		sta->sta.wme = true;
+	}
 
 	err = sta_info_insert(sta);
 	sta = NULL;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7fa8c6b..999f6be 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2652,7 +2652,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			else
 				rate_idx = status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, bssid,
-					hdr->addr2, BIT(rate_idx), GFP_ATOMIC);
+					hdr->addr2, BIT(rate_idx), false,
+					GFP_ATOMIC);
 		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
-- 
1.7.4.1

