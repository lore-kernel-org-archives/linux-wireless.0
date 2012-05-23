Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:46644 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942Ab2EWUvz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 16:51:55 -0400
Date: Wed, 23 May 2012 22:51:51 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, openwrt-devel@lists.openwrt.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
Message-ID: <20120523205150.GG28713@yumi.tdiedrich.de> (sfid-20120523_225213_244771_713434F4)
References: <20120517230400.GB22418@yumi.tdiedrich.de>
 <CAGXE3d-MTZu16cU1wybd6zehGOudKPadknuHm9MG6JDVRKmDag@mail.gmail.com>
 <20120522205829.GE28713@yumi.tdiedrich.de>
 <CAGXE3d-MLFJQ-O8=0ToC3fxx0=eLCi+Kbc-DDf_QaNQ2t42=pQ@mail.gmail.com>
 <20120523135514.GF28713@yumi.tdiedrich.de>
 <CAGXE3d8oAFhw8SO_i6M8TXhFeqQGc5LJ76-t12xdpCYcQDhSUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d8oAFhw8SO_i6M8TXhFeqQGc5LJ76-t12xdpCYcQDhSUQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa wrote:
> Hi,
> 
> On Wed, May 23, 2012 at 3:55 PM, Tobias Diedrich
> <ranma+openwrt@tdiedrich.de> wrote:
> > Helmut Schaa wrote:
> >> On Tue, May 22, 2012 at 10:58 PM, Tobias Diedrich
> >> <ranma+openwrt@tdiedrich.de> wrote:
> >> > Helmut Schaa wrote:
> >> >> On Fri, May 18, 2012 at 1:04 AM, Tobias Diedrich
> >> >> <ranma+openwrt@tdiedrich.de> wrote:
> >> >> > rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
> >> >> > respectively, similar to how it is already done in rt2[45]00pci.c
> >> >> >
> >> >> > rt2800lib.c doesn't initialize max_power and thus after
> >> >> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
> >> >> > was applied txpower is limited to 0 for these devices.
> >> >> >
> >> >> > This should be the proper fix compared to the net/wireless/reg.c
> >> >> > hack in http://patchwork.openwrt.org/patch/2165/
> >> >>
> >> >> Btw. Tobias, did this affect the real tx power of the device at all or
> >> >> is this just
> >> >> a cosmetic issue?
> >> >
> >> > Hmm, apparently setting txpower has no effect?
> >> > Is it not implemented in the driver?
> >>
> >> It is, but only for devices with correct tx power limit in the eeprom.
> >
> > Why?
> 
> Please read [1] for a detailed explanation.

It still seems somewhat handwavy, I suppose what it means is:
You get a default value for the txpower controlling registers
from the eeprom (which is your 'calibration value'), but don't
actually know how much this is in dBm, so you don't want to
expose a 'fake' dBm value just so it's adjustable by the user (until
percentage setting is implemented).

And I suppose it's more about the antenna gain and attenuation of
the path between RT3050 and antenna than about what comes out of the
SoC directly (which was more what I was thinking about initially).

Thanks for the patience. :)

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
