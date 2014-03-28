Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34475 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaC1PPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 11:15:22 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so3610206wgh.4
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 08:15:20 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Setting txpower fails?
From: Bruno Antunes <baantunes@gmail.com>
In-Reply-To: <53358EFB.1030308@candelatech.com>
Date: Fri, 28 Mar 2014 15:15:17 +0000
Cc: linux-wireless@vger.kernel.org, sedat.dilek@gmail.com
Message-Id: <E322ACF2-B0A6-45D9-93C8-85F68176DCB2@gmail.com> (sfid-20140328_161539_069901_0AB4FBE2)
References: <5334F8E7.1070803@candelatech.com> <CA+icZUVe7Mwf2P=Jk3rHvqZEDf3otOP7DwM=y7_LVHd4t_koQA@mail.gmail.com> <533584BF.70604@candelatech.com> <4CC49FDB-1767-4A3F-9C1D-8F8DCF612233@gmail.com> <53358920.6030304@candelatech.com> <8BD1BFE8-263F-4EDC-8044-30F4FBC44041@gmail.com> <53358EFB.1030308@candelatech.com>
To: Ben Greear <greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 28 Mar, 2014, at 15:02 , Ben Greear <greearb@candelatech.com> wrote:

> On 03/28/2014 07:49 AM, Bruno Antunes wrote:
>> 
>> On 28 Mar, 2014, at 14:37 , Ben Greear <greearb@candelatech.com> wrote:
>> 
>>> On 03/28/2014 07:29 AM, Bruno Antunes wrote:
>>>> Hi Ben,
>>>> I think you are missing some parameters
>>>> 
>>>> On 28 Mar, 2014, at 14:18 , Ben Greear <greearb@candelatech.com> wrote:
>>>> 
>>>>> On 03/28/2014 12:27 AM, Sedat Dilek wrote:
>>>>>> On Fri, Mar 28, 2014 at 5:21 AM, Ben Greear <greearb@candelatech.com> wrote:
>>>>>>> Any idea why this isn't working?
>>>>>>> 
>>>>>>> Kernel is 3.9.11+, driver is ath9k.
>>>>>>> 
>>>>>>> [root@ct523-9292 lanforge]# iwconfig wlan0
>>>>>>> wlan0     IEEE 802.11abgn  ESSID:off/any
>>>>>>>           Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>>>>>>>           Retry short limit:7   RTS thr:off   Fragment thr:off
>>>>>>>           Encryption key:off
>>>>>>>           Power Management:off
>>>>>>> 
>>>>>>> [root@ct523-9292 lanforge]# iwconfig wlan0 txpower 10
>>>> 
>>>> iw dev <devname> set txpower <auto|fixed|limit> [<tx power in mBm>]
>>>> 
>>>>  It should be something like:
>>>> 
>>>> iw dev wlan0 set txpower fixed 1000
>>> 
>>> Ok, that doesn't give an error, but 'iwconfig' still shows 16 dBm,
>>> and I don't see any way to get 'iw' to print out the power itself?
>>> 
>>> So, not sure if it is really working or not.
>> It works , at least on iw 3.10.
>> 
>> If you have debug enabled you can see the value changing.
> 
> Just for posterity's sake, it seems you should really be looking
> at user_power_level:
> 
> [root@ct523-9292 lanforge]# iw dev wlan0 set txpower fixed 1000
> [root@ct523-9292 lanforge]# cat /debug/ieee80211/wiphy0/netdev\:wlan0/txpower
> 0
> [root@ct523-9292 lanforge]#
> 
> [root@ct523-9292 lanforge]# cat /debug/ieee80211/wiphy0/netdev\:wlan0/user_power_level
> 10
> 
Not on all systems...

root@RSPro2:/etc/config#  iw dev adhoc0 set txpower fixed 700
root@RSPro2:/etc/config# cat /sys/kernel/debug/ieee80211/phy0/netdev\:adhoc0/txpower 
7
root@RSPro2:/etc/config# cat /sys/kernel/debug/ieee80211/phy0/netdev\:adhoc0/user_power_level 
7

Bruno

> Thanks,
> Ben
> 
>> 
>> On a openwrt system
>> 
>> root@RSPro2:/lib/wifi#  iw dev adhoc0 set txpower fixed 900
>> root@RSPro2:/lib/wifi# cat /sys/kernel/debug/ieee80211/phy0/netdev:adhoc0/txpower
>> 9
>> root@RSPro2:/lib/wifi#  iw dev adhoc0 set txpower fixed 1500
>> root@RSPro2:/lib/wifi# cat /sys/kernel/debug/ieee80211/phy0/netdev:adhoc0/txpower
>> 15
>> 
>> And the received power changes on the station confirming that is making effect.
>> 
>> Bruno
>> 
>>> 
>>> Thanks,
>>> Ben
>>> 
>>> 
>>> --
>>> Ben Greear <greearb@candelatech.com>
>>> Candela Technologies Inc  http://www.candelatech.com
>>> 
> 
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 

