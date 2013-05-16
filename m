Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64595 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab3EPRrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 13:47:03 -0400
Received: from mailout-de.gmx.net ([10.1.76.24]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MWvJi-1Uy1b70qRQ-00W0vD for
 <linux-wireless@vger.kernel.org>; Thu, 16 May 2013 19:47:01 +0200
Message-ID: <51951B90.70909@rempel-privat.de> (sfid-20130516_194722_230421_85A1A5EF)
Date: Thu, 16 May 2013 19:46:56 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Ignacy Gawedzki <i@lri.fr>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
References: <20130515134258.GA9033@zenon.in.qult.net> <5194DEB3.2060407@rempel-privat.de> <20130516172030.GD21850@zenon.in.qult.net>
In-Reply-To: <20130516172030.GD21850@zenon.in.qult.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 16.05.2013 19:20, schrieb Ignacy Gawedzki:
> On Thu, May 16, 2013 at 03:27:15PM +0200, thus spake Oleksij Rempel:
>> Am 15.05.2013 15:42, schrieb Ignacy Gawedzki:
>>> Hi everyone,
>>>
>>> This is an old issue, about which it seems the first posts date back to 2009.
>>> With the latest possible version of the firmware for AR9271 and the latest
>>> possible wireless drivers, the issue is still there.  Whether this is still
>>> the exact same problem every time remains to be checked, but it is annoying
>>> enough to deserve some consideration.
>>>
>>> The problem is that the driver can't talk to the device if the following
>>> conditions are met:
>>>
>>>   - The system cold boots with the USB dongle inserted or the USB dongle is
>>>     inserted on a running system.
>>>
>>>   - The interface is *not* brought up.
>>>
>>>   - The system (warm) reboots.
>>>
>>> Then the driver complains about the target being unresponsive after uploading
>>> the firmware.  Apparently the only way to make it work again is to unplug and
>>> then plug the USB dongle back, physically.  It seems that if the USB port is
>>> not powered down during reboot (which happens with at least two different
>>> setups that I've tested it with), the device is left in a broken state.
>>>
>>> I would gladly help in tracing down this bug if only I knew where to start.
>>>
>>> Thanks for any suggestion.
>>
>> Hi Ignacy,
>>
>> i can't reproduce this issue on my system. I tested it with 4
>> different ath9_htc adapter. Without luck.
>
> Without luck, but it seems you're the lucky one anyway. =)
>
>>                                            Please provide as match
>> information as possible:
>> - Usb host controller
>
> Tested both on Raspberry Pi and on Dell XPS 13.  The latter uses Intel EHCI,
> 8086:1c2d and Fresco Logic 1b73:1009, I don't know which one is used exactly.
>
>> - Adapter manufacture and version, or even better add it to the
>> wiki, and upload some images:
>> http://wikidevi.com/wiki/Main_Page
>
> TP-Link TL-WN722NC, exactly as the one on the wiki.

That is interesting. I have got today TL-WN722N, but i still can't 
reproduce this issue.

>> - your kernel version
>
> Tested with 3.5.0 on XPS and 3.6.11, 3.8.12 and 3.9.2 on RPi (using a
> customized buildroot, but I can provide the .config if needed).
>
>> I assume it is not firmware. May be there are some issue with boot
>> loader on adapter. Are you sure that UART pins are not soldered?
>
> I opened the dongle, managed to solder the metal shield off and the pins
> weren't used (all four 48-51, among others).
>
>> Current ath9k_htc do not have mechanism to reset an adapter. I will
>> start to work on it after some other issues are done.
>
> Is it physically possible?

may be.

>> PS: please find some way to enable uart, at least TX pin.
>
> I tried to solder the TX pin, but it's really too tiny.  I don't have an iron
> so small as to be able to do it, sorry.  I would really love to have an UART
> connection, but that's just beyond my abilities.  BTW, it would really be
> great to have a way to send debug message up the USB link, just as with
> carl9170.

That make no sense. Debug message i need, are from boot loader. There is 
no way, that boot loader can send messages over usb. Or if firmwre will 
crash, it wont send any thing too.

So what do we have:
- TL-WN722N is working. Or your model is different, or it is broken one.
- Did you checked the cable?
- usb host controller?
- other options?



-- 
Regards,
Oleksij
