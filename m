Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59566 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYKATLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 15:11:47 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <FB3E29C0-9493-4A1C-B725-734C100ADF3D@holtmann.org> (sfid-20081101_201154_385904_67344998)
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1ba2fa240810311635t69165473hef0ef64bf4426d3a@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: Still 4965 issues with wireless-testing
Date: Sat, 1 Nov 2008 20:11:42 +0100
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com> <DAD31980-B029-46D4-A687-9B0426899853@holtmann.org> <1ba2fa240810310652t351b0b77k819a7e03659503eb@mail.gmail.com> <BF4BAA7D-FEBC-40F7-AE07-D6BBD31A2A0B@holtmann.org> <1ba2fa240810311409i5203bcccu2b944dcc505deb30@mail.gmail.com> <C202FD8E-EB1E-417D-8086-7ADFBC72A1D3@holtmann.org> <1ba2fa240810311635t69165473hef0ef64bf4426d3a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

>>>>>>> so besides the point that the Ubuntu 8.10 kernel has a broken  
>>>>>>> driver
>>>>>>> for
>>>>>>> the Intel 4965 cards which will crash my X61 after less than one
>>>>>>> minute
>>>>>>> uptime when it connects to my access point, I have my dmesg  
>>>>>>> full with
>>>>>>> warnings from the latest wireless-testing kernel.
>>>>>>>
>>>>>>> I know that we have discussed this before and Johannes' patch  
>>>>>>> at least
>>>>>>> turns it into warnings instead of killing my system  
>>>>>>> completely, but I
>>>>>>> am
>>>>>>> still surprised why this hasn't been fixed.
>>>>>>
>>>>>> so this becomes more and more annoying. I get this WARN_ON now  
>>>>>> multiple
>>>>>> times pre minute. Only the first few minutes after loading the  
>>>>>> firmware
>>>>>> everything is okay and then it keeps filling my dmesg. And on  
>>>>>> top of
>>>>>> that, I
>>>>>> now see these:
>>>>>>
>>>>>> __ratelimit: 1189 callbacks suppressed
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> __ratelimit: 57695 callbacks suppressed
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> __ratelimit: 3345 callbacks suppressed
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>> iwlagn: Can not allocate SKB buffers
>>>>>>
>>>>>> What is going on here? This is a normal setup and nothing  
>>>>>> fancy. Access
>>>>>> point is N-Capable from D-Link btw.
>>>>>
>>>>>
>>>>> I have D-Link too I don't see this. What kernel version is this?  
>>>>> Is
>>>>> this your ubuntu version or wireless-testing?
>>>>> Any more data you can provide (.config. slabinfo)
>>>>
>>>> this is from wireless-testing. The Ubuntu 2.6.27 kernel is totally
>>>> broken.
>>>> It will crash the kernel since we are missing the patch to turn  
>>>> this into
>>>> a
>>>> warning :)
>>>>
>>>> Attached is my config. The slabinfo will follow once the SKB  
>>>> errors come
>>>> up
>>>> again. It normally takes a few hours before they show. Just  
>>>> resumed that
>>>> machine.
>>>
>>> I've downloaded whole moblin last night over 2.6.27.4, it's a bit  
>>> slow
>>> because the missing calibrations but it didn't crashed.
>>>
>>> I will test your config, your machine is T61  am I right?
>>
>> I have a X61 and running the 64-bit version of kernel and userspace.
>
> I found in sky2 driver comment
>
> * The buffer returned from netdev_alloc_skb is
> * aligned except if slab debugging is enabled
>
> Since you have slub debug enabled, can you run this debug patch on
> your system (might be withe space broken, I've  just pasted in)

I applied your patch and ran the latest wireless-testing for over 24  
hours now. The iwl_tx_cmd_complete issues shows up on a regular basis  
and the allocate SKB buffers, too. However it didn't trigger the extra  
WARN_ON you added.

Regards

Marcel

