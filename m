Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40736 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932742AbcH2NkJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 09:40:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Mon, 29 Aug 2016 16:39:56 +0300
Message-Id: <1472477998-25972-3-git-send-email-luca@coelho.fi> (sfid-20160829_154014_332267_2BEC3CD4)
Subject: [PATCH 3/5] mac80211: add support for radiotap timestamp field
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the existing device timestamp from the RX status information
to add support for the new radiotap timestamp field. Currently
only 32-bit counters are supported, but we also add the radiotap
mactime where applicable. This new field allows more flexibility
in where the timestamp is taken etc. The non-timestamp data in
the field is taken from a new field in the hw struct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/ieee80211_radiotap.h | 21 +++++++++++++++++++++
 include/net/mac80211.h           | 12 ++++++++++++
 net/mac80211/main.c              |  3 +++
 net/mac80211/rx.c                | 30 ++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index b0fd947..ba07b9d 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -190,6 +190,10 @@ struct ieee80211_radiotap_header {
  * IEEE80211_RADIOTAP_VHT	u16, u8, u8, u8[4], u8, u8, u16
  *
  *	Contains VHT information about this frame.
+ *
+ * IEEE80211_RADIOTAP_TIMESTAMP		u64, u16, u8, u8	variable
+ *
+ *	Contains timestamp information for this frame.
  */
 enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TSFT = 0,
@@ -214,6 +218,7 @@ enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_MCS = 19,
 	IEEE80211_RADIOTAP_AMPDU_STATUS = 20,
 	IEEE80211_RADIOTAP_VHT = 21,
+	IEEE80211_RADIOTAP_TIMESTAMP = 22,
 
 	/* valid in every it_present bitmap, even vendor namespaces */
 	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
@@ -321,6 +326,22 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_CODING_LDPC_USER2			0x04
 #define IEEE80211_RADIOTAP_CODING_LDPC_USER3			0x08
 
+/* For IEEE80211_RADIOTAP_TIMESTAMP */
+#define IEEE80211_RADIOTAP_TIMESTAMP_UNIT_MASK			0x000F
+#define IEEE80211_RADIOTAP_TIMESTAMP_UNIT_MS			0x0000
+#define IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US			0x0001
+#define IEEE80211_RADIOTAP_TIMESTAMP_UNIT_NS			0x0003
+#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_MASK			0x00F0
+#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_BEGIN_MDPU		0x0000
+#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_EO_MPDU		0x0010
+#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_EO_PPDU		0x0020
+#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_PLCP_SIG_ACQ		0x0030
+#define IEEE80211_RADIOTAP_TIMESTAMP_SPOS_UNKNOWN		0x00F0
+
+#define IEEE80211_RADIOTAP_TIMESTAMP_FLAG_64BIT			0x00
+#define IEEE80211_RADIOTAP_TIMESTAMP_FLAG_32BIT			0x01
+#define IEEE80211_RADIOTAP_TIMESTAMP_FLAG_ACCURACY		0x02
+
 /* helpers */
 static inline int ieee80211_get_radiotap_len(unsigned char *data)
 {
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cca510a..81870dc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2141,6 +2141,14 @@ enum ieee80211_hw_flags {
  *	the default is _GI | _BANDWIDTH.
  *	Use the %IEEE80211_RADIOTAP_VHT_KNOWN_* values.
  *
+ * @radiotap_timestamp: Information for the radiotap timestamp field; if the
+ *	'units_pos' member is set to a non-negative value it must be set to
+ *	a combination of a IEEE80211_RADIOTAP_TIMESTAMP_UNIT_* and a
+ *	IEEE80211_RADIOTAP_TIMESTAMP_SPOS_* value, and then the timestamp
+ *	field will be added and populated from the &struct ieee80211_rx_status
+ *	device_timestamp. If the 'accuracy' member is non-negative, it's put
+ *	into the accuracy radiotap field and the accuracy known flag is set.
+ *
  * @netdev_features: netdev features to be set in each netdev created
  *	from this HW. Note that not all features are usable with mac80211,
  *	other features will be rejected during HW registration.
@@ -2184,6 +2192,10 @@ struct ieee80211_hw {
 	u8 offchannel_tx_hw_queue;
 	u8 radiotap_mcs_details;
 	u16 radiotap_vht_details;
+	struct {
+		int units_pos;
+		s16 accuracy;
+	} radiotap_timestamp;
 	netdev_features_t netdev_features;
 	u8 uapsd_queues;
 	u8 uapsd_max_sp_len;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d00ea9b..ac053a9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -660,6 +660,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 
 	ieee80211_roc_setup(local);
 
+	local->hw.radiotap_timestamp.units_pos = -1;
+	local->hw.radiotap_timestamp.accuracy = -1;
+
 	return &local->hw;
  err_free:
 	wiphy_free(wiphy);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d922a01..c8ec434 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -180,6 +180,11 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 		len += 12;
 	}
 
+	if (local->hw.radiotap_timestamp.units_pos >= 0) {
+		len = ALIGN(len, 8);
+		len += 12;
+	}
+
 	if (status->chains) {
 		/* antenna and antenna signal fields */
 		len += 2 * hweight8(status->chains);
@@ -447,6 +452,31 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		pos += 2;
 	}
 
+	if (local->hw.radiotap_timestamp.units_pos >= 0) {
+		u16 accuracy = 0;
+		u8 flags = IEEE80211_RADIOTAP_TIMESTAMP_FLAG_32BIT;
+
+		rthdr->it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_TIMESTAMP);
+
+		/* ensure 8 byte alignment */
+		while ((pos - (u8 *)rthdr) & 7)
+			pos++;
+
+		put_unaligned_le64(status->device_timestamp, pos);
+		pos += sizeof(u64);
+
+		if (local->hw.radiotap_timestamp.accuracy >= 0) {
+			accuracy = local->hw.radiotap_timestamp.accuracy;
+			flags |= IEEE80211_RADIOTAP_TIMESTAMP_FLAG_ACCURACY;
+		}
+		put_unaligned_le16(accuracy, pos);
+		pos += sizeof(u16);
+
+		*pos++ = local->hw.radiotap_timestamp.units_pos;
+		*pos++ = flags;
+	}
+
 	for_each_set_bit(chain, &chains, IEEE80211_MAX_CHAINS) {
 		*pos++ = status->chain_signal[chain];
 		*pos++ = chain;
-- 
2.8.1
