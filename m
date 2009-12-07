Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42529 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZLGQgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 11:36:43 -0500
Received: by fxm5 with SMTP id 5so5160168fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 08:36:48 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [RFT] ar9170: AP broadcast buffering
Date: Mon, 7 Dec 2009 17:36:40 +0100
Cc: linux-wireless@vger.kernel.org
References: <200911290206.07784.chunkeey@googlemail.com> <4B1BF68D.8060907@web.de>
In-Reply-To: <4B1BF68D.8060907@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200912071736.40929.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 December 2009 19:23:09 Jan Kiszka wrote:
> Christian Lamparter wrote:
> > This patch should fix "broadcast traffic before DTIM beacon",
> > But there is a downside: the broadcast (e.g arp) frames
> > might get delayed and won't make it in time.
> > 
> > let me know, if this patch does any good, or not...
> 
> Mmm, how is this supposed to work?
The driver sets the PRETBTT interval and the HW will trigger
the PRETBTT event. Which will tell the driver to update the beacon,
which _in turn_ triggers the BCN_CFG event and the buffered
BC frames are _released_ into the queues.

Now the problem is that under traffic the BC/MC frames might
be delayed in the tx_pending queues and don't make it in time.

> I still haven't started hacking on this as well, but I read a bit
> about DTIM.
> One thing I think to have understood is that the DTIM interval is typically
> larger than the beacon interval. There is even some interrupt on ar9170
> indicating this event, it's just not enabled yet.
Na, I _think_ that BIT is meant for the PS/station mode and
is used to say to the fw/driver to stay alert for incoming
broadcast/multicast data.

If this really is the case, then I'm afraid to say:
the bit is probably for little use in this situation. 
> Moreover, I do not yet understand how deferring multicast frames works
> in this patch. How are they filtered out from normal frames and queued
> until the beacon event? (But that misunderstanding might be due to the
> fact that I haven't read the whole driver code yet.)
ar9170 does not have a "Content After Beacon" queue like p54 or ath5k/ath9k.
But luckily the mac80211 stack provides the necessary queuing mechanism.
And all the driver needs to do: 
 - set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING
 - grab the buffered BC/MC frames and push them to the device.

Note:

That's the current situation. But maybe you'll be in for a big surprise.
There is a special firmware & driver: "carl9170", which will add several
useful features:
 * accurate tx status feedback
 * _CAB_ queuing in firmware
  => this should be enough to finally enable NL80211_IFTYPE_AP / MESH.

 * multirate retry support (minstrel)
  => improve performance in suboptimal environments.

 * Real Hardware QoS support.
   (But unfortunately with a catch)

I hope it will be ready for Christmas ;-)

Regards,
	Chr
