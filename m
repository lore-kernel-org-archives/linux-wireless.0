Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46832 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbbIRVC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 17:02:29 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Take bitrates into account when building IEs.
Date: Fri, 18 Sep 2015 14:02:25 -0700
Message-Id: <1442610145-8759-1-git-send-email-greearb@candelatech.com> (sfid-20150918_230233_022235_AAE0B7BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If a user restricts the rateset for some reason, then the
probe requests should not advertise rates that are not
selected by the user.

To implement this, we save the requested bitrates at
the mac80211 level and take it into account when building
the IEs.

This allows one to create a more realistic /b mode
station on modern hardware, for instance.  Good for
testing, and likely good for other things as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/mac80211.h     |  4 ++
 net/mac80211/cfg.c         |  3 ++
 net/mac80211/ieee80211_i.h | 15 ++++++-
 net/mac80211/scan.c        | 26 ++++++++++++-
 net/mac80211/util.c        | 97 ++++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 135 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d52914b..be069bd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1838,10 +1838,14 @@ struct ieee80211_hw {
  * struct ieee80211_scan_request - hw scan request
  *
  * @ies: pointers different parts of IEs (in req.ie)
+ * @disable_ht: Ensure nothing related to HT is in the probe request?
+ * @disable_vht: Ensure nothing related to VHT is in the probe request?
  * @req: cfg80211 request.
  */
 struct ieee80211_scan_request {
 	struct ieee80211_scan_ies ies;
+	bool disable_ht[IEEE80211_NUM_BANDS];
+	bool disable_vht[IEEE80211_NUM_BANDS];
 
 	/* Keep last */
 	struct cfg80211_scan_request req;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dd4ff36..41a7036 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2466,6 +2466,9 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
+	memcpy(&sdata->cfg_bitrate_mask, mask, sizeof(*mask));
+	sdata->cfg_bitrate_mask_set = true;
+
 	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {
 		ret = drv_set_bitrate_mask(local, sdata, mask);
 		if (ret)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 524ae63..2c3842e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -903,6 +903,10 @@ struct ieee80211_sub_if_data {
 	bool rc_has_mcs_mask[IEEE80211_NUM_BANDS];
 	u8  rc_rateidx_mcs_mask[IEEE80211_NUM_BANDS][IEEE80211_HT_MCS_MASK_LEN];
 
+	/* Store bitrate mask configured from user-space */
+	struct cfg80211_bitrate_mask cfg_bitrate_mask;
+	bool cfg_bitrate_mask_set; /* Has user set the mask? */
+
 	union {
 		struct ieee80211_if_ap ap;
 		struct ieee80211_if_wds wds;
@@ -1601,6 +1605,14 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
+void ieee80211_check_disabled_rates(struct ieee80211_sub_if_data *sdata,
+				    bool *disable_ht,
+				    bool *disable_vht);
+void ieee80211_check_all_rates_disabled(u8 bands_used,
+					bool *disable_ht_cfg,
+					bool *disable_vht_cfg,
+					bool *disable_ht,
+					bool *disable_vht);
 void ieee80211_scan_work(struct work_struct *work);
 int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				const u8 *ssid, u8 ssid_len,
@@ -1978,7 +1990,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     struct ieee80211_scan_ies *ie_desc,
 			     const u8 *ie, size_t ie_len,
 			     u8 bands_used, u32 *rate_masks,
-			     struct cfg80211_chan_def *chandef);
+			     struct cfg80211_chan_def *chandef,
+			     bool disable_ht, bool disable_vht);
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  const u8 *src, const u8 *dst,
 					  u32 ratemask,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 335ee7f..6fa21a6 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -256,6 +256,8 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	struct cfg80211_chan_def chandef;
 	u8 bands_used = 0;
 	int i, ielen, n_chans;
+	bool disable_ht;
+	bool disable_vht;
 
 	req = rcu_dereference_protected(local->scan_req,
 					lockdep_is_held(&local->mtx));
@@ -291,6 +293,11 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 		} while (!n_chans);
 	}
 
+	ieee80211_check_all_rates_disabled(bands_used,
+					   local->hw_scan_req->disable_ht,
+					   local->hw_scan_req->disable_vht,
+					   &disable_ht, &disable_vht);
+
 	local->hw_scan_req->req.n_channels = n_chans;
 	ieee80211_prepare_scan_chandef(&chandef, req->scan_width);
 
@@ -299,7 +306,8 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 					 local->hw_scan_ies_bufsize,
 					 &local->hw_scan_req->ies,
 					 req->ie, req->ie_len,
-					 bands_used, req->rates, &chandef);
+					 bands_used, req->rates, &chandef,
+					 disable_ht, disable_vht);
 	local->hw_scan_req->req.ie_len = ielen;
 	local->hw_scan_req->req.no_cck = req->no_cck;
 	ether_addr_copy(local->hw_scan_req->req.mac_addr, req->mac_addr);
