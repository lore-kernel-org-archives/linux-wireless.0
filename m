Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49192 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0GFMDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 08:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <4C330D37.4090104@nokia.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-6-git-send-email-ohad@wizery.com> <alpine.LFD.2.00.1007052134460.6020@xanadu.home>
	<AANLkTim4E4LlFERmfYA1M0HLBOoRAsQuvdW6QBNu6pC0@mail.gmail.com>
	<4C330D37.4090104@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Jul 2010 15:02:50 +0300
Message-ID: <AANLkTil8BOU6s8KKXmlmHHhSZJHv62okjL6ltXlQK1-G@mail.gmail.com>
Subject: Re: [PATCH 05/15] omap: hsmmc: add virtual card detect support
To: Roger Quadros <roger.quadros@nokia.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Pandita, Vikram" <vikram.pandita@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 6, 2010 at 2:02 PM, Roger Quadros <roger.quadros@nokia.com> wrote:
> On 07/06/2010 01:22 PM, ext Ohad Ben-Cohen wrote:
>> We prefer not to power up the chip as early as boot time; instead, we
>
> Why?

Let's say you boot your device but never use WLAN.
In this scenario, we prefer the wl1271 device to stay powered off to
minimize power consumption.
This way we will power on the wl1271 device only when the user
actually turns WLAN on.

> The function driver should power it down later if required. no?

Care to explain this ? I'm not sure I'm following: the sdio function
is added and the sdio driver is probed only after you power on the
wl1271 device and let the mmc layer initialize and configure it. Why
would you want to do that if WLAN is disabled (i.e. user didn't turn
wlan on) ?

> If it was powered OFF then how did the wlan interface come into picture?

As soon as you insmod wl1271 and wl1271_sdio, you will have a wlan
interface (which is still down). At this point the wl1271 device is
still powered off and not consuming power.

If the user chooses to enable wlan (i.e. ifconfig wlan0 up), the chip
is powered on, it is initialized and configured by the mmc layer, and
then it can be used for WLAN activities.

> I agree, we some how need to power down the card when not in use in the
> right way.

In this patchset proposal, as soon as the user disables wlan (i.e.
ifconfig wlan0 down), the wl1271 device is powered off, and the
corresponding sdio function is removed.


Thanks,
Ohad.
