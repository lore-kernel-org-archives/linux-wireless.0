Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51398 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbaCOP7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 11:59:38 -0400
Received: by mail-ie0-f170.google.com with SMTP id rd18so3846671iec.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2014 08:59:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
	<1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
	<1393852248.10039.5.camel@jlt4.sipsolutions.net>
	<CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
	<CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
	<CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com>
	<CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com>
Date: Sat, 15 Mar 2014 16:59:37 +0100
Message-ID: <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com> (sfid-20140315_165942_644230_36005AD0)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Colleen T <colleen@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-03-15 2:03 GMT+01:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
> On Fri, Mar 14, 2014 at 3:12 PM, Colleen T <colleen@cozybit.com> wrote:
>> I'm on mac80211-next/master, sha is
>> 5a970df8990d173e7e4092952f2e3da1de69b27d
>
> I tried to reproduce by just merging the fixes in question onto Linus'
> tree and using radios=3 but no go. Can you provide the full kernel
> log, I'm particularly interested in what happened before. The
> COUNTRY=US on debian, which I believe you're on, should just trigger a
> regulatory domain setting to US upon initialization. Depending on how
> Debian does it this could either trigger as a module parameter or as a
> userspace event *after* the world regdom get set.
>
> The radios=3 alone would not do anything other than add new radios so
> I see no contention on the last_request by increasing or decreasing
> that. last_request is also protected by rtnl and although I was
> considering a possible race against processing the same last_request
> twice if you see how we call reg_process_pending_hints() on reg_todo()
> its protected by rtnl_lock() so I'm a bit puzzled as to how this is
> being triggered as those operations should be atomic. The other corner
> case I thought of was that for userspace requests which sets a
> timeout, but our when the timeout hits we also rtnl_lock() under
> reg_timeout_work().
>
> The other corner I thought of was when we reset_regdomains() but all
> callers are rtnl_lock()'d. This is also the same for callers of
> set_regdom().
>
> Do you get different results if you reduce the number of radios? If so
> where's the trigger point?
>

Just guessing, try add this one if not included in mac80211-next yet.

[PATCH 1/2] cfg80211: regulatory, reset regdomain in case of error -
this goes to 3.14 directly.

BR
Janusz
