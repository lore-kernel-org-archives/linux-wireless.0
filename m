Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:55972 "EHLO
        resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752427AbdHHWer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 18:34:47 -0400
Reply-To: james@nurealm.net
Subject: Re: wireless drivers fail to report link speed?
To: Ben Greear <greearb@candelatech.com>,
        Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
 <1502228547.24881.5.camel@redhat.com>
 <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
From: James Feeney <james@nurealm.net>
Message-ID: <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net> (sfid-20170809_003503_122885_01527D68)
Date: Tue, 8 Aug 2017 16:25:51 -0600
MIME-Version: 1.0
In-Reply-To: <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Dan

> ...
> So one second the wifi might be the "best" link and then when somebody
> turns on a microwave oven or a baby monitor, it may be the "worst"
> until the microwave's duty cycle completes a few seconds later then
> it'll become the "best" again for a couple seconds then "worst" again,
> repeat until your Easy Mac is nice and warm and creamy.
> 
> Furthermore, for some drivers IIRC when there isn't any traffic, they
> might drop the link rate very low because there's no reason keep
> powering blocks when you're not transmitting/receiving any data.  IIRC
> the Intel drivers used to do that a couple years ago.

Yes, thanks, but, while all of that is true, it has nothing to do with the
question asked.

The question is, regardless that the wireless speed may be constantly changing,
why is it that the kernel ethtool returns an error on get_settings(), instead of
returning the current wireless speed, whatever that link speed might be at the
moment?

> Also, "duplex" doesn't mean anything in wireless land.  So no clue what
> bonding is expecting them to say here.  I would say the modifications
> to the bonding core made assumptions that simply aren't applicable to
> mediums other than wired ones.

Since, as Ben mentions,

> Well, wifi acts half-duplex in that only one side can transmit at once.

then the wireless drivers would be expected to simply report "half-duplex".

Again, the issue is not that wireless is half-duplex or full-duplex, but rather,
why does the kernel ethtool return an error on get_settings()?

And, why is it that it seems get_settings() returns an error with multiple
wireless drivers?  Is there some assumption, or convention, that causes the
kernel ethtool to fail with *all* the wireless drivers?

I see that, on bugzilla, Florian is suggesting that wireless network devices
*cannot* report a speed/duplex, simply because the wireless speed changes on a
per-packet basis, but that does not seem to me to be a persuasive argument.  A
wireless connection *does* always have a current speed, even if that speed
changes frequently.  The kernel ethtool get_settings() should simply report that
speed, not throw an error, yes?


Thanks
James
