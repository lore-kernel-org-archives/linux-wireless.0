Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39365 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184AbbBJAfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 19:35:13 -0500
Received: by iecvy18 with SMTP id vy18so1585997iec.6
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 16:35:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEZVCP6HNDsR=S4c5xYLr=UZZmQhA9WBwrzwT_5jJvfXz+gC1A@mail.gmail.com>
References: <CAEZVCP4bNmfnHH=Ksi6wMQoqdZGbprUH5X_VA41GRf9=h2MT1A@mail.gmail.com>
 <54D92DFC.1080604@broadcom.com> <CAEZVCP7+gTqJJUNQuUDTGWG1BQ4_XY7Q79Cg-2daVourfasvEw@mail.gmail.com>
 <CAEZVCP6HNDsR=S4c5xYLr=UZZmQhA9WBwrzwT_5jJvfXz+gC1A@mail.gmail.com>
From: Steeve Morin <steeve.morin@gmail.com>
Date: Tue, 10 Feb 2015 01:34:52 +0100
Message-ID: <CAEZVCP6R4-aotR4K5=EhXzg0jEcgfoURAXmbc+Xeb3UZWNs0Kw@mail.gmail.com> (sfid-20150210_013519_543775_1A6DD429)
Subject: Re: brcmfmac + AP6120 (brcm43362) doesn't connect to WPA2 AP
 (unprotected ok)
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, using udhcpc fails to retrieve an IP with a rather strange "error"
udhcpc (v1.22.1) started
Sending discover...
Sending select for 192.168.1.89...
Sending select for 192.168.1.89...
Sending select for 192.168.1.89...
Sending discover...
Sending discover...

Which leads me to believe this might be due to data being lost somewhere...

However, the rare times I managed to make it connect, SSH was
functionning normally.

Let me know if you need more log.

Thanks

On 10 February 2015 at 00:06, Steeve Morin <steeve.morin@gmail.com> wrote:
> The weird thing is that wpa_supplicant apparently manages to associate
> with the AP (but i'm not really sure about that) [1]
>
> [1] https://gist.github.com/steeve/10a9a643476cea99abf4#file-005-wpa-supplicant-conf
>
> On 9 February 2015 at 23:17, Steeve Morin <steeve.morin@gmail.com> wrote:
>> Thanks for answering.
>>
>> I'm using connmanctl [1]
>>
>> The funny thing is trying to make this gist, I tried and it connected
>> succesfully....
>> Could it be a race somewhere?
>>
>> [1] https://gist.github.com/steeve/10a9a643476cea99abf4#file-004-connmanctl
>>
>> On 9 February 2015 at 23:00, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 02/09/15 18:57, Steeve Morin wrote:
>>>>
>>>> Hi linux-wireless,
>>>>
>>>> I'm running brcmfmac from backports-3.19-rc1-1 on linux 3.10. running
>>>> on an arm Amlogic S805 (cortex-a5, arm7) board (CX-S859).
>>>>
>>>> I had to apply multiple custom patches [1]:
>>>> - Make sure the wifi chip is on via custom GPIO [1]
>>>> - Remove a problematic piece of code related to power manager (will
>>>> look into it later) [1]
>>>> - Mix the mmc->max_blk_count on the host (would cause a BUG_ON
>>>> assertion later on) [2] [3]
>>>>
>>>> After that, I am able to modprobe brcmfmac see wlan0.
>>>> The interface correctly scans for wifi aps, and I can connect to
>>>> unprotected ones.
>>>>
>>>> It fails, however, to connect to WPA/WPA2 protected aps. I have
>>>> attached a debug log obtained with debug=0xffffff [4]
>>>> I don't see any errors in it though...
>>>>
>>>> Would anyone of you guys have any idea why ?
>>>
>>>
>>> In the log I don't see any connect attempt. Only seeing a scan completing.
>>> So how do you try to connect?
>>>
>>> Regards,
>>> Arend
>>>
>>>
>>>> Thanks a lot,
>>>>
>>>> [1]
>>>> https://gist.github.com/steeve/10a9a643476cea99abf4#file-backports-power-on-wifi-sdio-patch
>>>> [2]
>>>> https://gist.github.com/steeve/10a9a643476cea99abf4#file-fix-block-size-patch
>>>> [3]
>>>> https://github.com/codesnake/linux-amlogic/blob/master/drivers/amlogic/mmc/aml_sdio.c#L317
>>>> [4] https://gist.github.com/steeve/10a9a643476cea99abf4#file-003-dmesg-log
>>>
>>>
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
> --
> Steeve Morin
> twitter.com/steeve
> github.com/steeve
> linkd.in/smorin



-- 
Steeve Morin
twitter.com/steeve
github.com/steeve
linkd.in/smorin
