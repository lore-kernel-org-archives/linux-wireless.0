Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41305 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0IMXSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 19:18:12 -0400
Message-ID: <4C8EB131.6090903@candelatech.com>
Date: Mon, 13 Sep 2010 16:18:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k, virtual stations, and WPA:  No luck so far.
References: <4C8EA7D6.4040101@candelatech.com> <201009140112.23751.chunkeey@googlemail.com>
In-Reply-To: <201009140112.23751.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2010 04:12 PM, Christian Lamparter wrote:
> On Tuesday 14 September 2010 00:38:14 Ben Greear wrote:
>> I'm having no luck getting WPA to work with two STA interfaces
>> on the same ath9k NIC.
>>
>> So far, I've done a bunch of hacking to only scan on the one
>> channel that we're currently using if 1+ stations are associated,
>> and some other logic to not call change-channel logic unnecessarily.
>>
>> Currently, I see wlan0 able to associate and authenticate with wpa_supplicant,
>> but sta1 (the other STA interface), won't work.  A snippet from it's supplicant
>> log is below.  No-encryption and WEP seems to work fine.
>> If anyone has any suggestions as to where I should look to debug this,
>> I'd welcome the pointers!
>
> First things first: Have you tried your "idea" with mac80211_hwsim?

No, I didn't know that existed..I will look for information
on that.

> Also, have you disabled the hardware crypto accelerator? Because if
> you spend one second to look at ath9k's set_key code, you "will see"
> why the hardware has a problem dealing with multiple keys for a
> single MAC (of your AP).

Yes, I think that part is correct:

[root@a230-ath9k ~]# cat /sys/module/ath9k/parameters/nohwcrypt
1

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

