Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37419 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaCPEnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2014 00:43:06 -0400
Received: by mail-lb0-f181.google.com with SMTP id c11so2757462lbj.26
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2014 21:43:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
 <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
 <1393852248.10039.5.camel@jlt4.sipsolutions.net> <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
 <CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
 <CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com>
 <CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com> <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 15 Mar 2014 21:42:43 -0700
Message-ID: <CAB=NE6UGWfZxU6zi=XzLKWeN+1aFgxTVUpr349FVHBsRgSGo+A@mail.gmail.com> (sfid-20140316_054335_689754_8978DBFD)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: Colleen T <colleen@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 15, 2014 at 8:59 AM, Janusz Dziedzic
<janusz.dziedzic@gmail.com> wrote:
> 2014-03-15 2:03 GMT+01:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
>> On Fri, Mar 14, 2014 at 3:12 PM, Colleen T <colleen@cozybit.com> wrote:
>>> I'm on mac80211-next/master, sha is
>>> 5a970df8990d173e7e4092952f2e3da1de69b27d
>>
>> I tried to reproduce by just merging the fixes in question onto Linus'
>> tree and using radios=3 but no go. Can you provide the full kernel
>> log, I'm particularly interested in what happened before. The
>> COUNTRY=US on debian, which I believe you're on, should just trigger a
>> regulatory domain setting to US upon initialization. Depending on how
>> Debian does it this could either trigger as a module parameter or as a
>> userspace event *after* the world regdom get set.
>>
>> The radios=3 alone would not do anything other than add new radios so
>> I see no contention on the last_request by increasing or decreasing
>> that. last_request is also protected by rtnl and although I was
>> considering a possible race against processing the same last_request
>> twice if you see how we call reg_process_pending_hints() on reg_todo()
>> its protected by rtnl_lock() so I'm a bit puzzled as to how this is
>> being triggered as those operations should be atomic. The other corner
>> case I thought of was that for userspace requests which sets a
>> timeout, but our when the timeout hits we also rtnl_lock() under
>> reg_timeout_work().
>>
>> The other corner I thought of was when we reset_regdomains() but all
>> callers are rtnl_lock()'d. This is also the same for callers of
>> set_regdom().
>>
>> Do you get different results if you reduce the number of radios? If so
>> where's the trigger point?
>>
>
> Just guessing, try add this one if not included in mac80211-next yet.
>
> [PATCH 1/2] cfg80211: regulatory, reset regdomain in case of error -
> this goes to 3.14 directly.

Thanks for poingint that out Janusz, that patch is not in
mac80211-next. Colleen it'd be curious if that fixes your issue but I
don't see how given that I don't see how your situation would hit the
error case. It is certainly worth trying. In any case please do
provide the full kernel log and please try the other things I
mentioned, the more detail the better.

  Luis
