Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65428 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0IOQkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 12:40:03 -0400
Date: Wed, 15 Sep 2010 09:39:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	akpm@linux-foundation.org, Nicolas Pitre <nico@fluxnic.net>,
	linux-mmc@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-wireless@vger.kernel.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/7] wireless: wl12xx: add platform data passing
 support
Message-ID: <20100915163939.GU8647@atomide.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
 <1283376410-9999-4-git-send-email-ohad@wizery.com>
 <AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com>
 <20100906120716.GE20903@n2100.arm.linux.org.uk>
 <AANLkTikAFCd+3ggZKhQXY=+bG==KgLkv3qNVdEGa=GBX@mail.gmail.com>
 <AANLkTinM8vY7CygEN6DBR35WLkU-QOBwuiaRrpfwF6Mz@mail.gmail.com>
 <AANLkTikSP874gnsPrc_M1LJYNpjX+Lz3-5=Bk5_HtgP+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTikSP874gnsPrc_M1LJYNpjX+Lz3-5=Bk5_HtgP+@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Vitaly Wool <vitalywool@gmail.com> [100915 01:18]:
> 2010/9/15 Ohad Ben-Cohen <ohad@wizery.com>:
> >> Sorry for pushing at this, but why would you mark data that's meant to
> >> be used after init phase as __initdata?
> >
> > I can remove the first copying as well if Russell is ok with it.
> 
> I personally think it's not worth it. This copying basically happens
> only once and this point is soooo irrelevant. My position therefore
> is: let's get the current implementation in, and if Michal is
> uncomfortable with that, he can come up with the patch. Let's
> concentrate on the real problems.

This becomes an issue when compiling in support for multiple
boards.. All the data that's not in use for the booted board
should be __initdata.

Regards,

Tony
