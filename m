Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:36303 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbcD0KXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 06:23:50 -0400
Received: by mail-lf0-f50.google.com with SMTP id u64so44919140lff.3
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2016 03:23:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5500469A22567C4BAF673A6E86AFA3A4022D20C8140D@IR-CENTRAL.corp.innerrange.com>
References: <5500469A22567C4BAF673A6E86AFA3A4022D20C813C8@IR-CENTRAL.corp.innerrange.com>
 <20160427052758.GA3583@localhost.localdomain> <5500469A22567C4BAF673A6E86AFA3A4022D20C8140D@IR-CENTRAL.corp.innerrange.com>
From: Vishal Thanki <vishalthanki@gmail.com>
Date: Wed, 27 Apr 2016 12:23:29 +0200
Message-ID: <CAC3a_SAt-ssa0Wx1mtC45_09ysa0PY47vsTXxSpdvWqn1ckMbg@mail.gmail.com> (sfid-20160427_122354_731385_329450B8)
Subject: Re: rt2800 and BeagleBone Black kernel panic when connecting to
 access point
To: Craig McQueen <craig.mcqueen@innerrange.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 27, 2016 at 7:56 AM, Craig McQueen
<craig.mcqueen@innerrange.com> wrote:
> Vishal Thanki wrote:
>> Hi,
>>
>> On Wed, Apr 27, 2016 at 02:21:36PM +1000, Craig McQueen wrote:
>> > I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based (5392
>> chipset). I've been testing it on a BeagleBone Black running an Ubuntu 16.04
>> image (4.4.6 kernel).
>> >
>> > 1) Install Ubuntu 16.04 on a BeagleBone Black.
>> > 2) Add lines to /etc/network/interfaces for the device to connect to a
>> WPA2 access point.
>> > 3) Plug the rt2800 USB Wi-Fi device into the BeagleBone Black.
>> >
>> > Apparently when it tries to connect to the access point, I get a kernel panic.
>> If I don't configure it (step 2 above) then the kernel panic doesn't happen.
>> >
>> > I've tested this with two access points: my Android phone acting as a
>> hotspot, and a cheap TP-Link TD-W8968.
>> >
>> > Serial debug console shows:
>> > ...
>>
>> I have seen a similar crash and fixed it as a part of following commit:
>>
>> 8b4c0009313f3d42e2540e3e1f776097dd0db73d
>>
>> But it would be helpful if you can get paste the entire kernel log.
>> Because in my case, I used to see a USB Disconnect event for the rt2800
>> driver and the crash was caused due to that.
>
> Okay, see the attached file. I can't see a USB Disconnect event for the rt2800, until the end (line 561, timestamp 222.861630) which is when I unplugged the USB hub.
>

The attached file seem to report a different kind of crash (soft
lockup) while the crash reported in the 1st email of yours is
different (NULL pointer dereference).
I am not sure about this soft lockup problem though.

> --
> Craig McQueen
>
