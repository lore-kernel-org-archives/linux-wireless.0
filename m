Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50723 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab1BBRmx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 12:42:53 -0500
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while in powersave mode
References: <201101311600.39486.IvDoorn@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 02 Feb 2011 19:42:51 +0200
In-Reply-To: <201101311600.39486.IvDoorn@gmail.com> (Ivo van Doorn's message of "Mon\, 31 Jan 2011 16\:00\:38 +0100")
Message-ID: <874o8mbaec.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn <ivdoorn@gmail.com> writes:

> Add a delayed work structure which can be used to wakeup the device
> just before a beacon from the AP is expected. This then allows the
> device to receive the beacon, check if there are pending broadcast
> or multicast frames.

So the firmware/hardware doesn't have support for tracking and waking
up for beacons? I didn't even know that such hardware exists :) Waking
up for beacons from host sounds very inefficient and unrealiable. All
the devices I have seen either do this in firmware or hardware due to
time constraints. Even at76c50x-usb, which is ancient, does all this
in firmware.

Are you sure there's no way to do this with hardware?

> TODO: Split out mac80211 changes into a separate patch. We also need
> to know if we need this check in mac80211 or in the driver.
> Personally I think the check belongs in mac80211, but at this time
> that work has been deferred to the drivers. However this means that
> a lot of logic is needed in the driver to check if the correct IE is
> available, and then check the value, while mac80211 will obtains
> that exact IE anyway during RX processing anyway...

I'm worried that client power save support in mac80211 is getting
quite complex already. How many drivers need this feature?

And if hardware is so broken, is it really worth the effort of trying
to implement power save with ugly hacks like this? If power
consumption is important for the user, I would recommend just buying
better hardware.

-- 
Kalle Valo
