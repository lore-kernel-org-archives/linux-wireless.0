Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34272 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0HBQCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 12:02:21 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=BUX59heXAW2Uf4wZo2dSS19Je54dkQ5u2YGAW@mail.gmail.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-4-git-send-email-ohad@wizery.com> <AANLkTimzA_JJ-byTDWznbL3YzeJ8LAP4M50onf2_3fBF@mail.gmail.com>
	<AANLkTi=Oy8X1xMOwWL_cKBB1LWULT6=p+adUgB+AuSJS@mail.gmail.com>
	<AANLkTi=BUX59heXAW2Uf4wZo2dSS19Je54dkQ5u2YGAW@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 2 Aug 2010 18:54:36 +0300
Message-ID: <AANLkTimZQKj7H_GeE=+O9cwxEMTR+LhfFbt=AyXGzN3d@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] mmc: support embedded data field in mmc_host
To: Vitaly Wool <vitalywool@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>, linux@arm.linux.org.uk,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vitaly,

On Thu, Jul 29, 2010 at 7:16 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
> On Thu, Jul 29, 2010 at 8:00 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>>> To my understanding, this data doesn't belong to mmc_host. It's not a
>>> host data at all. E. g. imagine a GPIO IRQ for some SDIO chip -- it's
>>> totally unrelated to host.
>>>
>>> I think a cleaner way would be to introduce something similar to what
>>> we have for SPI, e. g. struct sdio_board_info. This board info will
>>> contain platform-specific stuff and vendor id/chip id for each onboard
>>> SDIO device. Then the SDIO core will pick up the appropriate data
>>> basing on vendor id/chip id.
>>
>> Can you please elaborate some more about your proposal (specifically
>> where does this sdio_board_info get set and how do function drivers
>> access it) ?
>>
>> If I understand you correctly, you suggest to have a global,
>> board-specific table of sdio_board_info structures, which would be
>> accessible to the SDIO core (through the host driver ?). When a new
>> SDIO device is found the core would search this table for the
>> appropriate sdio_board_info struct and make it accessible to the SDIO
>> function driver ?
>
> Well, let's look at how it's implemented for SPI. There is the
> function spi_register_board_info in the SPI core which copies the
> board info into the local data structure (a linked list, actually).
> Whenever needed, the core walks through the list to find the
> appropriate board_info basing on some search key.
>
> I think this may be the way to go for SDIO as well.

IMHO this is a bit overkill solution for our problem.

SPI is using these spi_board_info tables to populate the SPI device
trees. These tables are registered early at the board-specific init
code, and are later used by SPI core to populate the devices when the
SPI master controller is registered.

SDIO doesn't normally needs any kind of hard coded data: most devices
are dynamically probed and populated.

On rare cases like the wl1271, we have some platform-specific data we
need to deliver the SDIO function driver (i.e. the irq info in this
case). Since the device is hardwired to a specific controller, it does
make some sense to pass this private data from the controller's info
in the board files, through the host driver, and make it accessible
through the specific host instance that drives this controller.

Btw, if our problem was be broader (e.g., needs to supply private data
for non-hardwired devices), then I agree that a more complex
mechanism, such as the one you suggest, would be needed. But currently
the problem is very simple and the solution is even simpler: just add
1 private pointer to the host.

Hope you find this reasonable,

Thanks,
Ohad.

>
> ~Vitaly
>
