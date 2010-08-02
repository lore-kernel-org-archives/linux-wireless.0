Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65256 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0HBQZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 12:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimZQKj7H_GeE=+O9cwxEMTR+LhfFbt=AyXGzN3d@mail.gmail.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-4-git-send-email-ohad@wizery.com>
	<AANLkTimzA_JJ-byTDWznbL3YzeJ8LAP4M50onf2_3fBF@mail.gmail.com>
	<AANLkTi=Oy8X1xMOwWL_cKBB1LWULT6=p+adUgB+AuSJS@mail.gmail.com>
	<AANLkTi=BUX59heXAW2Uf4wZo2dSS19Je54dkQ5u2YGAW@mail.gmail.com>
	<AANLkTimZQKj7H_GeE=+O9cwxEMTR+LhfFbt=AyXGzN3d@mail.gmail.com>
Date: Mon, 2 Aug 2010 18:25:23 +0200
Message-ID: <AANLkTikfRja-h9mz7uyRXCZNZjKdU_yB8e58XQucUzrn@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] mmc: support embedded data field in mmc_host
From: Vitaly Wool <vitalywool@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
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

Hi Ohad,

On Mon, Aug 2, 2010 at 5:54 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:

> SPI is using these spi_board_info tables to populate the SPI device
> trees. These tables are registered early at the board-specific init
> code, and are later used by SPI core to populate the devices when the
> SPI master controller is registered.
>
> SDIO doesn't normally needs any kind of hard coded data: most devices
> are dynamically probed and populated.
>
> On rare cases like the wl1271, we have some platform-specific data we
> need to deliver the SDIO function driver (i.e. the irq info in this
> case). Since the device is hardwired to a specific controller, it does
> make some sense to pass this private data from the controller's info
> in the board files, through the host driver, and make it accessible
> through the specific host instance that drives this controller.
>
> Btw, if our problem was be broader (e.g., needs to supply private data
> for non-hardwired devices), then I agree that a more complex
> mechanism, such as the one you suggest, would be needed. But currently
> the problem is very simple and the solution is even simpler: just add
> 1 private pointer to the host.
>
> Hope you find this reasonable,

no, actually I don't. I think this is a hack that intrudes into the
area it completely doesn't belong to.

In fact, one can have 2 views on this problem: either this is a fairly
generic problem we need to address, or this is a very specific corner
case.
Your solution will be treated as a hack in both cases.

If we consider it a generic problem, then we need to find a generic
solution, which is the board_info solution, for instance. FWIW, I2C
also uses this approach now.

If we consider it to be a corner case, let's just add a dummy
platform_device like it's done in WL1251 implementation and keep the
MMC subsystem clean.

Thanks,
   Vitaly
