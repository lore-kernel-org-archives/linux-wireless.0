Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab2GaLfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:35:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: support A-MPDU status reporting
Date: Tue, 31 Jul 2012 13:35:40 +0200
Message-Id: <1343734541-14934-3-git-send-email-johannes@sipsolutions.net> (sfid-20120731_133552_986228_DF997778)
In-Reply-To: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
References: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Support getting A-MPDU status information from the
drivers and reporting it to userspace via radiotap
in the standard fields.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |   53 +++++++++++++++++++++++++++++++++++-------------
 net/mac80211/rx.c      |   42 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 15 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8114f59..3762636 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -676,21 +676,41 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_HT_GF: This frame was received in a HT-greenfield transmission, if
  *	the driver fills this value it should add %IEEE80211_RADIOTAP_MCS_HAVE_FMT
  *	to hw.radiotap_mcs_details to advertise that fact
+ * @RX_FLAG_AMPDU_DETAILS: A-MPDU details are known, in particular the reference
+ *	number (@ampdu_reference) must be populated and be a distinct number for
+ *	each A-MPDU
+ * @RX_FLAG_AMPDU_REPORT_ZEROLEN: driver reports 0-length subframes
+ * @RX_FLAG_AMPDU_IS_ZEROLEN: This is a zero-length subframe, for
+ *	monitoring purposes only
+ * @RX_FLAG_AMPDU_LAST_KNOWN: last subframe is known, should be set on all
+ *	subframes of a single A-MPDU
+ * @RX_FLAG_AMPDU_IS_LAST: this subframe is the last subframe of the A-MPDU
+ * @RX_FLAG_AMPDU_DELIM_CRC_ERROR: A delimiter CRC error has been detected
+ *	on this subframe
+ * @RX_FLAG_AMPDU_DELIM_CRC_KNOWN: The delimiter CRC field is known (the CRC
+ *	is stored in the @ampdu_delimiter_crc field)
  */
 enum mac80211_rx_flags {
-	RX_FLAG_MMIC_ERROR	= 1<<0,
-	RX_FLAG_DECRYPTED	= 1<<1,
-	RX_FLAG_MMIC_STRIPPED	= 1<<3,
-	RX_FLAG_IV_STRIPPED	= 1<<4,
-	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
-	RX_FLAG_FAILED_PLCP_CRC = 1<<6,
-	RX_FLAG_MACTIME_MPDU	= 1<<7,
-	RX_FLAG_SHORTPRE	= 1<<8,
-	RX_FLAG_HT		= 1<<9,
-	RX_FLAG_40MHZ		= 1<<10,
-	RX_FLAG_SHORT_GI	= 1<<11,
-	RX_FLAG_NO_SIGNAL_VAL	= 1<<12,
-	RX_FLAG_HT_GF		= 1<<13,
+	RX_FLAG_MMIC_ERROR		= BIT(0),
+	RX_FLAG_DECRYPTED		= BIT(1),
+	RX_FLAG_MMIC_STRIPPED		= BIT(3),
+	RX_FLAG_IV_STRIPPED		= BIT(4),
+	RX_FLAG_FAILED_FCS_CRC		= BIT(5),
+	RX_FLAG_FAILED_PLCP_CRC 	= BIT(6),
+	RX_FLAG_MACTIME_MPDU		= BIT(7),
+	RX_FLAG_SHORTPRE		= BIT(8),
+	RX_FLAG_HT			= BIT(9),
+	RX_FLAG_40MHZ			= BIT(10),
+	RX_FLAG_SHORT_GI		= BIT(11),
+	RX_FLAG_NO_SIGNAL_VAL		= BIT(12),
+	RX_FLAG_HT_GF			= BIT(13),
+	RX_FLAG_AMPDU_DETAILS		= BIT(14),
+	RX_FLAG_AMPDU_REPORT_ZEROLEN	= BIT(15),
+	RX_FLAG_AMPDU_IS_ZEROLEN	= BIT(16),
+	RX_FLAG_AMPDU_LAST_KNOWN	= BIT(17),
+	RX_FLAG_AMPDU_IS_LAST		= BIT(18),
+	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(19),
+	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(20),
 };
 
 /**
@@ -714,17 +734,22 @@ enum mac80211_rx_flags {
  *	HT rates are use (RX_FLAG_HT)
  * @flag: %RX_FLAG_*
  * @rx_flags: internal RX flags for mac80211
+ * @ampdu_reference: A-MPDU reference number, must be a different value for
+ *	each A-MPDU but the same for each subframe within one A-MPDU
+ * @ampdu_delimiter_crc: A-MPDU delimiter CRC
  */
 struct ieee80211_rx_status {
 	u64 mactime;
 	u32 device_timestamp;
-	u16 flag;
+	u32 ampdu_reference;
+	u32 flag;
 	u16 freq;
 	u8 rate_idx;
 	u8 rx_flags;
 	u8 band;
 	u8 antenna;
 	s8 signal;
+	u8 ampdu_delimiter_crc;
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 090d417..6284e86 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -60,7 +60,9 @@ static inline int should_drop_frame(struct sk_buff *skb,
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
-	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
+	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
+			    RX_FLAG_FAILED_PLCP_CRC |
+			    RX_FLAG_AMPDU_IS_ZEROLEN))
 		return 1;
 	if (unlikely(skb->len < 16 + present_fcs_len))
 		return 1;
