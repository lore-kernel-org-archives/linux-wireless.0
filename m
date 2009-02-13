Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:56930 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZBMVko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 16:40:44 -0500
Received: by gxk22 with SMTP id 22so1218785gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 13:40:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234560264.4219.33.camel@johannes.local>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234523055.4219.15.camel@johannes.local>
	 <43e72e890902131021j6289a817m67c9ad22ab958a1d@mail.gmail.com>
	 <1234560264.4219.33.camel@johannes.local>
Date: Fri, 13 Feb 2009 13:40:41 -0800
Message-ID: <43e72e890902131340n61471cd1m92cea2218f171b0@mail.gmail.com> (sfid-20090213_224048_683993_17952F87)
Subject: Re: [PATCH 5/6] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 1:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-02-13 at 10:21 -0800, Luis R. Rodriguez wrote:
>> On Fri, Feb 13, 2009 at 3:04 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2009-02-12 at 21:36 -0800, Luis R. Rodriguez wrote:
>> >>
>> >> +       if (wiphy_idx_valid(last_request->wiphy_idx))
>> >> +               request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
>> >
>> > All this seems pointless, wiphy_idx_to_wiphy will just return NULL if
>> > the index isn't valid. This is in a number of places, and it's not like
>> > it being invalid will be happening often so we'd have to optimise for
>> > it.
>>
>> The check can be removed if the WARNING is removed on
>> wiphy_idx_to_wiphy(). I left it as I figured it'd be good to leave the
>> warning, your call.
>
> Dunno, I think no warning is probably better if more than half the
> callers would have to check first... Also, the warning seems like it
> could spuriously trigger if a wiphy is removed?

Yeah I think you're right.

> One other thing I noticed - why is there a conditional assert on the
> mutex? Shouldn't it always be locked?

The conditional assert on the mutex is there because on cfg80211 you
don't want to hold a mutex as that would mean userspace gets stuck
with one. I believe lockdep complained to me about it as exactly that.

  Luis
