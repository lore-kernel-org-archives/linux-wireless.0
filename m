Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30735 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYKKMaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 07:30:23 -0500
To: "Vivek Natarajan" <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211 dynamic powersave
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	<8e92b4100811102018q4a13568l625abf2c59dca253@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 11 Nov 2008 14:29:14 +0200
In-Reply-To: <8e92b4100811102018q4a13568l625abf2c59dca253@mail.gmail.com> (ext Vivek Natarajan's message of "Tue\, 11 Nov 2008 09\:48\:23 +0530")
Message-ID: <87k5babg4l.fsf@nokia.com> (sfid-20081111_133043_344251_5D49B0EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> Hello Kalle,

Hello Vivek,

>   I have a few questions on the PS implementation. Here they are,
>
> 1) I see from your patch that power save is enabled whenever there
>    is no Tx for the specified 'timeout' period. Should we also take into
>    account the type of power connection( i.e battery or direct ac supply)
>    before enabling PS?

That's a policy decision and should be in user space. User space can
enable or disable the dynamic PS as it sees fit based on different
parameters.

> 2) Do you intend to leave the NULL frame formation

[to the driver]

Yes, that was my and Johannes' plan.

> waking up the chip for TIM

What do you mean by this? Sending a beacon interval setting to the chip?

> and modifying sleep/awake time according to DTIM to the driver since
> I did not see this in your TODO list?

I think these should be in mac80211, just haven't thought that far
yet. I'll add it to the TODO list.

> ( I understand from the iwlwifi code that it just sends a request to
> the firmware for sending NULL frame and the firmware takes care of
> the rest. But it may not be so in the case of other vendor drivers.)

Yes, that's how I have understood iwlwifi to work. Currently stlc45xx
is the only hardware which requires the driver to create the null
frames, but if we are more than one hardware I think we need to
considering adding the feature to mac80211 (with a new HW flag, of
course).

> 3) Is the PS-POLL concept(or M frames in N milliseconds concept of Johannes)
>
>      dropped after the DNS response timings related discussion that you had
>      since it might save some more power in low-traffic conditions?

I have dropped it for now. I try to get a simple implementation
approved first, we can add advanced stuff later.

-- 
Kalle Valo
