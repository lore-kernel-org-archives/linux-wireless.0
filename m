Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:47363 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYJ1RYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 13:24:22 -0400
Received: by gxk11 with SMTP id 11so1884307gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 10:24:21 -0700 (PDT)
Message-ID: <43e72e890810281024q5b69d35dofb7c401512c23053@mail.gmail.com> (sfid-20081028_182427_970445_04C4A4CE)
Date: Tue, 28 Oct 2008 10:24:21 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: rtl2860 driver in mainline?
Cc: "Greg KH" <greg@kroah.com>, "Ivo Van Doorn" <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1225205997.2387.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081028004915.GA3442@kroah.com>
	 <a32f33a40810272248j5ee755ccoc8f6a8c8d5338cb8@mail.gmail.com>
	 <20081028061023.GA6568@kroah.com>
	 <1225205997.2387.12.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 7:59 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2008-10-27 at 23:10 -0700, Greg KH wrote:
>> On Tue, Oct 28, 2008 at 06:48:31AM +0100, Ivo Van Doorn wrote:
>> > Hi,
>> >
>> > > So, on my quest to suck up every out-of-tree driver and get it into the
>> > > main kernel tree (drivers/staging/ to start with), I've been pointed at
>> > > the rtl2860 driver.
>> >
>> > in that case make sure you include rt2870 on your list as well then. ;)
>>
>> Do you have a pointer to it?
>>
>> > > Does anyone know of a "cleaned up" version of this driver that is
>> > > newer/better than the one on ralink's web site?  I found the
>> > > 2008_0918_RT2860_Linux_STA_v1.8.0.0.tar.bz2 version there, and will
>> > > start with that if no one else has yet.
>> >
>> > rt2800pci/rt2800usb development is in progress in the rt2x00.git
>> > experimental branch:
>> > http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=shortlog;h=experimental
>> >
>> > The current status is that rt2800usb has working RX with some warnings
>> > regarding the
>> > RX signal, and a non functional TX. rt2800pci isn't complete yet.
>> >
>> > So far progress has been very slow because of lack of time, so any help with the
>> > development of the drivers is welcome.
>>
>> Is this a port of the tarball driver to the in-kernel wireless stack, or
>> starting over from scratch?
>>
>> As it's not really working, do you mind if I just dump the tarball
>> driver into the staging tree for users to use now (hint, they already
>> are, the distros are shipping that driver as a kernel module package),
>> and then when this "real" driver is up and working properly, we can drop
>> the staging version?
>
> Seriously, how does including this help _anybody_ beyond today?

In this particular case if Joe the Plumber installs Linux 6 months
from now chances are this move will get his Ralink 802.11n device
supported. Perhaps 6 months from now the rt2x00 driver port will be
ready though, in those cases people smarter than Joe the Plumber will
be able to use compat-wireless, lets say, or the latest -rc kernel
release to use an upstream driver which replaces it instead.

> The
> vendor driver is not going to get upstream,

Once in staging it means it is upstream now though.

> and shipping it in staging
> suggests that people help fix the vendor driver there,

It actually means developers have the option to work on what they
like, crap or not crap. And crap that works, or cool-stuff that
doesn't work quite well yet.

> not work on the
> driver that will actually go upstream.

It is not barring people who do want to work on the ubber cool
upstream driver from doing so; it *may* deviate effort of a few
developers -- this is true and this is what hurts. But like Johannes
says too, people spend tons of hours uselessly watching TV. So
technically it just gives developers and users more options. That is
all.

> staging drivers are supposed to eventually go "mainstream" if somebody
> fixes them up, right?  So how does cramming in a driver that will go
> nowhere help anyone in the medium or long term?

Problem is having no support yet and that distributions still work on
getting the crap into their own distribution. Getting it into staging
should reduce the turnaround time for device to get supported.

> Should we have shipped
> madwifi with the open HAL in staging

They're not compatible though.

> while ath5k was getting brought up
> to speed?

If a real HAL did work I don't see why not if the premise is we are
willing to accept complete crap into staging.

> Would that have taken effort away from ath5k?

Yes but this cannot be avoided, despite my efforts people still want
to poke and maintain MadWifi. I have to respect that but it doesn't
mean my own resources or what I push for has to be dedicated towards
that.

> I highly respect the work that you're doing with staging, but just
> because the driver is out of tree doesn't mean that it'll ever go
> mainline, and that including some drivers will just sap effort from
> where it's needed.

This is the danger, and I wonder how much this is really true or
rather if this actually attracts more developers to keep crap working
for users willing to use crap in the meantime while other more
seasoned developers get stuff working *properly*.

> Cleaning up crappy vendor driver code is _not_ where
> the effort is needed.  We have a higher standard of quality.

We do, but crap developers don't, and crap vendor developers don't either.

Should we have TAINT_CRAP ? :) Oh wait look!!!!

     { TAINT_CRAP, 'C', ' ' },

 *  'C' - modules from drivers/staging are loaded.

>From panic.c! Yay!

  Luis
  Luis
