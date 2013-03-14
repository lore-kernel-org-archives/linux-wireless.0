Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout3.wanadoo.co.uk ([80.12.242.59]:18578 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CNVrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 17:47:49 -0400
Date: Thu, 14 Mar 2013 21:39:56 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: isedev@gmail.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: BCM4312 / b43 DMA transmission sequence errors
Message-ID: <20130314213956.05aa6dee@bother.homenet> (sfid-20130314_224753_376595_29718FAA)
In-Reply-To: <4530943.RJ7WpUJOSz@wks001.ise.net>
References: <1695808.c7XUjJpf0R@wks001.ise.net>
	<1476129.oNtxuF3Ght@wks001.ise.net>
	<51413800.6050300@lwfinger.net>
	<4530943.RJ7WpUJOSz@wks001.ise.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 14 Mar 2013 14:08:33 +0100
ISE Development <isedev@gmail.com> wrote:
> On Wednesday 13 Mar 2013 21:37:52 Larry Finger wrote:
> > On 03/13/2013 08:06 PM, ISE Development wrote:
> > 
> > >
> > > I've hacked the driver to 'skip' one header and data frame if
> > > receiving an interrupt for the first slot + 2. It's not pretty
> > > and I have literally no idea if it will causes other problems,
> > > but it has allowed me to keep the Wifi connection up for a little
> > > over 3 hours now (as compared to the 45 seconds previously). It
> > > does not appear to be corrupting the data stream (checked by
> > > download large signed binaries and verifying the signature) and
> > > as far as my limited knowledge can tell, it should not be causing
> > > a memory leak.
> > >
> > > The patch is listed below, for reference. However, I do not claim
> > > that it is valid, safe or even reasonsable. It does provide me
> > > with much needed relief though.
> > >
> > > The diff is against the current head of
> > > linville/wireless-testing.git
> > > (d41d9c7419e3ac9c81841f43bbd7639dd0a5819e).
> > >
> > 
> > I am testing the patch on BCM4312 and other cards.
> > 
> > Larry
> > 
> 
> Here's a slighted cleaner version, with comments, in case you are
> considering integrating it.

[snip]

It might look like a bit of a hack (probably one that broadcom have
hidden away in their own wl driver if it is a firmware issue) but it is
certainly effective.

I have applied this patch to the 3.8.2 kernel and for the first time I
get reliable performance from the bcm4312 card in my netbook using the
b43 driver.  I have banged about 5 GB through it and I am continuing to
do so, but it is still up.  I get I would say on average about one TX
ring error (on ring 1 in the case of my card) per 500 MB of
throughput and the frame skip resolves the problem for me.

As this patch also avoid spamming the debug log with shed loads of
error reports once an inconsistency arises, it also reveals that the
inconsistency always begins with an expected status report of 138 and a
report of 140 being received.  Yours, however, may well be different,
and this may be meaningless anyway.

Chris





