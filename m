Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34912 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbbCOIun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 04:50:43 -0400
MIME-Version: 1.0
In-Reply-To: <20150313151301.GJ5264@atomide.com>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com>
	<1426162154-8716-7-git-send-email-eliad@wizery.com>
	<20150313151301.GJ5264@atomide.com>
Date: Sun, 15 Mar 2015 10:50:42 +0200
Message-ID: <CAB3XZEdFMQexA69JEuw=VnqsNOEkWAM0+oWWmt6DaN9+hZ+vdw@mail.gmail.com> (sfid-20150315_095052_234022_75116C96)
Subject: Re: [PATCH v6 6/6] wlcore: remove wl12xx_platform_data
From: Eliad Peller <eliad@wizery.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Luciano Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2015 at 5:13 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Eliad Peller <eliad@wizery.com> [150312 05:10]:
>> Now that we have wlcore device-tree bindings in place
>> (for both wl12xx and wl18xx), remove the legacy
>> wl12xx_platform_data struct, and move its members
>> into the platform device data (that is passed to wlcore)
>>
>> Davinci 850 is the only platform that still set
>> the platform data in the legacy way (and doesn't
>> have DT bindings), so remove the relevant
>> code/Kconfig option from the board file (as suggested
>> by Sekhar Nori)
>>
>> Signed-off-by: Luciano Coelho <luca@coelho.fi>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  arch/arm/mach-davinci/Kconfig                  |  11 ---
>>  arch/arm/mach-davinci/board-da850-evm.c        | 113 -------------------------
>>  drivers/net/wireless/ti/wilink_platform_data.c |  25 ------
>>  drivers/net/wireless/ti/wl12xx/main.c          |  19 ++---
>>  drivers/net/wireless/ti/wlcore/boot.c          |   1 -
>>  drivers/net/wireless/ti/wlcore/main.c          |   4 +-
>>  drivers/net/wireless/ti/wlcore/sdio.c          |  75 +++++-----------
>>  drivers/net/wireless/ti/wlcore/wlcore_i.h      |   8 +-
>>  include/linux/wl12xx.h                         |  25 ------
>>  9 files changed, 36 insertions(+), 245 deletions(-)
>
> I got a build error related to the SPI driver with this series, probably
> need to update this patch:
>
> drivers/net/wireless/ti/wlcore/spi.c: In function ‘wl1271_probe’:
> drivers/net/wireless/ti/wlcore/spi.c:334:11: error: ‘struct wlcore_platdev_data’ has no member named ‘pdata’
>   pdev_data.pdata = dev_get_platdata(&spi->dev);
>            ^
> drivers/net/wireless/ti/wlcore/spi.c:335:16: error: ‘struct wlcore_platdev_data’ has no member named ‘pdata’
>   if (!pdev_data.pdata) {
>
yeah, i missed it :/

looks like there's no platform that defines platform data for it.
i'll replace the dev_get_platdata() with a function that only parses
the clock-frequency properties (the irq is taken in this case from the
spi_device).
(or maybe i should just drop it, as no one actually uses it?)

thanks,
Eliad.
