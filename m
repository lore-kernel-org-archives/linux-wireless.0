Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752409AbdHINpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 09:45:01 -0400
Message-ID: <1502286213.9777.3.camel@redhat.com> (sfid-20170809_154504_725636_E4B74F5C)
Subject: Re: wireless drivers fail to report link speed?
From: Dan Williams <dcbw@redhat.com>
To: james@nurealm.net, Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 09 Aug 2017 08:43:33 -0500
In-Reply-To: <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net>
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
         <1502228547.24881.5.camel@redhat.com>
         <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
         <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
         <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com>
         <3d16a276-0e15-c722-483c-c17d715ebb5e@nurealm.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-08-08 at 18:36 -0600, James Feeney wrote:
> Hey
> 
> On 08/08/2017 04:49 PM, Ben Greear wrote:
> > 
> > Some time back, I added some support to ath10k to report some
> > ethtool info.
> > At least most of this is upstream.  I do report rx and rx link
> > rate, and yes,
> > it changes, but it does contain some useful info, at least when
> > modest amounts
> > of packets are being transmitted and received (so that rate-ctrl
> > logic
> > is working).  I think the stuff not prepended with d_ will show up
> > for any
> > mac80211 driver.  Someone could improve ethtool to report these
> > through more
> > normal API than just getting the stats if they wanted...
> 
> Hmm - would you then lean in the direction of saying that this
> failure to report
> a link speed is a fault in the kernel ethtool?

No, it's not a fault of ethtool.  Ethtool only reports something, it's
up to the thing that interprets that data (eg, bonding) to do the right
thing with it.

> And, if so, would an update be required in just the kernel ethtool,
> or in both
> the kernel ethtool and in every wireless driver?

Likely every wireless driver, except that for mac80211-based drivers it
would only take updating the mac80211 stack.

I'm not really arguing against updating mac80211 to report this
information if somebody actually wants to do the patch.  I'm only
saying that even with the patch, it's not going to do exactly what you
want it to do, and even if it works for you 90% of the time, it's not
going to work for others that much of the time, and thus it gives a
false sense of "correctness" which is just wrong.

> Should the kernel ethtool get_settings() be made to report a proper
> link speed
> and duplex when used with the wireless drivers?
> 
> On 08/08/2017 05:43 PM, Dan Williams wrote:
> > 
> > It's very relevant to the question.  Because if the speed is
> > actually
> > not useful for the requested purpose, there is no real point in
> > having
> > it reported it via ethtool.  Same for duplex.  Wifi is only "half
> > duplex", and so the property is actually meaningless for WiFi.
> 
> That seems a little over-broad, at least certainly with respect to
> "half
> duplex".  If the link is known to be half duplex, then the kernel
> ethtool can
> simply report that the link is "half duplex".  I am not hearing a
> good
> justification, or a necessity, for the kernel ethtool to return an
> error, instead.

> > At
> > worst, your bonding link will flip-flop between slaves every second
> > or
> > two.  At best, bonding won't do anything differently than if the
> > speed
> > was just faked to some fake lowest common denominator number so
> > that
> > your wired link was always faster.
> 
> Well ok, flip-flopping every second would seem a pointless and bad
> effect.  But
> then, for instance, my rtl8192ce driver shows a stable, actual link
> speed:
> 
> $ iwconfig wlp2s0
> ...
> Bit Rate=72.2 Mb/s
> ...

iwconfig cannot report high rates, so try 'iw dev <name> link' to make
sure.

When I did 'iw dev wlp4s0 link' with a 2.4GHz baby monitor on in the
next room, my device flipped continuously between ~70Mb/s and 130Mb/s
every couple seconds. YMMV.  It's gonna be the same anywhere near a
microwave.

> $ ethtool -S wlp2s0
> ...
>      txrate: 72200000
>      rxrate: 1000000
> ...
> 
> Then, I don't know if this effect is as bad as you suggest.  Is there
> an actual
> "stable" link speed here?  Or is this an "illusion", of bit of
> "fluff" being
> promoted by the user-space iwconfig and ethtool?

There is no "stable" link speed.  The link selects the maximum speed
that produces as few errors as possible, and adjusts that speed
continuously due to the radio environment.  Again, many external
factors that you have no control over affect link speed.

In the span of 5 seconds, 2 feet away from my 11n AP, my link went
through 65Mb, 130Mb, 78Mb, and back to 130Mb.  That's just how this
works.

It's like if your ethernet link dynamically adjusted speed from 2Mb/s
up to 10Gb/s based on how much traffic was going through it at a given
time, or to save power, or something.

> > Sure, somebody could do a patch (like Ben has) that plumbs all this
> > stuff through.  But that's not solving the *actual* problem, which
> > is
> > that this bonding change makes assumptions of slave devices that
> > simply
> > don't match how those devices work.
> 
> I take it that your position would be that the bonding module people,
> and Mahesh
> in particular, are being unreasonable in expecting the kernel ethtool
> to provide
> anything but an error in response to get_settings()?  What do you
> think of
> Florian's suggestion, to check for dev->ieee80211_ptr being set, and
> letting
> these interfaces proceed with being enslaved in a bond master network
> device if
> that's the case?

I'm suggesting that if the bonding driver is expecting a *continuous*
stable link rate from any kind of radio device, whether that's WiFi,
WWAN, Bluetooth, or whatever, it's being unreasonable.

It's not necessarily unreasonable to add speed/duplex reporting to the
ethtool hooks for wifi drivers.  But before that happens, we should
understand what other bits will use that information, how they use it,
and if they are going to use it incorrectly and thus do something that
users don't expect and consider a bug itself.

Dan

> Would you go so far as to say that modifying the kernel ethtool to
> report
> wireless link speed and duplex would be entirely pointless?
> 
> Thanks
> James
