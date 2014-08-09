Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5257 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaHIGa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 02:30:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Ben Greear <greearb@candelatech.com>,
	Dave Taht <dave.taht@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: Reporting firmware stats to ethtool
References: <53E3F65D.8080102@candelatech.com>
	<87wqajz6yg.fsf@kamboji.qca.qualcomm.com>
	<53E4EFCB.5090501@candelatech.com>
	<CAA93jw429GCjwiD0FQNFudZ0RDEKShZh4iiuOP+g+PpRjFNT7Q@mail.gmail.com>
	<53E4F6B8.50009@candelatech.com> <53E4FEA9.80803@broadcom.com>
Date: Sat, 9 Aug 2014 09:30:06 +0300
In-Reply-To: <53E4FEA9.80803@broadcom.com> (Arend van Spriel's message of
	"Fri, 8 Aug 2014 18:45:29 +0200")
Message-ID: <87vbq2uqdt.fsf@kamboji.qca.qualcomm.com> (sfid-20140809_083030_897913_810DE732)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

>>> I do kind of prefer 64 bit counters in the general case. Nuke it from
>>> orbit, it's the only way to be sure.
>>
>> It's 64-bit to user-space, but that means nothing because firmware
>> uses 32-bit (or even 16 bit in some cases, probably) internally.
>> A great deal of counters are the same, so be very careful when
>> trying to keep long term counters grabbed from firmware/drivers/hardware.
>>
>> And, stations come and go when you re-associate, so all sorts of wifi counters
>> reset themselves all the time...
>
> Does ath driver notify mac80211 about firmware restart, ie. through
> ieee80211_restart_hw().

ath10k does use ieee80211_restart_hw().

> If only user-space could get that info.

Yeah, that would be nice to have for ath10k firmware crash dump
functionality. And doesn't Android also need something similar?

-- 
Kalle Valo
