Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57192 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaC1OSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 10:18:41 -0400
Message-ID: <533584BF.70604@candelatech.com> (sfid-20140328_151844_777684_0EF64730)
Date: Fri, 28 Mar 2014 07:18:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Setting txpower fails?
References: <5334F8E7.1070803@candelatech.com> <CA+icZUVe7Mwf2P=Jk3rHvqZEDf3otOP7DwM=y7_LVHd4t_koQA@mail.gmail.com>
In-Reply-To: <CA+icZUVe7Mwf2P=Jk3rHvqZEDf3otOP7DwM=y7_LVHd4t_koQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2014 12:27 AM, Sedat Dilek wrote:
> On Fri, Mar 28, 2014 at 5:21 AM, Ben Greear <greearb@candelatech.com> wrote:
>> Any idea why this isn't working?
>>
>> Kernel is 3.9.11+, driver is ath9k.
>>
>> [root@ct523-9292 lanforge]# iwconfig wlan0
>> wlan0     IEEE 802.11abgn  ESSID:off/any
>>            Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>>            Retry short limit:7   RTS thr:off   Fragment thr:off
>>            Encryption key:off
>>            Power Management:off
>>
>> [root@ct523-9292 lanforge]# iwconfig wlan0 txpower 10
>> [root@ct523-9292 lanforge]# echo $?
>> 0
>> [root@ct523-9292 lanforge]# iwconfig wlan0
>> wlan0     IEEE 802.11abgn  ESSID:off/any
>>            Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
>>            Retry short limit:7   RTS thr:off   Fragment thr:off
>>            Encryption key:off
>>            Power Management:off
>>
>> [root@ct523-9292 lanforge]#
>>
>
> Which version of wireless-tools?
> Why don't you use modern iw?

Do you know the right incantation for 'iw'?  From it's help, it seems
this should work, but it throws an error.  I haven't dug into the
code to figure out why...

[root@ct523-9292 lanforge]# iw dev wlan0 set txpower 10
Invalid parameter: 10

[root@ct523-9292 lanforge]# iwconfig --version
iwconfig  Wireless-Tools version 29
           Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

sta211    Recommend Wireless Extension v21 or later,
           Currently compiled with Wireless Extension v22.
...


Thanks,
Ben

>
> - Sedat -
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

