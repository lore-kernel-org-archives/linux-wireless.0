Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:46407 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab3D2JGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 05:06:19 -0400
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linux@rempel-privat.de,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 1/2] mac80211: Add STBC RX flag to radiotap
Date: Mon, 29 Apr 2013 11:04:18 +0200
Message-Id: <1367226260-26755-2-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20130429_110625_498196_82A8FB5B)
In-Reply-To: <1367226260-26755-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1367226260-26755-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add rx flag to radiotap header which tells whether
Space-Time Block Code was used. At the moment only
1 stream STBC is supported.

TODO: Pass information from the driver on how many STBC
streams have been received.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 include/net/ieee80211_radiotap.h |    6 ++++++
 include/net/mac80211.h           |    2 ++
 net/mac80211/main.c              |    3 ++-
 net/mac80211/rx.c                |    2 ++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index e07d7d7..0254cbd 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -271,6 +271,7 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_HAVE_GI		0x04
 #define IEEE80211_RADIOTAP_MCS_HAVE_FMT		0x08
 #define IEEE80211_RADIOTAP_MCS_HAVE_FEC		0x10
+#define IEEE80211_RADIOTAP_MCS_HAVE_STBC	0x20
 
 #define IEEE80211_RADIOTAP_MCS_BW_MASK		0x03
 #define		IEEE80211_RADIOTAP_MCS_BW_20	0
@@ -280,6 +281,11 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_SGI		0x04
 #define IEEE80211_RADIOTAP_MCS_FMT_GF		0x08
 #define IEEE80211_RADIOTAP_MCS_FEC_LDPC		0x10
+#define IEEE80211_RADIOTAP_MCS_STBC_MASK	0x60
+#define		IEEE80211_RADIOTAP_MCS_STBC_0	0
+#define		IEEE80211_RADIOTAP_MCS_STBC_1	1
+#define		IEEE80211_RADIOTAP_MCS_STBC_2	2
+#define		IEEE80211_RADIOTAP_MCS_STBC_3	3
 
 /* For IEEE80211_RADIOTAP_AMPDU_STATUS */
 #define IEEE80211_RADIOTAP_AMPDU_REPORT_ZEROLEN		0x0001
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1fe1844..efa9fb1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -808,6 +808,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	on this subframe
  * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
  *	is stored in the @ampdu_delimiter_crc field)
+ * @RX_FLAG_STBC: Space-Time Block Code was used
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -835,6 +836,7 @@ enum mac80211_rx_flags {
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
index c8447af..955a70f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -267,6 +267,8 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
 		if (status->flag & RX_FLAG_HT_GF)
 			*pos |= IEEE80211_RADIOTAP_MCS_FMT_GF;
+		if (status->flag & RX_FLAG_STBC)
+			*pos |= IEEE80211_RADIOTAP_MCS_STBC_1;
 		pos++;
 		*pos++ = status->rate_idx;
 	}
-- 
1.7.10.4

