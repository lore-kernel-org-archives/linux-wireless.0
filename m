Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63884 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab2C0N4X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 09:56:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] mac80211: prepare ieee80211_mandatory_rates to per-vif
Date: Tue, 27 Mar 2012 15:55:56 +0200
Message-ID: <1332856558-5708-2-git-send-email-michal.kazior@tieto.com> (sfid-20120327_155627_286722_1493CB90)
In-Reply-To: <1332856558-5708-1-git-send-email-michal.kazior@tieto.com>
References: <1332856558-5708-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/ibss.c        |    6 +++---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |    2 +-
 net/mac80211/util.c        |    3 ++-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 33fd8d9..50ba1fa 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -332,7 +332,7 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
+			ieee80211_mandatory_rates(sdata, band);
 
 	return ieee80211_ibss_finish_sta(sta, auth);
 }
@@ -417,7 +417,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				prev_rates = sta->sta.supp_rates[band];
 				/* make sure mandatory rates are always added */
 				sta->sta.supp_rates[band] = supp_rates |
-					ieee80211_mandatory_rates(local, band);
+					ieee80211_mandatory_rates(sdata, band);
 
 				if (sta->sta.supp_rates[band] != prev_rates) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
@@ -604,7 +604,7 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
-			ieee80211_mandatory_rates(local, band);
+			ieee80211_mandatory_rates(sdata, band);
 
 	spin_lock(&ifibss->incomplete_lock);
 	list_add(&sta->list, &ifibss->incomplete_stations);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..de9346e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1406,7 +1406,7 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
+u32 ieee80211_mandatory_rates(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_band band);
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 401c01f..c7c60ce 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1005,7 +1005,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 
 	/* reset some values that shouldn't be kept across type changes */
 	sdata->vif.bss_conf.basic_rates =
-		ieee80211_mandatory_rates(sdata->local,
+		ieee80211_mandatory_rates(sdata,
 			sdata->local->hw.conf.channel->band);
 	sdata->drop_unencrypted = 0;
 	if (type == NL80211_IFTYPE_STATION)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 32f7a3b..959b2c4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -868,9 +868,10 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_wmm_default(sdata, true);
 }
 
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
+u32 ieee80211_mandatory_rates(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_band band)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
 	u32 mandatory_rates;
-- 
1.7.0.4

