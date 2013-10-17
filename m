Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:49483 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab3JQQ2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 12:28:42 -0400
Message-ID: <52600E1A.6070806@opentechinstitute.org> (sfid-20131017_182847_727682_1FA3B0EF)
Date: Thu, 17 Oct 2013 12:19:38 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Detlev Casanova <detlev.casanova@gmail.com>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: NetworkManager not listing access points
References: <31357461.i5mG9q5IfA@naboo> <2916718.7t7kLXuBQV@naboo>	 <1381131658.13586.0.camel@jlt4.sipsolutions.net> <3301062.MLBKDh0Ksv@naboo>	 (sfid-20131011_174257_646312_6E07DE10) <1382020735.14410.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1382020735.14410.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/17/2013 10:38 AM, Johannes Berg wrote:
> On Fri, 2013-10-11 at 17:43 +0200, Detlev Casanova wrote:
> 
>>>>>> occur before commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8
>>>>
>>>> ("cfg80211:
>>>>>> use DS or HT operation IEs to determine BSS channel")
>>>
>>> [...]
>>>
>>>> I looked into wpa_supplicant and after an upgrade from 0.7.3 to 2.0,
>>>> the problem seems to be fixed.
>>>
>>> Huh, that's odd. Did 0.7.3 use wext driver?
>>
>> Yes it did.
> 
> Hmm. Even taking that into account though I don't really see any
> difference.
> 
> Maybe you could check if there's any difference in iwlist scan output
> before/after the patch (for the affected AP)?
> 
> johannes

Not to clog up the channel, but I was running into exactly the same
problem. I expected to see the problem somewhere in the kernel, etc. I
turned on debugging and kernel tracing and saw nothing. The fix for me
is almost identical to the fix that Detlev first described.

However, the problem for me was somewhere else entirely. The access
point was sending out malformed beacon messages that kept it from
showing up.

I *hope* that this helps. However, I hope, at least, this was not a
waste of bits. :-)

Will


> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
