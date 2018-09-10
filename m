Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51232 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbeIJP5U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 11:57:20 -0400
Message-ID: <1536577419.3224.50.camel@sipsolutions.net> (sfid-20180910_130352_636568_F78AF419)
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 13:03:39 +0200
In-Reply-To: <87musplivy.fsf@toke.dk>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897010.14170.2992498632345986102.stgit@alrua-x1>
         <1536565717.3224.12.camel@sipsolutions.net> <87musplivy.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-10 at 12:57 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Sat, 2018-09-08 at 00:22 +0200, Toke Høiland-Jørgensen wrote:
> > > 
> > > Usage of the new API is optional, so drivers can be ported one at a time.
> > 
> > With the 1:1 hardware queue/txq mapping in iwlwifi (we're close to
> > getting that patch in, though now the Jewish holidays mean a delay),
> > I'm not sure we'd be able to do this at all in iwlwifi. So this may
> > not be a case of porting one at a time until we can get rid of it ...
> 
> Could you elaborate a bit more on how the hwq/txq stuff works in iwl?

I can try.

> Does the driver just hand off a TXQ to the hardware on wake_txq(), which
> is then scheduled by the hardware after that? Or how does the mapping to
> hwqs work, and how is the hardware notified that there are still packets
> queued / that new packets have arrived for an already mapped txq?

Basically, we use the TXQ driver data to do this. On initialization, we
set all TXQs to have no hardware queue mapped. Then, when the first wake
happens for this TXQ, we allocate a hardware queue for this RA/TID.

>From then on, right now we basically just try to refill the hardware
queue from the TXQ whenever the hardware releases frames from that
queue. If there are none, we fall back to putting them on the hardware
queue from the wake signal.

> > It would be nice to be able to use it, for better queue behaviour, but
> > it would mean much more accounting in iwlwifi? Not even sure off the
> > top of my head how to do that.
> 
> I think we'll need to have some kind of fallback airtime estimation in
> mac80211 that calculates airtime from packet size and rate information.
> Not all drivers can get this from the hardware, it seems. See my reply
> to Kan about the BQL-like behaviour as well.
> 
> Does iwl get airtime usage information for every packet on tx complete?

Yes, we do.

johannes
