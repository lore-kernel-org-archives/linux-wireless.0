Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:23083 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab0IWSwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 14:52:05 -0400
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board
 file
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Robert Nelson <robertcnelson@gmail.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <AANLkTi=1QqxE3P_+5goP43YNvcaQLjQUk5XWo-Oq51iW@mail.gmail.com>
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
	 <AANLkTinLjQbvbTj3LTnw+54S-ojWzojqgyd=-3F783We@mail.gmail.com>
	 <AANLkTimce-=MP2DDNTpRh_oRFW15_gSkKZJ6fQzwc4yJ@mail.gmail.com>
	 <1285246353.3231.84.camel@chilepepper>
	 <AANLkTi=1QqxE3P_+5goP43YNvcaQLjQUk5XWo-Oq51iW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 21:52:00 +0300
Message-ID: <1285267920.1562.43.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 15:42 +0200, ext Robert Nelson wrote:
> On Thu, Sep 23, 2010 at 7:52 AM, Luciano Coelho
> <luciano.coelho@nokia.com> wrote:
> > On Thu, 2010-09-23 at 14:03 +0200, ext Robert Nelson wrote:
> >> On Thu, Sep 23, 2010 at 5:30 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> >> > On Thu, Sep 23, 2010 at 11:20 AM, Luciano Coelho
> >> > <luciano.coelho@nokia.com> wrote:
> >> >> Add board configuration for the wl1271 daughter board.  This patch is based
> >> >> on Ohad Ben-Cohen's patches for Zoom boards.
> >> >
> >> > Hm can that daughter board be detected? With your patch all beagle
> >> > users will get GPIO139 toggled, and if someone has that wired to
> >> > chainsaw switch somebody might get hurt.
> >>
> >> Expansion boards really need to follow:
> >>
> >> http://elinux.org/BeagleBoardPinMux#Expansion_boards
> >>
> >> Is there any eeprom on i2c bus #2 for identification on this board?
> >
> > Hmmm... <checking the schematics>
> >
> > Yes, it does. :) This makes perfect sense.
> >
> > My bootloader (U-Boot 2010.03) doesn't seem to detect it, though:
> >
> > <clip>
> > Probing for expansion boards, if none are connected you'll see a
> > harmless I2C error.
> >
> > No EEPROM on expansion board
> > <clip>
> 
> I'd first add the board to the list on the wiki to protect the
> expansion board id.

Okay, I'll do that.


> Here's the current patch for u-boot for these expansion boards, it
> only implements id's for the boards listed at the time.
> 
> http://www.sakoman.com/cgi-bin/gitweb.cgi?p=u-boot.git;a=commit;h=95993d1fee62ef64b2f58c1e186176ca9033c35e

Thanks for the pointer.  Now I understand how this works.


> > Do I need a special bootloader?
> >
> > Is there any standard way to recognize the expansion board and configure
> > it properly?
> 
> Yeap, you need a special bootloader, which is a downside to the
> current implementation...  It relies on u-boot to do the i2c probing
> and detect which expansion board is connected, it would be nice if the
> kernel could do it on it's own..

Is there any technical problem which would prevent this from being done
in the kernel? Or is it just legacy and nobody has implemented it
properly in the kernel side?


> So currently u-boot probes, then notifies the kernel thru a "buddy"
> variable that gets passed with the bootargs..

I see.  The good thing is that if someone is using a boot loader that is
not probing and passing the variable, it can be specified manually in
the kernel bootargs.


> board-omap3beagle.c then parse's the "buddy" variable to setup the
> expansion device, like as shown for the zippy1/2 expansion boards:
> 
> http://cgit.openembedded.org/cgit.cgi/openembedded/tree/recipes/linux/linux-omap-psp-2.6.32/0007-ARM-OMAP-beagleboard-Add-infrastructure-to-do-fixups.patch
> 
> (note there are patches applied before this and after, so it's won't
> apply cleanly to mainline)

Thanks for this pointer too.  I see that the beagle board files are
indeed different from what is in the mainline.  Any ideas if/when this
is going to be integrated into the mainline?


-- 
Cheers,
Luca.

