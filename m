Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965023AbbLHOG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/9] mac80211: limit the A-MSDU Tx based on peer's capabilities
Date: Tue,  8 Dec 2015 16:04:32 +0200
Message-Id: <1449583479-26658-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150636_838036_A68DED7C)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In VHT, the specification allows to limit the number of
MSDUs in an A-MSDU in the Extended Capabilities IE. There
is also a limitation on the byte size in the VHT IE.
In HT, the only limitation is on the byte size.
Parse the capabilities from the peer and make them
available to the driver.

In HT, there is another limitation when a BA agreement
is active: the byte size can't be greater than 4095.
This is not enforced here.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h | 19 +++++++++++++++++++
 include/net/mac80211.h    | 14 ++++++++++++++
 net/mac80211/cfg.c        | 29 +++++++++++++++++++++++++++++
 net/mac80211/ht.c         |  5 +++++
 net/mac80211/vht.c        | 18 ++++++++++++++++++
 5 files changed, 85 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d9ddb89..3b1f6ce 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -163,6 +163,14 @@ static inline u16 ieee80211_sn_sub(u16 sn1, u16 sn2)
 /* 30 byte 4 addr hdr, 2 byte QoS, 2304 byte MSDU, 12 byte crypt, 4 byte FCS */
 #define IEEE80211_MAX_FRAME_LEN		2352
 
+/* Maximal size of an A-MSDU */
+#define IEEE80211_MAX_MPDU_LEN_HT_3839		3839
+#define IEEE80211_MAX_MPDU_LEN_HT_7935		7935
+
+#define IEEE80211_MAX_MPDU_LEN_VHT_3895		3895
+#define IEEE80211_MAX_MPDU_LEN_VHT_7991		7991
+#define IEEE80211_MAX_MPDU_LEN_VHT_11454	11454
+
 #define IEEE80211_MAX_SSID_LEN		32
 
 #define IEEE80211_MAX_MESH_ID_LEN	32
@@ -1505,6 +1513,7 @@ struct ieee80211_vht_operation {
 #define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895			0x00000000
 #define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991			0x00000001
 #define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454			0x00000002
+#define IEEE80211_VHT_CAP_MAX_MPDU_MASK				0x00000003
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ		0x00000004
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ	0x00000008
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK			0x0000000C
@@ -2086,6 +2095,16 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED	BIT(5)
 #define WLAN_EXT_CAPA8_OPMODE_NOTIF	BIT(6)
 
+/* Defines the maximal number of MSDUs in an A-MSDU. */
+#define WLAN_EXT_CAPA8_MAX_MSDU_IN_AMSDU_LSB	BIT(7)
+#define WLAN_EXT_CAPA9_MAX_MSDU_IN_AMSDU_MSB	BIT(0)
+
+/*
+ * Fine Timing Measurement Initiator - bit 71 of @WLAN_EID_EXT_CAPABILITY
+ * information element
+ */
+#define WLAN_EXT_CAPA9_FTM_INITIATOR	BIT(7)
+
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8da483b..71be30d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1701,6 +1701,18 @@ struct ieee80211_sta_rates {
  * @tdls_initiator: indicates the STA is an initiator of the TDLS link. Only
  *	valid if the STA is a TDLS peer in the first place.
  * @mfp: indicates whether the STA uses management frame protection or not.
+ * @max_amsdu_subframes: indicates the maximal number of MSDUs in a single
+ *	A-MSDU. Taken from the Extended Capabilities element. 0 means
+ *	unlimited.
+ * @max_amsdu_len: indicates the maximal length of an A-MSDU in bytes. This
+ *	field is always valid for packets with a VHT preamble. For packets
+ *	with a HT preamble, additional limits apply:
+ *		+ If the skb is transmitted as part of a BA agreement, the
+ *		  A-MSDU maximal size is min(max_amsdu_len, 4065) bytes.
+ *		+ If the skb is not part of a BA aggreement, the A-MSDU maximal
+ *		  size is min(max_amsdu_len, 7935) bytes.
+ *	Both additional HT limits must be enforced by the low level driver.
+ *	This is defined by the spec (IEEE 802.11-2012 section 8.3.2.2 NOTE 2).
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
  */
 struct ieee80211_sta {
@@ -1719,6 +1731,8 @@ struct ieee80211_sta {
 	bool tdls;
 	bool tdls_initiator;
 	bool mfp;
+	u8 max_amsdu_subframes;
+	u16 max_amsdu_len;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2d1c4c3..b9e2c2f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1131,6 +1131,34 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		sta->sta.max_sp = params->max_sp;
 	}
 
+	/* The sender might not have sent the last bit, consider it to be 0 */
+	if (params->ext_capab_len >= 8) {
+		u8 val = (params->ext_capab[7] &
+			  WLAN_EXT_CAPA8_MAX_MSDU_IN_AMSDU_LSB) >> 7;
+
+		/* we did get all the bits, take the MSB as well */
+		if (params->ext_capab_len >= 9) {
+			u8 val_msb = params->ext_capab[8] &
+				WLAN_EXT_CAPA9_MAX_MSDU_IN_AMSDU_MSB;
+			val_msb <<= 1;
+			val |= val_msb;
+		}
+
+		switch (val) {
+		case 1:
+			sta->sta.max_amsdu_subframes = 32;
+			break;
+		case 2:
+			sta->sta.max_amsdu_subframes = 16;
+			break;
+		case 3:
+			sta->sta.max_amsdu_subframes = 8;
+			break;
+		default:
+			sta->sta.max_amsdu_subframes = 0;
+		};
+	}
+
 	/*
 	 * cfg80211 validates this (1-2007) and allows setting the AID
 	 * only when creating a new station entry
@@ -1160,6 +1188,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  params->ht_capa, sta);
 
+	/* VHT can override some HT caps such as the A-MSDU max length */
 	if (params->vht_capa)
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    params->vht_capa, sta);
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 7a76ce6..f4a5287 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -230,6 +230,11 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	/* set Rx highest rate */
 	ht_cap.mcs.rx_highest = ht_cap_ie->mcs.rx_highest;
 
+	if (ht_cap.cap & IEEE80211_HT_CAP_MAX_AMSDU)
+		sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_HT_7935;
+	else
+		sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_HT_3839;
+
  apply:
 	changed = memcmp(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
 
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 92c9843..d2f2ff6 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -281,6 +281,24 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	}
 
 	sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
+
+	/* If HT IE reported 3839 bytes only, stay with that size. */
+	if (sta->sta.max_amsdu_len == IEEE80211_MAX_MPDU_LEN_HT_3839)
+		return;
+
+	switch (vht_cap->cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK) {
+	case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454:
+		sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_VHT_11454;
+		break;
+	case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991:
+		sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_VHT_7991;
+		break;
+	case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895:
+	default:
+		sta->sta.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_VHT_3895;
+		break;
+	}
+
 }
 
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cap_rx_bw(struct sta_info *sta)
-- 
2.5.0