@@ -91,6 +93,13 @@ ieee80211_rx_radiotap_len(struct ieee80211_local *local,
 	if (status->flag & RX_FLAG_HT) /* HT info */
 		len += 3;
 
+	if (status->flag & RX_FLAG_AMPDU_DETAILS) {
+		/* padding */
+		while (len & 3)
+			len++;
+		len += 8;
+	}
+
 	return len;
 }
 
@@ -215,6 +224,37 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 		pos++;
 		*pos++ = status->rate_idx;
 	}
+
+	if (status->flag & RX_FLAG_AMPDU_DETAILS) {
+		u16 flags = 0;
+
+		/* ensure 4 byte alignment */
+		while ((pos - (u8 *)rthdr) & 3)
+			pos++;
+		rthdr->it_present |=
+			cpu_to_le32(1 << IEEE80211_RADIOTAP_AMPDU_STATUS);
+		put_unaligned_le32(status->ampdu_reference, pos);
+		pos += 4;
+		if (status->flag & RX_FLAG_AMPDU_REPORT_ZEROLEN)
+			flags |= IEEE80211_RADIOTAP_AMPDU_REPORT_ZEROLEN;
+		if (status->flag & RX_FLAG_AMPDU_IS_ZEROLEN)
+			flags |= IEEE80211_RADIOTAP_AMPDU_IS_ZEROLEN;
+		if (status->flag & RX_FLAG_AMPDU_LAST_KNOWN)
+			flags |= IEEE80211_RADIOTAP_AMPDU_LAST_KNOWN;
+		if (status->flag & RX_FLAG_AMPDU_IS_LAST)
+			flags |= IEEE80211_RADIOTAP_AMPDU_IS_LAST;
+		if (status->flag & RX_FLAG_AMPDU_DELIM_CRC_ERROR)
+			flags |= IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_ERR;
+		if (status->flag & RX_FLAG_AMPDU_DELIM_CRC_KNOWN)
+			flags |= IEEE80211_RADIOTAP_AMPDU_DELIM_CRC_KNOWN;
+		put_unaligned_le16(flags, pos);
+		pos += 2;
+		if (status->flag & RX_FLAG_AMPDU_DELIM_CRC_KNOWN)
+			*pos++ = status->ampdu_delimiter_crc;
+		else
+			*pos++ = 0;
+		*pos++ = 0;
+	}
 }
 
 /*
-- 
1.7.10.4

