Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:58455 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0CVPGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 11:06:39 -0400
Received: by iwn12 with SMTP id 12so4387017iwn.21
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 08:06:38 -0700 (PDT)
Message-ID: <4BA7877A.5090703@lwfinger.net>
Date: Mon, 22 Mar 2010 10:06:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Calvin Walton <calvin.walton@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <1269239303.12836.17.camel@ayu> <201003220937.55133.mb@bu3sch.de>
In-Reply-To: <201003220937.55133.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/2010 03:37 AM, Michael Buesch wrote:
> On Monday 22 March 2010 07:28:23 Calvin Walton wrote:
>> Hi,
>>
>> On Sat, 2010-03-20 at 19:14 -0500, Larry Finger wrote:
>> Some recent BCM43XX devices lack an on-board SPROM. The pertinent data
>>> from the SPROM could be included in the kernel; however, this presents
>>> a problem in the generation of a unique, reproducible MAC address. The
>>> solution has been to create a utility that generates a virtual SPROM
>>> image with a random MAC address. This image is stored in the firmware
>>> area, and loaded using the asyncronous firmware load facility.
>>
>> I'm curious, how would this firmware-loading scheme deal with having
>> multiple cards of this type installed? This seems like an unusual
>> situation, but it looks like this patch will cause all of the cards to
>> start up with the same MAC address due to the fixed filename.
>>
>> Instead of using a firmware file to load in the MAC address, might it be
>> possible to move the persistent MAC setting to a simple udev rule which
>> generates a persistent MAC address, saves it, then sets it each boot
>> using a command like "ip link set wlan0 address XX:XX:XX:XX:XX:XX" ?
>>
>> This would remove the need to have this "fake" firmware file available
>> at boot, provided that the driver can handle leaving the address
>> unconfigured until userspace gets around to setting it. As well, it
>> could be written to work with multiple cards easily, saving a different
>> MAC for each.
>>
>> Some thoughts for your consideration,
>>
> 
> I think this actually is a very good idea.
> This way we could live without a user-supplied sprom image, which I would _really_
> prefer. 

Avoiding the use of a new user-space program would be desirable, but I cannot
think of any way that a udev rule could distinguish one card from another. If we
had any unique features such as a serial number, then we wouldn't need user
space at all. Any suggestions?

Larry


