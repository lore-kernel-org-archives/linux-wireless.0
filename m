Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52942 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab3D2Jd5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 05:33:57 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LxZlV-1UYonf0sbj-017GP4 for
 <linux-wireless@vger.kernel.org>; Mon, 29 Apr 2013 11:33:56 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 2/4] mac80211: add STBC flag for radiotap
Date: Mon, 29 Apr 2013 11:33:42 +0200
Message-Id: <1367228024-17936-3-git-send-email-linux@rempel-privat.de> (sfid-20130429_113400_548526_A3E50994)
In-Reply-To: <1367228024-17936-1-git-send-email-linux@rempel-privat.de>
References: <1367228024-17936-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 include/net/ieee80211_radiotap.h | 2 ++
 include/net/mac80211.h           | 2 ++
 net/mac80211/main.c              | 3 ++-
 net/mac80211/rx.c                | 2 ++
 net/mac80211/status.c            | 3 ++-
 5 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index c399963..8d3455b 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -269,6 +269,7 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_HAVE_GI		0x04
 #define IEEE80211_RADIOTAP_MCS_HAVE_FMT		0x08
 #define IEEE80211_RADIOTAP_MCS_HAVE_FEC		0x10
+#define IEEE80211_RADIOTAP_MCS_HAVE_STBC	0x20
 
 #define IEEE80211_RADIOTAP_MCS_BW_MASK		0x03
 #define		IEEE80211_RADIOTAP_MCS_BW_20	0
@@ -278,6 +279,7 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_SGI		0x04
 #define IEEE80211_RADIOTAP_MCS_FMT_GF		0x08
 #define IEEE80211_RADIOTAP_MCS_FEC_LDPC		0x10
+#define IEEE80211_RADIOTAP_MCS_STBC		0x20
 
 /* For IEEE80211_RADIOTAP_AMPDU_STATUS */
 #define IEEE80211_RADIOTAP_AMPDU_REPORT_ZEROLEN		0x0001
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 04c2d46..76e7977 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -805,6 +805,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	on this subframe
  * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
  *	is stored in the @ampdu_delimiter_crc field)
+ * @RX_FLAG_STBC: STBC was used
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -832,6 +833,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_80MHZ			= BIT(23),
 	RX_FLAG_80P80MHZ		= BIT(24),
 	RX_FLAG_160MHZ			= BIT(25),
+	RX_FLAG_STBC			= BIT(26),
 };
 
 /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8a7bfc4..44191a3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -589,7 +589,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->hw.radiotap_mcs_details = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 					 IEEE80211_RADIOTAP_MCS_HAVE_GI |
-					 IEEE80211_RADIOTAP_MCS_HAVE_BW;
+					 IEEE80211_RADIOTAP_MCS_HAVE_BW |
+					 IEEE80211_RADIOTAP_MCS_HAVE_STBC;
 	local->hw.radiotap_vht_details = IEEE80211_RADIOTAP_VHT_KNOWN_GI |
 					 IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
 	local->hw.uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c8447af..fada697 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -267,6 +267,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
 		if (status->flag & RX_FLAG_HT_GF)
 			*pos |= IEEE80211_RADIOTAP_MCS_FMT_GF;
+		if (status->flag & RX_FLAG_STBC)
+			*pos |= IEEE80211_RADIOTAP_MCS_STBC;
 		pos++;
 		*pos++ = status->rate_idx;
 	}
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4343920..41143f8 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -312,7 +312,8 @@ static void ieee80211_add_tx_radiotap_header(struct ieee80211_supported_band
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
 		pos[0] = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
-			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
+			 IEEE80211_RADIOTAP_MCS_HAVE_BW |
+			 IEEE80211_RADIOTAP_MCS_HAVE_STBC;
 		if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
 			pos[1] |= IEEE80211_RADIOTAP_MCS_SGI;
 		if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-- 
1.8.1.2

