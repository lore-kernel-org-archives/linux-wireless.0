Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62576 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab0JKNkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 09:40:31 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so574157ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 06:40:31 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/7] rt2x00: Validate MCS on RX path
Date: Mon, 11 Oct 2010 15:38:07 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010111537.26584.IvDoorn@gmail.com> <201010111537.48587.IvDoorn@gmail.com>
In-Reply-To: <201010111537.48587.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010111538.08677.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to the PLCP signal and bitrates values,
we should validate the MCS value from the RX descriptor
before sending it to mac80211.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   74 ++++++++++++++++---------------
 1 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9b745fa..db25209 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -432,36 +432,44 @@ static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_supported_band *sband;
 	const struct rt2x00_rate *rate;
 	unsigned int i;
-	int signal;
-	int type;
+	int signal = rxdesc->signal;
+	int type = (rxdesc->dev_flags & RXDONE_SIGNAL_MASK);
 
-	/*
-	 * For non-HT rates the MCS value needs to contain the
-	 * actually used rate modulation (CCK or OFDM).
-	 */
-	if (rxdesc->dev_flags & RXDONE_SIGNAL_MCS)
-		signal = RATE_MCS(rxdesc->rate_mode, rxdesc->signal);
-	else
-		signal = rxdesc->signal;
-
-	type = (rxdesc->dev_flags & RXDONE_SIGNAL_MASK);
-
-	sband = &rt2x00dev->bands[rt2x00dev->curr_band];
-	for (i = 0; i < sband->n_bitrates; i++) {
-		rate = rt2x00_get_rate(sband->bitrates[i].hw_value);
-
-		if (((type == RXDONE_SIGNAL_PLCP) &&
-		     (rate->plcp == signal)) ||
-		    ((type == RXDONE_SIGNAL_BITRATE) &&
-		      (rate->bitrate == signal)) ||
-		    ((type == RXDONE_SIGNAL_MCS) &&
-		      (rate->mcs == signal))) {
-			return i;
+	switch (rxdesc->rate_mode) {
+	case RATE_MODE_CCK:
+	case RATE_MODE_OFDM:
+		/*
+		 * For non-HT rates the MCS value needs to contain the
+		 * actually used rate modulation (CCK or OFDM).
+		 */
+		if (rxdesc->dev_flags & RXDONE_SIGNAL_MCS)
+			signal = RATE_MCS(rxdesc->rate_mode, signal);
+
+		sband = &rt2x00dev->bands[rt2x00dev->curr_band];
+		for (i = 0; i < sband->n_bitrates; i++) {
+			rate = rt2x00_get_rate(sband->bitrates[i].hw_value);
+			if (((type == RXDONE_SIGNAL_PLCP) &&
+			     (rate->plcp == signal)) ||
+			    ((type == RXDONE_SIGNAL_BITRATE) &&
+			      (rate->bitrate == signal)) ||
+			    ((type == RXDONE_SIGNAL_MCS) &&
+			      (rate->mcs == signal))) {
+				return i;
+			}
 		}
+		break;
+	case RATE_MODE_HT_MIX:
+	case RATE_MODE_HT_GREENFIELD:
+		if (signal >= 0 && signal <= 76)
+			return signal;
+		break;
+	default:
+		break;
 	}
 
 	WARNING(rt2x00dev, "Frame received with unrecognized signal, "
-		"signal=0x%.4x, type=%d.\n", signal, type);
+		"mode=0x%.4x, signal=0x%.4x, type=%d.\n",
+		rxdesc->rate_mode, signal, type);
 	return 0;
 }
 
@@ -523,18 +531,12 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 	skb_trim(entry->skb, rxdesc.size);
 
 	/*
-	 * Check if the frame was received using HT. In that case,
-	 * the rate is the MCS index and should be passed to mac80211
-	 * directly. Otherwise we need to translate the signal to
-	 * the correct bitrate index.
+	 * Translate the signal to the correct bitrate index.
 	 */
-	if (rxdesc.rate_mode == RATE_MODE_CCK ||
-	    rxdesc.rate_mode == RATE_MODE_OFDM) {
-		rate_idx = rt2x00lib_rxdone_read_signal(rt2x00dev, &rxdesc);
-	} else {
+	rate_idx = rt2x00lib_rxdone_read_signal(rt2x00dev, &rxdesc);
+	if (rxdesc.rate_mode == RATE_MODE_HT_MIX ||
+	    rxdesc.rate_mode == RATE_MODE_HT_GREENFIELD)
 		rxdesc.flags |= RX_FLAG_HT;
-		rate_idx = rxdesc.signal;
-	}
 
 	/*
 	 * Update extra components
-- 
1.7.2.3

