Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.infomaniak.ch ([84.16.68.90]:59801 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZESPyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 11:54:45 -0400
From: Alexandre Becholey <alexandre.becholey@epfl.ch>
To: linux-wireless@vger.kernel.org
Cc: ivdoorn@gmail.com, Alexandre Becholey <alexandre.becholey@epfl.ch>
Subject: [PATCH v2]rt73usb: fix for master mode
Date: Tue, 19 May 2009 17:52:56 +0200
Message-Id: <1242748376-8993-1-git-send-email-alexandre.becholey@epfl.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report status unknown as if there were successfully transmitted.
This will avoid hostapd to disassociate because it doesn't understand what a status unknown is.

Signed-off-by: Alexandre Becholey <alexandre.becholey@epfl.ch>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f227084..57813e7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -260,7 +260,8 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 * Update TX statistics.
 	 */
 	rt2x00dev->link.qual.tx_success +=
-	    test_bit(TXDONE_SUCCESS, &txdesc->flags);
+	    test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
+	    test_bit(TXDONE_UNKNOWN, &txdesc->flags);
 	rt2x00dev->link.qual.tx_failed +=
 	    test_bit(TXDONE_FAILURE, &txdesc->flags);
 
@@ -278,14 +279,16 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	tx_info->status.rates[1].idx = -1; /* terminate */
 
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
+		if (test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
+				test_bit(TXDONE_UNKNOWN, &txdesc->flags))
 			tx_info->flags |= IEEE80211_TX_STAT_ACK;
 		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}
 
 	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
-		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
+		if (test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
+				test_bit(TXDONE_UNKNOWN, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
 		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11RTSFailureCount++;
-- 
1.6.3

