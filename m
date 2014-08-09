Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50636 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaHIP5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 11:57:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Ben Greear <greearb@candelatech.com>,
	Dave Taht <dave.taht@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	Franky Lin <frankyl@broadcom.com>
Subject: Re: Reporting firmware stats to ethtool
References: <53E3F65D.8080102@candelatech.com>
	<87wqajz6yg.fsf@kamboji.qca.qualcomm.com>
	<53E4EFCB.5090501@candelatech.com>
	<CAA93jw429GCjwiD0FQNFudZ0RDEKShZh4iiuOP+g+PpRjFNT7Q@mail.gmail.com>
	<53E4F6B8.50009@candelatech.com> <53E4FEA9.80803@broadcom.com>
	<87vbq2uqdt.fsf@kamboji.qca.qualcomm.com>
	<53E5CDF9.4010008@broadcom.com>
Date: Sat, 9 Aug 2014 18:56:55 +0300
In-Reply-To: <53E5CDF9.4010008@broadcom.com> (Arend van Spriel's message of
	"Sat, 9 Aug 2014 09:30:01 +0200")
Message-ID: <87y4uxu054.fsf@kamboji.qca.qualcomm.com> (sfid-20140809_175731_098151_C796ABC3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

>>> Does ath driver notify mac80211 about firmware restart, ie. through
>>> ieee80211_restart_hw().
>>
>> ath10k does use ieee80211_restart_hw().
>>
>>> If only user-space could get that info.
>>
>> Yeah, that would be nice to have for ath10k firmware crash dump
>> functionality. And doesn't Android also need something similar?
>
> Probably. bcmdhd seems to send a "firmware hang" event up to wpa_supp,
> which probably ends up in the android wifi framework through the
> control interface. Currently, this is a driver private event handled
> by wpa_supplicant_lib, but it seems trivial to me to add a nl80211
> event to trigger that.
>
> I am not sure what infrastructure your "ath10k firmware crash dump" is
> going to use.

Currently we are planning to just provide a debugfs file to retrieve the
latest dump.

> I have seen similar thing from Marvell recently [1] which relies on
> udev and ethtool to do the work. I guess aligning the solutions is why
> this topic is listed for the wireless breakout session at kernel
> summit in Chicago.

Yeah, we did talk about that a bit in the mailing list few months back.

-- 
Kalle Valo
