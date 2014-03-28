Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43568 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaC1PCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 11:02:22 -0400
Message-ID: <53358EFB.1030308@candelatech.com> (sfid-20140328_160225_397882_6CC810B0)
Date: Fri, 28 Mar 2014 08:02:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bruno Antunes <baantunes@gmail.com>
CC: linux-wireless@vger.kernel.org, sedat.dilek@gmail.com
Subject: Re: Setting txpower fails?
References: <5334F8E7.1070803@candelatech.com> <CA+icZUVe7Mwf2P=Jk3rHvqZEDf3otOP7DwM=y7_LVHd4t_koQA@mail.gmail.com> <533584BF.70604@candelatech.com> <4CC49FDB-1767-4A3F-9C1D-8F8DCF612233@gmail.com> <53358920.6030304@candelatech.com> <8BD1BFE8-263F-4EDC-8044-30F4FBC44041@gmail.com>
In-Reply-To: <8BD1BFE8-263F-4EDC-8044-30F4FBC44041@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2014 07:49 AM, Bruno Antunes wrote:
>
> On 28 Mar, 2014, at 14:37 , Ben Greear <greearb@candelatech.com> wrote:
>
>> On 03/28/2014 07:29 AM, Bruno Antunes wrote:
>>> Hi Ben,
>>> I think you are missing some parameters
>>>
>>> On 28 Mar, 2014, at 14:18 , Ben Greear <greearb@candelatech.com> wrote:
>>>
>>>> On 03/28/2014 12:27 AM, Sedat Dilek wrote:
>>>>> On Fri, Mar 28, 2014 at 5:21 AM, Ben Greear <greearb@candelatech.com> wrote:
>>>>>> Any idea why this isn't working?
>>>>>>
>>>>>> Kernel is 3.9.11+, driver is ath9k.
>>>>>>
>>>>>> [root@ct523-9292 lanforge]# iwconfig wlan0
>>>>>> wlan0     IEEE 802.11abgn  ESSID:off/any
>>>>>>            Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>>>>>>            Retry short limit:7   RTS thr:off   Fragment thr:off
>>>>>>            Encryption key:off
>>>>>>            Power Management:off
>>>>>>
>>>>>> [root@ct523-9292 lanforge]# iwconfig wlan0 txpower 10
>>>
>>> iw dev <devname> set txpower <auto|fixed|limit> [<tx power in mBm>]
>>>
>>>   It should be something like:
>>>
>>> iw dev wlan0 set txpower fixed 1000
>>
>> Ok, that doesn't give an error, but 'iwconfig' still shows 16 dBm,
>> and I don't see any way to get 'iw' to print out the power itself?
>>
>> So, not sure if it is really working or not.
> It works , at least on iw 3.10.
>
> If you have debug enabled you can see the value changing.

Just for posterity's sake, it seems you should really be looking
at user_power_level:

[root@ct523-9292 lanforge]# iw dev wlan0 set txpower fixed 1000
[root@ct523-9292 lanforge]# cat /debug/ieee80211/wiphy0/netdev\:wlan0/txpower
0
[root@ct523-9292 lanforge]#

[root@ct523-9292 lanforge]# cat /debug/ieee80211/wiphy0/netdev\:wlan0/user_power_level
10

Thanks,
Ben

>
> On a openwrt system
>
> root@RSPro2:/lib/wifi#  iw dev adhoc0 set txpower fixed 900
> root@RSPro2:/lib/wifi# cat /sys/kernel/debug/ieee80211/phy0/netdev:adhoc0/txpower
> 9
> root@RSPro2:/lib/wifi#  iw dev adhoc0 set txpower fixed 1500
> root@RSPro2:/lib/wifi# cat /sys/kernel/debug/ieee80211/phy0/netdev:adhoc0/txpower
> 15
>
> And the received power changes on the station confirming that is making effect.
>
> Bruno
>
>>
>> Thanks,
>> Ben
>>
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

