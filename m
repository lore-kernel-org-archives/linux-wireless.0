Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:35074 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3F0Q7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 12:59:15 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 07/18] mac80211: add radiotap flag and handling for 5/10 MHz
Date: Thu, 27 Jun 2013 18:58:49 +0200
Message-Id: <1372352340-20663-9-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_192030_004890_E840EB59)
In-Reply-To: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireshark already defines radiotap channel flags for 5 and 10 MHz, so
just use them in Linux radiotap too. Furthermore, add rx status flags to
allow drivers to report when they received data on 5 or 10 MHz channels.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/ieee80211_radiotap.h |    4 ++++
 include/net/mac80211.h           |    4 ++++
 net/mac80211/rx.c                |   21 ++++++++++++---------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index c6d07cb..8b5b714 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -230,6 +230,10 @@ enum ieee80211_radiotap_type {
 #define	IEEE80211_CHAN_PASSIVE	0x0200	/* Only passive scan allowed */
 #define	IEEE80211_CHAN_DYN	0x0400	/* Dynamic CCK-OFDM channel */
 #define	IEEE80211_CHAN_GFSK	0x0800	/* GFSK channel (FHSS PHY) */
+#define	IEEE80211_CHAN_GSM	0x1000	/* GSM (900 MHz) */
+#define	IEEE80211_CHAN_STURBO	0x2000	/* Static Turbo */
+#define	IEEE80211_CHAN_HALF	0x4000	/* Half channel (10 MHz wide) */
+#define	IEEE80211_CHAN_QUARTER	0x8000	/* Quarter channel (5 MHz wide) */
 
 /* For IEEE80211_RADIOTAP_FLAGS */
 #define	IEEE80211_RADIOTAP_F_CFP	0x01	/* sent/received
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9445f38..ed3dd96 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -809,6 +809,8 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
  *	is stored in the @ampdu_delimiter_crc field)
  * @RX_FLAG_STBC_MASK: STBC 2 bit bitmask. 1 - Nss=1, 2 - Nss=2, 3 - Nss=3
+ * @RX_FLAG_10MHZ: 10 MHz (half channel) was used
+ * @RX_FLAG_5MHZ: 5 MHz (quarter channel) was used
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR		= BIT(0),
@@ -837,6 +839,8 @@ enum mac80211_rx_flags {
 	RX_FLAG_80P80MHZ		= BIT(24),
 	RX_FLAG_160MHZ			= BIT(25),
 	RX_FLAG_STBC_MASK		= BIT(26) | BIT(27),
+	RX_FLAG_10MHZ			= BIT(28),
+	RX_FLAG_5MHZ			= BIT(29),
 };
 
 #define RX_FLAG_STBC_SHIFT		26
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 90ab888..e62aca1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -146,6 +146,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	struct ieee80211_radiotap_header *rthdr;
 	unsigned char *pos;
 	u16 rx_flags = 0;
+	u16 channel_flags = 0;
 	int mpdulen;
 
 	mpdulen = skb->len;
@@ -220,20 +221,22 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	/* IEEE80211_RADIOTAP_CHANNEL */
 	put_unaligned_le16(status->freq, pos);
 	pos += 2;
+	if (status->flag & RX_FLAG_10MHZ)
+		channel_flags |= IEEE80211_CHAN_HALF;
+	else if (status->flag & RX_FLAG_5MHZ)
+		channel_flags |= IEEE80211_CHAN_QUARTER;
+
 	if (status->band == IEEE80211_BAND_5GHZ)
-		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
-				   pos);
+		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ;
 	else if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
-		put_unaligned_le16(IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ,
-				   pos);
+		channel_flags |= IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ;
 	else if (rate && rate->flags & IEEE80211_RATE_ERP_G)
-		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
-				   pos);
+		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ;
 	else if (rate)
-		put_unaligned_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
-				   pos);
+		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ;
 	else
-		put_unaligned_le16(IEEE80211_CHAN_2GHZ, pos);
+		channel_flags |= IEEE80211_CHAN_2GHZ;
+	put_unaligned_le16(channel_flags, pos);
 	pos += 2;
 
 	/* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
-- 
1.7.10.4

