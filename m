Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46669 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaCSIpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 04:45:11 -0400
Received: by mail-oa0-f46.google.com with SMTP id i7so8020188oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 01:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEdq=m2oFggRLRaJiMto3q37SFPU2u4uk2LkDqYJ4vt0ow@mail.gmail.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-9-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEdq=m2oFggRLRaJiMto3q37SFPU2u4uk2LkDqYJ4vt0ow@mail.gmail.com>
Date: Wed, 19 Mar 2014 09:45:10 +0100
Message-ID: <CA+BoTQkiic-LROVE-sN58p=Gx15eov+c6_2+JMiS3AmWUUCgqQ@mail.gmail.com> (sfid-20140319_094516_964952_A7E56454)
Subject: Re: [RFC 08/21] mac80211: improve chanctx reservation lookup
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 March 2014 17:57, Eliad Peller <eliad@wizery.com> wrote:
> On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Use a separate function to look for reservation
>> chanctx. For multi-interface/channel reservation
>> search sematics differ slightly.
>>
>> The new routine allows reservations to be merged
>> with chanctx that are already reserved by other
>> interface(s).
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
> [...]
>
>> +static const struct cfg80211_chan_def *
>> +ieee80211_chanctx_non_reserved_chandef(struct ieee80211_local *local,
>> +                                      struct ieee80211_chanctx *ctx,
>> +                                      const struct cfg80211_chan_def *compat)
>> +{
>> +       struct ieee80211_sub_if_data *sdata;
>> +
>> +       lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +       list_for_each_entry(sdata, &ctx->assigned_vifs,
>> +                           assigned_chanctx_list) {
>> +               if (rcu_access_pointer(sdata->reserved_chanctx) != NULL)
>> +                       continue;
> this is not rcu pointer...

Good catch, thanks! I must've missed this while rebasing.


>> +static bool
>> +ieee80211_chanctx_can_reserve_chandef(struct ieee80211_local *local,
>> +                                     struct ieee80211_chanctx *ctx,
>> +                                     const struct cfg80211_chan_def *def)
>> +{
>> +       lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +       if (ieee80211_chanctx_combined_chandef(local, ctx, NULL) &&
>> +           ieee80211_chanctx_combined_chandef(local, ctx, def))
>> +               return true;
>> +
> what's the reason for calling it with NULL?
>
>> +       if (!list_empty(&ctx->reserved_vifs) &&
>> +           ieee80211_chanctx_reserved_chandef(local, ctx, NULL) &&
>> +           ieee80211_chanctx_reserved_chandef(local, ctx, def))
>> +               return true;
> and this seems redundant as _combined_chandef() should already check for it?

Hmm, good point. I'll get rid of these redundant checks.


Michał
