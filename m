Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36086 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab1BBTJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 14:09:03 -0500
Received: by qyk12 with SMTP id 12so319612qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 11:09:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <874o8mbaec.fsf@purkki.adurom.net>
References: <201101311600.39486.IvDoorn@gmail.com>
	<874o8mbaec.fsf@purkki.adurom.net>
Date: Wed, 2 Feb 2011 20:09:02 +0100
Message-ID: <AANLkTikKevPWkWMu=HLPHt-jACLZLQzqN6thr-2LNk59@mail.gmail.com>
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while in
 powersave mode
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	RA-Jay Hung <Jay_Hung@ralinktech.com>,
	RA-Dennis Lee <Dennis_Lee@ralinktech.com>,
	RA-Eddy Tsai <Eddy_Tsai@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> Add a delayed work structure which can be used to wakeup the device
>> just before a beacon from the AP is expected. This then allows the
>> device to receive the beacon, check if there are pending broadcast
>> or multicast frames.
>
> So the firmware/hardware doesn't have support for tracking and waking
> up for beacons? I didn't even know that such hardware exists :) Waking
> up for beacons from host sounds very inefficient and unrealiable. All
> the devices I have seen either do this in firmware or hardware due to
> time constraints. Even at76c50x-usb, which is ancient, does all this
> in firmware.
>
> Are you sure there's no way to do this with hardware?

Well the official Ralink driver also uses a timer to wakeup the hardware,
there are however registers which suggest support for autowake functionality.

Jay, Dennis, Eddy, can you explain a but how the autowake functionality is
implemented in the rt2800usb firmware?

>> TODO: Split out mac80211 changes into a separate patch. We also need
>> to know if we need this check in mac80211 or in the driver.
>> Personally I think the check belongs in mac80211, but at this time
>> that work has been deferred to the drivers. However this means that
>> a lot of logic is needed in the driver to check if the correct IE is
>> available, and then check the value, while mac80211 will obtains
>> that exact IE anyway during RX processing anyway...
>
> I'm worried that client power save support in mac80211 is getting
> quite complex already. How many drivers need this feature?

At least rt2800usb and carl9170. But I haven't done a full round
through all drivers though.

Ivo
