Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:47035 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZLHHXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 02:23:37 -0500
Received: by ewy1 with SMTP id 1so2369075ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 23:23:43 -0800 (PST)
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
Subject: Re: [RFT] ar9170: AP broadcast buffering
References: <200911290206.07784.chunkeey@googlemail.com>
	<200912071736.40929.chunkeey@googlemail.com>
	<87aaxu4ke7.fsf@purkki.valot.fi>
	<200912072231.32798.chunkeey@googlemail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 08 Dec 2009 09:23:39 +0200
In-Reply-To: <200912072231.32798.chunkeey@googlemail.com> (Christian Lamparter's message of "Mon\, 7 Dec 2009 22\:31\:32 +0100")
Message-ID: <871vj63p50.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> On Monday 07 December 2009 21:08:32 Kalle Valo wrote:
>
>> I don't know what time constraints you refer to here, but clients
>> should stay awake until they have received a multicast/broadcast
>> message with the moredata bit disabled. So, in theory, it doesn't
>> matter even if the frames are transmitted even 20 ms after the beacon.
>> (In practise some hardware might have timers for this, I think at
>> least wl1251 had one.)
>
>> Of course the downside is the increased power consumption. But it's
>> still better than to not receive the multicast/broadcast frames at
>> all :)
>
> That's the thing: 802.11-2007 11.2.1.5 f) says:
> "*Immediately* after every DTIM, the AP shall
>   transmit all buffered broadcast/multicast MSDUs...".
> And I cannot rule out that some Devs took this quite literally. ;-)

Well, "immediately" is relative. If my wife says to immeaditely do
something, it might take a week before I'll do it ;)

> Anyway, here is a case that I've witnessed:
>
> During testing, I caught samples where MC/BC frames were delayed for
> more up to 115ms. (b_interval = 102.4ms and dtim_period = 3)

Yeah, if the time is longer than the beacon interval then it won't
definitely work.

-- 
Kalle Valo
