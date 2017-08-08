Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49570 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752137AbdHHXoe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 19:44:34 -0400
Message-ID: <1502235788.24881.9.camel@redhat.com> (sfid-20170809_014438_093532_84694179)
Subject: Re: wireless drivers fail to report link speed?
From: Dan Williams <dcbw@redhat.com>
To: james@nurealm.net, Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 08 Aug 2017 18:43:08 -0500
In-Reply-To: <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
         <1502228547.24881.5.camel@redhat.com>
         <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
         <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-08-08 at 16:25 -0600, James Feeney wrote:
> Hey Dan
> 
> > ...
> > So one second the wifi might be the "best" link and then when
> > somebody
> > turns on a microwave oven or a baby monitor, it may be the "worst"
> > until the microwave's duty cycle completes a few seconds later then
> > it'll become the "best" again for a couple seconds then "worst"
> > again,
> > repeat until your Easy Mac is nice and warm and creamy.
> > 
> > Furthermore, for some drivers IIRC when there isn't any traffic,
> > they
> > might drop the link rate very low because there's no reason keep
> > powering blocks when you're not transmitting/receiving any
> > data.  IIRC
> > the Intel drivers used to do that a couple years ago.
> 
> Yes, thanks, but, while all of that is true, it has nothing to do
> with the
> question asked.

It's very relevant to the question.  Because if the speed is actually
not useful for the requested purpose, there is no real point in having
it reported it via ethtool.  Same for duplex.  Wifi is only "half
duplex", and so the property is actually meaningless for WiFi.

The bonding driver is requiring completely irrelevant information, or
at least information that simply doesn't make sense for some
communication mechanisms.  There's no way the bonding driver can make a
useful decision if the speed *intentionally* changes regularly.  At
worst, your bonding link will flip-flop between slaves every second or
two.  At best, bonding won't do anything differently than if the speed
was just faked to some fake lowest common denominator number so that
your wired link was always faster.

Sure, somebody could do a patch (like Ben has) that plumbs all this
stuff through.  But that's not solving the *actual* problem, which is
that this bonding change makes assumptions of slave devices that simply
don't match how those devices work.

Dan

> The question is, regardless that the wireless speed may be constantly
> changing,
> why is it that the kernel ethtool returns an error on get_settings(),
> instead of
> returning the current wireless speed, whatever that link speed might
> be at the
> moment?
> 
> > Also, "duplex" doesn't mean anything in wireless land.  So no clue
> > what
> > bonding is expecting them to say here.  I would say the
> > modifications
> > to the bonding core made assumptions that simply aren't applicable
> > to
> > mediums other than wired ones.
> 
> Since, as Ben mentions,
> 
> > Well, wifi acts half-duplex in that only one side can transmit at
> > once.
> 
> then the wireless drivers would be expected to simply report "half-
> duplex".
> 
> Again, the issue is not that wireless is half-duplex or full-duplex,
> but rather,
> why does the kernel ethtool return an error on get_settings()?
> 
> And, why is it that it seems get_settings() returns an error with
> multiple
> wireless drivers?  Is there some assumption, or convention, that
> causes the
> kernel ethtool to fail with *all* the wireless drivers?
> 
> I see that, on bugzilla, Florian is suggesting that wireless network
> devices
> *cannot* report a speed/duplex, simply because the wireless speed
> changes on a
> per-packet basis, but that does not seem to me to be a persuasive
> argument.  A
> wireless connection *does* always have a current speed, even if that
> speed
> changes frequently.  The kernel ethtool get_settings() should simply
> report that
> speed, not throw an error, yes?
> 
> 
> Thanks
> James
> 
