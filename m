Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:48425 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZBPKL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 05:11:58 -0500
Received: by gxk22 with SMTP id 22so2850251gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 02:11:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234778566.4219.120.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-9-git-send-email-lrodriguez@atheros.com>
	 <1234695858.4219.54.camel@johannes.local>
	 <43e72e890902160155j402e887an9c5ea3ca9b9f64f3@mail.gmail.com>
	 <1234778566.4219.120.camel@johannes.local>
Date: Mon, 16 Feb 2009 02:11:56 -0800
Message-ID: <43e72e890902160211p683bef08g5643ccb787cbf725@mail.gmail.com> (sfid-20090216_111202_218668_65917F45)
Subject: Re: [PATCH 08/10] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 2:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-16 at 01:55 -0800, Luis R. Rodriguez wrote:
>
>> >> +static inline
>> >> +int wiphy_idx(struct wiphy *wiphy)
>> >> +{
>> >> +     struct cfg80211_registered_device *drv;
>> >> +     if (!wiphy)
>> >> +             return WIPHY_IDX_STALE;
>> >> +     drv = wiphy_to_dev(wiphy);
>> >> +     return drv->wiphy_idx;
>> >> +}
>> >
>> > I neither like the name of this function (same as the variable name) nor
>> > the function -- you're using it in exactly one place where you cannot
>> > ever pass NULL afaict.
>>
>> Nope, I'm calling it from 2 places:
>>
>> * Driver hints which never have the wiphy NULL
>> * __regulatory_hint: called from 11d hints, and from the workqueue
>> that processes the pending requests (which can come from userspace or
>> from drivers right now).
>
> Ok, but in the first case you can't have NULL, and in the second you
> could just inline it. It's not an operation that requires an inline here
> for it.

Sure, its just called twice and I think it makes the code more
readable to use a routine, what if I just move it to core.c or reg.c.

  Luis
