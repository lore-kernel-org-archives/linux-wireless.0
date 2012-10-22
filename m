Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46740 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2JVQDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 12:03:23 -0400
Message-ID: <1350921800.1785.23.camel@aeonflux> (sfid-20121022_180329_784216_8F7D02EE)
Subject: Re: [PATCH 1/2] NFC: Move pn544.h header file close to the driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Oct 2012 09:03:20 -0700
In-Reply-To: <20121022143009.GB5800@sortiz-mobl>
References: <1350672971-29716-1-git-send-email-marcel@holtmann.org>
	 <20121022143009.GB5800@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

> > With the removal of the deprecated pn544.c driver, the header
> > file pn544.h is now used only by the new pn544_hci.c driver. So
> > move the header file close to the driver.
> 
> There are quite a bit of junk in this header file, as outlined from your
> second patch. But there is a platform data structure definition (struct
> pn544_nfc_platform_data) that should be available from the arch code.
> 
> By passing function pointers (That don't do anything else than toggling
> GPIOs) from arch code to the driver, this function is not very nice. Nor
> flexible as it won't work with e.g. DT platforms. The driver should just get
> the IRQ and the 3 potentially needed GPIOs and implement the functions itself.
> Even when that happens, we'll still need a header file that !DT platform could
> use to pass the GPIO numbers around. So the bottom line is: We need to keep
> this one under include/linux/nfc/.

all good intentions, but it does not seem to work this way anyway. I was
tempted to actually just merge the one struct and one enum into the
driver itself.

Regards

Marcel


