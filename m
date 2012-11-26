Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab2KZOYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 09:24:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] mac80211: support (partial) VHT radiotap information
Date: Mon, 26 Nov 2012 15:25:15 +0100
Message-Id: <1353939915-25121-4-git-send-email-johannes@sipsolutions.net> (sfid-20121126_152457_536207_9F0C1DAD)
In-Reply-To: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net>
References: <1353939915-25121-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add some information that we have about VHT to radiotap.
This at least lets one see the MCS and NSS information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/ieee80211_radiotap.h | 24 ++++++++++++++++++++++++
 include/net/mac80211.h           |  5 +++++
 net/mac80211/main.c              |  2 ++
 net/mac80211/rx.c                | 40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 7f0df13..c399963 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -186,6 +186,10 @@ struct ieee80211_radiotap_header {
  * IEEE80211_RADIOTAP_AMPDU_STATUS	u32, u16, u8, u8	unitless
  *
  *	Contains the AMPDU information for the subframe.
+ *
+ * IEEE80211_RADIOTAP_VHT	u16, u8, u8, u8[4], u8, u8, u16
+ *
+ *	Contains VHT information about this frame.
  */
 enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TSFT = 0,
@@ -209,6 +213,7 @@ enum ieee80211_radiotap_type {
 
 	IEEE80211_RADIOTAP_MCS = 19,
 	IEEE80211_RADIOTAP_AMPDU_STATUS = 20,
+	IEEE80211_RADIOTAP_VHT = 21,
 
 	/* valid in every it_present bitmap, even vendor namespaces */
 	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
@@ -282,6 +287,25 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_ERR		0x0010
 #define IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_KNOWN	0x0020
 
+/* For IEEE80211_RADIOTAP_VHT */
+#define IEEE80211_RADIOTAP_VHT_KNOWN_STBC			0x0001
+#define IEEE80211_RADIOTAP_VHT_KNOWN_TXOP_PS_NA			0x0002
+#define IEEE80211_RADIOTAP_VHT_KNOWN_GI				0x0004
+#define IEEE80211_RADIOTAP_VHT_KNOWN_SGI_NSYM_DIS		0x0008
+#define IEEE80211_RADIOTAP_VHT_KNOWN_LDPC_EXTRA_OFDM_SYM	0x0010
+#define IEEE80211_RADIOTAP_VHT_KNOWN_BEAMFORMED			0x0020
+#define IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH			0x0040
+#define IEEE80211_RADIOTAP_VHT_KNOWN_GROUP_ID			0x0080
+#define IEEE80211_RADIOTAP_VHT_KNOWN_PARTIAL_AID		0x0100
+
+#define IEEE80211_RADIOTAP_VHT_FLAG_STBC			0x01
+#define IEEE80211_RADIOTAP_VHT_FLAG_TXOP_PS_NA			0x02
+#define IEEE80211_RADIOTAP_VHT_FLAG_SGI				0x04
+#define IEEE80211_RADIOTAP_VHT_FLAG_SGI_NSYM_M10_9		0x08
+#define IEEE80211_RADIOTAP_VHT_FLAG_LDPC_EXTRA_OFDM_SYM		0x10
+#define IEEE80211_RADIOTAP_VHT_FLAG_BEAMFORMED			0x20
+
+
 /* helpers */
 static inline int ieee80211_get_radiotap_len(unsigned char *data)
 {
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index db7680a..e806f1d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1473,6 +1473,10 @@ enum ieee80211_hw_flags {
  *	include _FMT. Use %IEEE80211_RADIOTAP_MCS_HAVE_* values, only
  *	adding _BW is supported today.
  *
+ * @radiotap_vht_details: lists which VHT MCS information the HW reports,
+ *	the default is _GI | _BANDWIDTH.
+ *	Use the %IEEE80211_RADIOTAP_VHT_KNOWN_* values.
+ *
  * @netdev_features: netdev features to be set in each netdev created
  *	from this HW. Note only HW checksum features are currently
  *	compatible with mac80211. Other feature bits will be rejected.
@@ -1499,6 +1503,7 @@ struct ieee80211_hw {
 	u8 max_tx_aggregation_subframes;
 	u8 offchannel_tx_hw_queue;
 	u8 radiotap_mcs_details;
+	u16 radiotap_vht_details;
 	netdev_features_t netdev_features;
 };
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6e93340..c4ed83b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -638,6 +638,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.radiotap_mcs_details = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 					 IEEE80211_RADIOTAP_MCS_HAVE_GI |
 					 IEEE80211_RADIOTAP_MCS_HAVE_BW;
+	local->hw.radiotap_vht_details = IEEE80211_RADIOTAP_VHT_KNOWN_GI |
+					 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
 	local->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
 	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 825f33c..9b13b8b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -111,6 +111,11 @@ ieee80211_rx_radiotap_space(struct ieee80211_local *local,
 		len += 8;
 	}
 
+	if (status->flag & RX_FLAG_VHT) {
+		len = ALIGN(len, 2);
+		len += 12;
+	}
+
 	if (status->vendor_radiotap_len) {
 		if (WARN_ON_ONCE(status->vendor_radiotap_align == 0))
 			status->vendor_radiotap_align = 1;
@@ -297,6 +302,41 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos++ = 0;
 	}
 
+	if (status->flag & RX_FLAG_VHT) {
+		u16 known = local->hw.radiotap_vht_details;
+
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
+		/* known field - how to handle 80+80? */
+		if (status->flag & RX_FLAG_80P80MHZ)
+			known &= ~IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
+		put_unaligned_le16(known, pos);
+		pos += 2;
+		/* flags */
+		if (status->flag & RX_FLAG_SHORT_GI)
+			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_SGI;
+		pos++;
+		/* bandwidth */
+		if (status->flag & RX_FLAG_80MHZ)
+			*pos++ = 4;
+		else if (status->flag & RX_FLAG_80P80MHZ)
+			*pos++ = 0; /* marked not known above */
+		else if (status->flag & RX_FLAG_160MHZ)
+			*pos++ = 11;
+		else if (status->flag & RX_FLAG_40MHZ)
+			*pos++ = 1;
+		else /* 20 MHz */
+			*pos++ = 0;
+		/* MCS/NSS */
+		*pos = (status->rate_idx << 4) | status->vht_nss;
+		pos += 4;
+		/* coding field */
+		pos++;
+		/* group ID */
+		pos++;
+		/* partial_aid */
+		pos += 2;
+	}
+
 	if (status->vendor_radiotap_len) {
 		/* ensure 2 byte alignment for the vendor field as required */
 		if ((pos - (u8 *)rthdr) & 1)
-- 
1.8.0

