Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33629 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3L1Hka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Dec 2013 02:40:30 -0500
Received: by mail-ob0-f177.google.com with SMTP id vb8so9921674obc.8
        for <linux-wireless@vger.kernel.org>; Fri, 27 Dec 2013 23:40:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALLGbRKcSNxaTmOAr2rSctqfDThWrEOtu5HkEq7NfYgaOF13pA@mail.gmail.com>
References: <20131203202607.0b445195@kemnade.info> <1386167786.19448.4.camel@dcbw.foobar.com>
 <CA+E=qVdY4M=bnX=pqMiMirhQ_BRg6Uc6K9Xkzvf328BaByUF1g@mail.gmail.com>
 <20131209041821.GC14878@us.netrek.org> <CA+E=qVd_F_=z5Vb2jan-nNVmizQznOiR=98CPHQevMxbnxGJiA@mail.gmail.com>
 <20131210022746.GE28975@us.netrek.org> <CA+E=qVdFq6XNAibsTUCbxQVbdRh+p6YT=nvgvmuO_u7jkBdKcw@mail.gmail.com>
 <20131211205532.GE452@us.netrek.org> <CA+E=qVdFfvXVXJfbnKj6sxfsE6qDxQ6YZ5-eSKOmopVEodxM0A@mail.gmail.com>
 <1386801713.17188.59.camel@dcbw.foobar.com> <CALLGbRKcSNxaTmOAr2rSctqfDThWrEOtu5HkEq7NfYgaOF13pA@mail.gmail.com>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Sat, 28 Dec 2013 10:40:09 +0300
Message-ID: <CA+E=qVeAszdE5H_MyrLQRJ_GUC31nGOE=PnnwzucvEAicAZmrA@mail.gmail.com> (sfid-20131228_084050_729557_1EC67DFA)
Subject: Re: status of libertas_tf + sdio?
To: Steve deRosier <derosier@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	linux-wireless@vger.kernel.org, James Cameron <quozl@laptop.org>,
	libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 28, 2013 at 12:30 AM, Steve deRosier <derosier@gmail.com> wrote:
> On Wed, Dec 11, 2013 at 2:41 PM, Dan Williams <dcbw@redhat.com> wrote:
>>
>> On Thu, 2013-12-12 at 00:21 +0300, Vasily Khoruzhick wrote:
>> > On Wed, Dec 11, 2013 at 11:55 PM, James Cameron <quozl@laptop.org> wrote:
>> > > On Wed, Dec 11, 2013 at 11:10:50AM +0300, Vasily Khoruzhick wrote:
>> > >> On Tue, Dec 10, 2013 at 5:27 AM, James Cameron <quozl@laptop.org> wrote:
>> > >> > On Mon, Dec 09, 2013 at 12:38:28PM +0300, Vasily Khoruzhick wrote:
>> > >> >> On Mon, Dec 9, 2013 at 7:18 AM, James Cameron <quozl@laptop.org> wrote:
>> > >> >> > On Fri, Dec 06, 2013 at 01:40:00PM +0300, Vasily Khoruzhick wrote:
>> > >> >> >> Out of curiosity,
>> > >> >> >>
>> > >> >> >> Does anyone know if it's possible to get thin firmware for 8686 with
>> > >> >> >> SPI interface?
>> > >> >> >
>> > >> >> > What happens when you try?
>> > >> >>
>> > >> >> How? There's no tf available for 8686 with SPI interface.
>> > >> >
>> > >> > How do you know that?  Are you saying that SPI support was removed
>> > >> > from firmware during the conversion from fat to thin?
>> > >>
>> > >> Err, there's no lbtf_spi.bin file.
>> > >
>> > > Basing decisions on the names of files rather than the code they
>> > > may contain seems rather limiting.
>> > >
>> > > In the absence of evidence, there's a possibility that SPI support
>> > > remained.
>> >
>> > But fat firmware differs for SPI and SDIO
>>
>> Correct.  AFAIK (and I could be wrong, I haven't been involved for a few
>> years) CozyBit only did the thin firmware for OLPC-specific deployments
>> of the usb8388 and sd868x parts which were included in OLPC devices, to
>> support the mesh networking protocols used by OLPC.  None of those parts
>> used SPI; and thus I would not expect there to be a thin firmware for
>> any SPI parts.  I'd love to be proved wrong though.
>>
>> Each bus type uses different firmware, so yes, you'd need both a helper
>> firmware and a main firmware that contains code specific to the bus
>> type.
>>
>> Dan
>>
>
> Hi guys,

Hi Steve,

> Sorry for not noticing this earlier.  I'm the guy (formerly) at
> Cozybit who wrote the driver and did the thinfirmware for OLPC.  I
> never got a chance to get the driver cleaned up so it could be
> accepted into the kernel mainline; ended up shifted off to a different
> project right away and then, well, you know how it goes.
>
> In case you weren't aware, the git repo for the driver is at:
> http://dev.laptop.org/git/users/derosier/wireless-testing/
>
> There's also an old compat-wireless for it:
> http://dev.laptop.org/git/users/derosier/compat-wireless/
>
> The driver of course requires the thinfirm firmware.  You should be
> able to find it somewhere on OLPC's site, or in various posts or
> emails from me.  If you really can't find it, let me know and I'll see
> if I can find the binary by digging through my archives.
>
> As for SPI support... The SDIO spec requires SPI support.  I don't
> recall any specific support or no support for SPI (either way) in the
> SD8686 firmware.  If I were you I'd give it a try (assuming you're not
> having to do hardware spins to try it).  It may work.  Then again, I
> haven't looked at that code in over three years (and no longer have it
> to check) and my recollections may be fuzzy.
>
> If it doesn't work, contact Cozybit, they can fairly easily make a
> thinfirm change to the SPI version of the firmware if that indeed
> exists as a separate project.  Frankly the hard part is not in making
> the thinfirm change, its is in fitting it into the chip and doing all
> the testing to be sure you didn't break anything else.

OK, thanks, I'll give it a try!

Regards
Vasily

> Useful links:
> http://wiki.laptop.org/go/Thinfirm_1.5
> http://wiki.laptop.org/go/Thin_firmware_spec
> http://wiki.laptop.org/go/XO_as_AP
>
> - Steve
>
> PS sorry for the resend... Darn google HTMLified it on me and I hadn't noticed.
