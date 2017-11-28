Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:34135 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753164AbdK1Q7K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 11:59:10 -0500
Received: by mail-qk0-f177.google.com with SMTP id d66so715572qkg.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Nov 2017 08:59:09 -0800 (PST)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: Slow connection with rtl8xxxu and 8192eu chipset
To: Nikolay Borisov <n.borisov.lkml@gmail.com>,
        linux-wireless@vger.kernel.org
References: <1195e649-c57f-1247-a0dc-2f0cc0732a00@gmail.com>
 <ce042534-6ba9-9654-c99f-7cfdff45b88a@gmail.com>
 <61e93af9-ef8a-5319-5a23-0b622d3cf0d0@gmail.com>
 <7cb804e5-c1f5-a5d4-764d-e5a786625093@gmail.com>
 <0b5d91b2-7e79-5767-aab7-7911806454a3@gmail.com>
 <12fed6ac-0e21-a137-4d7c-3bb341c4e831@gmail.com>
Message-ID: <e4cd40ab-8663-e329-952f-0eb7c27cf565@gmail.com> (sfid-20171128_175915_043860_84754BB7)
Date: Tue, 28 Nov 2017 11:59:07 -0500
MIME-Version: 1.0
In-Reply-To: <12fed6ac-0e21-a137-4d7c-3bb341c4e831@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2017 11:49 AM, Nikolay Borisov wrote:
> 
> 
> On 28.11.2017 18:35, Jes Sorensen wrote:
>> On 11/28/2017 11:26 AM, Nikolay Borisov wrote:
>>>
>>>
>>> On 28.11.2017 18:16, Jes Sorensen wrote:
>>>> On 11/14/2017 05:39 AM, Nikolay Borisov wrote:
>>>>>
>>>>>
>>>>> I just tested with verbatim 4.14 and even though the wireless works, 
>>>>> iwconfig reports something strange: 
>>>>>
>>>>> iwconfig wifi1
>>>>> wifi1     no wireless extensions.
>>>>>
>>>>> However, my device works as expected (albeit still slow): 
>>>>>
>>>>> wifi1     Link encap:Ethernet  HWaddr 18:d6:c7:0d:47:3c  
>>>>>           inet addr:10.20.1.175  Bcast:10.20.1.255  Mask:255.255.255.0
>>>>>           inet6 addr: fe80::281d:5f27:eb1b:8ded/64 Scope:Link
>>>>>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>>>>           RX packets:38903 errors:0 dropped:0 overruns:0 frame:0
>>>>>           TX packets:24689 errors:0 dropped:0 overruns:0 carrier:0
>>>>>           collisions:0 txqueuelen:1000 
>>>>>           RX bytes:51524413 (51.5 MB)  TX bytes:5503039 (5.5 MB)
>>>>
>>>> iwconfig has been deprecated for a decade, but maybe you could elaborate
>>>> on what you feel is strange in this output?
>>>
>>> Well there are 2 things:
>>>
>>> 1. The low bitrate - which I've confirmed doing actual data test, ie,
>>> not just the number but the fact that the speeds are low.
>>>
>>> 2. The worse signal level/link quality.
>>
>> I don't see either of those in the iwconfig output
>>
>> The low TX bitrate is a known issue. Somehow the firmware rate handling
>> doesn't seem to work (or it works differently than I assumed) similar to
>> for the 8188eu. It's something I need to figure out when I have some time.
>>
>> As for link quality is this something you measured or read out of 'iw' ?
> 
> Well there is:
> 
> Link Quality=26/70  Signal level=-84 dBm < - with rtl8xxxu driver
> 
> Link Quality=81/100  Signal level=100/100  Noise level=0/100 <-- with
> vendor's driver. Another vector was the icon of network manager had only
> 2 bars with the in-tree driver and had full bars with out (yeah, this is
> a bit subjective metric but it's the best i've got).

OK, the link reporting from rtl8xxxu isn't complete, so I wouldn't put
too much into this.

Cheers,
Jes
