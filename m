Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59979 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab1ACVZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 16:25:15 -0500
To: Jouni Malinen <j@w1.fi>
Cc: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, Jouni Malinen <Jouni.Malinen@atheros.com>
Subject: Re: [PATCH] Revert "ath9k: Parse DTIM period from mac80211"
References: <1293691681-3574-1-git-send-email-mshajakhan@atheros.com>
	<871v4xgdfp.fsf@purkki.adurom.net> <20110102085300.GA14217@jm.kir.nu>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 03 Jan 2011 23:25:12 +0200
In-Reply-To: <20110102085300.GA14217@jm.kir.nu> (Jouni Malinen's message of "Sun\, 2 Jan 2011 10\:53\:00 +0200")
Message-ID: <87vd25fznr.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Sat, Jan 01, 2011 at 11:50:50AM +0200, Kalle Valo wrote:
>> Mohammed Shafi Shajakhan <mshajakhan@atheros.com> writes:
>> > * Preventing association with broken AP's
>> 
>> How can different dtim value cause problems with association? Power
>> save should not be even enabled during association. Or do you mean
>> there are problems after association, for example during eap
>> negotation?
>
> It is not the DTIM value, it is the part of having to receive a Beacon
> frame before even trying to associate. This is very much a corner case,
> but well, that behavior did change with the commit.

[...]

> The real issue (as far as I can tell) was that ath9k was changed to
> require mac80211 to get it DTIM period before association. I'm not aware
> of any need for that with ath9k. It should have no problems updating PS
> parameters after association and as such, should not require mac80211 to
> figure DTIM period out before being able to associate. This change is
> not about hardcoding DTIM period; it is about removing unneeded change
> that added extra latency without any real gain.

Ah, sorry. I misunderstood the case here then.

I have a feeling ath9k consumes quite a lot of power already, even
when I use dtim 10, and I was worried if ath9k power consumption even
increases more :)

-- 
Kalle Valo