@@ -557,6 +565,10 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		local->hw_scan_band = 0;
 
+		ieee80211_check_disabled_rates(sdata,
+					       local->hw_scan_req->disable_ht,
+					       local->hw_scan_req->disable_vht);
+
 		/*
 		 * After allocating local->hw_scan_req, we must
 		 * go through until ieee80211_prep_hw_scan(), so
@@ -1066,6 +1078,10 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_chan_def chandef;
 	int ret, i, iebufsz, num_bands = 0;
 	u32 rate_masks[IEEE80211_NUM_BANDS] = {};
+	bool disable_ht_cfg[IEEE80211_NUM_BANDS];
+	bool disable_vht_cfg[IEEE80211_NUM_BANDS];
+	bool disable_ht;
+	bool disable_vht;
 	u8 bands_used = 0;
 	u8 *ie;
 	size_t len;
@@ -1093,10 +1109,16 @@ int __ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_prepare_scan_chandef(&chandef, req->scan_width);
 
+	ieee80211_check_disabled_rates(sdata, disable_ht_cfg, disable_vht_cfg);
+	ieee80211_check_all_rates_disabled(bands_used, disable_ht_cfg,
+					   disable_vht_cfg,
+					   &disable_ht, &disable_vht);
+
 	len = ieee80211_build_preq_ies(local, ie, num_bands * iebufsz,
 				       &sched_scan_ies, req->ie,
 				       req->ie_len, bands_used,
-				       rate_masks, &chandef);
+				       rate_masks, &chandef, disable_ht,
+				       disable_vht);
 
 	ret = drv_sched_scan_start(local, sdata, req, &sched_scan_ies);
 	if (ret == 0) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8065dd4..8d33b7b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -47,6 +47,72 @@ struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(wiphy_to_ieee80211_hw);
 
+/**
+ * ieee80211_check_disabled_rates: Calculate which rate-sets are disabled
+ *    in all bands.
+ * @disable_ht_cfg  Holds array of enable/disable values for each band.
+ * @disable_vht_cfg  Holds array of enable/disable values for each band.
+ * @disable_ht  Return value:  is HT disabled for all bands.
+ * @disable_vht  Return value:  is VHT disabled for all bands.
+ */
+void ieee80211_check_all_rates_disabled(u8 bands_used,
+					bool *disable_ht_cfg,
+					bool *disable_vht_cfg,
+					bool *disable_ht,
+					bool *disable_vht)
+{
+	int i;
+
+	*disable_ht = true;
+	*disable_vht = true;
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		if (bands_used & (1 << i)) {
+			if (!disable_ht_cfg[i])
+				*disable_ht = false;
+			if (!disable_vht_cfg[i])
+				*disable_vht = false;
+		}
+	}
+}
+
+/**
+ * ieee80211_check_disabled_rates: Calculate which bands have zero rates
+ *  configured for HT and VHT.
+ * @disable_ht  Holds return value, array of length IEEE80211_NUM_BANDS.
+ * @disable_vht  Holds return value, array of length IEEE80211_NUM_BANDS.
+ */
+void ieee80211_check_disabled_rates(struct ieee80211_sub_if_data *sdata,
+				    bool *disable_ht,
+				    bool *disable_vht)
+{
+	int i;
+	int j;
+
+	/* Disable HT, VHT where we have no rates set. */
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		disable_ht[i] = false;
+		disable_vht[i] = false;
+		if (!sdata->cfg_bitrate_mask_set)
+			break;
+
+		disable_ht[i] = true;
+		disable_vht[i] = true;
+		for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
+			if (sdata->cfg_bitrate_mask.control[i].ht_mcs[j]) {
+				disable_ht[i] = false;
+				break;
+			}
+		}
+
+		for (j = 0; j < NL80211_VHT_NSS_MAX; j++) {
+			if (sdata->cfg_bitrate_mask.control[i].vht_mcs[j]) {
+				disable_vht[i] = false;
+				break;
+			}
+		}
+	}
+}
+
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type)
 {
@@ -1394,7 +1460,8 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 					 enum ieee80211_band band,
 					 u32 rate_mask,
 					 struct cfg80211_chan_def *chandef,
-					 size_t *offset)
+					 size_t *offset, bool disable_ht,
+					 bool disable_vht)
 {
 	struct ieee80211_supported_band *sband;
 	u8 *pos = buffer, *end = buffer + buffer_len;
@@ -1494,7 +1561,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 		*offset = noffset;
 	}
 
