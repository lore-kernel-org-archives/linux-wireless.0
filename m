Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36755 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbbCQG6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 02:58:51 -0400
MIME-Version: 1.0
In-Reply-To: <20150316182426.GW5264@atomide.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
	<20150313151301.GJ5264@atomide.com>
	<CAB3XZEdFMQexA69JEuw=VnqsNOEkWAM0+oWWmt6DaN9+hZ+vdw@mail.gmail.com>
	<2070859.WcMooC33YH@wuerfel>
	<20150316152939.GP5264@atomide.com>
	<20150316182536.GA16829@earth>
	<20150316182426.GW5264@atomide.com>
Date: Tue, 17 Mar 2015 08:58:50 +0200
Message-ID: <CAB3XZEdtmCDnHLW_JpmPXu2rgg8RNkOvPaUfoijmL_UsG93_Gg@mail.gmail.com> (sfid-20150317_075857_824584_226E0E4B)
Subject: Re: [PATCH v6 6/6] wlcore: remove wl12xx_platform_data
From: Eliad Peller <eliad@wizery.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Sebastian Reichel <sre@ring0.de>, Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>,
	=?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2015 at 8:24 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Sebastian Reichel <sre@ring0.de> [150316 11:26]:
>> Hi,
>>
>> On Mon, Mar 16, 2015 at 08:29:39AM -0700, Tony Lindgren wrote:
>> > * Arnd Bergmann <arnd@arndb.de> [150315 05:10]:
>> > > On Sunday 15 March 2015 10:50:42 Eliad Peller wrote:
>> > > > yeah, i missed it :/
>> > > >
>> > > > looks like there's no platform that defines platform data for it.
>> > > > i'll replace the dev_get_platdata() with a function that only parses
>> > > > the clock-frequency properties (the irq is taken in this case from the
>> > > > spi_device).
>> > > > (or maybe i should just drop it, as no one actually uses it?)
>> > >
>> > > I don't think we should drop the driver, but dropping the platform_data
>> > > support sounds reasonable. New users of this driver should all be using
>> > > DT, and if there is a good reason to use platform_data, it's easily
>> > > put back.
>> >
>> > Well we have n8x0 and n900 using the spi driver. For those, n8x0 boot
>> > all in dts mode, but n900 still also boots in legacy mode. It seems the
>> > board-rx51-peripherals.c only passes the power_gpio though, so that
>> > should be easy to keep around.
>> >
>> > We should keep things still working for n900 in legacy mode until the
>> > pending regressions with device tree based booting have been cleared
>> > for at least one merge cycle. I believe the last pending issues is the
>> > support for ATAG_REVISION in device tree mode as posted by Pali.
>>
>> mh by migrating to newer gpiod interface platform data is no longer
>> needed (instead the boardfile would need a gpiod_lookup_table). That
>> way all of the dirty code is in the board file and will be removed
>> once the time comes. See for example rx51_fmtx_gpios_table.
>>
>> Note: This is independent of wl12xx changes, since N900 uses wl1251.
>
> Oh sorry yes sounds like that's different platform data then. In that
> case I see no reasons to drop the platform data for wl12xx.
>
great.
so i'll drop the relevant wlcore_spi platform data code, and rebase
the patches on top of v4.0-rc4 (probably tomorrow).

Eliad.
