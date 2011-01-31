Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47256 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023Ab1AaPiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:38:17 -0500
Received: by qwa26 with SMTP id 26so5593688qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 07:38:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296487362.3812.33.camel@jlt3.sipsolutions.net>
References: <201101311600.39486.IvDoorn@gmail.com>
	<1296487362.3812.33.camel@jlt3.sipsolutions.net>
Date: Mon, 31 Jan 2011 16:38:16 +0100
Message-ID: <AANLkTikzz0b+2N1ktVLz_CFZUBKzwrPF5y6xYLvmknbS@mail.gmail.com>
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while in
 powersave mode
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Add a delayed work structure which can be used to wakeup the device
>> just before a beacon from the AP is expected. This then allows the device
>> to receive the beacon, check if there are pending broadcast or multicast frames.
>>
>> TODO: Split out mac80211 changes into a separate patch. We also need
>> to know if we need this check in mac80211 or in the driver. Personally I think the
>> check belongs in mac80211, but at this time that work has been deferred to the drivers.
>> However this means that a lot of logic is needed in the driver to check if the correct IE
>> is available, and then check the value, while mac80211 will obtains that exact IE anyway
>> during RX processing anyway...
>
> Hmm. I've always said that there's no efficient way to do this in
> mac80211. If you do it close to the beacon, unexpected latency means
> that we miss -- this can be severe if something else is happening in the
> system, especially with USB devices. If you do it early before the
> beacon, then you don't save much power. As a consequence, I don't really
> like this in mac80211.
>
> However, it seems you only added "stay awake after beacon" code to
> mac80211 that checks the TIM. Assuming the device actually stays awake
> for multicast traffic by itself that seems like an option, though I
> wouldn't wait for the next beacon before going to sleep again --
> wouldn't that happen with the timer anyway?

The timer is needed to automatically wake the device up in time to receive
the beacon. When the beacon is received all the driver needs to know if the
device should go back to sleep again for the next beacon period.

This is a similar behavior as carl9170 driver, which currently checks for
pending Mcast/Bcast frames in the RX path just before the frame is send
to mac80211.

Ivo
