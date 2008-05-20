Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:42373 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbYETOlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 10:41:46 -0400
Received: by el-out-1112.google.com with SMTP id s27so609437ele.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 07:41:45 -0700 (PDT)
Message-ID: <1ba2fa240805200741yf19929dk26d930f703b23f91@mail.gmail.com> (sfid-20080520_164149_724649_AB3C07BB)
Date: Tue, 20 May 2008 17:41:43 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Helmut Schaa" <hschaa@suse.de>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4832D661.60902@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
	 <1211288251.6252.86.camel@johannes.berg>
	 <1ba2fa240805200611o7c221c86na2c627242a2ce67@mail.gmail.com>
	 <1211289769.6252.90.camel@johannes.berg>
	 <1ba2fa240805200633y6730a1e3ufbc0adfedd3f8243@mail.gmail.com>
	 <1211290714.6252.93.camel@johannes.berg> <4832D661.60902@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 4:47 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Johannes Berg wrote:
>>>>
>>>> Thing is, I'm not totally convinced it is wrong to the code while it may
>>>> or may not be wrong...
>>>
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
>>>
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
> settle on a patch and get it upstream ASAP! Now that mainline is broken, the
> urgency is _MUCH_ greater.
>

We've just arguing about warning message so I won't consider it blocking.
Tomas
