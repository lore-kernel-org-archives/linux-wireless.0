Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42721 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZH2RKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 13:10:16 -0400
Received: by ewy2 with SMTP id 2so2932665ewy.17
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2009 10:10:17 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix TX status reporting
Date: Sat, 29 Aug 2009 19:10:14 +0200
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908291910.14528.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not all values of the TX status enumeration were
covered during updating of the TX statistics. This
could lead to wrong bitrate tuning but also wrong
behavior in tools like hostapd.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5db613f..71761b3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -206,6 +206,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	unsigned int header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
 	u8 rate_idx, rate_flags, retry_rates;
 	unsigned int i;
+	bool success;
 
 	/*
 	 * Unmap the skb.
@@ -234,13 +235,18 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
 
 	/*
-	 * Update TX statistics.
+	 * Determine if the frame has been successfully transmitted.
 	 */
-	rt2x00dev->link.qual.tx_success +=
+	success =
 	    test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
-	    test_bit(TXDONE_UNKNOWN, &txdesc->flags);
-	rt2x00dev->link.qual.tx_failed +=
-	    test_bit(TXDONE_FAILURE, &txdesc->flags);
+	    test_bit(TXDONE_UNKNOWN, &txdesc->flags) ||
+	    test_bit(TXDONE_FALLBACK, &txdesc->flags);
+
+	/*
+	 * Update TX statistics.
+	 */
+	rt2x00dev->link.qual.tx_success += success;
+	rt2x00dev->link.qual.tx_failed += !success;
 
 	rate_idx = skbdesc->tx_rate_idx;
 	rate_flags = skbdesc->tx_rate_flags;
@@ -263,22 +269,20 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 		tx_info->status.rates[i].flags = rate_flags;
 		tx_info->status.rates[i].count = 1;
 	}
-	if (i < (IEEE80211_TX_MAX_RATES -1))
+	if (i < (IEEE80211_TX_MAX_RATES - 1))
 		tx_info->status.rates[i].idx = -1; /* terminate */
 
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		if (test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
-				test_bit(TXDONE_UNKNOWN, &txdesc->flags))
+		if (success)
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
-		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
+		else
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}
 
 	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
-		if (test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
-				test_bit(TXDONE_UNKNOWN, &txdesc->flags))
+		if (success)
 			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
-		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
+		else
 			rt2x00dev->low_level_stats.dot11RTSFailureCount++;
 	}
 
-- 
1.6.4.1

