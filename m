Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47479 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab2FQKm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jun 2012 06:42:26 -0400
Received: by wibhm6 with SMTP id hm6so828465wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2012 03:42:24 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "David Lynch Jr." <ml@dlasys.net>
Subject: Re: CARL9170 driver/firmware questions
Date: Sun, 17 Jun 2012 12:42:20 +0200
Cc: linux-wireless@vger.kernel.org
References: <CADdUxCwt35GQU2j-a4AvvJVS=h93sgBqg09CZNxTivRfbYsqzg@mail.gmail.com> <201204252201.50803.chunkeey@googlemail.com> <1339901627.7998.15.camel@hp-dhlii>
In-Reply-To: <1339901627.7998.15.camel@hp-dhlii>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206171242.20559.chunkeey@googlemail.com> (sfid-20120617_124229_854856_CB1603E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 June 2012 04:53:47 David Lynch Jr. wrote:
> I am working on another AR9170 project. 
> This essentially requires injecting broadcast packets
> of specific size, frequency, ... at extremely precise
> intervals.
Sounds pretty much like TDOA (and Gary). But anyway, if
you are just looking for a noise "pattern generator", you
might as well look into the "radar" branch of the carl9170
firmware.

> I am trying to understand the data flow in the firmware. 
> 
> Initially I was looking to generate the frames in the firmware.
Well, there's "wlan_tx_fw" in wlan.c. Which can be used by the
firmware code to send out frames (Note: it's currently used to
sent BA when the device received a BAR from a HT peer)

> Am I correct that the same struct dma_desc is being used by
> both USB and the Radio?
Yes, it's a common data structure for lockless, vectored IO.

> Each dma_desc points to a payload, for tx packets this is a struct
> carl9170_tx_superframe, which must also be what the skb pointed to by 
> void carl9170_usb_tx(struct ar9170 *ar, struct sk_buff *skb) is
> sending ?
Yes. Altough, the (wlan) hardware will only cares about the 
ar9170_tx_frame struct which is embedded in the superframe.
So, the carl9170_tx_superdesc is "hidden" by wlan_tx before
the frame is sent down to the MAC's tx queue.
And likewise: unhide_super when the frame is given back to
the USB download queue.

> Can I construct a carl9170_tx_superframe on the host side, with
> something to allow me to identify it in handle_download in the firmware,
> perform minor mangling of the contents, and repeatedly transmit it at
> fixed intervals using wlan_tx() ?
Sure, the carl9170_tx_superdesc still has a unused u8 ["padding2"].
So, you can define your own set of flags and values right there. 
(Of course, you could also hijack rix and cnt - Note: this will work
if you only need to detect that the frames it needs to be handled
differently in handle_download since wlan_tx does override these
early on).

But if you need to repeatedly transmit frames, then the beaconing
mechanism might be worth a look. In theory it should be jitter
free since it is completely handled by the hardware.

Regards,
	Chr
