Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:31411 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0GFOb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 10:31:28 -0400
Message-ID: <4C333E0D.2070601@nokia.com>
Date: Tue, 06 Jul 2010 17:30:37 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>
Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device support
References: <1278376666-3509-1-git-send-email-ohad@wizery.com> 	<1278376666-3509-12-git-send-email-ohad@wizery.com> <4C32EF19.1000604@nokia.com> 	<AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com> 	<4C3306F4.8060907@nokia.com> <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com>
In-Reply-To: <AANLkTin5W52fPzWToRrAzm56SLZI-taSuI16rCEhLWqH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2010 03:53 PM, ext Ohad Ben-Cohen wrote:
> Hi Roger,
>
> On Tue, Jul 6, 2010 at 1:35 PM, Roger Quadros<roger.quadros@nokia.com>  wrote:
>> My point is that shouldn't this be handled by SDIO core?
>
> Care to explain what you mean / give a code example ?

If the Power enable GPIO can be treated as SDIO slot supply (i.e. vmmc), then 
the SDIO/MMC core should tackle it, just like it deals with supply for slots 
with removable cards.

see mmc_regulator_set_ocr()
mmc_power_up()
mmc_set_ios()

in drivers/mmc/core/core.c

and omap_hsmmc_set_ios()

in drivers/mmc/host/omap_hsmmc.c

>
>> If there are no users for the SDIO function and the card, doesn't the SDIO
>> core power down the slot and take care of re-initialization when it is
>> powered up?
>
> You need card detect events in order to trigger card&  sdio function
> initialization and removals.
>
> Please share any alternative approach you may be thinking on.

OK, this is how I see it.

- Treat the non-removable card as non-removable. So no need to do card detect 
emulation.

- Treat the GPIO power enable on wl1271 as VMMC supply. Use fixed regulator 
framework to define this regulator & supply. Even though you mention that it is 
not actually a supply, it fits well in the fixed supply framework.

- When the host controller is enumerated, the mmc core will power up the slot, 
find the sdio card, and probe the function driver (i.e. wl1271_sdio).

- if interface is not in use, the function driver must release the sdio host, 
and this should eventually disable the vmmc supply.

- Whenever the wlan interface must be brought up, wl1271_sdio, can claim the 
sdio host. this will cause the vmmc supply to be enabled, for as long as the 
interface is up.

Does this address all issues?

regards,
-roger
