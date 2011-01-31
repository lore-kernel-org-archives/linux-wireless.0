Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1AaPWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:22:45 -0500
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while
 in powersave mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
In-Reply-To: <201101311600.39486.IvDoorn@gmail.com>
References: <201101311600.39486.IvDoorn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 16:22:42 +0100
Message-ID: <1296487362.3812.33.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 16:00 +0100, Ivo van Doorn wrote:
> Add a delayed work structure which can be used to wakeup the device
> just before a beacon from the AP is expected. This then allows the device
> to receive the beacon, check if there are pending broadcast or multicast frames.
> 
> TODO: Split out mac80211 changes into a separate patch. We also need
> to know if we need this check in mac80211 or in the driver. Personally I think the
> check belongs in mac80211, but at this time that work has been deferred to the drivers.
> However this means that a lot of logic is needed in the driver to check if the correct IE
> is available, and then check the value, while mac80211 will obtains that exact IE anyway
> during RX processing anyway...

Hmm. I've always said that there's no efficient way to do this in
mac80211. If you do it close to the beacon, unexpected latency means
that we miss -- this can be severe if something else is happening in the
system, especially with USB devices. If you do it early before the
beacon, then you don't save much power. As a consequence, I don't really
like this in mac80211.

However, it seems you only added "stay awake after beacon" code to
mac80211 that checks the TIM. Assuming the device actually stays awake
for multicast traffic by itself that seems like an option, though I
wouldn't wait for the next beacon before going to sleep again --
wouldn't that happen with the timer anyway?

johannes

