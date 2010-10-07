Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53791 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760395Ab0JGMcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 08:32:41 -0400
Subject: Re: [PATCH v2 00/11] SDIO Runtime PM Support
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>, Chris Ball <cjb@laptop.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>
In-Reply-To: <1286020455-28946-1-git-send-email-ohad@wizery.com>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 15:32:16 +0300
Message-ID: <1286454736.27371.37.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-10-02 at 13:54 +0200, ext Ohad Ben-Cohen wrote:
> Introduce SDIO runtime PM support:
> 
> 1. Power to SDIO cards is kept low until one of its functions is bound
>    (i.e. a matching driver is successfully probed)
> 
> 2. If the matching driver supports runtime PM, power to the card is
>    dropped soon after probe() returns. It is then up to the driver
>    to request power to its function, using runtime PM API (the get/put
>    variants). This is demonstrated with the wl1271 driver, in which
>    the power of the card power is coupled with the state of the wlan
>    interface (interface up -> power is up, interface down -> power is down)
> 
> 3. If a matching driver does not support runtime PM, power to the card
>    is kept high during the whole lifetime of the driver
> 
> 4. When the driver is removed, power to the card is immediately dropped
> 
> 5. If there are multiple drivers for the same card (several SDIO functions),
>    power will be pulled high before the first driver probes, and dropped
>    down after the last driver is removed. In between, power will be
>    maintained accrording to the accumulated usage count of the complete
>    drivers group
> 
> 6. SDIO suspend/resume semantics are unchanged. In addition, when the system
>    comes out of suspend, it is guaranteed that the power state of the
>    SDIO card will reflect its runtime PM usage count.
> 
> 7. What was NOT changed:
>    - Interface: drivers can still assume that the card is powered
>      when probe/remove/suspend/resume are called
>    - Existing behavior: drivers that do not support runtime PM
>      are unchanged
> 
> Changes since v1:
> - Interaction with system suspend/resume
> - Better commentary
> 
> Dependencies:
> - SDIO patches are against mmc-next, and have a runtime dependency on
>   commit "PM / Runtime: Lenient generic runtime pm callbacks"
>   (patch is in linux-next now)
> - WLAN patches depend on recent wl1271 activity, and they are here
>   just to demonstrate the usage of the SDIO patchset (will be
>   resubmitted separately)
> 
> The full patchset, together with all its dependencies, is also available at:
> git://wizery.com/pub/mmc.git runtime-pm-v2

I have tested this on my beagle board with the wl1271 patches that Ohad
provided and it seems to be working fine.  I've also created a small
script to stress test the implementation a little bit and didn't see any
problems.

Tested-by: Luciano Coelho <luciano.coelho@nokia.com>

This is quite an important fix in the wl1271 point-of-view.  Chris, do
you think there is any chance that this could make it to 2.6.37?


-- 
Cheers,
Luca.

