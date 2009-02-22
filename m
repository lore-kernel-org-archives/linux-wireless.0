Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:51622 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbZBVLqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 06:46:55 -0500
Received: by bwz5 with SMTP id 5so3932015bwz.13
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2009 03:46:52 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
	<8763j7qyfx.fsf@litku.valot.fi> <1235014330.6344.18.camel@rainbow>
	<87fxibhr5q.fsf@litku.valot.fi>
	<c4d76b3b0902192007s347ea4e3hcfa3fae1a1e3060b@mail.gmail.com>
	<87hc2okyrm.fsf@litku.valot.fi>
	<c4d76b3b0902211344j5cefcdd3p4e34ddc0ac5d78d@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 22 Feb 2009 13:46:50 +0200
In-Reply-To: <c4d76b3b0902211344j5cefcdd3p4e34ddc0ac5d78d@mail.gmail.com> (Jason Andryuk's message of "Sat\, 21 Feb 2009 16\:44\:11 -0500")
Message-ID: <87y6vyd785.fsf@litku.valot.fi> (sfid-20090222_124659_394760_2DC5C40F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> On Sat, Feb 21, 2009 at 2:57 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> Jason Andryuk <jandryuk@gmail.com> writes:
>>
>>> I thought before I was not getting any scan results.  I may have been
>>> wrong.  However right now with the driver from wireless-testing
>>> 2009-02-18, 4 APs show up in NetworkManager.  Unfortunately, my AP is
>>> not one of them.
>>
>> What's your distance to the AP?
>
> Maybe twenty feet through some walls.  I successfully tested with a
> Windows machine and the adapter in more or less the same place.

It might be that the windows driver is doing something differently and
hence has better sensivity. Can you try closer, just in case?

>> Is at76_usb (the staging driver) is working fine with your device? Can
>> you take logs from it so that we can compare?
>
> How do scan results get returned from the device to the host
> computer?

Through the normal rx path, similary like data frames are received.
Driver sends CMD_SCAN, firmware starts sending probe requests to each
channel and forwards the received probe responses and beacons back to the
driver.

>  I can't see any place that the scans are actually received.  Does the
> rx_tasklet handle this?

Yes.

> Are the few listed scan results just those that are extracted by
> mac80211? 

Most probably. I didn't check the contents, though. You can make
educated guesses from the length also.

> I was trying at76_usb + mac80211 when that was in staging, but I have
> not tried ~ at76c503a.berlios.de staging version.  I can take a look.

Thanks for testing.

-- 
Kalle Valo
