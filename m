Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:59108 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbbCOMKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 08:10:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eliad Peller <eliad@wizery.com>, Tony Lindgren <tony@atomide.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?ISO-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>
Subject: Re: [PATCH v6 6/6] wlcore: remove wl12xx_platform_data
Date: Sun, 15 Mar 2015 13:08:19 +0100
Message-ID: <2070859.WcMooC33YH@wuerfel> (sfid-20150315_131047_538517_5272D631)
In-Reply-To: <CAB3XZEdFMQexA69JEuw=VnqsNOEkWAM0+oWWmt6DaN9+hZ+vdw@mail.gmail.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com> <20150313151301.GJ5264@atomide.com> <CAB3XZEdFMQexA69JEuw=VnqsNOEkWAM0+oWWmt6DaN9+hZ+vdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 15 March 2015 10:50:42 Eliad Peller wrote:
> yeah, i missed it :/
> 
> looks like there's no platform that defines platform data for it.
> i'll replace the dev_get_platdata() with a function that only parses
> the clock-frequency properties (the irq is taken in this case from the
> spi_device).
> (or maybe i should just drop it, as no one actually uses it?)

I don't think we should drop the driver, but dropping the platform_data
support sounds reasonable. New users of this driver should all be using
DT, and if there is a good reason to use platform_data, it's easily
put back.

	Arnd
