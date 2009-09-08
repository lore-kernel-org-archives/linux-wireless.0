Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:8668 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZIHSYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 14:24:49 -0400
Received: by fg-out-1718.google.com with SMTP id 22so2037000fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 11:24:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AA69F61.2040300@lwfinger.net>
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de>
	<4AA67009.4020400@lwfinger.net> <4AA69961.9010808@gmail.com>
	<4AA69F61.2040300@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 8 Sep 2009 20:24:26 +0200
Message-ID: <69e28c910909081124v71e6fa1cy815a2366385051e6@mail.gmail.com>
Subject: Re: b43 dma error
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Daiker <daikerjohn@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 8, 2009 at 8:16 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> John Daiker wrote:
>> On 09/08/2009 07:54 AM, Larry Finger wrote:
>>> Michael Buesch wrote:
>>>> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
>>>>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
>>>>> then the controller keep restarting...
>>>>>
>>>>> Please tell what I can provide or test, Thanks.
>>>>
>>>> Is this a regression? If so, please bisect.
>>>
>>> It is something specific to his system as I don't see anything like
>>> this. In addition, there are some users on the openSUSE forums that
>>> have implemented the latest compat-wireless and switched away from
>>> Broadcom wl to b43 on their LP PHY devices. So far, no complaints from
>>> them.
>>>
>>> Please reboot so that we see the ssb output as well. Use the command
>>>
>>> dmesg | egrep "ssb|b43"
>>>
>>> That way we will be able to see exactly what kind of device you have
>>> and what revisions are in it. AFAIK, the testing to date has been
>>> limited to Rev 1 PHYs and Rev 2 radios.
>>>
>>> Larry
>>>
>>
>> I can confirm the same issue.  I have a HP Mini 1116NR with a Broadcom
>> 4312.  Looks to be a PHY 1, Radio 2:
>>
>> --snip--
>> [  456.165296] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
>> [  456.165364] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062,
>> Revision 2
>> --snip--
>>
>> I've attached the output of 'dmesg | egrep "ssb|b43"', my kernel config,
>> and lspci -vv and lspci -nn
>>
>> Note: With the dmesg output, I had unloaded the b43 module previous
>> 'modprobe -r b43' and then loaded it again with debug output: 'modprobe
>  b43 verbose=3'
>
> Your PHY and your radio are the same as mine. In fact, the one thing I
> noticed is that you are using i386 architecture, whereas mine is
> x86_64. I have not tested with i386.
>
> Has anyone run the LP PHY modifications with 32-bit architecture?

Yes, me. (With the exact same card as John.)

>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
