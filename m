Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:33525 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaEWMXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 08:23:45 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so4885666wes.12
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 05:23:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQk3stQoK34q6VcXhHm8+9Rh67UF4TTfgy5P1JY1o1dTFA@mail.gmail.com>
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	<1400767676-15994-3-git-send-email-michal.kazior@tieto.com>
	<1400770304.4174.34.camel@jlt4.sipsolutions.net>
	<CA+BoTQk3stQoK34q6VcXhHm8+9Rh67UF4TTfgy5P1JY1o1dTFA@mail.gmail.com>
Date: Fri, 23 May 2014 14:23:43 +0200
Message-ID: <CA+BoTQ=gjJw1e2osxuemxK1M+bLQpFQKUD9qozOm5frbLiXB5Q@mail.gmail.com> (sfid-20140523_142349_030158_5550644A)
Subject: Re: [PATCH v6 2/6] mac80211: implement multi-vif in-place reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 08:16, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 22 May 2014 16:51, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2014-05-22 at 16:07 +0200, Michal Kazior wrote:
>>> +static int
>>> +ieee80211_vif_use_reserved_incompat(struct ieee80211_local *local,
>>> +                                 struct ieee80211_chanctx *ctx,
>>> +                                 const struct cfg80211_chan_def *chandef)
>>> +{
>>> +     struct ieee80211_sub_if_data *sdata, *tmp;
>>> +     struct ieee80211_chanctx *new_ctx;
>>> +     u32 changed = 0;
>>> +     int err;
>>> +
>>> +     lockdep_assert_held(&local->mtx);
>>> +     lockdep_assert_held(&local->chanctx_mtx);
>>> +
>>> +     if (!ieee80211_chanctx_all_reserved_vifs_ready(local, ctx))
>>> +             return 0;
>>> +
>>> +     if (ieee80211_chanctx_num_assigned(local, ctx) !=
>>> +         ieee80211_chanctx_num_reserved(local, ctx)) {
>>> +             wiphy_info(local->hw.wiphy,
>>> +                        "channel context reservation cannot be finalized because some interfaces aren't switching\n");
>>> +             err = -EBUSY;
>>> +             goto err;
>>>       }
>>
>> I don't think I understand that condition, it's it possible to switch
>> from two vifs using two channels to both using a single third one?
>
> I assume you have a case where max number of different channels is
> degraded (e.g. non-radar -> more restrictive radar combination) in
> mind, right? In that case this won't work with this code. Now that I
> think about it it also won't work with cross-swapping (2 chanctx are
> being swapped and some vifs try to interchange between).
>
> I'll have to re-think this a bit more.

Actually I think I've just spotted a little problem. This is also
related to the `[PATCH v6 6/6] cfg80211: remove channel_switch
combination check` thread.

Currently mac80211 verifies interface combinations in channel_switch.
It has an implicit assumption that channel switch does not change the
number of different channels (or at least it doesn't decrease it).

We were discussing degradation of number of different channels
earlier, e.g. due to non-radar -> radar change (going from max 2
channels to 1). With how things are now it's impossible to perform
such a channel switch.

Basically if we want to support this kind of channel switch we must
remove interface combination checks from ieee80211_channel_switch
because it's simply impossible to know the future (userspace may or
may not submit subsequent requests to match an existing interface
combination).

So while I still intend to rework the multi-vif reservation a little
(to support cross-swapping at least) I'd like to know if I should
invest my time implementing degradation of number of channels in
multi-vif reservation or not.


Michał
