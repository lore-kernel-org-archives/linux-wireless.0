Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57605 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2HWFki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 01:40:38 -0400
Message-ID: <5035C24C.5070302@candelatech.com> (sfid-20120823_074100_795970_81A095B7)
Date: Wed, 22 Aug 2012 22:40:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Issue with ath9k and tx/rx chainmask:  3x3 doesn't work with
 mask of 0x1.
References: <50329D11.9030405@candelatech.com> <5035414D.2080600@openwrt.org> <50355C21.2030508@candelatech.com> <503573C6.4000103@candelatech.com> <50357DCB.1000908@candelatech.com> <5035BFC4.6020307@openwrt.org>
In-Reply-To: <5035BFC4.6020307@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2012 10:29 PM, Felix Fietkau wrote:
> On 2012-08-23 2:48 AM, Ben Greear wrote:
>> On 08/22/2012 05:05 PM, Ben Greear wrote:
>>> On 08/22/2012 03:24 PM, Ben Greear wrote:
>>>> On 08/22/2012 01:30 PM, Felix Fietkau wrote:
>>>>> On 2012-08-20 10:24 PM, Ben Greear wrote:
>>>>>> I am trying to test out an attenuator.  For now, I have only a single attenuator,
>>>>>> so I set tx and rx chainmask to 0x1 on both AP and Station machine.
>>>>>>
>>>>>> I then connected channel 0 on the two machines together through the
>>>>>> attenuator.
>>>>>>
>>>>>> I have two station interfaces on the station machine.  They both
>>>>>> seem to associate OK, but they cannot receive dhcp responses.
>>>>>>
>>>>>> It *seems* that broadcast packets may go through fine.
>>>>>>
>>>>>> If I force the rate down to 1x1 or 2x2 MIMO (or force disable /n
>>>>>> and just use /a), then it appears to work fine.
>>>>>>
>>>>>> Nics are WPEA-127n (AR9380).  Kernel is 3.5.1+ on AP, 3.5.2+ on station
>>>>>> machine.
>>>>>>
>>>>>> I can see why forcing it down to 1x1 might work around some issue,
>>>>>> but I find it funny that 2x2 works while 3x3 does not.
>>>>> Did you set the chainmask manually via debugfs? If so, don't do that!
>>>>> Use the nl80211 antenna control API (e.g. via iw)
>>>>
>>>> [root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 1 1
>>>> command failed: Operation not supported (-95)
>>>> [root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 1
>>>> command failed: Operation not supported (-95)
>>>> [root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 3
>>>> command failed: Operation not supported (-95)
>>>> [root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 7
>>>> command failed: Operation not supported (-95)
>>>> [root@lec2010-ath9k-1 lanforge]# uname -a
>>>> Linux lec2010-ath9k-1 3.5.1+ #15 SMP PREEMPT Thu Aug 9 09:31:45 PDT 2012 i686 i686 i386 GNU/Linux
>>>
>>> I'm guessing it is because of this:
>>>
>>> static int ieee80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
>>> {
>>>       struct ieee80211_local *local = wiphy_priv(wiphy);
>>>
>>>       if (local->started)
>>>           return -EOPNOTSUPP;
>>>
>>>       return drv_set_antenna(local, tx_ant, rx_ant);
>>> }
>>
>> Even when I manually admin down everything, I can still freeze the NIC
>> (WPEA-127n, AR9380).
>>
>> To reproduce:
>> stop all VAP/STA interfaces on wiphy0
>> set tx and rx chainmask to 2 using 'iw'
>> start vap0
>>
>> # Boom, fails to reset, and for whatever reason, local->started never
>> # goes false, so you can't even set the chainmask back using 'iw'.
>>
>>
>> Aug 22 17:41:34 localhost dhcpd: DHCPDISCOVER from 00:00:08:76:52:14 via rddVR17: network 99.88.77.0/24: no free leases
>> Aug 22 17:41:37 localhost kernel: [ 5575.474706] ath: wiphy0: Unable to reset hardware; reset status -5 (freq 5785 MHz)
>> Aug 22 17:41:38 localhost kernel: [ 5576.116434] ath: wiphy0: Unable to reset hardware; reset status -5 (freq 5785 MHz)
>> Aug 22 17:41:38 localhost kernel: [ 5576.476336] ath: wiphy0: Unable to reset hardware; reset status -5 (freq 5785 MHz)
>> Aug 22 17:41:45 localhost kernel: [ 5582.653715] ath: wiphy0: Unable to reset hardware; reset status -5 (freq 5785 MHz)
>> Aug 22 17:41:46 localhost dhclient[18218]: DHCPDISCOVER on rddVR18 to 255.255.255.255 port 67 interval 11
>> Aug 22 17:41:46 localhost dhcpd: DHCPDISCOVER from 26:0c:f3:49:95:16 via rddVR17: network 99.88.77.0/24: no free leases
>> Aug 22 17:41:47 localhost dhclient[18706]: DHCPDISCOVER on rddVR18#4 to 255.255.255.255 port 67 interval 14
>> Aug 22 17:41:47 localhost dhcpd: DHCPDISCOVER from 00:00:08:76:52:14 via rddVR17: network 99.88.77.0/24: no free leases
>> Aug 22 17:41:57 localhost dhclient[18218]: DHCPDISCOVER on rddVR18 to 255.255.255.255 port 67 interval 7
>> Aug 22 17:41:57 localhost dhcpd: DHCPDISCOVER from 26:0c:f3:49:95:16 via rddVR17: network 99.88.77.0/24: no free leases
>> Aug 22 17:41:59 localhost kernel: [ 5597.279989] in set_wiphy
>> Aug 22 17:41:59 localhost kernel: [ 5597.296604] in set_wiphy
>> Aug 22 17:41:59 localhost kernel: [ 5597.314646] in set_wiphy
>> Aug 22 17:41:59 localhost kernel: [ 5597.319479] set antenna failed, local->started
>> Aug 22 17:41:59 localhost kernel: [ 5597.326555] ops->set_antenna rv: -95
> Don't use 2 as antenna mask, the chip cannot handle it properly (I
> recently sent a patch to make setting such masks fail). Masks need to
> start at bit 0 and be contiguous.

Ok...I just finished making the same restriction in my user-space app, and
that does seem to keep things properly under control.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


