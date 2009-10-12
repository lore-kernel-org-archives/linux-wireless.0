Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17494 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbZJLMb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:31:28 -0400
Message-ID: <4AD3212B.4000503@nokia.com>
Date: Mon, 12 Oct 2009 15:29:31 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: David Miller <davem@davemloft.net>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"hidave.darkstar@gmail.com" <hidave.darkstar@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
References: <873a5pq5vc.fsf@purkki.valot.fi>	<1255276971.4095.241.camel@johannes.local>	<87y6nhoqud.fsf@purkki.valot.fi>	<20091011.200857.141215452.davem@davemloft.net> <87tyy5njbf.fsf@purkki.valot.fi>
In-Reply-To: <87tyy5njbf.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Kalle Valo wrote:
> David Miller <davem@davemloft.net> writes:
> 
>>>> I really don't see the point, since it's just three lines of code, but I
>>>> wouldn't mind all that much either.
>>> My worry are the developers who even don't know what is a bottom half
>>> and might get it all wrong. (Yes, there really are such people.)
>> And the difference between this and knowing you need to call the
>> ieee80211_rx_ni() thing is?
>>
>> You have to know what the heck a bottom half is to even know that you
>> would need to call the ieee80211_rx_ni() thing.
>>
>> And that's the same amount of knowledge necessary to simply wrap the
>> thing in a BH disable/enable sequence.
> 
> I was thinking that it's possible to document it something like this:
> 
> o in irq context use ieee80211_rx_irqsafe()
> o in a tasklet use ieee80211_rx()
> o in process context use ieee80211_rx_ni()
> 
> Also in the future it might be easier to optimise something based on
> these functions. Maybe.
> 
> But as Johannes didn't like the idea, and neither do you, I'm going to
> drop the idea. I'll add the BH disable/enable to wl1251 instead and
> hopefully Luciano does the same to wl1271.

Yeps, I can do the same for wl1271.

-- 
Cheers,
Luca.
