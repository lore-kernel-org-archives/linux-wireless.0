Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:7119 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZBPJBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:01:15 -0500
Received: by yx-out-2324.google.com with SMTP id 8so922284yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 01:01:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234774163.4219.100.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-5-git-send-email-lrodriguez@atheros.com>
	 <1234695526.4219.46.camel@johannes.local>
	 <43e72e890902160013q48912fa1if1db7155e4fee1f1@mail.gmail.com>
	 <1234774163.4219.100.camel@johannes.local>
Date: Mon, 16 Feb 2009 01:01:14 -0800
Message-ID: <43e72e890902160101y30671861o43faccf51726a191@mail.gmail.com> (sfid-20090216_100125_481792_972A4272)
Subject: Re: [PATCH 04/10] nl80211: disallow user requests prior to
	regulatory_init()
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 12:49 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-16 at 00:13 -0800, Luis R. Rodriguez wrote:
>
>> >> +     if (!cfg80211_regdomain)
>> >> +             return -EINPROGRESS;
>> >> +
>> >
>> > But that variable access here is racy too.
>>
>> Right.
>>
>> > It might be ok anyway because
>> > the variable can never be NULL again after the first assignment
>>
>> That's what I was going for.
>>
>> >  but in
>> > that case the assignment needs to take care to assign something fully
>> > created ...
>>
>> Can you elaborate on what you mean?
>
> It'd have to be done in a RCU-like fashion,

I see what you're saying.

> unless we only ever use it
> as a bool here?

Its only used as a bool here, mind you __regulatory_hint() does do
mucking with cfg80211 but my patches move the hint to a workqueue so
that locking is now done later through the workqueue so under this new
patch series -- yes cfg80211_regdomain will only be used as a bool.

But come to think of it this is still racy -- think of the cases where
reset_regdomains() is called and the small race between the end of of
those calls and another CPU getting a new user reg hint. So we should
just lock.

  Luis
