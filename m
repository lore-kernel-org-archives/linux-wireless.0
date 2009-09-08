Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65113 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZIHSQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 14:16:01 -0400
Received: by bwz19 with SMTP id 19so2421413bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 11:16:03 -0700 (PDT)
Message-ID: <4AA69F61.2040300@lwfinger.net>
Date: Tue, 08 Sep 2009 13:16:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Daiker <daikerjohn@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	netrolller.3d@gmail.com, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: b43 dma error
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de> <4AA67009.4020400@lwfinger.net> <4AA69961.9010808@gmail.com>
In-Reply-To: <4AA69961.9010808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John Daiker wrote:
> On 09/08/2009 07:54 AM, Larry Finger wrote:
>> Michael Buesch wrote:
>>> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
>>>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
>>>> then the controller keep restarting...
>>>>
>>>> Please tell what I can provide or test, Thanks.
>>>
>>> Is this a regression? If so, please bisect.
>>
>> It is something specific to his system as I don't see anything like
>> this. In addition, there are some users on the openSUSE forums that
>> have implemented the latest compat-wireless and switched away from
>> Broadcom wl to b43 on their LP PHY devices. So far, no complaints from
>> them.
>>
>> Please reboot so that we see the ssb output as well. Use the command
>>
>> dmesg | egrep "ssb|b43"
>>
>> That way we will be able to see exactly what kind of device you have
>> and what revisions are in it. AFAIK, the testing to date has been
>> limited to Rev 1 PHYs and Rev 2 radios.
>>
>> Larry
>>
> 
> I can confirm the same issue.  I have a HP Mini 1116NR with a Broadcom
> 4312.  Looks to be a PHY 1, Radio 2:
> 
> --snip--
> [  456.165296] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
> [  456.165364] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062,
> Revision 2
> --snip--
> 
> I've attached the output of 'dmesg | egrep "ssb|b43"', my kernel config,
> and lspci -vv and lspci -nn
> 
> Note: With the dmesg output, I had unloaded the b43 module previous
> 'modprobe -r b43' and then loaded it again with debug output: 'modprobe
 b43 verbose=3'

Your PHY and your radio are the same as mine. In fact, the one thing I
noticed is that you are using i386 architecture, whereas mine is
x86_64. I have not tested with i386.

Has anyone run the LP PHY modifications with 32-bit architecture?

Larry
