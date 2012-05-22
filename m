Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:57834 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab2EVU6f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 16:58:35 -0400
Date: Tue, 22 May 2012 22:58:29 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, openwrt-devel@lists.openwrt.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
Message-ID: <20120522205829.GE28713@yumi.tdiedrich.de> (sfid-20120522_225838_814054_4DEE713B)
References: <20120517230400.GB22418@yumi.tdiedrich.de>
 <CAGXE3d-MTZu16cU1wybd6zehGOudKPadknuHm9MG6JDVRKmDag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d-MTZu16cU1wybd6zehGOudKPadknuHm9MG6JDVRKmDag@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa wrote:
> On Fri, May 18, 2012 at 1:04 AM, Tobias Diedrich
> <ranma+openwrt@tdiedrich.de> wrote:
> > rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
> > respectively, similar to how it is already done in rt2[45]00pci.c
> >
> > rt2800lib.c doesn't initialize max_power and thus after
> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
> > was applied txpower is limited to 0 for these devices.
> >
> > This should be the proper fix compared to the net/wireless/reg.c
> > hack in http://patchwork.openwrt.org/patch/2165/
> 
> Btw. Tobias, did this affect the real tx power of the device at all or
> is this just
> a cosmetic issue?

Hmm, apparently setting txpower has no effect?
Is it not implemented in the driver?

i.e. regardless of "iw (dev wlan0|phy phy0) set txpower fixed (100|2000)"
I don't see any significant chane in Wifi Analyzer on my Android
phone.

(The real reason I couldn't connect to the AP at all was a different recent
change)

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