-	if (sband->ht_cap.ht_supported) {
+	if (sband->ht_cap.ht_supported && !disable_ht) {
 		if (end - pos < 2 + sizeof(struct ieee80211_ht_cap))
 			goto out_err;
 		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
@@ -1544,7 +1611,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 		break;
 	}
 
-	if (sband->vht_cap.vht_supported && have_80mhz) {
+	if (sband->vht_cap.vht_supported && have_80mhz && !disable_vht) {
 		if (end - pos < 2 + sizeof(struct ieee80211_vht_cap))
 			goto out_err;
 		pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
@@ -1562,7 +1629,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     struct ieee80211_scan_ies *ie_desc,
 			     const u8 *ie, size_t ie_len,
 			     u8 bands_used, u32 *rate_masks,
-			     struct cfg80211_chan_def *chandef)
+			     struct cfg80211_chan_def *chandef,
+			     bool disable_ht, bool disable_vht)
 {
 	size_t pos = 0, old_pos = 0, custom_ie_offset = 0;
 	int i;
@@ -1577,7 +1645,9 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 							     ie, ie_len, i,
 							     rate_masks[i],
 							     chandef,
-							     &custom_ie_offset);
+							     &custom_ie_offset,
+							     disable_ht,
+							     disable_vht);
 			ie_desc->ies[i] = buffer + old_pos;
 			ie_desc->len[i] = pos - old_pos;
 			old_pos = pos;
@@ -1613,6 +1683,11 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mgmt *mgmt;
 	int ies_len;
 	u32 rate_masks[IEEE80211_NUM_BANDS] = {};
+	bool disable_ht_cfg[IEEE80211_NUM_BANDS];
+	bool disable_vht_cfg[IEEE80211_NUM_BANDS];
+	bool disable_ht;
+	bool disable_vht;
+	u8 bands_used;
 	struct ieee80211_scan_ies dummy_ie_desc;
 
 	/*
@@ -1632,10 +1707,18 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		return NULL;
 
 	rate_masks[chan->band] = ratemask;
+	bands_used = BIT(chan->band);
+
+	ieee80211_check_disabled_rates(sdata, disable_ht_cfg, disable_vht_cfg);
+	ieee80211_check_all_rates_disabled(bands_used, disable_ht_cfg,
+					   disable_vht_cfg,
+					   &disable_ht, &disable_vht);
+
 	ies_len = ieee80211_build_preq_ies(local, skb_tail_pointer(skb),
 					   skb_tailroom(skb), &dummy_ie_desc,
-					   ie, ie_len, BIT(chan->band),
-					   rate_masks, &chandef);
+					   ie, ie_len, bands_used,
+					   rate_masks, &chandef, disable_ht,
+					   disable_vht);
 	skb_put(skb, ies_len);
 
 	if (dst) {
-- 
2.4.3

