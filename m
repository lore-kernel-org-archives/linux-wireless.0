Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50291 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZG2HFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 03:05:45 -0400
Received: by fxm18 with SMTP id 18so201765fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 00:05:45 -0700 (PDT)
From: Chris Clayton <chris2553@sky.com>
Reply-To: chris2553@googlemail.com
To: Luis Correia <luis.f.correia@gmail.com>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
Date: Wed, 29 Jul 2009 08:03:46 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com> <c6b1100b0907280634j4610d077rb30f1f571aac7f36@mail.gmail.com> <efe7343f0907280638i12b0bb4bq237ca4f6376eb1fe@mail.gmail.com>
In-Reply-To: <efe7343f0907280638i12b0bb4bq237ca4f6376eb1fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907290803.46110.chris2553@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 July 2009, Luis Correia wrote:
> Chris
>
> On Tue, Jul 28, 2009 at 14:34, Chris Clayton<chris2553@googlemail.com> wrote:
> > 2009/7/28 Luis Correia <luis.f.correia@gmail.com>:
> >> Hi Chris
> >>
> >> Can you do a very dumb test for me?
> >>
> >> Boot your laptop by adding 'irqpoll' to the kernel command line
> >> options and see if the problem still occours.
> >
> > Not so dumb a request, actually.  Running -rc4 with the irqpoll
> > command line option, the laptop has just survived 30 minutes without a
> > freeze. It can't survive more than 5 minutes without that option.

Well, the laptop ran -rc4-git2 all evening yesterday without freezing. So using the irqpoll option 
seems to be an answer. A few questions and observations though:

1. Are we sure that it is the power-saving change that _caused_ this problem? Could it be that some 
other bug is simply unmasked by the power-saving change? I ask this because I noticed yesterday 
that the card's network LED switches off several seconds before the laptop freezes.

2. When power-saving kicks in, the network LED on the card is switched off. (At least I'm assuming 
that is what switches the LED off) When the card is woken up again, neither the network nor activity 
LED lights-up ever again. IMHO, this is a bug.

3. Once power-saving kicks in, the machine cannot be contacted from another machine on the network - 
pings are not responded to, for example. Is this the intended behaviour?

4. Are there any plans to be able to switch power-saving on/off on a driver-by-driver basis. It 
seems to me, although I'm happy to be corrected, that it is either on or off for a given kernel, 
depending on CONFIG_MAC80211_DEFAULT_PS. But, if like me, someone has two cards (one at home and one 
at work, for example), one that works fine with PS and one that doesn't, they have to set PS off 
for their kernel, or have two kernels. Could PS be {en,dis}abled by, say, a module parameter or a 
sysfs switch?

Thanks,

Chris

> >
> > Chris
>
> Well, if the laptop hangs on working without any problems, this may
> proove to be some strange kind of hardware incompatibility.
>
> The irqpoll option solves some of the interrupt related problems, by
> polling them instead of 'grabbing' them (at least that is what I think
> it is happening, correct me if I'm wrong:))
>
>
> Luis Correia
> rt2x00 project admin



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
