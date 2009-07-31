Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:50209 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZGaQdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:33:18 -0400
Received: by yxe5 with SMTP id 5so175809yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 09:33:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249056713.25587.6.camel@johannes.local>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
	<1249026324.29587.15.camel@johannes.local> <43e72e890907310849l3487b8a2p52302f6662a26f95@mail.gmail.com>
	<1249055782.20312.19.camel@johannes.local> <43e72e890907310903k65be4480j3279253281f2935e@mail.gmail.com>
	<1249056713.25587.6.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 31 Jul 2009 09:32:57 -0700
Message-ID: <43e72e890907310932u4510fc6fwc0c3dab598036041@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming feature
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 9:11 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-07-31 at 09:03 -0700, Luis R. Rodriguez wrote:
>
>> > I did mean those devices. Adding a reg notifier hook for iwlwifi seems a
>> > little odd, given that cfg80211 is supposed to always honour the flags
>> > (which it copies to orig_flags for that purpose).
>> >
>> > But I don't see why ath couldn't do this:
>> >
>> >  * do _not_ set the passive/no-ibss flags in flags (orig_flags)
>>
>> That's up to cfg80211 through the custom regdomain, so yes, and in
>> fact we can WARN if these are set.
>
> Ah, that seems a little heavy-handed :)
>
>> >  * in the reg notifier, always set the passive/no-ibss flag into 'flags'
>> >   unless a beacon was noticed on that channel.
>>
>> That's fine too, we still need a fix for 2.6.31. Do you have any
>> thoughts on that?
>
> Not really, tbh. Seems like all you'd have to do is remove the
> IEEE80211_CHAN_PASSIVE_SCAN/IEEE80211_CHAN_NO_IBSS flags from your
> channel registration,

Its not that simple. Consider the fact we build our own custom
regulatory domain and stuff what is intended for each one of them. The
_orig stuff is set upon channel registration so it is correct that
we'd have to avoid setting the channel flags prior to wiphy
registration. How you do that is left up to implementation. Since
cfg80211 will set the channel *_orig params based on
wiphy_registration() you're only option is to either prevent your
wiphy being registered with the flags set or to reset the channel
flags on the reg_notifier(). The later seems like the way to go but we
currently do not call the reg_notifier() upon beacon hints -- we
currently only call the reg_notifier() upon regulatory domain changes
and upon wiphy registration. My point is both of these options require
considerable changes for 2.6.31.

> and set them in ath_reg_apply_beaconing_flags and
> ath_reg_apply_active_scan_flags, changing the polarity?
>
> I mean, right now you tell cfg80211 you don't support it,
> and then try
> to support it anyhow.

Not sure I follow, support what? The reg_notifier() is there for
regulatory domain changes, we didn't call it upon beacon hints. We
can, and I agree its the right approach, but not for 2.6.31.

> Instead, you could tell cfg80211 you _do_ support
> it, and then not support them depending on the notifier? It seems like
> that should work and not break cfg80211's assumption that you can never
> ever support _more_ than registration flags (orig_flags).

I'm not following at all, orig_flags do not tell cfg80211 the channel
flags the device supports. Most devices set flag to 0 upon wiphy
registration and therefore cfg80211 sets orig_flags to 0 as well
during wiphy registration.

  Luis
