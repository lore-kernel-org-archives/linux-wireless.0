Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:46851 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3AWUTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 15:19:01 -0500
Received: by mail-da0-f48.google.com with SMTP id k18so3971109dae.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 12:19:00 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/2] mac80211: support mesh rate updates
Date: Wed, 23 Jan 2013 12:18:13 -0800
Message-Id: <1358972293-2884-2-git-send-email-thomas@cozybit.com> (sfid-20130123_211910_598374_21E445A7)
In-Reply-To: <1358972293-2884-1-git-send-email-thomas@cozybit.com>
References: <1358972293-2884-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An existing mesh station entry may change its rate
capabilities, so call rate_control_rate_update() to notify
the rate control.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/driver-ops.h |    3 ++-
 net/mac80211/mesh_plink.c |    8 +++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 0c07f94..b80d7a3 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -569,7 +569,8 @@ static inline void drv_sta_rc_update(struct ieee80211_local *local,
 	check_sdata_in_driver(sdata);
 
 	WARN_ON(changed & IEEE80211_RC_SUPP_RATES_CHANGED &&
-		sdata->vif.type != NL80211_IFTYPE_ADHOC);
+		(sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+		 sdata->vif.type != NL80211_IFTYPE_MESH_POINT);
 
 	trace_drv_sta_rc_update(local, sdata, sta, changed);
 	if (local->ops->sta_rc_update)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index fd280a6..1500a44 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -292,7 +292,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband;
-	u32 rates, basic_rates = 0;
+	u32 rates, basic_rates = 0, changed = 0;
 
 	sband = local->hw.wiphy->bands[band];
 	rates = ieee80211_sta_get_rates(local, elems, band, &basic_rates);
@@ -304,6 +304,8 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	if (sta->plink_state == NL80211_PLINK_ESTAB)
 		goto out;
 
+	if (sta->sta.supp_rates[band] != rates)
+		changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
 	sta->sta.supp_rates[band] = rates;
 	if (elems->ht_cap_elem &&
 	    sdata->vif.bss_conf.chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
@@ -322,11 +324,15 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 					    ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		ieee80211_ht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
 					     elems->ht_operation, &chandef);
+		if (sta->ch_width != chandef.width)
+			changed |= IEEE80211_RC_BW_CHANGED;
 		sta->ch_width = chandef.width;
 	}
 
 	if (insert)
 		rate_control_rate_init(sta);
+	else
+		rate_control_rate_update(local, sband, sta, changed);
 out:
 	spin_unlock_bh(&sta->lock);
 }
-- 
1.7.10.4

