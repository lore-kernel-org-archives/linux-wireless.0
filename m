Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:49231 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753758AbYEHRWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 13:22:40 -0400
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH] mac80211: make rx radiotap header more flexible
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Date: Thu, 08 May 2008 19:22:43 +0200
Message-ID: <20080508172243.22763.20648.stgit@localhost> (sfid-20080508_192140_987717_60BC67B0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use hw flags and rx flags to determine which fields are present in the header
and use all available information from the driver.

make sure radiotap header starts at a naturally aligned address (mod 8) for
all radiotap fields.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 net/mac80211/rx.c |  195 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 133 insertions(+), 62 deletions(-)


diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3ea856f..69e2677 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -77,6 +77,134 @@ static inline int should_drop_frame(struct ieee80211_rx_status *status,
 	return 0;
 }
 
+static int
+ieee80211_rx_radiotap_len(struct ieee80211_local *local,
+			  struct ieee80211_rx_status *status)
+{
+	int len;
+
+	/* always present fields */
+	len = sizeof(struct ieee80211_radiotap_header) + 9;
+
+	if (status->flag & RX_FLAG_TSFT)
+		len += 8;
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DB ||
+	    local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		len += 1;
+	if (local->hw.flags & IEEE80211_HW_NOISE_DBM)
+		len += 1;
+
+	if (len & 1) /* padding for RX_FLAGS if necessary */
+		len++;
+
+	/* make sure radiotap starts at a naturally aligned address */
+	if (len % 8)
+		len = roundup(len, 8);
+
+	return len;
+}
+
+/**
+ * ieee80211_add_rx_radiotap_header - add radiotap header
+ *
+ * add a radiotap header containing all the fields which the hardware provided.
+ */
+static void
+ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
+				 struct sk_buff *skb,
+				 struct ieee80211_rx_status *status,
+				 struct ieee80211_rate *rate,
+				 int rtap_len)
+{
+	struct ieee80211_radiotap_header *rthdr;
+	unsigned char *pos;
+
+	rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
+	memset(rthdr, 0, rtap_len);
+
+	/* radiotap header, set always present flags */
+	rthdr->it_present =
+		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
+			    (1 << IEEE80211_RADIOTAP_RATE) |
+			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
+			    (1 << IEEE80211_RADIOTAP_ANTENNA) |
+			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
+	rthdr->it_len = cpu_to_le16(rtap_len);
+
+	pos = (unsigned char *)(rthdr+1);
+
+	/* the order of the following fields is important */
+
+	/* IEEE80211_RADIOTAP_TSFT */
+	if (status->flag & RX_FLAG_TSFT) {
+		*(__le64 *)pos = cpu_to_le64(status->mactime);
+		rthdr->it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
+		pos += 8;
+	}
+
+	/* IEEE80211_RADIOTAP_FLAGS */
+	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
+		*pos |= IEEE80211_RADIOTAP_F_FCS;
+	pos++;
+
+	/* IEEE80211_RADIOTAP_RATE */
+	*pos = rate->bitrate / 5;
+	pos++;
+
+	/* IEEE80211_RADIOTAP_CHANNEL */
+	*(__le16 *)pos = cpu_to_le16(status->freq);
+	pos += 2;
+	if (status->band == IEEE80211_BAND_5GHZ)
+		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_OFDM |
+					     IEEE80211_CHAN_5GHZ);
+	else
+		*(__le16 *)pos = cpu_to_le16(IEEE80211_CHAN_DYN |
+					     IEEE80211_CHAN_2GHZ);
+	pos += 2;
+
+	/* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+		*pos = status->signal;
+		rthdr->it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL);
+		pos++;
+	}
+
+	/* IEEE80211_RADIOTAP_DBM_ANTNOISE */
+	if (local->hw.flags & IEEE80211_HW_NOISE_DBM) {
+		*pos = status->noise;
+		rthdr->it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_DBM_ANTNOISE);
+		pos++;
+	}
+
+	/* IEEE80211_RADIOTAP_LOCK_QUALITY is missing */
+
+	/* IEEE80211_RADIOTAP_ANTENNA */
+	*pos = status->antenna;
+	pos++;
+
+	/* IEEE80211_RADIOTAP_DB_ANTSIGNAL */
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DB) {
+		*pos = status->signal;
+		rthdr->it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL);
+		pos++;
+	}
+
+	/* IEEE80211_RADIOTAP_DB_ANTNOISE is not used */
+
+	/* IEEE80211_RADIOTAP_RX_FLAGS */
+	/* ensure 2 byte alignment for the 2 byte field as required */
+	if ((pos - (unsigned char *)rthdr) & 1)
+		pos++;
+	/* FIXME: when radiotap gets a 'bad PLCP' flag use it here */
+	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
+		*(__le16 *)pos |= cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
+	pos += 2;
+}
+
 /*
  * This function copies a received frame to all monitor interfaces and
  * returns a cleaned-up SKB that no longer includes the FCS nor the
@@ -89,17 +217,6 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 {
 	struct ieee80211_sub_if_data *sdata;
 	int needed_headroom = 0;
-	struct ieee80211_radiotap_header *rthdr;
-	__le64 *rttsft = NULL;
-	struct ieee80211_rtap_fixed_data {
-		u8 flags;
-		u8 rate;
-		__le16 chan_freq;
-		__le16 chan_flags;
-		u8 antsignal;
-		u8 padding_for_rxflags;
-		__le16 rx_flags;
-	} __attribute__ ((packed)) *rtfixed;
 	struct sk_buff *skb, *skb2;
 	struct net_device *prev_dev = NULL;
 	int present_fcs_len = 0;
@@ -116,8 +233,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	if (status->flag & RX_FLAG_RADIOTAP)
 		rtap_len = ieee80211_get_radiotap_len(origskb->data);
 	else
-		/* room for radiotap header, always present fields and TSFT */
-		needed_headroom = sizeof(*rthdr) + sizeof(*rtfixed) + 8;
+		/* room for the radiotap header based on driver features */
+		needed_headroom = ieee80211_rx_radiotap_len(local, status);
 
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
@@ -163,55 +280,9 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	}
 
 	/* if necessary, prepend radiotap information */
