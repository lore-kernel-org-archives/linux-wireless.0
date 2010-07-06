Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40288 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab0GFJbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 05:31:12 -0400
MIME-Version: 1.0
In-Reply-To: <4C32EF19.1000604@nokia.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-12-git-send-email-ohad@wizery.com> <4C32EF19.1000604@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Jul 2010 12:30:50 +0300
Message-ID: <AANLkTintIz-N7MwwtqhVq2LR3Ln5JTNYSbJUBSSClcA-@mail.gmail.com>
Subject: Re: [PATCH 11/15] wireless: wl1271: introduce platform device support
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
	San Mehat <san@google.com>, Ohad Ben-Cohen <ohadb@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Roger,

On Tue, Jul 6, 2010 at 11:53 AM, Roger Quadros <roger.quadros@nokia.com> wrote:
> Could you please explain why you need to do this?

To minimize power consumption when the wlan device is not in use, we
would like to keep the device powered off as long as the interface is
down, and only power it on when the user brings up the interface.

Whenever the chip is powered on, it must be initialized and
reconfigured by mmc_attach_sdio, and the wl1271 driver have to wait
for that phase to successfully complete (essentially waiting for the
sdio_driver's probe function to be called).

To make sure this SDIO init step occurs correctly every time we toggle
the device's power back on, and to prevent potential races, we also
have to make sure that the sdio function is removed every time we
power off the chip (the driver waits for the sdio_driver's remove
function to be called).

That's why we let the mmc layer think that the card is removed:
physically it is still there, but for all practical purposes it is
really removed, because once you power off the chip, you must
reinitialize it again next time you power it on, as if the card was
really removed and re-inserted.

Thanks,
Ohad.

>
> br,
> -roger
>
