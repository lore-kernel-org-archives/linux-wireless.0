Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:33680 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZGWTEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 15:04:09 -0400
Received: by qw-out-2122.google.com with SMTP id 8so645242qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 12:04:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248375280.22109.33.camel@mountain.triplerocks.net>
References: <1248290605.4717.76.camel@mountain.triplerocks.net>
	<43e72e890907221230m53109c3eqf388a2d987d8cdda@mail.gmail.com>
	<1248375280.22109.33.camel@mountain.triplerocks.net>
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Date: Thu, 23 Jul 2009 12:03:48 -0700
Message-ID: <43e72e890907231203m2b9d576eh2f990817007f07d9@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless-old: Fix problem with TX on amd64
To: Gao Lei <lei.alvin.gao@gmail.com>
Cc: linux-wireless@vger.kernel.org, Tony Espy <espy@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 11:54 AM, Gao Lei<lei.alvin.gao@gmail.com> wrote:
> On Wed, 2009-07-22 at 12:30 -0700, Luis R. Rodriguez wrote:
>> On Wed, Jul 22, 2009 at 12:23 PM, Gao Lei wrote:
>> > On amd64, the `ieee80211_tx_info' struct takes 56 bytes, thus cannot fit
>> > into skb's control buffer.
>>
>> Thanks, what kernel is this against BTW? Just so you know we should be
>> able to bring down compat-wireless down to 2.6.21 and maybe even
>> further now that we no longer are using the master netdev, which used
>> the multiqueue support added as of 2.6.27. Last I checked
>> compat-wireless now compiles on 2.6.25, but I never actually tried
>> loading it as I'm on ext4. So if you are on 2.6.25 or 2.6.26 you may
>> want to try out compat-wireless directly and see if to works. If you
>> are on 2.6.21..2.6.24 you can try adding backport support. I've added
>> a few files already for older kernel support based on our old
>> compat-wireless-old effort, so only the new stuff that mac80211 makes
>> use of should require backporting.
>>
>>   Luis
>
> Hi,
>
> I am using kernel 2.6.26. Just tested compat-wireless and yes it works!
> Here the TX info struct takes exactly 48 bytes so it can fit well into
> the control buffer.
>
> Btw, I came up with the 'iwlagn: Unknown symbol iwl4965_agn_cfg' issue
> though (actually also in compat-wireless-old). Strange as it seems
> there're already some treatments there. Will look at it later.

May be a real issue. You can try wireless-testing directly and see if
it happens there.

> While it's great to see compat-wireless working for more old kernels, I
> wonder if compat-wireless-old is still actively maintained?

Well sure its maintained, its just deprecated now as we can backport
compat-wireless. The issue we had with compat-wireless-old is lack of
interest from developers to support it as no one cared for old drivers
and that old kernels.

> Asking this
> because currently most of the documentations still describe it as
> 'compat-wireless-old for <= 2.6.26 and compat-wireless for >= 2.6.27',
> and I was probably not the only amd64 user reading that. :)

Well so a few things:

1) We hadn't announced compat-wireless was available for older kernels
now. This was really because we had no testers.
2) you are the first to report success with 2.6.26 so that's a plus,
so now you can go ahead and update the documentation (its a wiki after
all) to mention this
3) If someone reports success with 2.6.25 then we bring the
documentation down to 2.6.25 and so on

  Luis
