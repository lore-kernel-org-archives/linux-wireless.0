Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaBEKuv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 05:50:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] mac80211: propagate STBC / LDPC flags to radiotap
Date: Wed,  5 Feb 2014 12:48:53 +0200
Message-Id: <1391597333-6398-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140205_115055_734008_EB434311)
In-Reply-To: <1391597333-6398-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1391597333-6398-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This capabilities weren't propagated to the radiotap header.
We don't set here the VHT_KNOWN / MCS_HAVE flag because not
all the low level drivers will know how to properly flag
the frames, hence the low level driver will be in charge
of setting IEEE80211_RADIOTAP_MCS_HAVE_FEC,
IEEE80211_RADIOTAP_MCS_HAVE_STBC and / or
IEEE80211_RADIOTAP_VHT_KNOWN_STBC according to its
capabilities.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/ieee80211_radiotap.h | 4 ++++
 include/net/mac80211.h           | 2 ++
 net/mac80211/rx.c                | 7 +++++++
 3 files changed, 13 insertions(+)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 8b5b714..b0fd947 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -316,6 +316,10 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_VHT_FLAG_LDPC_EXTRA_OFDM_SYM		0x10
 #define IEEE80211_RADIOTAP_VHT_FLAG_BEAMFORMED			0x20
 
+#define IEEE80211_RADIOTAP_CODING_LDPC_USER0			0x01
+#define IEEE80211_RADIOTAP_CODING_LDPC_USER1			0x02
+#define IEEE80211_RADIOTAP_CODING_LDPC_USER2			0x04
+#define IEEE80211_RADIOTAP_CODING_LDPC_USER3			0x08
 
 /* helpers */
 static inline int ieee80211_get_radiotap_len(unsigned char *data)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 83137fb..6bf38bd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -827,6 +827,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	on this subframe
  * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
  *	is stored in the @ampdu_delimiter_crc field)
+ * @RX_FLAG_LDPC: LDPC was used
  * @RX_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3
  * @RX_FLAG_10MHZ: 10 MHz (half channel) was used
  * @RX_FLAG_5MHZ: 5 MHz (quarter channel) was used
@@ -863,6 +864,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(20),
 	RX_FLAG_MACTIME_END		= BIT(21),
 	RX_FLAG_VHT			= BIT(22),
+	RX_FLAG_LDPC			= BIT(23),
 	RX_FLAG_STBC_MASK		= BIT(26) | BIT(27),
 	RX_FLAG_10MHZ			= BIT(28),
 	RX_FLAG_5MHZ			= BIT(29),
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 72ed9ef..d6569ad 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -279,6 +279,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
 		if (status->flag & RX_FLAG_HT_GF)
 			*pos |= IEEE80211_RADIOTAP_MCS_FMT_GF;
+		if (status->flag & RX_FLAG_LDPC)
+			*pos |= IEEE80211_RADIOTAP_MCS_FEC_LDPC;
 		stbc = (status->flag & RX_FLAG_STBC_MASK) >> RX_FLAG_STBC_SHIFT;
 		*pos |= stbc << IEEE80211_RADIOTAP_MCS_STBC_SHIFT;
 		pos++;
@@ -328,6 +330,9 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		/* flags */
 		if (status->flag & RX_FLAG_SHORT_GI)
 			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_SGI;
+		/* in VHT, STBC is binary */
+		if (status->flag & RX_FLAG_STBC_MASK)
+			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_STBC;
 		pos++;
 		/* bandwidth */
 		if (status->vht_flag & RX_VHT_FLAG_80MHZ)
@@ -344,6 +349,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		*pos = (status->rate_idx << 4) | status->vht_nss;
 		pos += 4;
 		/* coding field */
+		if (status->flag & RX_FLAG_LDPC)
+			*pos |= IEEE80211_RADIOTAP_CODING_LDPC_USER0;
 		pos++;
 		/* group ID */
 		pos++;
-- 
1.8.3.2

