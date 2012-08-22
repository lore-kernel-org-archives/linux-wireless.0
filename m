Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47981 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404Ab2HVWYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 18:24:38 -0400
Message-ID: <50355C21.2030508@candelatech.com> (sfid-20120823_002441_892545_A737F18C)
Date: Wed, 22 Aug 2012 15:24:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Issue with ath9k and tx/rx chainmask:  3x3 doesn't work with
 mask of 0x1.
References: <50329D11.9030405@candelatech.com> <5035414D.2080600@openwrt.org>
In-Reply-To: <5035414D.2080600@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2012 01:30 PM, Felix Fietkau wrote:
> On 2012-08-20 10:24 PM, Ben Greear wrote:
>> I am trying to test out an attenuator.  For now, I have only a single attenuator,
>> so I set tx and rx chainmask to 0x1 on both AP and Station machine.
>>
>> I then connected channel 0 on the two machines together through the
>> attenuator.
>>
>> I have two station interfaces on the station machine.  They both
>> seem to associate OK, but they cannot receive dhcp responses.
>>
>> It *seems* that broadcast packets may go through fine.
>>
>> If I force the rate down to 1x1 or 2x2 MIMO (or force disable /n
>> and just use /a), then it appears to work fine.
>>
>> Nics are WPEA-127n (AR9380).  Kernel is 3.5.1+ on AP, 3.5.2+ on station
>> machine.
>>
>> I can see why forcing it down to 1x1 might work around some issue,
>> but I find it funny that 2x2 works while 3x3 does not.
> Did you set the chainmask manually via debugfs? If so, don't do that!
> Use the nl80211 antenna control API (e.g. via iw)

[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 1 1
command failed: Operation not supported (-95)
[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 1
command failed: Operation not supported (-95)
[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 3
command failed: Operation not supported (-95)
[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 7
command failed: Operation not supported (-95)
[root@lec2010-ath9k-1 lanforge]# uname -a
Linux lec2010-ath9k-1 3.5.1+ #15 SMP PREEMPT Thu Aug 9 09:31:45 PDT 2012 i686 i686 i386 GNU/Linux

# Set previously using debugfs.
[root@lec2010-ath9k-1 lanforge]# cat /debug/ieee80211/wiphy0/ath9k/tx_chainmask
0x00000001

[root@lec2010-ath9k-1 lanforge]# ./local/sbin/iw phy wiphy0 set antenna 7 7
command failed: Operation not supported (-95)


Any idea what I'm doing wrong?

Thanks,
Ben


>
> - Felix
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

