Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34867 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbdK1Q0m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 11:26:42 -0500
Received: by mail-pg0-f68.google.com with SMTP id q20so147319pgv.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Nov 2017 08:26:42 -0800 (PST)
Subject: Re: Slow connection with rtl8xxxu and 8192eu chipset
To: Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org
References: <1195e649-c57f-1247-a0dc-2f0cc0732a00@gmail.com>
 <ce042534-6ba9-9654-c99f-7cfdff45b88a@gmail.com>
 <61e93af9-ef8a-5319-5a23-0b622d3cf0d0@gmail.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <7cb804e5-c1f5-a5d4-764d-e5a786625093@gmail.com> (sfid-20171128_172646_149446_7270B96D)
Date: Tue, 28 Nov 2017 18:26:36 +0200
MIME-Version: 1.0
In-Reply-To: <61e93af9-ef8a-5319-5a23-0b622d3cf0d0@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28.11.2017 18:16, Jes Sorensen wrote:
> On 11/14/2017 05:39 AM, Nikolay Borisov wrote:
>>
>>
>> On 14.11.2017 11:26, Nikolay Borisov wrote:
>>> (Please CC as I'm not subscribed)
>>>
>>> Hello,
>>>
>>> I have the tp-link tl-wn822N usb wifi dongle. lsbusb reports it as
>>>
>>> Bus 001 Device 003: ID 2357:0108
>>>
>>> Unfortunately with the in-kernel rtl8xxxu driver I don't get very good
>>> results:
>>>
>>> wifi1     IEEE 802.11  ESSID:"HOME"
>>>           Mode:Managed  Frequency:2.462 GHz  Access Point:
>>> 30:B5:C2:75:A4:CD
>>>           Bit Rate=1 Mb/s   Tx-Power=20 dBm
>>>           Retry short limit:7   RTS thr=2347 B   Fragment thr:off
>>>           Power Management:off
>>>           Link Quality=26/70  Signal level=-84 dBm
>>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>           Tx excessive retries:0  Invalid misc:165   Missed beacon:0
>>>
>>>
>>> At the same time if I use an out of tree driver acquired from github:
>>> https://github.com/Mange/rtl8192eu-linux-driver I get the following:
>>>
>>> wifi1     IEEE 802.11bgn  ESSID:"HOME"  Nickname:"<WIFI@REALTEK>"
>>>           Mode:Managed  Frequency:2.462 GHz  Access Point:
>>> 30:B5:C2:75:A4:CD
>>>           Bit Rate:144.4 Mb/s   Sensitivity:0/0
>>>           Retry:off   RTS thr:off   Fragment thr:off
>>>           Power Management:off
>>>           Link Quality=81/100  Signal level=100/100  Noise level=0/100
>>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>>
>>> Clearly this is a software problem of the in-kernel driver. I'm using
>>> v4.10.17 with commit c14239f23adb ("rtl8xxxu: Add another 8192eu device
>>> to the USB list") so that my device is recognised. Latest commit for
>>> that driver in my kernel is: c59f13bbead4 ("rtl8xxxu: Work around issue
>>> with 8192eu and 8723bu devices not reconnecting").
>>>
>>> Any ideas what I can do to further debug this, I'd really like to use
>>> the in-kernel driver ?
>>
>> I just tested with verbatim 4.14 and even though the wireless works, 
>> iwconfig reports something strange: 
>>
>> iwconfig wifi1
>> wifi1     no wireless extensions.
>>
>> However, my device works as expected (albeit still slow): 
>>
>> wifi1     Link encap:Ethernet  HWaddr 18:d6:c7:0d:47:3c  
>>           inet addr:10.20.1.175  Bcast:10.20.1.255  Mask:255.255.255.0
>>           inet6 addr: fe80::281d:5f27:eb1b:8ded/64 Scope:Link
>>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>           RX packets:38903 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:24689 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:1000 
>>           RX bytes:51524413 (51.5 MB)  TX bytes:5503039 (5.5 MB)
> 
> iwconfig has been deprecated for a decade, but maybe you could elaborate
> on what you feel is strange in this output?

Well there are 2 things:

1. The low bitrate - which I've confirmed doing actual data test, ie,
not just the number but the fact that the speeds are low.

2. The worse signal level/link quality.

> 
> The 8192eu driver has some issues, it looks like firmware rate support
> isn't working and it therefore transmits everything at low rates. I have
> to find some time to look into this.>
> Jes
> 
