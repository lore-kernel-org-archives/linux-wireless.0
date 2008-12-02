Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:33793 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYLBRXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 12:23:13 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1328678eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 09:23:13 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/5] rt2x00: Store retry limit values
Date: Tue, 2 Dec 2008 18:20:04 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200812021819.23756.IvDoorn@gmail.com> <200812021819.48603.IvDoorn@gmail.com>
In-Reply-To: <200812021819.48603.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812021820.05124.IvDoorn@gmail.com> (sfid-20081202_182319_294943_9B3919CE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store retry limit values in the rt2x00dev structure.
This allows the removal of the FIXME where we assumed
the long retry is only used when working with RTS frames.

Instead we should check the current retry limit values
and decide if the required retry count for this frame
is a long or short retry.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00config.c |    2 ++
 drivers/net/wireless/rt2x00/rt2x00queue.c  |    9 +--------
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 780ba73..e7ed56d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -803,6 +803,12 @@ struct rt2x00_dev {
 	u16 tx_power;
 
 	/*
+	 * Current retry values.
+	 */
+	u8 short_retry;
+	u8 long_retry;
+
+	/*
 	 * Rssi <-> Dbm offset
 	 */
 	u8 rssi_offset;
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 7c62ce1..b3bc8b4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -194,6 +194,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00dev->curr_band = conf->channel->band;
 	rt2x00dev->tx_power = conf->power_level;
+	rt2x00dev->short_retry = conf->short_frame_max_tx_count;
+	rt2x00dev->long_retry = conf->long_frame_max_tx_count;
 
 	rt2x00dev->rx_status.band = conf->channel->band;
 	rt2x00dev->rx_status.freq = conf->channel->center_freq;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index b8de9d2..7f908a1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -231,14 +231,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * Determine retry information.
 	 */
 	txdesc->retry_limit = tx_info->control.rates[0].count - 1;
-	/*
-	 * XXX: If at this point we knew whether the HW is going to use
-	 *	the RETRY_MODE bit or the retry_limit (currently all
-	 *	use the RETRY_MODE bit) we could do something like b43
-	 *	does, set the RETRY_MODE bit when the RC algorithm is
-	 *	requesting more than the long retry limit.
-	 */
-	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+	if (txdesc->retry_limit >= rt2x00dev->long_retry)
 		__set_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags);
 
 	/*
-- 
1.5.6.1

