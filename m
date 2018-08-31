Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45524 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727997AbeHaM65 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:58:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:20 +0300
Message-Id: <20180831083130.15525-19-luca@coelho.fi> (sfid-20180831_105448_154522_5A94ED10)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 18/28] mac80211: support radiotap L-SIG data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

As before with HE, the data needs to be provided by the
driver in the skb head, since there's not enough space
in the skb CB.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/ieee80211_radiotap.h | 15 +++++++++++++++
 include/net/mac80211.h           |  2 ++
 net/mac80211/rx.c                | 21 +++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index feef706e1158..80d543902b8b 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -75,6 +75,7 @@ enum ieee80211_radiotap_presence {
 	IEEE80211_RADIOTAP_TIMESTAMP = 22,
 	IEEE80211_RADIOTAP_HE = 23,
 	IEEE80211_RADIOTAP_HE_MU = 24,
+	IEEE80211_RADIOTAP_LSIG = 27,
 
 	/* valid in every it_present bitmap, even vendor namespaces */
 	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
@@ -325,6 +326,20 @@ enum ieee80211_radiotap_he_mu_bits {
 	IEEE80211_RADIOTAP_HE_MU_FLAGS2_CH2_CTR_26T_RU		= 0x0800,
 };
 
+enum ieee80211_radiotap_lsig_data1 {
+	IEEE80211_RADIOTAP_LSIG_DATA1_RATE_KNOWN		= 0x0001,
+	IEEE80211_RADIOTAP_LSIG_DATA1_LENGTH_KNOWN		= 0x0002,
+};
+
+enum ieee80211_radiotap_lsig_data2 {
+	IEEE80211_RADIOTAP_LSIG_DATA2_RATE			= 0x000f,
+	IEEE80211_RADIOTAP_LSIG_DATA2_LENGTH			= 0xfff0,
+};
+
+struct ieee80211_radiotap_lsig {
+	__le16 data1, data2;
+};
+
 /**
  * ieee80211_get_radiotap_len - get radiotap header length
  */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 02d251ea0126..b061131b2198 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1141,6 +1141,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	from the RX info data, so leave those zeroed when building this data)
  * @RX_FLAG_RADIOTAP_HE_MU: HE MU radiotap data is present
  *	(&struct ieee80211_radiotap_he_mu)
+ * @RX_FLAG_RADIOTAP_LSIG: L-SIG radiotap data is present
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -1171,6 +1172,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_AMPDU_EOF_BIT_KNOWN	= BIT(25),
 	RX_FLAG_RADIOTAP_HE		= BIT(26),
 	RX_FLAG_RADIOTAP_HE_MU		= BIT(27),
+	RX_FLAG_RADIOTAP_LSIG		= BIT(28),
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 46223b694227..66cc2590e88c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -189,6 +189,12 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 		BUILD_BUG_ON(sizeof(struct ieee80211_radiotap_he_mu) != 12);
 	}
 
+	if (status->flag & RX_FLAG_RADIOTAP_LSIG) {
+		len = ALIGN(len, 2);
+		len += 4;
+		BUILD_BUG_ON(sizeof(struct ieee80211_radiotap_lsig) != 4);
+	}
+
 	if (status->chains) {
 		/* antenna and antenna signal fields */
 		len += 2 * hweight8(status->chains);
@@ -279,6 +285,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	struct ieee80211_vendor_radiotap rtap = {};
 	struct ieee80211_radiotap_he he = {};
 	struct ieee80211_radiotap_he_mu he_mu = {};
+	struct ieee80211_radiotap_lsig lsig = {};
 
 	if (status->flag & RX_FLAG_RADIOTAP_HE) {
 		he = *(struct ieee80211_radiotap_he *)skb->data;
@@ -291,6 +298,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		skb_pull(skb, sizeof(he_mu));
 	}
 
+	if (status->flag & RX_FLAG_RADIOTAP_LSIG) {
+		lsig = *(struct ieee80211_radiotap_lsig *)skb->data;
+		skb_pull(skb, sizeof(lsig));
+	}
+
 	if (status->flag & RX_FLAG_RADIOTAP_VENDOR_DATA) {
 		rtap = *(struct ieee80211_vendor_radiotap *)skb->data;
 		/* rtap.len and rtap.pad are undone immediately */
@@ -630,6 +642,15 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		pos += sizeof(he_mu);
 	}
 
+	if (status->flag & RX_FLAG_RADIOTAP_LSIG) {
+		/* ensure 2 byte alignment */
+		while ((pos - (u8 *)rthdr) & 1)
+			pos++;
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_LSIG);
+		memcpy(pos, &lsig, sizeof(lsig));
+		pos += sizeof(lsig);
+	}
+
 	for_each_set_bit(chain, &chains, IEEE80211_MAX_CHAINS) {
 		*pos++ = status->chain_signal[chain];
 		*pos++ = chain;
-- 
2.18.0
