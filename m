Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:44858 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753216AbdKWSYI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Nov 2017 13:24:08 -0500
Received: by mail-ot0-f181.google.com with SMTP id d27so16928349ote.11
        for <linux-wireless@vger.kernel.org>; Thu, 23 Nov 2017 10:24:07 -0800 (PST)
Subject: Re: rtl8723be on Fedora27
To: =?UTF-8?Q?R=c3=a1kosi_Gergely?= <rakosi.gergely@gmail.com>,
        James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
 <3a1fc541-9104-2d13-409f-c8e64845a86d@lwfinger.net>
 <c6662534-db2f-61dc-142e-8015984c6813@gmail.com>
 <2524fe93-9d8a-523e-3256-2b495c951eb0@lwfinger.net>
 <d4ba5178-3d60-76b0-3819-e70e3e173fac@gmail.com>
 <20171121203746.GC5400@us.netrek.org>
 <e639e8df-7cea-87c5-add9-cea1c5e57a8a@gmail.com>
 <20171121213046.GD5400@us.netrek.org>
 <44aaa502-a8f0-c494-f3d2-674e398ca16c@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <88073798-e6c3-99a8-15ff-d3c7a8b3ef55@lwfinger.net> (sfid-20171123_192412_266190_BBD0E138)
Date: Thu, 23 Nov 2017 12:24:05 -0600
MIME-Version: 1.0
In-Reply-To: <44aaa502-a8f0-c494-f3d2-674e398ca16c@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2017 08:36 AM, Rákosi Gergely wrote:
> 2017-11-21 22:30 keltezéssel, James Cameron írta:
>> On Tue, Nov 21, 2017 at 09:52:12PM +0100, Rákosi Gergely wrote:
>>> 2017-11-21 21:37 keltezéssel, James Cameron írta:
>>>> On Tue, Nov 21, 2017 at 03:08:16PM +0100, Rákosi Gergely wrote:
>>>>> 2017-11-18 16:52 keltezéssel, Larry Finger írta:
>>>>>> On 11/17/2017 06:22 PM, Rákosi Gergely wrote:
>>>>>>> Hello Larry,
>>>>>>>
>>>>>>> First of all, thanks your help.
>>>>>>> Lets see...here is the kernel version: 4.13.12-300
>>>>>>> The machine is an Asus ROG 553VE
>>>>>>>
>>>>>>> The firmware which loading in the dmesg is : rtlwifi/rtl8723befw_36.bin
>>>>>>> The output of md5sum is : 1850c1308fbcd95e9f6a7f58ede1e35f
>>>>>> [...]
>>>>>> sudo iw dev wlan0 scan | egrep "SSID|signal"
>>>>>>
>>>>>> Post that output. In addition, copy the dmesg output to some pastebin
>>>>>> and post the link as well.
>>>>>>
>>>>>> Larry
>>>>>>
>>>>> Hello Larry,
>>>>>
>>>>> I hope this email post format is good, and fit to the rules.
>>>>> Here is the output:
>>>>>
>>>>> root@skynet-x2 ~]# iw dev wlp2s0 scan | egrep "SSID|signal"
>>>>>          signal: -46.00 dBm
>>>>>          SSID: SKYNET-X2
>>>>> [...]
>>>>> [root@skynet-x2 ~]#
>>>> Scan results seem normal.  Was this scan before disconnect?
>>> Yes, this command output taken while the connection was OK
>> Thanks.
>>
>>>>> And the dmesg output:
>>>>>
>>>>> https://pastebin.com/iqQSu2hD
>>>> Is now v4.13.13.
>>> Yes, thats the upgraded kernel
>>>
>>>> This is interesting, an H2C command was dropped, but no idea which.
>>>>
>>>> [    9.848052] rtl8723be: error H2C cmd because of Fw download fail!!!
>>>>
>>>> Disconnection happened at boot+440 seconds, associate+429 seconds;
>>>>
>>>> [  439.871033] rtlwifi: AP off, try to reconnect now
>>>> [  439.871093] wlp2s0: Connection to AP 4c:5e:0c:c7:fa:e3 lost
>>>>
>>>> I cannot tell what causes disconnect.  I wonder if the same
>>>> timing of the problem happens always, or if the timing varies.
>>> The timing always changing, never is the same. And I dont realize
>>> the cause at now...
>> Thanks.  I had similar problem with different wireless device.
>>
>>>> Init MAC failed was another 30 seconds later;
>>>>
>>>> [  468.600670] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
>>>> [  469.618926] rtl8723be: Init MAC failed
>>>>
>>>> Looking at _rtl8723be_init_mac, there are two false returns;
>>>> hardware power on fail, and llt write fail.
>>>>
>>>> Sorry, I don't have rtl8723be hardware.
>>>>
>>>> Rákosi, did any older kernel keep connection?
>>> The oldest kernel is 4.13.9-300.fc27.x86_64 in Fedora 27
>>> installation, but did the same.  If you can give advise how, and
>>> what I do, then I'll try it.
>> You might try running "Live CD" of Fedora 26 or Fedora 25, without
>> installing, to test if unexpected disconnection happens in two older
>> kernels.  Not for permanent solution, just for easy testing.
>>
>> I don't have specific advice for Fedora 27, you might ask Fedora
>> community about that, or use RHBZ.  A quick search finds this old 2013
>> page;
>>
>> https://fedoraproject.org/wiki/User:Ignatenkobrain/Kernel/Bisection
>>
> And now the wireless is working almost 20 hours long, from yesterday
> afternoon. I dont know why. Lets check some happening:
> - Yesterday I disconnect the charger from laptop, and lay down at the
> other room
> - I left the laptop more than a hour without interaction, so the system
> is going to sleep
> - When I push the keyboard the system load up, and everything is working
> fine
> - The battery almost depleted when I going back to the original room,
> and connect the charger
> 
> Then nothing changed, and I have a working rtl8723be wifi module. Why ?

Who knows? I do not understand why it did not work before the way mine does with 
openSUSE!

Larry
