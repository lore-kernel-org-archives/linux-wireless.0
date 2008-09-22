Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:49358 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYIVIG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 04:06:29 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Christian Lamparter" <chunkeey@web.de>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
References: <877i98iw4h.fsf@nokia.com>
	<43e72e890809182257r65da8757g1de0ce4f132bf019@mail.gmail.com>
	<1221814778.10419.23.camel@johannes.berg>
	<200809191658.46690.chunkeey@web.de>
	<43e72e890809191055o4085fab1k8a85fe9266ae8aab@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 22 Sep 2008 11:06:05 +0300
In-Reply-To: <43e72e890809191055o4085fab1k8a85fe9266ae8aab@mail.gmail.com> (ext Luis R. Rodriguez's message of "Fri\, 19 Sep 2008 10\:55\:18 -0700")
Message-ID: <87wsh438r6.fsf@nokia.com> (sfid-20080922_100634_471538_88F90E58)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

>>> > Cool! I thought n810 basically used a p54 type chipset over SPI?
>>>
>>> Yes, but the firmware (lower MAC) is sufficiently different that it
>>> would be painful to support in p54, afaict.
>>>
>> not that much... only the frequency calibration data is a bit different,
>> while most other data structures are more or less the same. Really!
>
> Well to be fair we had similar question with ath5k and we went with
> ath9k because that's how we best could support the hardware as quickly
> as possible for users. Eventually we will converge though as it just
> makes sense in areas that we can share. So if this driver is targeted
> upstream to get users supported I can see how using a new driver
> supported by a team can make sense. But eventually convergence should
> be considered.

I don't have the p54 hardware (for regression testing) or the time to
add stlc45xx support to p54, and most probably there might be even
some legal implications which might prevent me of doing the work. So
somebody else would have to do the converge between p54 and stlc45xx.

> Is this driver targeted for inclusion upstream?

Yes, that's my goal but it's not quite ready yet. Now that the driver
is published I will be doing cleanup, starting from Johannes'
comments. I also understand that there might problems with the
upstream inclusion, biggest one being the proprietary user space
calibration tool.

I'm very interested in mac80211 and would like to see it suitable for
embedded devices like N800/N810. The just announced stlc45xx driver
would be a perfect tool for that kind of development and having the
driver upstream would make development a lot easier. 

Features that I am interested in, just from the top of my head, are
proper roaming support, power save mode and beacon filtering. In my
opinion the biggest areas needing work are everything related to
mobility or the power consumption.

> If the driver is targeted upstream and a company is sponsoring its
> development we would like a license for the firmware. I mentioned this
> on another thread but it must be one which meets distribution
> requirements. You can see the WHENCE file on linux-firmware git tree
> for examples.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
>
> Otherwise how can I use this driver, test it or enhance it?

Currently sltc45xx is usable only on N800/N810 and the rootfs in those
devices contains the firmware. But, like I already said in
stlc45xx-devel, I'm working on this. Just don't expect a quick
resolution, working with lawyers is slow.

-- 
Kalle Valo
