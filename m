Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:51086 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZIJGbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 02:31:32 -0400
Received: by pxi32 with SMTP id 32so1583645pxi.4
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 23:31:35 -0700 (PDT)
Message-ID: <4AA89BB2.1080205@gmail.com>
Date: Wed, 09 Sep 2009 23:24:50 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: b43 dma error
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de> 	<4AA67009.4020400@lwfinger.net> <4AA69961.9010808@gmail.com> <69e28c910909081106p413b70d8u83a48a63943f123e@mail.gmail.com> <4AA890F9.90604@gmail.com>
In-Reply-To: <4AA890F9.90604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2009 10:39 PM, John Daiker wrote:
> On 09/08/2009 11:06 AM, Gábor Stefanik wrote:
>> On Tue, Sep 8, 2009 at 7:50 PM, John Daiker<daikerjohn@gmail.com> wrote:
>>> On 09/08/2009 07:54 AM, Larry Finger wrote:
>>>>
>>>> Michael Buesch wrote:
>>>>>
>>>>> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
>>>>>>
>>>>>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
>>>>>> then the controller keep restarting...
>>>>>>
>>>>>> Please tell what I can provide or test, Thanks.
>>>>>
>>>>> Is this a regression? If so, please bisect.
>>>>
>>>> It is something specific to his system as I don't see anything like
>>>> this. In addition, there are some users on the openSUSE forums that
>>>> have implemented the latest compat-wireless and switched away from
>>>> Broadcom wl to b43 on their LP PHY devices. So far, no complaints from
>>>> them.
>>>>
>>>> Please reboot so that we see the ssb output as well. Use the command
>>>>
>>>> dmesg | egrep "ssb|b43"
>>>>
>>>> That way we will be able to see exactly what kind of device you have
>>>> and what revisions are in it. AFAIK, the testing to date has been
>>>> limited to Rev 1 PHYs and Rev 2 radios.
>>>>
>>>> Larry
>>>>
>>>
>>> I can confirm the same issue. I have a HP Mini 1116NR with a Broadcom
>>> 4312.
>>> Looks to be a PHY 1, Radio 2:
>>>
>>> --snip--
>>> [ 456.165296] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
>>> [ 456.165364] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062,
>>> Revision 2
>>> --snip--
>>>
>>> I've attached the output of 'dmesg | egrep "ssb|b43"', my kernel
>>> config, and
>>> lspci -vv and lspci -nn
>>>
>>> Note: With the dmesg output, I had unloaded the b43 module previous
>>> 'modprobe -r b43' and then loaded it again with debug output:
>>> 'modprobe b43
>>> verbose=3'
>>>
>>> John Daiker
>>>
>>
>> Again, please test with v478 or v5xx firmware.
>>
>
> I've tried with the v478 firmware (was using 410.2160 earlier). I do not
> see the 'Fatal DMA error' messages anymore.
>
> On another note, however, I can't connect to a network. The device seems
> to alternate between being idle, and scanning for APs.
>
> --snip--
> [ 73.273722] phy0: device no longer idle - scanning
> [ 74.561178] phy0: device now idle
> [ 79.545776] phy0: device no longer idle - scanning
> [ 80.828232] phy0: device now idle
> [ 85.817930] phy0: device no longer idle - scanning
> [ 87.100240] phy0: device now idle
> [ 92.090713] phy0: device no longer idle - scanning
> [ 93.372367] phy0: device now idle
> [ 98.362829] phy0: device no longer idle - scanning
> [ 99.644362] phy0: device now idle
> --snip--
>
> I've attached the relevant portion of my dmesg output for your review.
>
> Where would I got about finding the v5xx firmware?
>
> JD

Found the v5xx firmware along with a patch by Daniel Lenski for 
b43-fwcutter on the bcm43xx mailing list.  I've tried both versions 
(508.102 and 508.1107) without any luck.  I see the same 'idle -> 
scanning -> idle' loop as before.

Any other ideas?

JD
