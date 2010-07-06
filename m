Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55673 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0GFNrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 09:47:53 -0400
MIME-Version: 1.0
In-Reply-To: <4C33228D.8000908@nokia.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-15-git-send-email-ohad@wizery.com> <4C33228D.8000908@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Jul 2010 16:47:33 +0300
Message-ID: <AANLkTilARXB6NVMOAC7lW1HSOzDnONveS0oK6MomvDy0@mail.gmail.com>
Subject: Re: [PATCH 14/15] omap: zoom: add WLAN device
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

On Tue, Jul 6, 2010 at 3:33 PM, Roger Quadros <roger.quadros@nokia.com> wrote:
>> +static void omap_zoom_wlan_power(bool enable)
>> +{
>> +       int val = enable ? 1 : 0;
>> +
>> +       pr_info("%s: set power %d\n", __func__, val);
>> +
>> +       gpio_set_value(OMAP_ZOOM_WLAN_PMENA_GPIO, val);
>> +}
>
> Can we consider that OMAP_ZOOM_WLAN_PMENA_GPIO is equivalent to vmmc supply
> or equivalent to supply voltage to the SDIO card?

Not really, this gpio does not supply power to the chip. It's only a
digital indication that instructs the chip to go into on or off mode.

Thanks,
Ohad.
