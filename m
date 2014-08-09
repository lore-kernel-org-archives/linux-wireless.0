Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:61975 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaHIHaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 03:30:05 -0400
Message-ID: <53E5CDF9.4010008@broadcom.com> (sfid-20140809_093026_015755_2C63147B)
Date: Sat, 9 Aug 2014 09:30:01 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Ben Greear <greearb@candelatech.com>,
	Dave Taht <dave.taht@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	Franky Lin <frankyl@broadcom.com>
Subject: Re: Reporting firmware stats to ethtool
References: <53E3F65D.8080102@candelatech.com>	<87wqajz6yg.fsf@kamboji.qca.qualcomm.com>	<53E4EFCB.5090501@candelatech.com>	<CAA93jw429GCjwiD0FQNFudZ0RDEKShZh4iiuOP+g+PpRjFNT7Q@mail.gmail.com>	<53E4F6B8.50009@candelatech.com> <53E4FEA9.80803@broadcom.com> <87vbq2uqdt.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vbq2uqdt.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2014 08:30 AM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>>>> I do kind of prefer 64 bit counters in the general case. Nuke it from
>>>> orbit, it's the only way to be sure.
>>>
>>> It's 64-bit to user-space, but that means nothing because firmware
>>> uses 32-bit (or even 16 bit in some cases, probably) internally.
>>> A great deal of counters are the same, so be very careful when
>>> trying to keep long term counters grabbed from firmware/drivers/hardware.
>>>
>>> And, stations come and go when you re-associate, so all sorts of wifi counters
>>> reset themselves all the time...
>>
>> Does ath driver notify mac80211 about firmware restart, ie. through
>> ieee80211_restart_hw().
>
> ath10k does use ieee80211_restart_hw().
>
>> If only user-space could get that info.
>
> Yeah, that would be nice to have for ath10k firmware crash dump
> functionality. And doesn't Android also need something similar?

Probably. bcmdhd seems to send a "firmware hang" event up to wpa_supp, 
which probably ends up in the android wifi framework through the control 
interface. Currently, this is a driver private event handled by 
wpa_supplicant_lib, but it seems trivial to me to add a nl80211 event to 
trigger that.

I am not sure what infrastructure your "ath10k firmware crash dump" is 
going to use. I have seen similar thing from Marvell recently [1] which 
relies on udev and ethtool to do the work. I guess aligning the 
solutions is why this topic is listed for the wireless breakout session 
at kernel summit in Chicago.

Regards,
Arend

[1] http://www.spinics.net/lists/linux-wireless/msg123943.html
