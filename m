Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:51291 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbXBDToc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 14:44:32 -0500
Received: by wr-out-0506.google.com with SMTP id i22so1064507wra
        for <linux-wireless@vger.kernel.org>; Sun, 04 Feb 2007 11:44:31 -0800 (PST)
Message-ID: <9e4733910702041144n277facd1g6af9c4659afc6d39@mail.gmail.com>
Date: Sun, 4 Feb 2007 14:44:30 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: SoftMAC vs FullMAC
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200702042007.29357.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
	 <20070204123048.4bhesocg4kosgscg@webmail.spamcop.net>
	 <9e4733910702041031i5edd6dfeq7f8c5179fee5e00e@mail.gmail.com>
	 <200702042007.29357.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/4/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Sunday 04 February 2007 19:31, Jon Smirl wrote:
> > On 2/4/07, Pavel Roskin <proski@gnu.org> wrote:
> > > In fact, Atheros chips are not that intelligent to be treated as FullMAC, but
> > > going to d80211 removes many chip specific features.
> >
> > What types of features are removed? For example Atheros turbo mode can
> > be treated like another PHY layer implementation.
> >
> > If it is just off-loading the implementation of standard behavior then
> > we may actually be better off ignoring this capability and
> > implementing the standard behavior in the host.
> >
> > It's not even clear to me that doing encryption is a wireless
> > co-processor is a win. It is almost certain that the host can perform
> > the same algorithms many times faster that an embedded wireless
> > processor.  Moving encryption onto the host reduces the latency of the
> > connection.
>
> If creating and uploading the keys to the device is less work than
> doing crypto in software, then it is clearly a win.
> And that _is_ the case for bcm43xx (at least. I don't know about other
> devices' hwcrypto capabilities).
> Doing less on the CPU and more in hw is always a win. I'm not sure
> how you can say that you're not sure it is. ;)

Don't get too focused on the crypto question, this is more of a
philosophical question. What happened in the wired world was the
creation of total software implementations. These software
implementations had hooks for off-load, but the implementations
implemented all of the stack in software. To get a new piece of
hardware running all you had to do was provide basic send/receive
functions.

The model where all the hardware had to do was send/receive plus some
bookkeeping led to an explosion in the amount of networking hardware
supported under Windows (I was in the MS networking group when NDIS
was built). Previous to NDIS it had been a major process interfacing
the coprocessor based network cards into the MS networking stack.
Every card needed it's own set of hooks and the vendors kept changing
the features supported (reminds you of the current situation with
FullMAC?).

In the Windows case the software stack had another side effect, if you
ran the hardware in software mode it always interoperated. That was
because both sides were running the same software.  Switching to
software only mode exposed thousands of bugs in hardware and software
implementations by the vendors.

This same model also existing the the graphics world. Mesa implements
the entire OpenGL stack in software. Hardware drivers then overlay
functions in Mesa with accelerated implementations.

Obviously you would quickly provide drivers that accelerate the low
hanging fruit like encryption, but there is always the software
fallback available. Also note that after the transition to dumb
Ethernet hardware around 1990, it was 2002 or so before TCP checksum
offload became a win, and it is still controversial if it really is a
win.

I was looking at the problem from the context of 11s. If hardware uses
a minimal software MAC and everything else is done in host software,
then a software 11s implementation would enable all the hardware in
this model to work immediately.  If the FullMAC model is followed
instead it may be years, if ever, before a majority of Linus wireless
hardware becomes enabled for 11s.


> Additionally, doing crypto in the RX path (tasklet context) is
> not really optimal, from a latency point of view.
>
> But you can test it yourself. Enable/disable hwcrypto and watch how
> CPU load in "top" reacts.
>
> I did a quick test on my powerbook and software interrupt load
> decreases from about 30% to about 10% when switching from swcrypto
> to hwcrypto. I'd call that a significant win. And this 20% decrease
> is just the RX path. TX is done in process context (I think).
>
> --
> Greetings Michael.
>


-- 
Jon Smirl
jonsmirl@gmail.com
