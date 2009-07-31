Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:59689 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZGaRar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 13:30:47 -0400
Received: by yxe5 with SMTP id 5so226612yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 10:30:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907311028t5087b8bj9b685795e0528151@mail.gmail.com>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
	<1249026324.29587.15.camel@johannes.local> <43e72e890907310849l3487b8a2p52302f6662a26f95@mail.gmail.com>
	<1249055782.20312.19.camel@johannes.local> <43e72e890907310903k65be4480j3279253281f2935e@mail.gmail.com>
	<1249056713.25587.6.camel@johannes.local> <43e72e890907310932u4510fc6fwc0c3dab598036041@mail.gmail.com>
	<1249058611.6549.3.camel@johannes.local> <43e72e890907311028t5087b8bj9b685795e0528151@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 31 Jul 2009 10:30:27 -0700
Message-ID: <43e72e890907311030n8beda0ex28eb88921ba85c0@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming feature
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 10:28 AM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> On Fri, Jul 31, 2009 at 9:43 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
>> On Fri, 2009-07-31 at 09:32 -0700, Luis R. Rodriguez wrote:
>>
>>> Its not that simple. Consider the fact we build our own custom
>>> regulatory domain and stuff what is intended for each one of them. The
>>> _orig stuff is set upon channel registration so it is correct that
>>> we'd have to avoid setting the channel flags prior to wiphy
>>> registration. How you do that is left up to implementation. Since
>>> cfg80211 will set the channel *_orig params based on
>>> wiphy_registration() you're only option is to either prevent your
>>> wiphy being registered with the flags set or to reset the channel
>>> flags on the reg_notifier(). The later seems like the way to go but we
>>> currently do not call the reg_notifier() upon beacon hints -- we
>>> currently only call the reg_notifier() upon regulatory domain changes
>>> and upon wiphy registration. My point is both of these options require
>>> considerable changes for 2.6.31.
>>
>> Aha. So the problem really is that we don't have a reg notifier on
>> updates due to beacons.
>
> Yeah, seems that's the core issue from the original implementation. We
> should have added that.
>
>>> > and set them in ath_reg_apply_beaconing_flags and
>>> > ath_reg_apply_active_scan_flags, changing the polarity?
>>> >
>>> > I mean, right now you tell cfg80211 you don't support it,
>>> > and then try
>>> > to support it anyhow.
>>>
>>> Not sure I follow, support what? The reg_notifier() is there for
>>> regulatory domain changes, we didn't call it upon beacon hints. We
>>> can, and I agree its the right approach, but not for 2.6.31.
>>
>> I'm thinking more in terms of iwlwifi here, for all intents and purposes
>> it doesn't support beaconing on channel N, so it only supports NO_IBSS
>> on that channel. Which is what it puts into flags before registration.
>
> Ah I see, well but remember also that devices may have custom world
> regulatory domains for which they can set the no-ibss/passive scan
> flags and then allow for it due to a beacon hint.
>
>>> > Instead, you could tell cfg80211 you _do_ support
>>> > it, and then not support them depending on the notifier? It seems like
>>> > that should work and not break cfg80211's assumption that you can never
>>> > ever support _more_ than registration flags (orig_flags).
>>>
>>> I'm not following at all, orig_flags do not tell cfg80211 the channel
>>> flags the device supports. Most devices set flag to 0 upon wiphy
>>> registration and therefore cfg80211 sets orig_flags to 0 as well
>>> during wiphy registration.
>>
>> Well ok, "supports" is a bad word since we're talking about
>> restrictions. But for iwlwifi the orig_flags _do_ tell cfg80211 the
>> channel restrictions that the device _requires_.
>
> Oh ok, got it, yeah agreed, but its important to note we never
> documented nor was I aware we wanted to treat flags set prior to wiphy
> registration as capabilities. Truth is the device is actually capable
> of active scanning and beaconing on those channels but the design of
> the firmware doesn't allow for it.
>
>> Your devices, however, do not _strictly_ _require_ those channel flags,
>> they just require them for compliance. Unlike iwlwifi which crashes when
>> you don't do it right :)
>>
>> So I think we're in agreement -- the proper solution would be to call
>> the reg notifier on beacon hints too.
>
> Yeah, unless we want to just document an exception to the rules, but I
> do agree that seems like a slippery slope.
>
>> What we do for .31 I can't say I
>> really care,
>
> OK, I do, please consider this patch for 2.6.31 and also on
> wireless-testing for now.
>
>>  how much work do you think this would be? It doesn't seem
>> all _that_ bad, at least for core changes?
>
> After some thinking the reg_notifier() does not seem to be the
> appropriate place for this. The reg_notifier() was designed to account
> for regulatory domain changes, not enhancements such as beacon hints.
> Consider the regulatory_request structure passed as the second
> argument to reg_notifier() and the currently supported types of
> regulatory domain changes, %REGDOM_SET_BY_*.
>
> What seems cleaner is to add a beacon_hint() notifier and use that at
> the end of handle_reg_beacon() so that we already give the driver the
> channel on which a beacon was received.

And this in itself would be a no-op if we use the patch I posted, and
we treat iwlwifi on this matter as an exception. So I'm now more happy
to support this patch as-is.

  Luis
