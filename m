Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3818 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932178Ab2DXJ4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 05:56:10 -0400
Message-ID: <1335261368.21300.16.camel@t41.thuisdomein> (sfid-20120424_115614_494796_7130CECB)
Subject: Re: [ath5k-devel] ath5k phy0: failed to warm reset the MAC Chip
From: Paul Bolle <pebolle@tiscali.nl>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 24 Apr 2012 11:56:08 +0200
In-Reply-To: <CAFtRNNyvn3g_-XP1dPA4vfZi25AmiXokF5-nep2HY9xTF0cXQQ@mail.gmail.com>
References: <1334869564.25074.35.camel@t41.thuisdomein>
	 <CAFtRNNyNg4gqu16FzERGRzYCbJv_mR00BqwLhAKOXcMtJMhmTQ@mail.gmail.com>
	 <1334913493.27776.28.camel@t41.thuisdomein>
	 <CAFtRNNyvn3g_-XP1dPA4vfZi25AmiXokF5-nep2HY9xTF0cXQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-23 at 02:51 +0300, Nick Kossifidis wrote:
> 2012/4/20 Paul Bolle <pebolle@tiscali.nl>:
> Well we also need the chip revision to make sense so we need the part
> from dmesg where ath5k loads.

>From the current session:
<6>[   13.735187] ath5k 0000:02:02.0: registered as 'phy0'
<7>[   14.176985] Registered led device: ath5k-phy0::rx
<7>[   14.178755] Registered led device: ath5k-phy0::tx
<6>[   14.178798] ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
<6>[   14.178808] ath5k phy0: RF5111 5GHz radio found (0x17)
<6>[   14.178816] ath5k phy0: RF2111 2GHz radio found (0x23)

Is that what you needed?

> > [...]
> >
> > Which looks rather uninteresting. But if I look at the few instances of
> > these errors still logged in /var/log/messages* I see ntpd activity
> > preceding these errors. Coincidence?
> >
> 
> Well if there is a problem with your laptop's clock it might be the
> reason for this, you see some time ago we started using hr (high
> resolution) timers inside ath5k instead of the standard busy waits
> (udelay) and if there is any clock drifting or frequency changes (e.g.
> CPU sleep states or some governor) on the clock we use (e.g. CPU's
> cycle counter or TSC) it affects us (I think also that ntp changes the
> system clock and this affects hr timers too but I'm not sure). Inside
> register_timeout we use udelay but other parts of reset use hr timers,
> here is a suspect:
> 
> inside ath5k_hw_nic_reset (reset.c)
> 
> 410         /* Wait at least 128 PCI clocks */
> 411         usleep_range(15, 20);
> 
> inside ath5k_hw_set_power_mode
> 
> 564                 usleep_range(15, 20);
> [...]
> 572                         /* Wait a bit and retry */
> 573                         usleep_range(50, 75);
> 
> 
> It seems kind of extreme because most of these intervals are small and
> register timeout should be enough to cover such clock drifts (it's
> 20000 * 15us) even on old chips but it might explain the link with ntp
> activity. Try using a more "stable" time source such as PIT or HPET
> (you can use e.g. clock=pit on kernel's command line for this) and see
> how it goes. You can also try disabling ntp and see if the problem
> remains...

I'll hope to try some of these things. But first I need to be able to
trigger this error somewhat reliably. See, this is not a well-behaved
bug: it refuses to show up when I want it to. It hasn't triggered once
since I started this conversation! That's also because I can't reproduce
it as I don't know yet what triggers it.

So I'll have to keep digging here. Perhaps with some silly printks (say
in  ath5k_hw_nic_reset()) I can see what happens, and how often, in the
non-error case. To be continued ...


Paul Bolle

