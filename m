Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.173]:20467 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbXKLLOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 06:14:46 -0500
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [RFC] b43: multiple MAC addresses support
References: <1194572631.4793.64.camel@johannes.berg>
	<1194605550.4793.93.camel@johannes.berg>
	<20071111025808.GK4031@jm.kir.nu>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Mon, 12 Nov 2007 13:14:11 +0200
In-Reply-To: <20071111025808.GK4031@jm.kir.nu> (ext Jouni Malinen's message of "Sat\, 10 Nov 2007 18\:58\:08 -0800")
Message-ID: <87pryfd8cc.fsf@nokia.com> (sfid-20071112_111451_046579_6848E9DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Fri, Nov 09, 2007 at 11:52:30AM +0100, Johannes Berg wrote:
>
>> Something I'm not clear on right now is the timing of it all. If there
>> are say two BSSes, the driver can simply program the hardware to half
>> the beacon period and then the beacons will alternate. But if there are
>> seven BSSes, the beacon period might not be divisible by seven so timing
>> errors will happen and, worse yet, accumulate. Does hostapd somehow
>> account for this? Or should the beaconing work completely differently,
>> for example with all N beacons sent in a burst?
>
> You could always modify the beacon period to a suitable number that
> would be divisible by whatever number of BSSes there are and/or add
> empty slot to move from, say, 7 to 8, and just not send a beacon at some
> of the slots. Sending a burst of all beacons at the same time is also a
> valid option up to a certain limit on how long a time would be allocated
> for this. However, this may have some timing issues when there are
> multiple power save buffered broadcast/multicast frames waiting to be
> sent out. In general, it would be good to try to send the beacon frames
> as close to their correct time as possible to allow power saving
> stations to remain asleep most of the time.

Exactly, it is important for small mobile devices that beacons are
sent at the correct time. For example, I have seen broken APs which
Target Beacon Transmission Time fluctuates and Nokia N800 has high
power consumption because of that.

-- 
Kalle Valo
