Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35769 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbaCSKxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 06:53:50 -0400
Received: by mail-ie0-f169.google.com with SMTP id to1so8700001ieb.0
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 03:53:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=VSfN9KjAsGEsU0dnRTuUXagW8Kc7ThWDw_MzVycWknA@mail.gmail.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-8-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEern9n0HZtMui1nGZvsx0wOR_L1EbTJt5gR30VebWAizg@mail.gmail.com>
	<CA+BoTQ=-aw6hv9jjA60f+JgZsFdCqSE3cwZ4OdQfRaV6fe9s9g@mail.gmail.com>
	<CAB3XZEc0YpByFSu2QaPJ0VtACVRrJoQGfWKtC-qSPD1q1xKg1w@mail.gmail.com>
	<CA+BoTQ=VSfN9KjAsGEsU0dnRTuUXagW8Kc7ThWDw_MzVycWknA@mail.gmail.com>
Date: Wed, 19 Mar 2014 12:53:50 +0200
Message-ID: <CAB3XZEfU6h20kLPBw2k3Z3Z3am857uLAamW0wAd+g1Q7KcYJEQ@mail.gmail.com> (sfid-20140319_115354_271706_7BD4823E)
Subject: Re: [RFC 07/21] mac80211: improve find_chanctx() for reservations
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2014 at 11:00 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 19 March 2014 09:47, Eliad Peller <eliad@wizery.com> wrote:
>> On Wed, Mar 19, 2014 at 10:34 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> On 18 March 2014 17:42, Eliad Peller <eliad@wizery.com> wrote:
>>>> On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>>>> Relax ieee80211_find_chanctx(). If chanctx
>>>>> reservation chandef is compatible with
>>>>> current-future assigned interfaces chandef then
>>>>> allow it to be used by new interfaces.
>>>>>
>>>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>>>> ---
>>>> [...]
>>>>
>>>>> +static const struct cfg80211_chan_def *
>>>>> +ieee80211_chanctx_reserved_chandef(struct ieee80211_local *local,
>>>>> +                                  struct ieee80211_chanctx *ctx,
>>>>> +                                  const struct cfg80211_chan_def *compat)
>>>>> +{
>>>>> +       struct ieee80211_sub_if_data *sdata;
>>>>> +
>>>>> +       lockdep_assert_held(&local->chanctx_mtx);
>>>>> +
>>>>> +       list_for_each_entry(sdata, &ctx->reserved_vifs,
>>>>> +                           reserved_chanctx_list) {
>>>>> +               if (!compat)
>>>>> +                       compat = &sdata->reserved_chandef;
>>>> this check is redundant.
>>>
>>> It isn't. The function can be called with compat == NULL. You don't
>>> want to call cfg80211_chandef_compatible() with a NULL chandef.
>>>
>> at least this patch has an explicit check for compat not being NULL
>> (before calling the function).
>> since this function checks chandef compatibility with current
>> reserved chandefs, i don't see why anyone would call it with NULL?
>
> Fair argument if you treat the patch separately from the whole patchset.
>
> This is later called with NULL (patch: implement multi-vif in-place
> reservations).
>
> I could make a if (WARN_ON(!compat)) return NULL; guard condition at
> the function start but I prefer the current way as it has wider
> appliance for code reuse.
>
ok. i haven't passed through all the patches yet.
if you use it later with NULL there's no reason to change it.

Eliad.
