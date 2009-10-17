Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:8255 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZJQMyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 08:54:18 -0400
Received: by ey-out-2122.google.com with SMTP id 9so626739eyd.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2009 05:54:22 -0700 (PDT)
To: "John Willis" <John.Willis@Distant-earth.com>
Cc: "'Bob Copeland'" <me@bobcopeland.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] WL1251: Very crude EEPROM reading support for the WL1251 driver
References: <01c901ca4daf$6e3d7f20$4ab87d60$@Willis@Distant-earth.com>
	<20091016115909.GB341@hash.localnet> <87aazqmto1.fsf@purkki.valot.fi>
	<034401ca4f0d$d494a140$7dbde3c0$@Willis@Distant-earth.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 17 Oct 2009 15:54:20 +0300
In-Reply-To: <034401ca4f0d$d494a140$7dbde3c0$@Willis@Distant-earth.com> (John Willis's message of "Sat\, 17 Oct 2009 10\:40\:12 +0100")
Message-ID: <8763aemb9f.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John Willis" <John.Willis@Distant-earth.com> writes:

>> Didn't HTC Dream store the NVS file in the main flash memory? AFAIK
>> the EEPROM support in wl1251 needs a separate chip for the EEPROM, so
>> if someone has stored the NVS file to the main flash memory I really
>> doubt that they would still use EEPROM with wl1251. So the NVS file is
>> stored either to somewhere outside wl1251 or to the EEPROM, but not
>> both.
>
> Yep, the NVS on the MSM HTC devices I have seen have been stored in the main
> NAND flash at a given offset outside of the main rootfs 'but' I was sure
> someone had mentioned that the G1 also featured an EEPROM attached to the
> WL1251 as we have on the Pandora.

Ah, ok. Then your patch is really needed for those devices.

> Mea culpa, I could well be wrong on that one. I assumed that the HTC
> platform maintained both as some odd hangover to the Windows CE
> software roots of the platform (it would not be the 1st time ;-)).

Yeah, usually it's like that :)

> I guess that raises another point then, maybe should we look at another
> method of getting the NVS from NAND if the platform gives it's offsets? No
> idea how that would work in a clean way however but something to consider as
> the HTC devices will make up a chunk of the long term userbase.

I think it's better do this in user space, doing this from kernel in a
portable way is too complicated. In earlier discussions the conclusion
has been to use request_firmware() interface and a modified udev
script which retrieves the calibration data from NAND/NOR/whatever and
pushes it to kernel. 

To my knowledge nobody hasn't implemented this yet, but I think that's
the way to go. But as always, I'm open for suggestions.

-- 
Kalle Valo
