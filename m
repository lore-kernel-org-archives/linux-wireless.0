Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46436 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726212AbeIDQFr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:05:47 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  4 Sep 2018 14:40:47 +0300
Message-Id: <20180904114055.1429-2-luca@coelho.fi> (sfid-20180904_134132_137858_685A28BF)
In-Reply-To: <20180904114055.1429-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180904114055.1429-1-luca@coelho.fi>
Subject: [PATCH v2 1/9] mac80211: support reporting 0-length PSDU in radiotap
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

For certain sounding frames, it may be useful to report them
to userspace even though they don't have a PSDU in order to
determine the PHY parameters (e.g. VHT rate/stream config.)
Add support for this to mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/ieee80211_radiotap.h |  6 ++++++
 include/net/mac80211.h           |  7 +++++++
 net/mac80211/rx.c                | 12 +++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 80d543902b8b..8014153bdd49 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -75,6 +75,7 @@ enum ieee80211_radiotap_presence {
 	IEEE80211_RADIOTAP_TIMESTAMP = 22,
 	IEEE80211_RADIOTAP_HE = 23,
 	IEEE80211_RADIOTAP_HE_MU = 24,
+	IEEE80211_RADIOTAP_ZERO_LEN_PSDU = 26,
 	IEEE80211_RADIOTAP_LSIG = 27,
 
 	/* valid in every it_present bitmap, even vendor namespaces */
@@ -340,6 +341,11 @@ struct ieee80211_radiotap_lsig {
 	__le16 data1, data2;
 };
 
+enum ieee80211_radiotap_zero_len_psdu_type {
+	IEEE80211_RADIOTAP_ZERO_LEN_PSDU_SOUNDING		= 0,
+	IEEE80211_RADIOTAP_ZERO_LEN_PSDU_VENDOR			= 0xff,
+};
+
 /**
  * ieee80211_get_radiotap_len - get radiotap header length
  */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c26d2d36cbe..50bf598abdfd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1142,6 +1142,10 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_RADIOTAP_HE_MU: HE MU radiotap data is present
  *	(&struct ieee80211_radiotap_he_mu)
  * @RX_FLAG_RADIOTAP_LSIG: L-SIG radiotap data is present
+ * @RX_FLAG_NO_PSDU: use the frame only for radiotap reporting, with
+ *	the "0-length PSDU" field included there.  The value for it is
+ *	in &struct ieee80211_rx_status.  Note that if this value isn't
+ *	known the frame shouldn't be reported.
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -1173,6 +1177,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_RADIOTAP_HE		= BIT(26),
 	RX_FLAG_RADIOTAP_HE_MU		= BIT(27),
 	RX_FLAG_RADIOTAP_LSIG		= BIT(28),
+	RX_FLAG_NO_PSDU			= BIT(29),
 };
 
 /**
@@ -1245,6 +1250,7 @@ enum mac80211_rx_encoding {
  * @ampdu_reference: A-MPDU reference number, must be a different value for
  *	each A-MPDU but the same for each subframe within one A-MPDU
  * @ampdu_delimiter_crc: A-MPDU delimiter CRC
+ * @zero_length_psdu_type: radiotap type of the 0-length PSDU
  */
 struct ieee80211_rx_status {
 	u64 mactime;
@@ -1265,6 +1271,7 @@ struct ieee80211_rx_status {
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 	u8 ampdu_delimiter_crc;
+	u8 zero_length_psdu_type;
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 66cc2590e88c..5c8eaac8592f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -115,7 +115,8 @@ static inline bool should_drop_frame(struct sk_buff *skb, int present_fcs_len,
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
 			    RX_FLAG_FAILED_PLCP_CRC |
-			    RX_FLAG_ONLY_MONITOR))
+			    RX_FLAG_ONLY_MONITOR |
+			    RX_FLAG_NO_PSDU))
 		return true;
 
 	if (unlikely(skb->len < 16 + present_fcs_len + rtap_space))
@@ -189,6 +190,9 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 		BUILD_BUG_ON(sizeof(struct ieee80211_radiotap_he_mu) != 12);
 	}
 
+	if (status->flag & RX_FLAG_NO_PSDU)
+		len += 1;
+
 	if (status->flag & RX_FLAG_RADIOTAP_LSIG) {
 		len = ALIGN(len, 2);
 		len += 4;
@@ -642,6 +646,12 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		pos += sizeof(he_mu);
 	}
 
+	if (status->flag & RX_FLAG_NO_PSDU) {
+		rthdr->it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_ZERO_LEN_PSDU);
+		*pos++ = status->zero_length_psdu_type;
+	}
+
 	if (status->flag & RX_FLAG_RADIOTAP_LSIG) {
 		/* ensure 2 byte alignment */
 		while ((pos - (u8 *)rthdr) & 1)
-- 
2.18.0
