Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38111 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbbGYOch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2015 10:32:37 -0400
Received: by wibxm9 with SMTP id xm9so65211910wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2015 07:32:36 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC 3/4] mac80211: define rate_control_apply_mask_ratetbl()
Date: Sat, 25 Jul 2015 16:32:28 +0200
Message-Id: <1437834749-23765-4-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150725_163242_840593_00A54455)
In-Reply-To: <1437834749-23765-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1437834749-23765-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define rate_control_apply_mask_ratetbl() in order to apply ratemask in
rate_control_set_rates() for station rate table

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/mac80211/rate.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 4f61ca0..7e71de9 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -651,6 +651,30 @@ static bool rate_control_cap_mask(struct ieee80211_sub_if_data *sdata,
 	return true;
 }
 
+static void
+rate_control_apply_mask_ratetbl(struct sta_info *sta,
+				struct ieee80211_supported_band *sband,
+				struct ieee80211_sta_rates *rates)
+{
+	int i;
+	u32 mask;
+	u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN];
+	enum nl80211_chan_width chan_width;
+
+	if (!rate_control_cap_mask(sta->sdata, sband, &sta->sta, &mask,
+				   mcs_mask))
+		return;
+
+	chan_width = sta->sdata->vif.bss_conf.chandef.width;
+	for (i = 0; i < IEEE80211_TX_RATE_TABLE_SIZE; i++) {
+		if (rates->rate[i].idx < 0)
+			break;
+
+		rate_idx_match_mask(&rates->rate[i].idx, &rates->rate[i].flags,
+				    sband, chan_width, mask, mcs_mask);
+	}
+}
+
 static void rate_control_apply_mask(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_sta *sta,
 				    struct ieee80211_supported_band *sband,
@@ -766,7 +790,10 @@ int rate_control_set_rates(struct ieee80211_hw *hw,
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sta_rates *old;
+	struct ieee80211_supported_band *sband;
 
+	sband = hw->wiphy->bands[ieee80211_get_sdata_band(sta->sdata)];
+	rate_control_apply_mask_ratetbl(sta, sband, rates);
 	/*
 	 * mac80211 guarantees that this function will not be called
 	 * concurrently, so the following RCU access is safe, even without
-- 
2.1.4

