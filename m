Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:35849 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0GFKWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 06:22:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1007052134460.6020@xanadu.home>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-6-git-send-email-ohad@wizery.com> <alpine.LFD.2.00.1007052134460.6020@xanadu.home>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Jul 2010 13:22:26 +0300
Message-ID: <AANLkTim4E4LlFERmfYA1M0HLBOoRAsQuvdW6QBNu6pC0@mail.gmail.com>
Subject: Re: [PATCH 05/15] omap: hsmmc: add virtual card detect support
To: Nicolas Pitre <nico@fluxnic.net>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Pandita, Vikram" <vikram.pandita@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nicolas,

On Tue, Jul 6, 2010 at 4:45 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Tue, 6 Jul 2010, Ohad Ben-Cohen wrote:
>
>> From: Ohad Ben-Cohen <ohadb@ti.com>
>>
>> Add support for software emulation of card detect
>> events.
>>
>> This is required for specific controllers
>> that are hard wired with embedded SDIO devices
>> (such as TI's wl1271 WLAN device).
>
> Why?
>
> Many instances of hardwired SDIO based WLAN devices do exist already,
> and they don't need extra card detect events to be generated.  The core
> MMC code already triggers a probe for cards whenever a new host
> controller is registered.

We prefer not to power up the chip as early as boot time; instead, we
would like to have it powered off until the wlan interface is brought
up, power it on when the interface is brought up,
and power it off again as soon as the interface is brought down again
(to minimize power consumption when the wlan is not in use).

For that we can't rely on the probing done when the controller is
registered, we want to have a mechanism to allow dynamic detection and
removal of the card.

Note: the wl1271 device does support standard card detection, but
AFAIK there's a limitation to use that with the specific omap
controller the device is hardwired to. I will try to get more info
about that, but probably Madhu can comment on that better.

>> Board-specific configuration is required to
>> enable this software card detect control.
>
> Could you elaborate please?

Please check out the last patch - that patch is doing that configuration.
In essence, this virtual card detect mechanism is enabled only for
specific controllers which we know there's an embedded sdio device
hardwired to. This knowledge is board-specific, and that's why we
enable this mechanism in the board files, per a specific mmc
controller.

Thanks,
Ohad.


>
>
> Nicolas
>
