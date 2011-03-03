Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59983 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1CCSsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:50 -0500
Received: by wwe15 with SMTP id 15so285125wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:49 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/19] rt2x00: Don't call ieee80211_get_tx_rate for MCS rates
Date: Thu, 3 Mar 2011 19:43:49 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031942.58935.IvDoorn@gmail.com> <201103031943.26328.IvDoorn@gmail.com>
In-Reply-To: <201103031943.26328.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031943.50656.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

ieee80211_get_tx_rate is not valid for HT rates. Hence, restructure the
TX desciptor creation to be aware of MCS rates. The generic TX desciptor
creation now cares about the rate_mode (CCK, OFDM, MCS, GF).

As a result, ieee80211_get_tx_rate gets only called for legacy rates.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00ht.c    |    8 --------
 drivers/net/wireless/rt2x00/rt2x00queue.c |   22 +++++++++++++++-------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00ht.c b/drivers/net/wireless/rt2x00/rt2x00ht.c
index 78a0e73..ae1219d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ht.c
+++ b/drivers/net/wireless/rt2x00/rt2x00ht.c
@@ -78,14 +78,6 @@ void rt2x00ht_create_tx_descriptor(struct queue_entry *entry,
 		__set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
 
 	/*
-	 * Determine HT Mix/Greenfield rate mode
-	 */
-	if (txrate->flags & IEEE80211_TX_RC_MCS)
-		txdesc->rate_mode = RATE_MODE_HT_MIX;
-	if (txrate->flags & IEEE80211_TX_RC_GREEN_FIELD)
-		txdesc->rate_mode = RATE_MODE_HT_GREENFIELD;
-
-	/*
 	 * Set 40Mhz mode if necessary (for legacy rates this will
 	 * duplicate the frame to both channels).
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 6300cf3..f06b5c7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -321,9 +321,9 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
-	struct ieee80211_rate *rate =
-	    ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
-	const struct rt2x00_rate *hwrate;
+	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
+	struct ieee80211_rate *rate;
+	const struct rt2x00_rate *hwrate = NULL;
 
 	memset(txdesc, 0, sizeof(*txdesc));
 
@@ -390,10 +390,18 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	/*
 	 * Determine rate modulation.
 	 */
-	hwrate = rt2x00_get_rate(rate->hw_value);
-	txdesc->rate_mode = RATE_MODE_CCK;
-	if (hwrate->flags & DEV_RATE_OFDM)
-		txdesc->rate_mode = RATE_MODE_OFDM;
+	if (txrate->flags & IEEE80211_TX_RC_GREEN_FIELD)
+		txdesc->rate_mode = RATE_MODE_HT_GREENFIELD;
+	else if (txrate->flags & IEEE80211_TX_RC_MCS)
+		txdesc->rate_mode = RATE_MODE_HT_MIX;
+	else {
+		rate = ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
+		hwrate = rt2x00_get_rate(rate->hw_value);
+		if (hwrate->flags & DEV_RATE_OFDM)
+			txdesc->rate_mode = RATE_MODE_OFDM;
+		else
+			txdesc->rate_mode = RATE_MODE_CCK;
+	}
 
 	/*
 	 * Apply TX descriptor handling by components
-- 
1.7.2.3

