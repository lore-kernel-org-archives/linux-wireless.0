Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64132 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab3EWHSH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 03:18:07 -0400
Received: from mailout-de.gmx.net ([10.1.76.12]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MRydg-1V48Sk1TKc-00TCqW for
 <linux-wireless@vger.kernel.org>; Thu, 23 May 2013 09:18:04 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 1/3] mac80211: add STBC flag for radiotap
Date: Thu, 23 May 2013 09:17:55 +0200
Message-Id: <1369293475-9408-1-git-send-email-linux@rempel-privat.de> (sfid-20130523_091822_007021_C47C5016)
In-Reply-To: <1369250674.8207.26.camel@jlt4.sipsolutions.net>
References: <1369250674.8207.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

revision:
- v2. set HAVE_STBC only if it is present.
      do not set STBC flag on TX packets.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 include/net/ieee80211_radiotap.h |  7 +++++++
 include/net/mac80211.h           |  4 ++++
 net/mac80211/rx.c                | 13 ++++++++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index c399963..c6d07cb 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -269,6 +269,7 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_HAVE_GI		0x04
 #define IEEE80211_RADIOTAP_MCS_HAVE_FMT		0x08
 #define IEEE80211_RADIOTAP_MCS_HAVE_FEC		0x10
+#define IEEE80211_RADIOTAP_MCS_HAVE_STBC	0x20
 
 #define IEEE80211_RADIOTAP_MCS_BW_MASK		0x03
 #define		IEEE80211_RADIOTAP_MCS_BW_20	0
@@ -278,6 +279,12 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_SGI		0x04
 #define IEEE80211_RADIOTAP_MCS_FMT_GF		0x08
 #define IEEE80211_RADIOTAP_MCS_FEC_LDPC		0x10
+#define IEEE80211_RADIOTAP_MCS_STBC_MASK	0x60
+#define		IEEE80211_RADIOTAP_MCS_STBC_1	1
+#define		IEEE80211_RADIOTAP_MCS_STBC_2	2
+#define		IEEE80211_RADIOTAP_MCS_STBC_3	3
+
+#define IEEE80211_RADIOTAP_MCS_STBC_SHIFT	5
 
 /* For IEEE80211_RADIOTAP_AMPDU_STATUS */
 #define IEEE80211_RADIOTAP_AMPDU_REPORT_ZEROLEN		0x0001
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 885898a..16705a9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -805,6 +805,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	on this subframe
  * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
  *	is stored in the @ampdu_delimiter_crc field)
+ * @RX_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -832,8 +833,11 @@ enum mac80211_rx_flags {
 	RX_FLAG_80MHZ			= BIT(23),
 	RX_FLAG_80P80MHZ		= BIT(24),
 	RX_FLAG_160MHZ			= BIT(25),
+	RX_FLAG_STBC_MASK		= BIT(26) | BIT(27),
 };
 
+#define RX_FLAG_STBC_SHIFT		26
+
 /**
  * struct ieee80211_rx_status - receive status
  *
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8e29526..db7c68a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -258,8 +258,16 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	pos += 2;
 
 	if (status->flag & RX_FLAG_HT) {
+		unsigned int stbc = status->flag & RX_FLAG_STBC_MASK;
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
-		*pos++ = local->hw.radiotap_mcs_details;
+
+		/* MCS known field */
+		*pos = local->hw.radiotap_mcs_details;
+		if (stbc)
+			*pos |= IEEE80211_RADIOTAP_MCS_HAVE_STBC;
+		*pos++;
+
+		/* MCS flags field */
 		*pos = 0;
 		if (status->flag & RX_FLAG_SHORT_GI)
 			*pos |= IEEE80211_RADIOTAP_MCS_SGI;
@@ -267,6 +275,9 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
 		if (status->flag & RX_FLAG_HT_GF)
 			*pos |= IEEE80211_RADIOTAP_MCS_FMT_GF;
+		if (stbc)
+			*pos |= (stbc >> RX_FLAG_STBC_SHIFT)
+					<< IEEE80211_RADIOTAP_MCS_STBC_SHIFT;
 		pos++;
 		*pos++ = status->rate_idx;
 	}
-- 
1.8.1.2

