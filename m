Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:55323 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYGXPCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 11:02:42 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1229436ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 08:02:40 -0700 (PDT)
Message-ID: <1ba2fa240807240802t2e4ae505j84fa4569b4cebd46@mail.gmail.com> (sfid-20080724_170250_869983_F8996883)
Date: Thu, 24 Jul 2008 18:02:40 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Another fragmentation multiqueue kludge
Cc: "David Miller" <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy Cohen" <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <1216911563.13587.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com>
	 <1ba2fa240807240601o2c083347rf5f1b6507e0abe7c@mail.gmail.com>
	 <1216908973.13587.65.camel@johannes.berg>
	 <1ba2fa240807240737lf649fc8m3c4236329e02288@mail.gmail.com>
	 <1216910776.13587.74.camel@johannes.berg>
	 <1ba2fa240807240755o25889a9fy50d20e298beb14b0@mail.gmail.com>
	 <1216911563.13587.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 5:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-07-24 at 17:55 +0300, Tomas Winkler wrote:
>
>> > What happens if you just invert the
>> >                if (__netif_subqueue_stopped(local->mdev, i))
>> >                        continue;
>>
>> > check in ieee80211_tx_pending to read
>> >                if (!__netif_subqueue_stopped(local->mdev, i))
>> >                        continue;
>> >
>> > as I suggested yesterday?
>>
>> This is wrong since you it will actually starts queues that driver
>> didn't ask to start in the next line.
>
> Ok.
>
>> As I see it any failure in the driver's tx path will cause moving to
>> pending queue, except packets on AMPDU
>> queues that will be dropped.
>
>> That's correct for stopping because of queue overhead, not for errors.
>
> Tough luck, just drop packets on errors. If that matters to you, fix the
> driver to not run into these errors.

I don't really mind. I just want to be environment friendly and don't
want to be asked by other driver maintainers to fix their drivers :)

>> So till someone fix adm driver consider this patch It worked quite
>> well. I will also send patch that fixes the behavior in the iwlwifi
>> driver.
>
> If you fix iwlwifi we don't need this patch, and then I can instead
> remove the code from mac80211, but we can just as well merge this first
> since we'll get rid of it again.

Okay I will post both patches.
Thanks for review
Tomas
