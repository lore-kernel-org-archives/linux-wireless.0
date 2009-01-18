Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f12.google.com ([209.85.219.12]:65364 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZARQ5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 11:57:23 -0500
Received: by ewy5 with SMTP id 5so597226ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 08:57:21 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2.6.29-rc2 - rt61pci regression
Date: Sun, 18 Jan 2009 17:57:18 +0100
Cc: linux-wireless@vger.kernel.org
References: <c6b1100b0901180730y4d32dfabn8de0024b4fc1c749@mail.gmail.com> <200901181728.13706.IvDoorn@gmail.com> <c6b1100b0901180850w4ab737a8la09489d7bd1ef964@mail.gmail.com>
In-Reply-To: <c6b1100b0901180850w4ab737a8la09489d7bd1ef964@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901181757.18648.IvDoorn@gmail.com> (sfid-20090118_175727_614053_97688673)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 18 January 2009, Chris Clayton wrote:
> 2009/1/18 Ivo van Doorn <ivdoorn@gmail.com>:
> >> > Feel free to request any additional information needed to resolve this problem.
> >>
> >> Could you try below patch?
> >>
> >> Thanks,
> >>
> >> Ivo
> >
> > Hi,
> >
> > Sorry, patch won't apply correctly since rt2x00ht_create_tx_descriptor(entry, txdesc, rate); isn't
> > in 2.6.29 yet. Below is the correct patch
> >
> > Ivo
> >
> Sorry Ivo, that neither patch applies. The second one you sent gives
> 
> [chris:~/kernel/linux-2.6]$ patch -p1 < ~/ivo.patch
> patching file drivers/net/wireless/rt2x00/rt2x00queue.c
> Hunk #1 FAILED at 186.
> Hunk #2 succeeded at 314 (offset 81 lines).
> Hunk #3 FAILED at 408.
> 2 out of 3 hunks FAILED -- saving rejects to file
> drivers/net/wireless/rt2x00/rt2x00queue.c.rej
> 
> Are you preparing patches against current wireless git? -rc2 may be a
> bit behind that

Ok, I just pulled linux-2.6.git so this should apply cleanly/

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 746a8f3..0709dec 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -154,6 +154,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
+	struct ieee80211_tx_rate *txrate = &tx_info->control.rates[0];
 	struct ieee80211_rate *rate =
 	    ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
 	const struct rt2x00_rate *hwrate;
@@ -313,7 +314,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 		 * When preamble is enabled we should set the
 		 * preamble bit for the signal.
 		 */
-		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+		if (txrate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 			txdesc->signal |= 0x08;
 	}
 }
