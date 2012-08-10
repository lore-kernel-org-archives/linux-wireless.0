Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41108 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2HJN2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 09:28:44 -0400
Date: Fri, 10 Aug 2012 09:20:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless?] bcma: keep info about parallel flash
 presentence
Message-ID: <20120810132054.GA2229@tuxdriver.com> (sfid-20120810_152848_090100_F6F62535)
References: <1344544690-11280-1-git-send-email-zajec5@gmail.com>
 <5024CE29.5030500@broadcom.com>
 <CACna6rzxb4jtFWOQcRvPxPE0KhTXP5P8fckaN-KaZMCyvq0Lhw@mail.gmail.com>
 <5024FD42.6070307@hauke-m.de>
 <CACna6rxLe6PKqdfG7XVb4f7XH5nk_dKZX-sC1-KS19AManD1+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rxLe6PKqdfG7XVb4f7XH5nk_dKZX-sC1-KS19AManD1+Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2012 at 02:25:48PM +0200, Rafał Miłecki wrote:
> 2012/8/10 Hauke Mehrtens <hauke@hauke-m.de>:
> > On 08/10/2012 11:32 AM, Rafał Miłecki wrote:
> >> 2012/8/10 Arend van Spriel <arend@broadcom.com>:
> >>> On 08/09/2012 10:38 PM, Rafał Miłecki wrote:
> >>>> This allows drivers to access flash conditionally and stop crashing some
> >>>> devices.
> >>>>
> >>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> >>>> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> >>>> ---
> >>>> John: I suggest taking it for wirelesss, AKA fix
> >>>
> >>> Maybe you could mentioned devices and/or drivers crashes without this patch?
> >>
> >> Yes, sure! The problematic one for me is arch/mips/bcm47xx/nvram.c.
> >> Right now it assumes every BCMA board has pflash. I'll submit fix for
> >> mips tree when this patch hits it.
> >
> > Letting this patches get merged into the wireless tree and an other
> > patches which depends on this one into the mips tree will cause
> > problems, because the wireless tree only gets merged into the mips tree
> > indirectly round about the rc1 release in form of the rc1 release done
> > by Linus.
> >
> > The patch to arch/mips/bcm47xx/nvram.c will depend on this one and you
> > should submit them to the same tree.
> 
> I'm planning to wait until rc2 (or rc3 if needed). I know the dependency :)

Which rc2?  Because Ralf probably won't have it in his tree until
the 3.7-rc1 timeframe...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
