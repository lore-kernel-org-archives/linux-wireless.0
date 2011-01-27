Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1A0NNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:13:19 -0500
Subject: [PATCH] mac80211: add MCS information to radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 14:13:17 +0100
Message-ID: <1296133997.3622.36.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds the MCS information we currently get
from the drivers into radiotap.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/ieee80211_radiotap.h |   25 +++++++++++++++++++++++++
 net/mac80211/rx.c                |   17 +++++++++++++++++
 2 files changed, 42 insertions(+)

--- wireless-testing.orig/net/mac80211/rx.c	2011-01-23 11:38:27.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2011-01-27 14:10:46.000000000 +0100
@@ -85,6 +85,9 @@ ieee80211_rx_radiotap_len(struct ieee802
 	if (len & 1) /* padding for RX_FLAGS if necessary */
 		len++;
 
+	if (status->flag & RX_FLAG_HT) /* HT info */
+		len += 3;
+
 	return len;
 }
 
@@ -193,6 +196,20 @@ ieee80211_add_rx_radiotap_header(struct
 		rx_flags |= IEEE80211_RADIOTAP_F_RX_BADPLCP;
 	put_unaligned_le16(rx_flags, pos);
 	pos += 2;
+
+	if (status->flag & RX_FLAG_HT) {
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
+		*pos++ = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
+			 IEEE80211_RADIOTAP_MCS_HAVE_GI |
+			 IEEE80211_RADIOTAP_MCS_HAVE_BW;
+		*pos = 0;
+		if (status->flag & RX_FLAG_SHORT_GI)
+			*pos |= IEEE80211_RADIOTAP_MCS_SGI;
+		if (status->flag & RX_FLAG_40MHZ)
+			*pos |= IEEE80211_RADIOTAP_MCS_BW_40;
+		pos++;
+		*pos++ = status->rate_idx;
+	}
 }
 
 /*
--- wireless-testing.orig/include/net/ieee80211_radiotap.h	2011-01-23 11:38:27.000000000 +0100
+++ wireless-testing/include/net/ieee80211_radiotap.h	2011-01-27 14:10:46.000000000 +0100
@@ -178,6 +178,11 @@ struct ieee80211_radiotap_header {
  *
  *     Number of unicast retries a transmitted frame used.
  *
+ * IEEE80211_RADIOTAP_MCS	u8, u8, u8		unitless
+ *
+ *     Contains a bitmap of known fields/flags, the flags, and
+ *     the MCS index.
+ *
  */
 enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TSFT = 0,
@@ -199,6 +204,8 @@ enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_RTS_RETRIES = 16,
 	IEEE80211_RADIOTAP_DATA_RETRIES = 17,
 
+	IEEE80211_RADIOTAP_MCS = 19,
+
 	/* valid in every it_present bitmap, even vendor namespaces */
 	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
 	IEEE80211_RADIOTAP_VENDOR_NAMESPACE = 30,
@@ -245,6 +252,24 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_F_TX_CTS	0x0002	/* used cts 'protection' */
 #define IEEE80211_RADIOTAP_F_TX_RTS	0x0004	/* used rts/cts handshake */
 
+
+/* For IEEE80211_RADIOTAP_MCS */
+#define IEEE80211_RADIOTAP_MCS_HAVE_BW		0x01
+#define IEEE80211_RADIOTAP_MCS_HAVE_MCS		0x02
+#define IEEE80211_RADIOTAP_MCS_HAVE_GI		0x04
+#define IEEE80211_RADIOTAP_MCS_HAVE_FMT		0x08
+#define IEEE80211_RADIOTAP_MCS_HAVE_FEC		0x10
+
+#define IEEE80211_RADIOTAP_MCS_BW_MASK		0x03
+#define		IEEE80211_RADIOTAP_MCS_BW_20	0
+#define		IEEE80211_RADIOTAP_MCS_BW_40	1
+#define		IEEE80211_RADIOTAP_MCS_BW_20L	2
+#define		IEEE80211_RADIOTAP_MCS_BW_20U	3
+#define IEEE80211_RADIOTAP_MCS_SGI		0x04
+#define IEEE80211_RADIOTAP_MCS_FMT_GF		0x08
+#define IEEE80211_RADIOTAP_MCS_FEC_LDPC		0x10
+
+
 /* Ugly macro to convert literal channel numbers into their mhz equivalents
  * There are certianly some conditions that will break this (like feeding it '30')
  * but they shouldn't arise since nothing talks on channel 30. */


