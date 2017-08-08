Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752070AbdHHVnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 17:43:53 -0400
Message-ID: <1502228547.24881.5.camel@redhat.com> (sfid-20170808_234358_078631_15127FE7)
Subject: Re: wireless drivers fail to report link speed?
From: Dan Williams <dcbw@redhat.com>
To: james@nurealm.net, linux-wireless@vger.kernel.org
Date: Tue, 08 Aug 2017 16:42:27 -0500
In-Reply-To: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-08-08 at 13:07 -0600, James Feeney wrote:
> Hello All
> 
> Would you please look at kernel bug report "Since 4.12 - bonding
> module not
> working with wireless drivers", and tell me if you know why the
> kernel ethtool
> does not receive a speed report from the wireless drivers?
> 
>  https://bugzilla.kernel.org/show_bug.cgi?id=196547
> 
> It seems that Mahesh Bandewar became annoyed that some network
> drivers do not
> report speed and duplex to the bonding module properly, so that it
> becomes
> impossible to make "best connection" decisions.  A patch was applied
> to the
> bonding module in linux 4.12 which now disables any network interface
> that does
> not successfully report its speed and duplex.  In practice, this
> seems to
> include every wireless network driver I've tried, the ath5k, ath9k,
> the
> rtl8192ce and RTL8188CUS.  Of course, this new behavior breaks
> wireless bonding!
> 
> Do you know if there is some general reason why the wireless drivers
> do not work
> with the kernel ethtool?  Is this something that can be fixed?  Can
> you tell if
> this reporting failure would be the fault of the kernel ethtool?  Or
> the
> wireless driver?  Or the bonding module?

Because the "speed" (whatever that means) can and sometimes does change
with every packet.  The driver dynamically adjusts the link rate based
on all kinds of things.  But mainly the current radio environment; how
many other APs are around, how much interference there is, how many
other clients are trying to talk, that kind of thing.

So one second the wifi might be the "best" link and then when somebody
turns on a microwave oven or a baby monitor, it may be the "worst"
until the microwave's duty cycle completes a few seconds later then
it'll become the "best" again for a couple seconds then "worst" again,
repeat until your Easy Mac is nice and warm and creamy.

Furthermore, for some drivers IIRC when there isn't any traffic, they
might drop the link rate very low because there's no reason keep
powering blocks when you're not transmitting/receiving any data.  IIRC
the Intel drivers used to do that a couple years ago.

Also, "duplex" doesn't mean anything in wireless land.  So no clue what
bonding is expecting them to say here.  I would say the modifications
to the bonding core made assumptions that simply aren't applicable to
mediums other than wired ones.

Dan
