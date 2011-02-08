Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57239 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1BHI1E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:27:04 -0500
To: Johannes Stezenbach <js@sig21.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while in powersave mode
References: <201101311600.39486.IvDoorn@gmail.com>
	<874o8mbaec.fsf@purkki.adurom.net> <20110202212912.GA28687@sig21.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 08 Feb 2011 10:27:02 +0200
In-Reply-To: <20110202212912.GA28687@sig21.net> (Johannes Stezenbach's message of "Wed\, 2 Feb 2011 22\:29\:12 +0100")
Message-ID: <87r5bj7wyx.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Stezenbach <js@sig21.net> writes:

> On Wed, Feb 02, 2011 at 07:42:51PM +0200, Kalle Valo wrote:
>> So the firmware/hardware doesn't have support for tracking and waking
>> up for beacons? I didn't even know that such hardware exists :) Waking
>> up for beacons from host sounds very inefficient and unrealiable. All
>> the devices I have seen either do this in firmware or hardware due to
>> time constraints. Even at76c50x-usb, which is ancient, does all this
>> in firmware.
>
> IMHO this is a bit exaggerated.

Ok, you have a point that maybe I was exaggerating a bit too much.

>  Given that the beacon interval is typically ~100 msecs, and typical
> worst cast irq latencies on Linux 2.6 are a few 100 usecs, we can
> sleep e.g. 90msecs and wake up in time to catch the beacon with high
> probability, thus saving 90% on PHY power. Not perfect, but good
> enough, isn't it?

But it's not only about irq latency. If we would implement this in
mac80211 at least one context switch is involved before the beacon is
processed. Also driver might create more latency. And then there's
waking up chip from the sleep mode, that usually takes time. And what
happens when the host is under severe load? I just think that there is
just too much ucertainty here and I don't trust this to be reliable.

So I have my concerns if it really makes sense to implement this in
mac80211. Extra complexity (and extra maintenance) for two sub-optimal
(from power save point of view) hardware.

(dropping rt2x00 list because it spams me about not being subscribed)

-- 
Kalle Valo
