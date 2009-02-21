Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:49522 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZBUVoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 16:44:13 -0500
Received: by el-out-1112.google.com with SMTP id b25so747576elf.1
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2009 13:44:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87hc2okyrm.fsf@litku.valot.fi>
References: <c4d76b3b0902161643p73101b29hb55a9da696d16da9@mail.gmail.com>
	 <8763j7qyfx.fsf@litku.valot.fi> <1235014330.6344.18.camel@rainbow>
	 <87fxibhr5q.fsf@litku.valot.fi>
	 <c4d76b3b0902192007s347ea4e3hcfa3fae1a1e3060b@mail.gmail.com>
	 <87hc2okyrm.fsf@litku.valot.fi>
Date: Sat, 21 Feb 2009 16:44:11 -0500
Message-ID: <c4d76b3b0902211344j5cefcdd3p4e34ddc0ac5d78d@mail.gmail.com> (sfid-20090221_224457_209017_754BE6DB)
Subject: Re: [PATCH] at76c50x-usb: support cfg80211 scanning
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 21, 2009 at 2:57 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Jason Andryuk <jandryuk@gmail.com> writes:
>
>> I thought before I was not getting any scan results.  I may have been
>> wrong.  However right now with the driver from wireless-testing
>> 2009-02-18, 4 APs show up in NetworkManager.  Unfortunately, my AP is
>> not one of them.
>
> What's your distance to the AP?

Maybe twenty feet through some walls.  I successfully tested with a
Windows machine and the adapter in more or less the same place.

>> No signal strength is reported for any of them.
>
> Yes, this is a know issue. I'll try to fix it soon.
>
>> Curiously, there are distinct results for each of at76c50x-usb, a
>> semi-operational iwl3945 and the functional rtl8187.
>>
>> CMD_SCAN is receiving a lot of status 0x03 CMD_STATUS_INVALID_PARAMETER
>>
>> With debug=0xf022c001 I get the output below.  I was wondering if
>> status=0x03 was being received because CMD_SET_MIB was called before
>> CMD_SCAN's status was checked.  Hopefully you can make some sense out
>> of the below logs.
>
> After a quick look I didn't find anything, but I will investigate this
> more.
>
> Is at76_usb (the staging driver) is working fine with your device? Can
> you take logs from it so that we can compare?

How do scan results get returned from the device to the host computer?
 I can't see any place that the scans are actually received.  Does the
rx_tasklet handle this?  Are the few listed scan results just those
that are extracted by mac80211?  I ask because you can see the calls
to ieee80211_rx_irqsafe.

I was trying at76_usb + mac80211 when that was in staging, but I have
not tried ~ at76c503a.berlios.de staging version.  I can take a look.

Jason
