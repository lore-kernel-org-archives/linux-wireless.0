Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:41637 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933367Ab2EWNzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 09:55:18 -0400
Date: Wed, 23 May 2012 15:55:14 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, openwrt-devel@lists.openwrt.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
Message-ID: <20120523135514.GF28713@yumi.tdiedrich.de> (sfid-20120523_155538_685404_51EE5E4F)
References: <20120517230400.GB22418@yumi.tdiedrich.de>
 <CAGXE3d-MTZu16cU1wybd6zehGOudKPadknuHm9MG6JDVRKmDag@mail.gmail.com>
 <20120522205829.GE28713@yumi.tdiedrich.de>
 <CAGXE3d-MLFJQ-O8=0ToC3fxx0=eLCi+Kbc-DDf_QaNQ2t42=pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d-MLFJQ-O8=0ToC3fxx0=eLCi+Kbc-DDf_QaNQ2t42=pQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa wrote:
> On Tue, May 22, 2012 at 10:58 PM, Tobias Diedrich
> <ranma+openwrt@tdiedrich.de> wrote:
> > Helmut Schaa wrote:
> >> On Fri, May 18, 2012 at 1:04 AM, Tobias Diedrich
> >> <ranma+openwrt@tdiedrich.de> wrote:
> >> > rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
> >> > respectively, similar to how it is already done in rt2[45]00pci.c
> >> >
> >> > rt2800lib.c doesn't initialize max_power and thus after
> >> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
> >> > was applied txpower is limited to 0 for these devices.
> >> >
> >> > This should be the proper fix compared to the net/wireless/reg.c
> >> > hack in http://patchwork.openwrt.org/patch/2165/
> >>
> >> Btw. Tobias, did this affect the real tx power of the device at all or
> >> is this just
> >> a cosmetic issue?
> >
> > Hmm, apparently setting txpower has no effect?
> > Is it not implemented in the driver?
> 
> It is, but only for devices with correct tx power limit in the eeprom.

Why?
Lowering the tx power should never be an issue, right?
Or are you saying I'm stuck with 0dBm txpower?
That would be an issue by itself.
Why not use min(hw defaults, regulatory limits) as maximum if there is
no limit in the eeprom?
Do I have to add an eeprom fixup that will insert valid txpower
limit bytes as an additional step after the eeprom extraction from flash
to make this work?

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
