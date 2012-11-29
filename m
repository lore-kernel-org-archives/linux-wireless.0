Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2K2MRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 07:17:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] mac80211: make ieee80211_build_preq_ies safer
Date: Thu, 29 Nov 2012 13:17:35 +0100
Message-Id: <1354191456-29577-2-git-send-email-johannes@sipsolutions.net> (sfid-20121129_131722_632015_D52FC155)
In-Reply-To: <1354191456-29577-1-git-send-email-johannes@sipsolutions.net>
References: <1354191456-29577-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of assuming 200 bytes are always enough for
all the IEs we add, give the length of the buffer
to the function and warn instead of overrunning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/scan.c        | 21 ++++++++++++---------
 net/mac80211/util.c        | 34 +++++++++++++++++++++++++++-------
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e13697d..f148cfa 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1034,6 +1034,7 @@ struct ieee80211_local {
 	enum ieee80211_band hw_scan_band;
 	int scan_channel_idx;
 	int scan_ies_len;
+	int hw_scan_ies_bufsize;
 
 	struct work_struct sched_scan_stopped_work;
 	struct ieee80211_sub_if_data __rcu *sched_scan_sdata;
@@ -1570,7 +1571,7 @@ void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 				    const u8 *bssid, u16 stype, u16 reason,
 				    bool send_frame, u8 *frame_buf);
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
-			     const u8 *ie, size_t ie_len,
+			     size_t buffer_len, const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel);
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ddd1a9a..d7c190b80 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -247,6 +247,7 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	local->hw_scan_req->n_channels = n_chans;
 
 	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
+					 local->hw_scan_ies_bufsize,
 					 req->ie, req->ie_len, band,
 					 req->rates[band], 0);
 	local->hw_scan_req->ie_len = ielen;
@@ -445,11 +446,13 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan) {
 		u8 *ies;
 
+		local->hw_scan_ies_bufsize = 2 + IEEE80211_MAX_SSID_LEN +
+					     local->scan_ies_len +
+					     req->ie_len;
 		local->hw_scan_req = kmalloc(
 				sizeof(*local->hw_scan_req) +
 				req->n_channels * sizeof(req->channels[0]) +
-				2 + IEEE80211_MAX_SSID_LEN + local->scan_ies_len +
-				req->ie_len, GFP_KERNEL);
+				local->hw_scan_ies_bufsize, GFP_KERNEL);
 		if (!local->hw_scan_req)
 			return -ENOMEM;
 
@@ -928,7 +931,10 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sched_scan_ies sched_scan_ies;
-	int ret, i;
+	int ret, i, iebufsz;
+
+	iebufsz = 2 + IEEE80211_MAX_SSID_LEN +
+		  local->scan_ies_len + req->ie_len;
 
 	mutex_lock(&local->mtx);
 
@@ -946,10 +952,7 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 		if (!local->hw.wiphy->bands[i])
 			continue;
 
-		sched_scan_ies.ie[i] = kzalloc(2 + IEEE80211_MAX_SSID_LEN +
-					       local->scan_ies_len +
-					       req->ie_len,
-					       GFP_KERNEL);
+		sched_scan_ies.ie[i] = kzalloc(iebufsz, GFP_KERNEL);
 		if (!sched_scan_ies.ie[i]) {
 			ret = -ENOMEM;
 			goto out_free;
@@ -957,8 +960,8 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 
 		sched_scan_ies.len[i] =
 			ieee80211_build_preq_ies(local, sched_scan_ies.ie[i],
-						 req->ie, req->ie_len, i,
-						 (u32) -1, 0);
+						 iebufsz, req->ie, req->ie_len,
+						 i, (u32) -1, 0);
 	}
 
 	ret = drv_sched_scan_start(local, sdata, req, &sched_scan_ies);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 62a2158..602fc44 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1114,12 +1114,12 @@ void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 }
 
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
-			     const u8 *ie, size_t ie_len,
+			     size_t buffer_len, const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel)
 {
 	struct ieee80211_supported_band *sband;
-	u8 *pos;
+	u8 *pos = buffer, *end = buffer + buffer_len;
 	size_t offset = 0, noffset;
 	int supp_rates_len, i;
 	u8 rates[32];
@@ -1130,8 +1130,6 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	if (WARN_ON_ONCE(!sband))
 		return 0;
 
-	pos = buffer;
-
 	num_rates = 0;
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if ((BIT(i) & rate_mask) == 0)
@@ -1141,6 +1139,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 
 	supp_rates_len = min_t(int, num_rates, 8);
 
+	if (end - pos < 2 + supp_rates_len)
+		goto out_err;
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = supp_rates_len;
 	memcpy(pos, rates, supp_rates_len);
@@ -1157,6 +1157,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 					     before_extrates,
 					     ARRAY_SIZE(before_extrates),
 					     offset);
+		if (end - pos < noffset - offset)
+			goto out_err;
 		memcpy(pos, ie + offset, noffset - offset);
 		pos += noffset - offset;
 		offset = noffset;
@@ -1164,6 +1166,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 
 	ext_rates_len = num_rates - supp_rates_len;
 	if (ext_rates_len > 0) {
+		if (end - pos < 2 + ext_rates_len)
+			goto out_err;
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
 		*pos++ = ext_rates_len;
 		memcpy(pos, rates + supp_rates_len, ext_rates_len);
@@ -1171,6 +1175,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	}
 
 	if (channel && sband->band == IEEE80211_BAND_2GHZ) {
+		if (end - pos < 3)
+			goto out_err;
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
 		*pos++ = channel;
@@ -1189,14 +1195,19 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		noffset = ieee80211_ie_split(ie, ie_len,
 					     before_ht, ARRAY_SIZE(before_ht),
 					     offset);
+		if (end - pos < noffset - offset)
+			goto out_err;
 		memcpy(pos, ie + offset, noffset - offset);
 		pos += noffset - offset;
 		offset = noffset;
 	}
 
-	if (sband->ht_cap.ht_supported)
+	if (sband->ht_cap.ht_supported) {
+		if (end - pos < 2 + sizeof(struct ieee80211_ht_cap))
+			goto out_err;
 		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
 						sband->ht_cap.cap);
+	}
 
 	/*
 	 * If adding more here, adjust code in main.c
@@ -1206,15 +1217,23 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	/* add any remaining custom IEs */
 	if (ie && ie_len) {
 		noffset = ie_len;
+		if (end - pos < noffset - offset)
+			goto out_err;
 		memcpy(pos, ie + offset, noffset - offset);
 		pos += noffset - offset;
 	}
 
-	if (sband->vht_cap.vht_supported)
+	if (sband->vht_cap.vht_supported) {
+		if (end - pos < 2 + sizeof(struct ieee80211_vht_cap))
+			goto out_err;
 		pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
 						 sband->vht_cap.cap);
+	}
 
 	return pos - buffer;
+ out_err:
+	WARN_ONCE(1, "not enough space for preq IEs\n");
+	return pos - buffer;
 }
 
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
@@ -1246,7 +1265,8 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	else
 		chan_no = ieee80211_frequency_to_channel(chan->center_freq);
 
-	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len, chan->band,
+	buf_len = ieee80211_build_preq_ies(local, buf, 200 + ie_len,
+					   ie, ie_len, chan->band,
 					   ratemask, chan_no);
 
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
-- 
1.8.0

