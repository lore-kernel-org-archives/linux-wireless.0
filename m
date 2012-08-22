Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42660 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2HVVW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 17:22:59 -0400
Message-ID: <50354DAF.8060903@candelatech.com> (sfid-20120822_232304_236588_9AED3358)
Date: Wed, 22 Aug 2012 14:22:55 -0700
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

I was using debugfs....will check out using 'iw'.

Thanks,
Ben

>
> - Felix
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

