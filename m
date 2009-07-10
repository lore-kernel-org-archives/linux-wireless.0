Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:47188 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZGJIKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 04:10:19 -0400
Received: by bwz25 with SMTP id 25so693084bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 01:10:17 -0700 (PDT)
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	Alexander Wenzel <wenzel@fgan.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Problem with p54 driver and ibss mode
References: <4A55DB91.2070305@fgan.de> <200907092056.53055.chunkeey@web.de>
	<87vdm1pr5m.fsf@litku.valot.fi>
	<200907100143.29004.jcmvbkbc@gmail.com>
	<1247176098.1905.8.camel@johannes.local>
	<87my7d10nz.fsf@litku.valot.fi>
	<73aaf0dd0907100043p7916c4fbid9aa2faa3580477d@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 10 Jul 2009 11:10:15 +0300
In-Reply-To: <73aaf0dd0907100043p7916c4fbid9aa2faa3580477d@mail.gmail.com> (Max Filippov's message of "Fri\, 10 Jul 2009 11\:43\:48 +0400")
Message-ID: <87iqi10xi0.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Max Filippov <jcmvbkbc@gmail.com> writes:

>>> Should be easy to copy the code into p54spi, we just never did, hoping
>>> Kalle would come up with a better way, maybe request_firmware() :)
>>
>> I agree with you, better not to copy the sysfs interface to p54spi. I'm
>> planning to experiment with the firmware interface at some point, but it
>> would be great if someone else could take a look at it first.
>
> I can take a look at it. (:

Excellent!

> But the question is... to take a look at it to see what?

:)

Basically we have been talking about fetching calibration data via the
request_firmware() interface. In user space there would be a udev script
which would dynamically retrieve the calibration data specific to the
platform it is running on. In N800/N810 case that would mean to run
stlc45xx-cal and provide the calibration data to the driver. 

This way we can have platform specific implementations and use already
existing user space interface. The idea was discussed in this mailing
list few months ago. The implementation details are currently unknown to
me. I was planning to talk about this at the Wireless Summit, but of
course I forgot :/

stlc45xx-cal will most probably need some changes, maybe dumping the
calibration data to stdout so that udev script can forward it to the
driver? I can do the necessary changes to stlc45xx-cal, but it's better
to have a some sort of working prototype before I'll start changing
stlc45xx-cal.

-- 
Kalle Valo
