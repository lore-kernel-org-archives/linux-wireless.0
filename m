Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48134
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbXBDULX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 15:11:23 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: SoftMAC vs FullMAC
Date: Sun, 4 Feb 2007 21:11:16 +0100
Cc: "Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com> <200702042007.29357.mb@bu3sch.de> <9e4733910702041144n277facd1g6af9c4659afc6d39@mail.gmail.com>
In-Reply-To: <9e4733910702041144n277facd1g6af9c4659afc6d39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702042111.17005.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 February 2007 20:44, Jon Smirl wrote:
> On 2/4/07, Michael Buesch <mb@bu3sch.de> wrote:
> > On Sunday 04 February 2007 19:31, Jon Smirl wrote:
> > > On 2/4/07, Pavel Roskin <proski@gnu.org> wrote:
> > > > In fact, Atheros chips are not that intelligent to be treated as FullMAC, but
> > > > going to d80211 removes many chip specific features.
> > >
> > > What types of features are removed? For example Atheros turbo mode can
> > > be treated like another PHY layer implementation.
> > >
> > > If it is just off-loading the implementation of standard behavior then
> > > we may actually be better off ignoring this capability and
> > > implementing the standard behavior in the host.
> > >
> > > It's not even clear to me that doing encryption is a wireless
> > > co-processor is a win. It is almost certain that the host can perform
> > > the same algorithms many times faster that an embedded wireless
> > > processor.  Moving encryption onto the host reduces the latency of the
> > > connection.
> >
> > If creating and uploading the keys to the device is less work than
> > doing crypto in software, then it is clearly a win.
> > And that _is_ the case for bcm43xx (at least. I don't know about other
> > devices' hwcrypto capabilities).
> > Doing less on the CPU and more in hw is always a win. I'm not sure
> > how you can say that you're not sure it is. ;)
> 
> Don't get too focused on the crypto question, this is more of a
> philosophical question. What happened in the wired world was the
> creation of total software implementations. These software
> implementations had hooks for off-load, but the implementations
> implemented all of the stack in software. To get a new piece of
> hardware running all you had to do was provide basic send/receive
> functions.
> 
> The model where all the hardware had to do was send/receive plus some
> bookkeeping led to an explosion in the amount of networking hardware
> supported under Windows (I was in the MS networking group when NDIS
> was built). Previous to NDIS it had been a major process interfacing
> the coprocessor based network cards into the MS networking stack.
> Every card needed it's own set of hooks and the vendors kept changing
> the features supported (reminds you of the current situation with
> FullMAC?).
> 
> In the Windows case the software stack had another side effect, if you
> ran the hardware in software mode it always interoperated. That was
> because both sides were running the same software.  Switching to
> software only mode exposed thousands of bugs in hardware and software
> implementations by the vendors.
> 
> This same model also existing the the graphics world. Mesa implements
> the entire OpenGL stack in software. Hardware drivers then overlay
> functions in Mesa with accelerated implementations.
> 
> Obviously you would quickly provide drivers that accelerate the low
> hanging fruit like encryption, but there is always the software
> fallback available. Also note that after the transition to dumb
> Ethernet hardware around 1990, it was 2002 or so before TCP checksum
> offload became a win, and it is still controversial if it really is a
> win.
> 
> I was looking at the problem from the context of 11s. If hardware uses
> a minimal software MAC and everything else is done in host software,
> then a software 11s implementation would enable all the hardware in
> this model to work immediately.  If the FullMAC model is followed
> instead it may be years, if ever, before a majority of Linus wireless
> hardware becomes enabled for 11s.

I don't really see your point.
We can't change hardware. We have to implement the software around existing
hardware. And that's currently softmac _and_ fullmac devices.
So we have to create hooks and so on in our software to support
the fullmac devices.

-- 
Greetings Michael.
