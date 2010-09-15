Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:54354 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab0IOQzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 12:55:36 -0400
Received: by pxi10 with SMTP id 10so119919pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 09:55:36 -0700 (PDT)
Message-ID: <4C90FA78.2080707@gmail.com>
Date: Wed, 15 Sep 2010 11:55:20 -0500
From: =?UTF-8?B?Q2FybG9zIFNhbHZhZG9yIFDDqXJleiBTYWxnYWRv?=
	<carlosalvatore@gmail.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: compat-wireless-2.6.35-rc6 won't build
References: <4C7D17CF.6030501@gmail.com> <AANLkTik8PLwUfLU1OouBq6uPwSvaWBokAkSHcCzx97ms@mail.gmail.com> <4C7D2DB6.2090609@gmail.com> <4C7F2477.6030006@gmail.com> <AANLkTinDXfNBBBjJYtu12vbARecc1xgYO=bA_K+Wu-h2@mail.gmail.com> <4C827584.7010203@hauke-m.de> <4C90563D.5080108@gmail.com>
In-Reply-To: <4C90563D.5080108@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2010 12:14 AM, Carlos Salvador Pérez Salgado wrote:
> On 09/04/2010 11:36 AM, Hauke Mehrtens wrote:
>> Am 02.09.2010 09:17, schrieb Luis R. Rodriguez:
>>> 2010/9/1 Carlos Salvador Pérez Salgado<carlosalvatore@gmail.com>:
>>>> On 08/31/2010 11:28 AM, Carlos Salvador Pérez Salgado wrote:
>>>>> On 08/31/2010 10:32 AM, Luis R. Rodriguez wrote:
>>>>>> 2010/8/31 Carlos Salvador Pérez Salgado<carlosalvatore@gmail.com>:
>>>>>>> Do you have a better idea of how can I fix that? I'll really 
>>>>>>> appreciate
>>>>>>> it.
>>>>>> Yeah, try to compat-wireless-2.6.36-rc2 ...
>>>>>>
>>>>>>    Luis
>>>>>>
>>>>> Nope... the same error...
>>>>>
>>>>>
>>>>>   LD
>>>>>   /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/rfkill/built-in.o
>>>>>   LD
>>>>>   
>>>>> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/built-in.o
>>>>>   CC [M]  
>>>>> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.o
>>>>> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c: In
>>>>> function ‘cfg80211_netdev_notifier_call’:
>>>>> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c:705: 
>>>>>
>>>>> error: ‘struct net_device’ has no member named ‘wireless_handlers’
>>>>> /media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.c:706: 
>>>>>
>>>>> error: ‘struct net_device’ has no member named ‘wireless_handlers’
>>>>> make[3]: ***
>>>>> [/media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless/core.o] Error 
>>>>> 1
>>>>> make[2]: *** 
>>>>> [/media/disk/temp/compat-wireless-2.6.36-rc2-1/net/wireless]
>>>>> Error 2
>>>>> make[1]: *** 
>>>>> [_module_/media/disk/temp/compat-wireless-2.6.36-rc2-1] Error
>>>>> 2
>>>>> make[1]: Leaving directory `/media/disk/temp/linux-2.6.35.4'
>>>>> make: *** [modules] Error 2
>>>>>
>>>>> That didn't help. I hope you can give me another idea.
>>>>> Thanks.
>>>> So...? What should I do?
>>> Sorry, I have not have had time to test compile against 2.6.35, but
>>> when I do I will let you know.
>>>
>>>    Luis
>> Hi,
>>
>> I was able to reproduce the problem. In the kernel configuration
>> CONFIG_WIRELESS_EXT=n and CONFIG_CFG80211_WEXT=y are set.
>> compat-wireless uses the old wireless_handlers attribute for the wext
>> handlers interface, but this is only activated if CONFIG_WIRELESS_EXT=y
>> is set.
>> We can not use the new interface through struct wiphy that cfg80211_wext
>> normally uses. The struct is shipped by compat-wireless and changed
>> ofter with different kernel versions, so the pointers do not point to
>> the correct position when using two different versions of this strcut.
>> compat-wireless should *always* deactivates CONFIG_CFG80211_WEXT if
>> CONFIG_WIRELESS_EXT is not set. I got our compat_autoconf.h to overwirte
>> the kernels autoconf.h by add it to LINUXINCLUDE, but I have not found a
>> way how to disable CONFIG_WIRELESS_EXT in the makefile if it was set in
>> the kernel because config.mk is pared before the kernel configuration is
>> parsed. An other way would be to rename CONFIG_WIRELESS_EXT to something
>> else in compat-wireless to prevent the kernel from overwriting this 
>> value.
>>
>> There will be no way to support cfg80211_wext without a kernel
>> configured with CONFIG_CFG80211_WEXT=y.
>>
>> Hauke
>>
> After searching over the web I found this...
> http://bugs.gentoo.org/show_bug.cgi?format=multiple&id=332817 
> <http://bugs.gentoo.org/show_bug.cgi?format=multiple&id=332817>
> and now I was able to build the compat driver.
>
> But... It did not solved my problem, even with the new compat drivers 
> I got fixed channel -1 on mon0 using aircrack. Is there a patch for 
> this newer versions that fixes this?
I found it... here
cw.fixed.chan.patch 
<http://forum.aircrack-ng.org/index.php?PHPSESSID=8jcjg63uoaei3vsrpj2pt8sdd0&action=dlattach;topic=8373.0;id=733>
http://forum.aircrack-ng.org/index.php?action=dlattach;topic=8373.0;id=733
It solved my problem. Greetings.
