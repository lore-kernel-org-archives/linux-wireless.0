Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:60559 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3LTJax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 04:30:53 -0500
Message-ID: <52B40E49.5080309@broadcom.com> (sfid-20131220_103105_856547_773EFC5D)
Date: Fri, 20 Dec 2013 10:30:49 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Naughtboy <skylvlinux@gmail.com>, Hauke Mehrtens <hauke@hauke-m.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bcm43236 complient in the compat-wireless-3.6.81???
References: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>	<52B2E638.8060906@hauke-m.de>	<CAKH5=LsaEw7GEHs5nb1omDeSMmcoFSXo8EEy+DeXvyXF5_1M_g@mail.gmail.com>	<52B300FC.7070204@hauke-m.de>	<52B31392.2070705@broadcom.com> <CAKH5=LvUqfyqW5NQGNzCec2yVrzFqFWCbtQvF5ZL=cjkh=9HOw@mail.gmail.com>
In-Reply-To: <CAKH5=LvUqfyqW5NQGNzCec2yVrzFqFWCbtQvF5ZL=cjkh=9HOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2013 10:20 AM, Naughtboy wrote:
> hi guys
> 
> just you kown  ,the bcm43236 is the new chip to support dual band 2.4G and
> 5.8G
> rev3?(what is meaning)  it means is the third product ? or it means
> linux-3.xx? (just you said it  most likely  the first meanig )
> http://wireless.kernel.org/en/users/Drivers/brcm80211
>  and i try transplant it into linux-2.6.22 and occur lots of interface of
> mistakes , it just  suport linux-3.xx (and it transplant into linux-2.6.22
> it nedd modfiy lots interface )
> 
> and the   drivers/net/wireless/brcm80211/brcmfmac just support  (and did't
> suport rev2 ==linux-2.6)
> just you  request  , bcm43236 has a product in the market ,yu can see the
> follow !
> (however , my problems ,
> http://wireless.kernel.org/en/users/Drivers/brcm80211
> drivers/net/wireless/brcm80211/brcmfmac
>   it enough make bcm43236 working????)
> 
> bcm43236 has a product in the market:
> http://to-link.net/ProductShow.asp?ID=116

Your "english" is difficult to follow. Anyway, we are talking about chip
revisions. It has nothing to do with linux kernel versions. However, if
you want to use it on an ancient 2.6.22 kernel you better use the
backports that Hauke referred to. Unfortunately for BRCMFMAC it only
goes back to 2.6.29. Maybe in general backports only goes back till
2.6.24 (not sure). If you get the driver working it will spill out in
the kernel log whether your bcm43236 has a good *chip* revision, ie.
chiprev >= 3.

Regards,
Arend

> 2013/12/19 Arend van Spriel <arend@broadcom.com>
> 
>> On 12/19/2013 03:21 PM, Hauke Mehrtens wrote:
>>> On 12/19/2013 03:14 PM, Naughtboy wrote:
>>>> hello   guys
>>>> rev 3 ? where can i gain  this linux source code ?
>>>> thanks  advnace
>>>
>>> This device is supported by brcmfmac:
>>> http://wireless.kernel.org/en/users/Drivers/brcm80211
>>
>> It is in the kernel tree under
>> 'drivers/net/wireless/brcm80211/brcmfmac'. We only support rev 3 because
>> rev 2 and earlier do not have enough memory to run fullmac firmware.
>> However, I have not found any rev 3 on the market. If you have please
>> let me know.
>>
>> Gr. AvS
>>
>>> The source code is in a recent linux kernel or in backports:
>>> http://drvbp1.linux-foundation.org/~mcgrof/rel-html/backports/
>>>
>>> Hauke
>>>
>>>>
>>>> 2013/12/19 Hauke Mehrtens <hauke@hauke-m.de>:
>>>>> On 12/19/2013 11:03 AM, Naughtboy wrote:
>>>>>> hi erveryone !
>>>>>> i  have a usb dongle bcm43236
>>>>>> i wan to trsan it in the mips bcm47xx
>>>>>> but i search in hte www , and didn't find the driver for bcm43236
>>>>>> linux soucre code !!
>>>>>> i have find and study
>> http://wireless.kernel.org/en/users/Drivers/b43
>>>>>>
>>>>>> and  find   http://wireless.kernel.org/en/users/Drivers/b43 do
>> nothing
>>>>>> usefull !!
>>>>>>
>>>>>> anyone can do one hand?
>>>>>> thanks advance !!
>>>>>>
>>>>>> -----Naughyboy !
>>>>>
>>>>> Hi,
>>>>>
>>>>> I assume you have a bcm43236 rev 2 as all the bcm43236s connected to a
>>>>> MIPS BCM47XX SoC I saw have that rev.  There is probably no open source
>>>>> driver for the bcm43236 rev 2, just rev 3 is supported by brcmfmac.
>>>>>
>>>>> Hauke
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
> 

