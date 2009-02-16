Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:44706 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbZBPLLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 06:11:37 -0500
Received: by yw-out-2324.google.com with SMTP id 5so929416ywh.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 03:11:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234779625.4219.125.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-9-git-send-email-lrodriguez@atheros.com>
	 <1234695858.4219.54.camel@johannes.local>
	 <43e72e890902160155j402e887an9c5ea3ca9b9f64f3@mail.gmail.com>
	 <1234778566.4219.120.camel@johannes.local>
	 <43e72e890902160211p683bef08g5643ccb787cbf725@mail.gmail.com>
	 <1234779625.4219.125.camel@johannes.local>
Date: Mon, 16 Feb 2009 03:11:36 -0800
Message-ID: <43e72e890902160311r7b99a1f2i790fa1b4ea197b51@mail.gmail.com> (sfid-20090216_121142_492021_56F9A520)
Subject: Re: [PATCH 08/10] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 2:20 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-16 at 02:11 -0800, Luis R. Rodriguez wrote:
>
>> >> * Driver hints which never have the wiphy NULL
>> >> * __regulatory_hint: called from 11d hints, and from the workqueue
>> >> that processes the pending requests (which can come from userspace or
>> >> from drivers right now).
>> >
>> > Ok, but in the first case you can't have NULL, and in the second you
>> > could just inline it. It's not an operation that requires an inline here
>> > for it.
>>
>> Sure, its just called twice
>
> Yeah but the first call is entirely pointless since wiphy cannot be NULL
> there. I don't want to encourage random error-checking accessors where
> writing wiphy->wiphy_idx is perfectly fine.

That's the thing wiphy does not have a wiphy_idx, the
cfg80211_registered_device does.

>>  and I think it makes the code more
>> readable to use a routine, what if I just move it to core.c or reg.c.
>
> If you really think it makes the code that much more readable then
> please just use it once in the case where a NULL argument can happen
> (the workqueue), and move it to that code.

OK

  Luis
