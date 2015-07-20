Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbbGTTnR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2015 15:43:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: sara.sharon@intel.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 03/10] mac80211: limit the A-MSDU based on the Extended Capabilities element
Date: Mon, 20 Jul 2015 22:42:57 +0300
Message-Id: <1437421384-19884-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150720_214324_361914_D237479E)
In-Reply-To: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In VHT, the specification allows to limit the number of
MSDUs in an A-MSDU. Parse the capabilities from the peer
and make them available to the driver.
While at it, add a mask for the A-MSDU length in bytes.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h |  8 ++++++++
 include/net/mac80211.h    |  5 +++++
 net/mac80211/cfg.c        | 23 +++++++++++++++++++++++
 net/mac80211/vht.c        | 16 ++++++++++++++++
 4 files changed, 52 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2226496..23f22ae 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1498,6 +1498,7 @@ struct ieee80211_vht_operation {
 #define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895			0x00000000
 #define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991			0x00000001
 #define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454			0x00000002
+#define IEEE80211_VHT_CAP_MAX_MPDU_MASK				0x00000003
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ		0x00000004
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ	0x00000008
 #define IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK			0x0000000C
@@ -2078,6 +2079,13 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_EXT_CAPA8_OPMODE_NOTIF	BIT(6)
 #define WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED	BIT(7)
 
+/*
+ * Defines the number of maximanl number of MSDUs in
+ * an A-MSDUs.
+ */
+#define WLAN_EXT_CAPA8_MAX_AMSDU_IN_AMSDU_LSB	BIT(7)
+#define WLAN_EXT_CAPA9_MAX_AMSDU_IN_AMSDU_MSB	BIT(0)
+
 /* TDLS specific payload type in the LLC/SNAP header */
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 280419a..c65c1e7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1671,11 +1671,14 @@ struct ieee80211_sta_rates {
  *	notifications and capabilities. The value is only valid after
  *	the station moves to associated state.
  * @smps_mode: current SMPS mode (off, static or dynamic)
+ * @max_amsdu_sz: indicates the maximal length of an A-MSDU in bytes
  * @rates: rate control selection table
  * @tdls: indicates whether the STA is a TDLS peer
  * @tdls_initiator: indicates the STA is an initiator of the TDLS link. Only
  *	valid if the STA is a TDLS peer in the first place.
  * @mfp: indicates whether the STA uses management frame protection or not.
+ * @max_msdus: indicates the maximal number of MSDUs in a single A-MSDUs.
+ *	Taken from the Extended Capabilities element.
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
  */
 struct ieee80211_sta {
@@ -1690,10 +1693,12 @@ struct ieee80211_sta {
 	u8 rx_nss;
 	enum ieee80211_sta_rx_bandwidth bandwidth;
 	enum ieee80211_smps_mode smps_mode;
+	unsigned int max_amsdu_sz;
 	struct ieee80211_sta_rates __rcu *rates;
 	bool tdls;
 	bool tdls_initiator;
 	bool mfp;
+	u8 max_msdus;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bf7023f..03183e2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1102,6 +1102,29 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		sta->sta.max_sp = params->max_sp;
 	}
 
+	if (params->ext_capab_len >= 8) {
+		u8 val;
+
+		val = params->ext_capab[8] &
+			WLAN_EXT_CAPA9_MAX_AMSDU_IN_AMSDU_MSB;
+		val <<= 1;
+		val |= params->ext_capab[7] &
+			WLAN_EXT_CAPA8_MAX_AMSDU_IN_AMSDU_LSB;
+		switch (val) {
+		case 1:
+			sta->sta.max_msdus = 32;
+			break;
+		case 2:
+			sta->sta.max_msdus = 16;
+			break;
+		case 3:
+			sta->sta.max_msdus = 8;
+			break;
+		default:
+			sta->sta.max_msdus = 0;
+		};
+	}
+
 	/*
 	 * cfg80211 validates this (1-2007) and allows setting the AID
 	 * only when creating a new station entry
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 80694d5..b7a5a6a 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -263,6 +263,22 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	}
 
 	sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
+
+	switch (vht_cap->cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK) {
+	case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454:
+		sta->sta.max_amsdu_sz = 11454;
+		break;
+	case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991:
+		sta->sta.max_amsdu_sz = 7991;
+		break;
+	case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895:
+		sta->sta.max_amsdu_sz = 3895;
+		break;
+	default:
+		sta->sta.max_amsdu_sz = 3895;
+		WARN_ON(1);
+	}
+
 }
 
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cap_rx_bw(struct sta_info *sta)
-- 
2.1.4

