Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:22835
	"EHLO HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab2F2GRQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 02:17:16 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: VHT Cap IE
Date: Fri, 29 Jun 2012 06:17:15 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0D6345@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120629_081720_450830_3FECD806)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VHT cap IE insertion in probeReq as part of 11ac changes.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/main.c        |    8 +++++++-
 net/mac80211/util.c        |   25 +++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f834a00..478ed48 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1481,6 +1481,8 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       struct ieee80211_channel *channel,
 			       enum nl80211_channel_type channel_type,
 			       u16 prot_mode);
+u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+							   u32 cap);
 
 /* channel management */
 enum ieee80211_chan_mode {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0b040fb..06e6cc9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -688,7 +688,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int result, i;
 	enum ieee80211_band band;
 	int channels, max_bitrates;
-	bool supp_ht;
+	bool supp_ht, supp_vht;
 	netdev_features_t feature_whitelist;
 	static const u32 cipher_suites[] = {
 		/* keep WEP first, it may be removed below */
@@ -733,6 +733,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	channels = 0;
 	max_bitrates = 0;
 	supp_ht = false;
+	supp_vht = false;
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		struct ieee80211_supported_band *sband;
 
@@ -750,6 +751,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		if (max_bitrates < sband->n_bitrates)
 			max_bitrates = sband->n_bitrates;
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
+		supp_vht = supp_vht || sband->vht_cap.vht_supported;
 	}
 
 	local->int_scan_req = kzalloc(sizeof(*local->int_scan_req) +
@@ -825,6 +827,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (supp_ht)
 		local->scan_ies_len += 2 + sizeof(struct ieee80211_ht_cap);
 
+	if (supp_vht)
+		local->scan_ies_len += 2 + 
+			sizeof(struct ieee80211_vht_capabilities);
+
 	if (!local->ops->hw_scan) {
 		/* For hw_scan, driver needs to set these up. */
 		local->hw.wiphy->max_scan_ssids = 4;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 242ecde..94728de 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1072,6 +1072,10 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		pos += noffset - offset;
 	}
 
+	if (sband->vht_cap.vht_supported)
+		pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
+										 sband->vht_cap.cap);
+
 	return pos - buffer;
 }
 
@@ -1699,6 +1703,27 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 	return pos;
 }
 
+u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
+							   u32 cap)
+{
+	__le32 tmp;
+
+	*pos++ = WLAN_EID_VHT_CAPABILITY;
+	*pos++ = sizeof(struct ieee80211_vht_capabilities);
+	memset(pos, 0, sizeof(struct ieee80211_vht_capabilities));
+
+	/* capability flags */
+	tmp = cpu_to_le32(cap);
+	memcpy(pos, &tmp, sizeof(u32));
+	pos += sizeof(u32);
+
+	/* VHT MCS set */
+	memcpy(pos, &vht_cap->vht_mcs, sizeof(vht_cap->vht_mcs));
+	pos += sizeof(vht_cap->vht_mcs);
+
+	return pos;
+}
+
 u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			       struct ieee80211_channel *channel,
 			       enum nl80211_channel_type channel_type,