-	if (!(status->flag & RX_FLAG_RADIOTAP)) {
-		rtfixed = (void *) skb_push(skb, sizeof(*rtfixed));
-		rtap_len = sizeof(*rthdr) + sizeof(*rtfixed);
-		if (status->flag & RX_FLAG_TSFT) {
-			rttsft = (void *) skb_push(skb, sizeof(*rttsft));
-			rtap_len += 8;
-		}
-		rthdr = (void *) skb_push(skb, sizeof(*rthdr));
-		memset(rthdr, 0, sizeof(*rthdr));
-		memset(rtfixed, 0, sizeof(*rtfixed));
-		rthdr->it_present =
-			cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-				    (1 << IEEE80211_RADIOTAP_RATE) |
-				    (1 << IEEE80211_RADIOTAP_CHANNEL) |
-				    (1 << IEEE80211_RADIOTAP_DB_ANTSIGNAL) |
-				    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
-		rtfixed->flags = 0;
-		if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
-			rtfixed->flags |= IEEE80211_RADIOTAP_F_FCS;
-
-		if (rttsft) {
-			*rttsft = cpu_to_le64(status->mactime);
-			rthdr->it_present |=
-				cpu_to_le32(1 << IEEE80211_RADIOTAP_TSFT);
-		}
-
-		/* FIXME: when radiotap gets a 'bad PLCP' flag use it here */
-		rtfixed->rx_flags = 0;
-		if (status->flag &
-		    (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
-			rtfixed->rx_flags |=
-				cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
-
-		rtfixed->rate = rate->bitrate / 5;
-
-		rtfixed->chan_freq = cpu_to_le16(status->freq);
-
-		if (status->band == IEEE80211_BAND_5GHZ)
-			rtfixed->chan_flags =
-				cpu_to_le16(IEEE80211_CHAN_OFDM |
-					    IEEE80211_CHAN_5GHZ);
-		else
-			rtfixed->chan_flags =
-				cpu_to_le16(IEEE80211_CHAN_DYN |
-					    IEEE80211_CHAN_2GHZ);
-
-		rtfixed->antsignal = status->signal;
-		rthdr->it_len = cpu_to_le16(rtap_len);
-	}
+	if (!(status->flag & RX_FLAG_RADIOTAP))
+		ieee80211_add_rx_radiotap_header(local, skb, status, rate,
+						 needed_headroom);
 
 	skb_reset_mac_header(skb);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;

