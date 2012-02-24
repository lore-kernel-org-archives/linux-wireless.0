Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:59384 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2BYBUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 20:20:41 -0500
Received: by qadb12 with SMTP id b12so118096qad.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 17:20:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMcMvsj2XMFarr1+fqdSv88ZLrXLquK7wgF8LsTYDBfvHFwgrA@mail.gmail.com>
References: <CAMcMvsj2XMFarr1+fqdSv88ZLrXLquK7wgF8LsTYDBfvHFwgrA@mail.gmail.com>
From: Paul Stewart <pstew@chromium.org>
Date: Thu, 23 Feb 2012 17:59:53 -0800
Subject: [RFCv3] mac80211: Filter duplicate IE ids
To: linux-wireless@vger.kernel.org
Cc: sleffler@chromium.org, johannes@sipsolutions.net
Message-Id: <20120225012039.4E62720353@glenhelen.mtv.corp.google.com> (sfid-20120225_022048_565785_8AB44D08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 is lenient with respect to reception of corrupted beacons.
Even if the frame is corrupted as a whole, the available IE elements
are still passed back and accepted, sometimes replacing legitimate
data.  It is unknown to what extent this "feature" is made use of,
but it is clear that in some cases, this is detrimental.  One such
case is reported in http://crosbug.com/26832 where an AP corrupts
its beacons but not its probe responses.

One approach would be to completely reject frames with invaid data
(for example, if the last tag extends beyond the end of the enclosing
PDU).  The enclosed approach is much more conservative: we simply
prevent later IEs from overwriting the state from previous ones.
This approach hopes that there might be some salient data in the
IE stream before the corruption, and seeks to at least prevent that
data from being overwritten.  This approach will fix the case above.

Further, we flag element structures that contain data we think might
be corrupted, so that as we fill the mac80211 BSS structure, we try
not to replace data from an un-corrupted probe response with that
of a corrupted beacon, for example.

Short of any statistics gathering in the various forms of AP breakage,
it's not possible to ascertain the side effects of more stringent
discarding of data.

Signed-off-by: Paul Stewart <pstew@chromium.org>
Cc: Sam Leffler <sleffler@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
---

Fixed a couple style issues and a hanging variable.

 net/mac80211/ieee80211_i.h |   41 +++++++++++++++++++++++++
 net/mac80211/mlme.c        |   15 +++++++++
 net/mac80211/scan.c        |   71 +++++++++++++++++++++++++++++++------------
 net/mac80211/util.c        |   40 +++++++++++++++++++++++--
 4 files changed, 144 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 67aed1e..e02c033 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -105,6 +105,44 @@ struct ieee80211_bss {
 	 */
 	bool has_erp_value;
 	u8 erp_value;
+
+	/* Keep track of the corruption of the last beacon/probe response. */
+	u8 corrupt_data;
+
+	/* Keep track of what bits of information we have valid info for. */
+	u8 valid_data;
+};
+
+/**
+ * enum ieee80211_corrupt_data_flags - BSS data corruption flags
+ * @IEEE80211_BSS_CORRUPT_BEACON: last beacon frame received was corrupted
+ * @IEEE80211_BSS_CORRUPT_PROBE_RESP: last probe response received was corrupted
+ *
+ * These are bss flags that are attached to a bss in the
+ * @corrupt_data field of &struct ieee80211_bss.
+ */
+enum ieee80211_bss_corrupt_data_flags {
+	IEEE80211_BSS_CORRUPT_BEACON		= BIT(0),
+	IEEE80211_BSS_CORRUPT_PROBE_RESP	= BIT(1)
+};
+
+/**
+ * enum ieee80211_valid_data_flags - BSS valid data flags
+ * @IEEE80211_BSS_VALID_DTIM: DTIM data was gathered from non-corrupt IE
+ * @IEEE80211_BSS_VALID_WMM: WMM/UAPSD data was gathered from non-corrupt IE
+ * @IEEE80211_BSS_VALID_RATES: Supported rates were gathered from non-corrupt IE
+ * @IEEE80211_BSS_VALID_ERP: ERP flag was gathered from non-corrupt IE
+ *
+ * These are bss flags that are attached to a bss in the
+ * @valid_data field of &struct ieee80211_bss.  They show which parts
+ * of the data structure were recieved as a result of an un-corrupted
+ * beacon/probe response.
+ */
+enum ieee80211_bss_valid_data_flags {
+	IEEE80211_BSS_VALID_DTIM		= BIT(0),
+	IEEE80211_BSS_VALID_WMM			= BIT(1),
+	IEEE80211_BSS_VALID_RATES		= BIT(2),
+	IEEE80211_BSS_VALID_ERP			= BIT(3)
 };
 
 static inline u8 *bss_mesh_cfg(struct ieee80211_bss *bss)
@@ -1120,6 +1158,9 @@ struct ieee802_11_elems {
 	u8 quiet_elem_len;
 	u8 num_of_quiet_elem;	/* can be more the one */
 	u8 timeout_int_len;
+
+	/* whether a parse error occurred while retrieving these elements */
+	bool parse_error;
 };
 
 static inline struct ieee80211_local *hw_to_local(
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 52133da..3145dd4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3409,6 +3409,21 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 	run_again(ifmgd, assoc_data->timeout);
 
+
+	if (bss->corrupt_data) {
+		char *corrupt_type = "data";
+		if (bss->corrupt_data & IEEE80211_BSS_CORRUPT_BEACON) {
+			if (bss->corrupt_data &
+					IEEE80211_BSS_CORRUPT_PROBE_RESP)
+				corrupt_type = "beacon and probe response";
+			else
+				corrupt_type = "beacon";
+		} else if (bss->corrupt_data & IEEE80211_BSS_CORRUPT_PROBE_RESP)
+			corrupt_type = "probe response";
+		printk(KERN_DEBUG "%s: associating with AP with corrupt %s\n",
+		       sdata->name, corrupt_type);
+	}
+
 	err = 0;
 	goto out;
  err_clear:
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 9270771..dd27c7a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -103,16 +103,35 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	cbss->free_priv = ieee80211_rx_bss_free;
 	bss = (void *)cbss->priv;
 
+	if (elems->parse_error) {
+		if (beacon)
+			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_BEACON;
+		else
+			bss->corrupt_data |= IEEE80211_BSS_CORRUPT_PROBE_RESP;
+	} else {
+		if (beacon)
+			bss->corrupt_data &= ~IEEE80211_BSS_CORRUPT_BEACON;
+		else
+			bss->corrupt_data &= ~IEEE80211_BSS_CORRUPT_PROBE_RESP;
+	}
+
 	/* save the ERP value so that it is available at association time */
-	if (elems->erp_info && elems->erp_info_len >= 1) {
+	if (elems->erp_info && elems->erp_info_len >= 1 &&
+			(!elems->parse_error ||
+			 !(bss->valid_data & IEEE80211_BSS_VALID_ERP))) {
 		bss->erp_value = elems->erp_info[0];
 		bss->has_erp_value = true;
+		if (!elems->parse_error)
+			bss->valid_data |= IEEE80211_BSS_VALID_ERP;
 	}
 
-	if (elems->tim) {
+	if (elems->tim && (!elems->parse_error ||
+			   !(bss->valid_data & IEEE80211_BSS_VALID_DTIM))) {
 		struct ieee80211_tim_ie *tim_ie =
 			(struct ieee80211_tim_ie *)elems->tim;
 		bss->dtim_period = tim_ie->dtim_period;
+		if (!elems->parse_error)
+				bss->valid_data |= IEEE80211_BSS_VALID_DTIM;
 	}
 
 	/* If the beacon had no TIM IE, or it was invalid, use 1 */
@@ -120,26 +139,38 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		bss->dtim_period = 1;
 
 	/* replace old supported rates if we get new values */
-	srlen = 0;
-	if (elems->supp_rates) {
-		clen = IEEE80211_MAX_SUPP_RATES;
-		if (clen > elems->supp_rates_len)
-			clen = elems->supp_rates_len;
-		memcpy(bss->supp_rates, elems->supp_rates, clen);
-		srlen += clen;
-	}
-	if (elems->ext_supp_rates) {
-		clen = IEEE80211_MAX_SUPP_RATES - srlen;
-		if (clen > elems->ext_supp_rates_len)
-			clen = elems->ext_supp_rates_len;
-		memcpy(bss->supp_rates + srlen, elems->ext_supp_rates, clen);
-		srlen += clen;
+	if (!elems->parse_error ||
+	    !(bss->valid_data & IEEE80211_BSS_VALID_RATES)) {
+		srlen = 0;
+		if (elems->supp_rates) {
+			clen = IEEE80211_MAX_SUPP_RATES;
+			if (clen > elems->supp_rates_len)
+				clen = elems->supp_rates_len;
+			memcpy(bss->supp_rates, elems->supp_rates, clen);
+			srlen += clen;
+		}
+		if (elems->ext_supp_rates) {
+			clen = IEEE80211_MAX_SUPP_RATES - srlen;
+			if (clen > elems->ext_supp_rates_len)
+				clen = elems->ext_supp_rates_len;
+			memcpy(bss->supp_rates + srlen, elems->ext_supp_rates,
+			       clen);
+			srlen += clen;
+		}
+		if (srlen) {
+			bss->supp_rates_len = srlen;
+			if (!elems->parse_error)
+				bss->valid_data |= IEEE80211_BSS_VALID_RATES;
+		}
 	}
-	if (srlen)
-		bss->supp_rates_len = srlen;
 
-	bss->wmm_used = elems->wmm_param || elems->wmm_info;
-	bss->uapsd_supported = is_uapsd_supported(elems);
+	if (!elems->parse_error ||
+	    !(bss->valid_data & IEEE80211_BSS_VALID_WMM)) {
+		bss->wmm_used = elems->wmm_param || elems->wmm_info;
+		bss->uapsd_supported = is_uapsd_supported(elems);
+		if (!elems->parse_error)
+			bss->valid_data |= IEEE80211_BSS_VALID_WMM;
+	}
 
 	if (!beacon)
 		bss->last_probe_resp = jiffies;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 264397a..dd7041d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -572,24 +572,40 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 	size_t left = len;
 	u8 *pos = start;
 	bool calc_crc = filter != 0;
+	DECLARE_BITMAP(seen_elems, 256);
 
+	bitmap_zero(seen_elems, 256);
 	memset(elems, 0, sizeof(*elems));
 	elems->ie_start = start;
 	elems->total_len = len;
 
 	while (left >= 2) {
 		u8 id, elen;
+		bool elem_parse_failed;
 
 		id = *pos++;
 		elen = *pos++;
 		left -= 2;
 
-		if (elen > left)
+		if (elen > left) {
+			elems->parse_error = true;
 			break;
+		}
+
+		if (id != WLAN_EID_VENDOR_SPECIFIC &&
+		    test_bit(id, seen_elems)) {
+			elems->parse_error = true;
+			left -= elen;
+			pos += elen;
+			continue;
+		}
+
 
 		if (calc_crc && id < 64 && (filter & (1ULL << id)))
 			crc = crc32_be(crc, pos - 2, elen + 2);
 
+		elem_parse_failed = false;
+
 		switch (id) {
 		case WLAN_EID_SSID:
 			elems->ssid = pos;
@@ -615,7 +631,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			if (elen >= sizeof(struct ieee80211_tim_ie)) {
 				elems->tim = (void *)pos;
 				elems->tim_len = elen;
-			}
+			} else
+				elem_parse_failed = true;
 			break;
 		case WLAN_EID_IBSS_PARAMS:
 			elems->ibss_params = pos;
@@ -664,10 +681,14 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		case WLAN_EID_HT_CAPABILITY:
 			if (elen >= sizeof(struct ieee80211_ht_cap))
 				elems->ht_cap_elem = (void *)pos;
+			else
+				elem_parse_failed = true;
 			break;
 		case WLAN_EID_HT_INFORMATION:
 			if (elen >= sizeof(struct ieee80211_ht_info))
 				elems->ht_info_elem = (void *)pos;
+			else
+				elem_parse_failed = true;
 			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
@@ -676,6 +697,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		case WLAN_EID_MESH_CONFIG:
 			if (elen >= sizeof(struct ieee80211_meshconf_ie))
 				elems->mesh_config = (void *)pos;
+			else
+				elem_parse_failed = true;
 			break;
 		case WLAN_EID_PEER_MGMT:
 			elems->peering = pos;
@@ -696,6 +719,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		case WLAN_EID_RANN:
 			if (elen >= sizeof(struct ieee80211_rann_ie))
 				elems->rann = (void *)pos;
+			else
+				elem_parse_failed = true;
 			break;
 		case WLAN_EID_CHANNEL_SWITCH:
 			elems->ch_switch_elem = pos;
@@ -705,7 +730,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			if (!elems->quiet_elem) {
 				elems->quiet_elem = pos;
 				elems->quiet_elem_len = elen;
-			}
+			} else
+				elem_parse_failed = true;
 			elems->num_of_quiet_elem++;
 			break;
 		case WLAN_EID_COUNTRY:
@@ -724,10 +750,18 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			break;
 		}
 
+		if (elem_parse_failed)
+			elems->parse_error = true;
+		else
+			set_bit(id, seen_elems);
+
 		left -= elen;
 		pos += elen;
 	}
 
+	if (left != 0)
+		elems->parse_error = true;
+
 	return crc;
 }
 
-- 
1.7.7.3

