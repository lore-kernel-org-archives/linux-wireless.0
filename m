Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:48768 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZGaQDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:03:53 -0400
Received: by yxe5 with SMTP id 5so148665yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 09:03:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249055782.20312.19.camel@johannes.local>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
	<1249026324.29587.15.camel@johannes.local> <43e72e890907310849l3487b8a2p52302f6662a26f95@mail.gmail.com>
	<1249055782.20312.19.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 31 Jul 2009 09:03:33 -0700
Message-ID: <43e72e890907310903k65be4480j3279253281f2935e@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming feature
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 8:56 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-07-31 at 08:49 -0700, Luis R. Rodriguez wrote:
>
>> > just set the _flags_ in their reg
>> > notifier,
>>
>> So if you mean devices that used custom reg stuff, the answer is no
>> because the patch which introduced the regression would prevent the
>> setting of the passive scan flag and beaconing restrictions so the
>> reg_notifier would never notice the difference.
>
> I did mean those devices. Adding a reg notifier hook for iwlwifi seems a
> little odd, given that cfg80211 is supposed to always honour the flags
> (which it copies to orig_flags for that purpose).
>
> But I don't see why ath couldn't do this:
>
>  * do _not_ set the passive/no-ibss flags in flags (orig_flags)

That's up to cfg80211 through the custom regdomain, so yes, and in
fact we can WARN if these are set.

>  * in the reg notifier, always set the passive/no-ibss flag into 'flags'
>   unless a beacon was noticed on that channel.

That's fine too, we still need a fix for 2.6.31. Do you have any
thoughts on that?

  Luis
