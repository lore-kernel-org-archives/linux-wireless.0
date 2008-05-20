Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2667 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbYETO63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 10:58:29 -0400
Date: Tue, 20 May 2008 10:20:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	Helmut Schaa <hschaa@suse.de>, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
Message-ID: <20080520142012.GA1106@tuxdriver.com> (sfid-20080520_165833_438371_631646DC)
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de> <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com> <1211288251.6252.86.camel@johannes.berg> <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com> <1211289769.6252.90.camel@johannes.berg> <1ba2fa240805200633y6730a1e3ufbc0adfedd3f8243@mail.gmail.com> <1211290714.6252.93.camel@johannes.berg> <4832D661.60902@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4832D661.60902@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 08:47:13AM -0500, Larry Finger wrote:
> Johannes Berg wrote:
>>>> Thing is, I'm not totally convinced it is wrong to the code while it may
>>>> or may not be wrong...
>>> Doesn't should be bss pinned int he bss list if you are associating to
>>> it. If it's not there you don't have access to it's info It looks very
>>> wrong to me.
>>
>> Well, yes, it is a bit odd.
>>
>>>> I think this patch should go in first as it
>>>> actually fixes the oops, and then we can discuss the merits of adding a
>>>> warning there separately. Maybe after we look a bit at the code and try
>>>> to figure out whether it can still happen after that patch from
>>>> Abhijeet.
>>> I'm not sure if this patch is complete without this warning. What is
>>> in the else statement is a hack and it should be obvious.
>>
>> Considering that the message won't help us at all, why bother? We know
>> it's triggering, we know this might be a problem, and we know we can
>> only solve it by auditing the code. So why add a message that will get
>> us countless emails/complaints from people we cannot do anything about
>> anyway without doing the audit?
>
> This argument could go on endlessly; however, it is clear that we need to 
> settle on a patch and get it upstream ASAP! Now that mainline is broken, 
> the urgency is _MUCH_ greater.

I agree.  I'll take this one unless someone finds a problem with it.

John
-- 
John W. Linville
linville@tuxdriver.com
