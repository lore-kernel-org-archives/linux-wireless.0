Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56542 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0IOI0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 04:26:05 -0400
Date: Wed, 15 Sep 2010 09:25:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
	Kalle Valo <kalle.valo@iki.fi>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Ido Yariv <ido@wizery.com>, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/7] wireless: wl12xx: add platform data passing
	support
Message-ID: <20100915082544.GA4625@n2100.arm.linux.org.uk>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com> <1283376410-9999-4-git-send-email-ohad@wizery.com> <AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com> <20100906120716.GE20903@n2100.arm.linux.org.uk> <AANLkTikAFCd+3ggZKhQXY=+bG==KgLkv3qNVdEGa=GBX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTikAFCd+3ggZKhQXY=+bG==KgLkv3qNVdEGa=GBX@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 06, 2010 at 09:42:41PM +0200, Michał Mirosław wrote:
> W dniu 6 września 2010 14:07 użytkownik Russell King - ARM Linux
> <linux@arm.linux.org.uk> napisał:
> > On Sat, Sep 04, 2010 at 02:23:19PM +0200, Michał Mirosław wrote:
> >> 2010/9/1 Ohad Ben-Cohen <ohad@wizery.com>:
> >> > Add a simple mechanism to pass platform data to the
> >> > SDIO instances of wl12xx.
> [cut patch]
> >> Why do you need all that copying? Isn't the data constant?
> >
> > The first copy is to allow platforms to have their data marked with
> > __initdata.  The second copy probably isn't necessary, but avoids
> > problems where the driver may decide to modify the platform data.
> 
> Sorry for pushing at this, but why would you mark data that's meant to
> be used after init phase as __initdata?

Because you may have many instances of the data (due to multiple platform
support), and only need one of them at run-time.
