Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57991 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089Ab0H1QgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 12:36:25 -0400
Date: Sat, 28 Aug 2010 19:36:10 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Filter ProbeReq SuppRates based on TX rate mask
Message-ID: <20100828163610.GA23426@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the TX rate set has been masked, the removed rates can also be
removed from the Supported Rates and Extended Supported Rates IEs in
Probe Request frames.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/scan.c        |    2 +-
 net/mac80211/util.c        |   37 ++++++++++++++++++++++---------------
 3 files changed, 24 insertions(+), 17 deletions(-)

--- uml.orig/net/mac80211/ieee80211_i.h	2010-08-28 19:28:43.000000000 +0300
+++ uml/net/mac80211/ieee80211_i.h	2010-08-28 19:30:30.000000000 +0300
@@ -1229,7 +1229,7 @@ void ieee80211_send_auth(struct ieee8021
 			 const u8 *key, u8 key_len, u8 key_idx);
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
-			     enum ieee80211_band band);
+			     enum ieee80211_band band, u32 rate_mask);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len);
--- uml.orig/net/mac80211/scan.c	2010-08-28 19:28:43.000000000 +0300
+++ uml/net/mac80211/scan.c	2010-08-28 19:30:30.000000000 +0300
@@ -243,7 +243,7 @@ static bool ieee80211_prep_hw_scan(struc
 	local->hw_scan_req->n_channels = n_chans;
 
 	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
-					 req->ie, req->ie_len, band);
+					 req->ie, req->ie_len, band, (u32) -1);
 	local->hw_scan_req->ie_len = ielen;
 
 	return true;
--- uml.orig/net/mac80211/util.c	2010-08-28 19:28:43.000000000 +0300
+++ uml/net/mac80211/util.c	2010-08-28 19:30:30.000000000 +0300
@@ -904,26 +904,33 @@ void ieee80211_send_auth(struct ieee8021
 
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
-			     enum ieee80211_band band)
+			     enum ieee80211_band band, u32 rate_mask)
 {
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 	size_t offset = 0, noffset;
 	int supp_rates_len, i;
+	u8 rates[32];
+	int num_rates;
+	int ext_rates_len;
 
 	sband = local->hw.wiphy->bands[band];
 
 	pos = buffer;
 
-	supp_rates_len = min_t(int, sband->n_bitrates, 8);
+	num_rates = 0;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((BIT(i) & rate_mask) == 0)
+			continue; /* skip rate */
+		rates[num_rates++] = (u8) (sband->bitrates[i].bitrate / 5);
+	}
+
+	supp_rates_len = min_t(int, num_rates, 8);
 
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = supp_rates_len;
-
-	for (i = 0; i < supp_rates_len; i++) {
-		int rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
-	}
+	memcpy(pos, rates, supp_rates_len);
+	pos += supp_rates_len;
 
 	/* insert "request information" if in custom IEs */
 	if (ie && ie_len) {
@@ -941,14 +948,12 @@ int ieee80211_build_preq_ies(struct ieee
 		offset = noffset;
 	}
 
-	if (sband->n_bitrates > i) {
+	ext_rates_len = num_rates - supp_rates_len;
+	if (ext_rates_len > 0) {
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = sband->n_bitrates - i;
-
-		for (; i < sband->n_bitrates; i++) {
-			int rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
-		}
+		*pos++ = ext_rates_len;
+		memcpy(pos, rates + supp_rates_len, ext_rates_len);
+		pos += ext_rates_len;
 	}
 
 	/* insert custom IEs that go before HT */
@@ -1027,7 +1032,9 @@ void ieee80211_send_probe_req(struct iee
 	}
 
 	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len,
-					   local->hw.conf.channel->band);
+					   local->hw.conf.channel->band,
+					   sdata->rc_rateidx_mask
+					   [local->hw.conf.channel->band]);
 
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
 				     ssid, ssid_len,

-- 
Jouni Malinen                                            PGP id EFC895FA
