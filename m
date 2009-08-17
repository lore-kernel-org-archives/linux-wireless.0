Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:23125 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbZHQQ4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 12:56:30 -0400
Received: by ey-out-2122.google.com with SMTP id 22so711134eye.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 09:56:32 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 7/7] rt2x00: Add support for retry rates
Date: Mon, 17 Aug 2009 18:56:10 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
References: <200908171853.24256.IvDoorn@gmail.com> <200908171855.15390.IvDoorn@gmail.com> <200908171855.40486.IvDoorn@gmail.com>
In-Reply-To: <200908171855.40486.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908171856.10503.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benoit PAPILLAULT <benoit.papillault@free.fr>

rt2800pci can handle different retry rates,
it will always step 1 rate down after a failed
transmission so creating the retry rate list
for mac80211 is quite simple.

Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   22 +++++++++++++++++-----
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b6676c6..9ab70e4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -220,7 +220,8 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
 	unsigned int header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
-	u8 rate_idx, rate_flags;
+	u8 rate_idx, rate_flags, retry_rates;
+	unsigned int i;
 
 	/*
 	 * Unmap the skb.
@@ -259,16 +260,27 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 
 	rate_idx = skbdesc->tx_rate_idx;
 	rate_flags = skbdesc->tx_rate_flags;
+	retry_rates = test_bit(TXDONE_FALLBACK, &txdesc->flags) ?
+	    (txdesc->retry + 1) : 1;
 
 	/*
 	 * Initialize TX status
 	 */
 	memset(&tx_info->status, 0, sizeof(tx_info->status));
 	tx_info->status.ack_signal = 0;
-	tx_info->status.rates[0].idx = rate_idx;
-	tx_info->status.rates[0].flags = rate_flags;
-	tx_info->status.rates[0].count = txdesc->retry + 1;
-	tx_info->status.rates[1].idx = -1; /* terminate */
+
+	/*
+	 * Frame was send with retries, hardware tried
+	 * different rates to send out the frame, at each
+	 * retry it lowered the rate 1 step.
+	 */
+	for (i = 0; i < retry_rates && i < IEEE80211_TX_MAX_RATES; i++) {
+		tx_info->status.rates[i].idx = rate_idx - i;
+		tx_info->status.rates[i].flags = rate_flags;
+		tx_info->status.rates[i].count = 1;
+	}
+	if (i < (IEEE80211_TX_MAX_RATES -1))
+		tx_info->status.rates[i].idx = -1; /* terminate */
 
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		if (test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 47d175a..a5591fb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -214,6 +214,7 @@ struct rxdone_entry_desc {
  *
  * @TXDONE_UNKNOWN: Hardware could not determine success of transmission.
  * @TXDONE_SUCCESS: Frame was successfully send
+ * @TXDONE_FALLBACK: Frame was successfully send using a fallback rate.
  * @TXDONE_FAILURE: Frame was not successfully send
  * @TXDONE_EXCESSIVE_RETRY: In addition to &TXDONE_FAILURE, the
  *	frame transmission failed due to excessive retries.
@@ -221,6 +222,7 @@ struct rxdone_entry_desc {
 enum txdone_entry_desc_flags {
 	TXDONE_UNKNOWN,
 	TXDONE_SUCCESS,
+	TXDONE_FALLBACK,
 	TXDONE_FAILURE,
 	TXDONE_EXCESSIVE_RETRY,
 };
-- 
1.6.4

