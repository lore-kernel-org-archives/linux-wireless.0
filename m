Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f12.google.com ([209.85.219.12]:56524 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZARQYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 11:24:01 -0500
Received: by ewy5 with SMTP id 5so585543ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 08:23:59 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2.6.29-rc2 - rt61pci regression
Date: Sun, 18 Jan 2009 17:23:56 +0100
Cc: linux-wireless@vger.kernel.org
References: <c6b1100b0901180730y4d32dfabn8de0024b4fc1c749@mail.gmail.com>
In-Reply-To: <c6b1100b0901180730y4d32dfabn8de0024b4fc1c749@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200901181723.56783.IvDoorn@gmail.com> (sfid-20090118_172408_365733_84908933)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 18 January 2009, Chris Clayton wrote:
> Hi,
> 
> Firstly, I'm not subscribed, so please cc me on any reply.
> 
> I started testing 2.6.29 on my laptop yesterday and find that my
> wireless connection, which works fine on 2.6.28, is not working. The
> output from dmesg is attached. lspci shows the wireless card as:
> 
> 03:00.0 Network controller: RaLink RT2561/RT61 802.11g PCI
>         Subsystem: Belkin Device 701e
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64, Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 11
>         Region 0: Memory at f4000000 (32-bit, non-prefetchable) [size=32K]
>         Capabilities: <access denied>
>         Kernel driver in use: rt61pci
>         Kernel modules: rt61pci
> 
> Today, I've bisected and found that the problem is caused by:
> 
> [chris:~/kernel/linux-2.6]$ git bisect good
> 3ea96463156123cbfd09ac412012a87fef068830 is first bad commit
> commit 3ea96463156123cbfd09ac412012a87fef068830
> Author: Ivo van Doorn <ivdoorn@gmail.com>
> Date:   Sun Jan 4 17:33:25 2009 +0100
> 
>     rt2x00: Fix TX short preamble detection
> 
>     The short preamble mode was not correctly detected during TX,
>     rt2x00 used the rate->hw_value_short field but mac80211 is not
>     using this field that way.
>     Instead the flag IEEE80211_TX_RC_USE_SHORT_PREAMBLE should be
>     used to determine if the frame should be send out using
>     short preamble or not.
> 
>     Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> :040000 040000 efa4788721fcbc8366f6c75c09fa276a17713004
> 696761e1c46d0e5f1040df19c48be9c2f4d173f7 M      drivers
> 
> Reverting this patch from -rc2 makes my wireless connection work again.
> 
> Feel free to request any additional information needed to resolve this problem.

Could you try below patch?

Thanks,

Ivo
---
Subject: Fix preamble detection by using correct structure to read flags

rt2x00 mixed up structures ieee80211_tx_rate and ieee80211_rate to
read the IEEE80211_TX_RC_USE_SHORT_PREAMBLE flags. This could lead
to incorrect preamble detection.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index ce06d00..3c2a8bd 100644
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
@@ -327,7 +328,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	rt2x00crypto_create_tx_descriptor(entry, txdesc);
 	rt2x00ht_create_tx_descriptor(entry, txdesc, rate);
 	rt2x00queue_create_tx_descriptor_seq(entry, txdesc);
-	rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, rate);
+	rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, hwrate);
 }
 
 static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,

