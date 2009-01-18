Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:62879 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZARQ2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 11:28:19 -0500
Received: by ey-out-2122.google.com with SMTP id 22so445196eye.37
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 08:28:17 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2.6.29-rc2 - rt61pci regression
Date: Sun, 18 Jan 2009 17:28:13 +0100
Cc: linux-wireless@vger.kernel.org
References: <c6b1100b0901180730y4d32dfabn8de0024b4fc1c749@mail.gmail.com> <200901181723.56783.IvDoorn@gmail.com>
In-Reply-To: <200901181723.56783.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200901181728.13706.IvDoorn@gmail.com> (sfid-20090118_172824_045720_FBE63B65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Feel free to request any additional information needed to resolve this problem.
> 
> Could you try below patch?
> 
> Thanks,
> 
> Ivo

Hi,

Sorry, patch won't apply correctly since rt2x00ht_create_tx_descriptor(entry, txdesc, rate); isn't
in 2.6.29 yet. Below is the correct patch

Ivo

---
Subject: Fix preamble detection by using correct structure to read flags
 
rt2x00 mixed up structures ieee80211_tx_rate and ieee80211_rate to
read the IEEE80211_TX_RC_USE_SHORT_PREAMBLE flags. This could lead
to incorrect preamble detection.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index c1e5a05..3dab9b4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -186,10 +186,11 @@ static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
 
 static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
 						  struct txentry_desc *txdesc,
-						  struct ieee80211_rate *rate)
+						  const struct rt2x00_rate *hwrate)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	const struct rt2x00_rate *hwrate = rt2x00_get_rate(rate->hw_value);
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
+	const struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
 	unsigned int data_length;
 	unsigned int duration;
 	unsigned int residual;
@@ -232,7 +233,7 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
 		 * When preamble is enabled we should set the
 		 * preamble bit for the signal.
 		 */
-		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+		if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 			txdesc->signal |= 0x08;
 	}
 }
@@ -326,7 +327,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 */
 	rt2x00crypto_create_tx_descriptor(entry, txdesc);
 	rt2x00queue_create_tx_descriptor_seq(entry, txdesc);
-	rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, rate);
+	rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, hwrate);
 }
 
 static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
