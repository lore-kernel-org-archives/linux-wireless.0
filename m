Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60070 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0GYMk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jul 2010 08:40:57 -0400
MIME-Version: 1.0
In-Reply-To: <4C482D01.1040109@nokia.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-19-git-send-email-ohad@wizery.com> <4C482D01.1040109@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 25 Jul 2010 15:40:35 +0300
Message-ID: <AANLkTimfJnC7onDT83DWLb7sR7+evJB3eymt5Z6JYkAt@mail.gmail.com>
Subject: Re: [PATCH v2 18/20] mmc: sdio: enable a default power off mode of
	the card
To: Roger Quadros <roger.quadros@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 2:35 PM, Roger Quadros <roger.quadros@nokia.com> wrote:
> On 07/21/2010 08:33 PM, ext Ohad Ben-Cohen wrote:
>>
>> Add support for an SDIO device to stay powered off even without
>> the presence of an SDIO function driver. A host should explicitly
>> ask for it by means of MMC_CAP_DONT_POWER_CARD, and the SDIO
>> function driver should know it needs to call sdio_claim_power
>> before accessing the device.
>>
>> Signed-off-by: Ohad Ben-Cohen<ohad@wizery.com>
>
> Shouldn't this be the default behaviour? If there is no function driver for
> any of the functions of the card, then sdio core shold power off the card.
>
> I don't see a need for a special capability flag for this.
>
> in fact MMC_CAP_DONT_POWER_CARD does not seem like an mmc host's capability

Totally agree.

I didn't want to change the current behavior of the cards/funcs so I
looked for a way to explicitly power down only specific cards.

Alternatively we could power down all cards at the end
mmc_attach_sdio, and then power them up selectively in sdio_bus_probe,
just before calling probe. If the probe succeeds, the function driver
takes over. If the probe fails, we can power them down again.

Is that what you meant ?

This would work both if the sdio function driver is already loaded, or
will only be loaded at a later time. But I'm not too fond of the extra
power on/off cycles that it will introduce for each card..

Thanks,
Ohad.

> flag, it seems more like a request from the board to keep the card powered
> off.
>
> regards,
> -roger
>
