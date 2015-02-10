Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:57644 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbBJRbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 12:31:55 -0500
Message-ID: <54DA4070.8080002@broadcom.com> (sfid-20150210_183158_807116_5D845F46)
Date: Tue, 10 Feb 2015 18:31:28 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Steeve Morin <steeve.morin@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac + AP6120 (brcm43362) doesn't connect to WPA2 AP (unprotected
 ok)
References: <CAEZVCP4bNmfnHH=Ksi6wMQoqdZGbprUH5X_VA41GRf9=h2MT1A@mail.gmail.com> <54D92DFC.1080604@broadcom.com> <CAEZVCP7+gTqJJUNQuUDTGWG1BQ4_XY7Q79Cg-2daVourfasvEw@mail.gmail.com> <CAEZVCP6HNDsR=S4c5xYLr=UZZmQhA9WBwrzwT_5jJvfXz+gC1A@mail.gmail.com> <CAEZVCP6R4-aotR4K5=EhXzg0jEcgfoURAXmbc+Xeb3UZWNs0Kw@mail.gmail.com> <CAEZVCP4=ZRPFtdychXOhURvqaT02E_9dPpMf-zp2qB-eBsRRVQ@mail.gmail.com>
In-Reply-To: <CAEZVCP4=ZRPFtdychXOhURvqaT02E_9dPpMf-zp2qB-eBsRRVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/15 02:37, Steeve Morin wrote:
> I've managed to get a lease via udhcpc, over and over again, but as
> soon as a scan operation comes along, I am now unable to get a lease.

If you can provide a kernel log running into this situation I might get 
a clue about what is happening.

Regards,
Arend

> On 10 February 2015 at 01:34, Steeve Morin<steeve.morin@gmail.com>  wrote:
>> Also, using udhcpc fails to retrieve an IP with a rather strange "error"
>> udhcpc (v1.22.1) started
>> Sending discover...
>> Sending select for 192.168.1.89...
>> Sending select for 192.168.1.89...
>> Sending select for 192.168.1.89...
>> Sending discover...
>> Sending discover...
>>
>> Which leads me to believe this might be due to data being lost somewhere...
>>
>> However, the rare times I managed to make it connect, SSH was
>> functionning normally.
>>
>> Let me know if you need more log.
>>
>> Thanks
>>
>> On 10 February 2015 at 00:06, Steeve Morin<steeve.morin@gmail.com>  wrote:
>>> The weird thing is that wpa_supplicant apparently manages to associate
>>> with the AP (but i'm not really sure about that) [1]
>>>
>>> [1] https://gist.github.com/steeve/10a9a643476cea99abf4#file-005-wpa-supplicant-conf
>>>
>>> On 9 February 2015 at 23:17, Steeve Morin<steeve.morin@gmail.com>  wrote:
>>>> Thanks for answering.
>>>>
>>>> I'm using connmanctl [1]
>>>>
>>>> The funny thing is trying to make this gist, I tried and it connected
>>>> succesfully....
>>>> Could it be a race somewhere?
>>>>
>>>> [1] https://gist.github.com/steeve/10a9a643476cea99abf4#file-004-connmanctl
>>>>
>>>> On 9 February 2015 at 23:00, Arend van Spriel<arend@broadcom.com>  wrote:
>>>>> On 02/09/15 18:57, Steeve Morin wrote:
>>>>>>
>>>>>> Hi linux-wireless,
>>>>>>
>>>>>> I'm running brcmfmac from backports-3.19-rc1-1 on linux 3.10. running
>>>>>> on an arm Amlogic S805 (cortex-a5, arm7) board (CX-S859).
>>>>>>
>>>>>> I had to apply multiple custom patches [1]:
>>>>>> - Make sure the wifi chip is on via custom GPIO [1]
>>>>>> - Remove a problematic piece of code related to power manager (will
>>>>>> look into it later) [1]
>>>>>> - Mix the mmc->max_blk_count on the host (would cause a BUG_ON
>>>>>> assertion later on) [2] [3]
>>>>>>
>>>>>> After that, I am able to modprobe brcmfmac see wlan0.
>>>>>> The interface correctly scans for wifi aps, and I can connect to
>>>>>> unprotected ones.
>>>>>>
>>>>>> It fails, however, to connect to WPA/WPA2 protected aps. I have
>>>>>> attached a debug log obtained with debug=0xffffff [4]
>>>>>> I don't see any errors in it though...
>>>>>>
>>>>>> Would anyone of you guys have any idea why ?
>>>>>
>>>>>
>>>>> In the log I don't see any connect attempt. Only seeing a scan completing.
>>>>> So how do you try to connect?
>>>>>
>>>>> Regards,
>>>>> Arend
>>>>>
>>>>>
>>>>>> Thanks a lot,
>>>>>>
>>>>>> [1]
>>>>>> https://gist.github.com/steeve/10a9a643476cea99abf4#file-backports-power-on-wifi-sdio-patch
>>>>>> [2]
>>>>>> https://gist.github.com/steeve/10a9a643476cea99abf4#file-fix-block-size-patch
>>>>>> [3]
>>>>>> https://github.com/codesnake/linux-amlogic/blob/master/drivers/amlogic/mmc/aml_sdio.c#L317
>>>>>> [4] https://gist.github.com/steeve/10a9a643476cea99abf4#file-003-dmesg-log
>>>>>
>>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> Steeve Morin
>>>> twitter.com/steeve
>>>> github.com/steeve
>>>> linkd.in/smorin
>>>
>>>
>>>
>>> --
>>> Steeve Morin
>>> twitter.com/steeve
>>> github.com/steeve
>>> linkd.in/smorin
>>
>>
>>
>> --
>> Steeve Morin
>> twitter.com/steeve
>> github.com/steeve
>> linkd.in/smorin
>
>
>

