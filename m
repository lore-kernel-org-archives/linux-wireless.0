Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45048 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825Ab0H1QiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 12:38:01 -0400
Date: Sat, 28 Aug 2010 19:37:51 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Add DS Parameter Set into Probe Request on 2.4
 GHz
Message-ID: <20100828163751.GB23426@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE Std 802.11k-2008 added DS Parameter Set information element into
Probe Request frames as an optional information on 2.4 GHz band (and
mandatory, if radio measurements are enabled). This allows APs to
filter out Probe Request frames that may be received from neighboring
overlapping channels and by doing so, reduce the number of unnecessary
frames in the air. Make mac80211 add this IE into Probe Request frames
whenever the channel is known (i.e., whenever hwscan is not used).

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/scan.c        |    3 ++-
 net/mac80211/util.c        |   16 ++++++++++++++--
 3 files changed, 18 insertions(+), 4 deletions(-)

(note: this is on top of the previous Probe Request SuppRates masking
patch)

--- uml.orig/net/mac80211/ieee80211_i.h	2010-08-28 19:30:30.000000000 +0300
+++ uml/net/mac80211/ieee80211_i.h	2010-08-28 19:34:22.000000000 +0300
@@ -1229,7 +1229,8 @@ void ieee80211_send_auth(struct ieee8021
 			 const u8 *key, u8 key_len, u8 key_idx);
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
-			     enum ieee80211_band band, u32 rate_mask);
+			     enum ieee80211_band band, u32 rate_mask,
+			     u8 channel);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len);
--- uml.orig/net/mac80211/scan.c	2010-08-28 19:30:30.000000000 +0300
+++ uml/net/mac80211/scan.c	2010-08-28 19:34:22.000000000 +0300
@@ -243,7 +243,8 @@ static bool ieee80211_prep_hw_scan(struc
 	local->hw_scan_req->n_channels = n_chans;
 
 	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
-					 req->ie, req->ie_len, band, (u32) -1);
+					 req->ie, req->ie_len, band, (u32) -1,
+					 0);
 	local->hw_scan_req->ie_len = ielen;
 
 	return true;
--- uml.orig/net/mac80211/util.c	2010-08-28 19:30:30.000000000 +0300
+++ uml/net/mac80211/util.c	2010-08-28 19:34:22.000000000 +0300
@@ -904,7 +904,8 @@ void ieee80211_send_auth(struct ieee8021
 
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
-			     enum ieee80211_band band, u32 rate_mask)
+			     enum ieee80211_band band, u32 rate_mask,
+			     u8 channel)
 {
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
@@ -956,6 +957,12 @@ int ieee80211_build_preq_ies(struct ieee
 		pos += ext_rates_len;
 	}
 
+	if (channel && sband->band == IEEE80211_BAND_2GHZ) {
+		*pos++ = WLAN_EID_DS_PARAMS;
+		*pos++ = 1;
+		*pos++ = channel;
+	}
+
 	/* insert custom IEs that go before HT */
 	if (ie && ie_len) {
 		static const u8 before_ht[] = {
@@ -1022,6 +1029,7 @@ void ieee80211_send_probe_req(struct iee
 	struct ieee80211_mgmt *mgmt;
 	size_t buf_len;
 	u8 *buf;
+	u8 chan;
 
 	/* FIXME: come up with a proper value */
 	buf = kmalloc(200 + ie_len, GFP_KERNEL);
@@ -1031,10 +1039,14 @@ void ieee80211_send_probe_req(struct iee
 		return;
 	}
 
+	chan = ieee80211_frequency_to_channel(
+		local->hw.conf.channel->center_freq);
+
 	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len,
 					   local->hw.conf.channel->band,
 					   sdata->rc_rateidx_mask
-					   [local->hw.conf.channel->band]);
+					   [local->hw.conf.channel->band],
+					   chan);
 
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
 				     ssid, ssid_len,

-- 
Jouni Malinen                                            PGP id EFC895FA
