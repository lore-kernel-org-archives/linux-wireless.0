Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:34413 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbYBAWyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 17:54:25 -0500
Received: by wa-out-1112.google.com with SMTP id v27so954336wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 14:54:25 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Date: Fri, 1 Feb 2008 23:54:02 +0100
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
References: <1201882512.4188.66.camel@johannes.berg> <200802012316.44283.IvDoorn@gmail.com> <1201904975.4188.88.camel@johannes.berg>
In-Reply-To: <1201904975.4188.88.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802012354.02903.IvDoorn@gmail.com> (sfid-20080201_225428_693812_9732FB4E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > All patches are currently in testing, and I hope to send them to wireless-2.6
> > next weekend.
> 
> Ah cool, I'll hold off on doing anything then until then.
> 
> > rt2400pci, rt2500pci and rt2500usb have a special dedicated queue which is called
> > the ATIM queue. The implementation is a guess since it was never used in the
> > legacy drivers. But it is clear it contains frames which are send directly after the beacon.
> 
> Well I'd guess this is for the ATIM window. Broadcom firmware actually
> has an ATIM queue *and* a broadcast/multicast queue, I would expect that
> you should actually put broadcast/multicast traffic onto the beacon
> queue (unless the beacon queue only sends one packet per beacon
> interval)

In all Ralink drivers the beacon queue will only send out the frame each interval,
where rt2400pci and rt2500pci a interrupt will be triggered to request a new
beacon frame.

> ATIM is actually one of the things I haven't fully understood yet, see
> IEEE 802.11 11.2.2.
> 
> > >      4. remove IEEE80211_TX_QUEUE_SVP, it's something strange and
> > >         atheros specific
> > 
> > I always wondered what the queue was. ;)
> 
> spectralink voice protocol. I have not even the slightest clue.
> 
> > HCCA queue is a big mysterie, there are registers to initialize it inside the device,
> > but in implementation of the legacy driver the queue was unused, I haven't found a
> > correct entry point yet to send frames over it, since that interface seems to be missing
> > in the device... So either I am missing something or the queue was half-implemented
> > in the device itself.. :S
> 
> No idea, that's HCF (802.11e) stuff. Maybe they just never got around to
> finishing that implementation.

Or the documenation is just missing. ;)
In any case it will remain unused for rt61pci and rt73usb. I have seen some other
queue handling in the legacy rt2800 drivers but that driver needs more investigation
before I can say anything usefull about it.

Ivo
