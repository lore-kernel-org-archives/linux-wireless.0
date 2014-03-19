Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35484 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaCSIeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 04:34:16 -0400
Received: by mail-ob0-f182.google.com with SMTP id uz6so7951609obc.27
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 01:34:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEern9n0HZtMui1nGZvsx0wOR_L1EbTJt5gR30VebWAizg@mail.gmail.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-8-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEern9n0HZtMui1nGZvsx0wOR_L1EbTJt5gR30VebWAizg@mail.gmail.com>
Date: Wed, 19 Mar 2014 09:34:16 +0100
Message-ID: <CA+BoTQ=-aw6hv9jjA60f+JgZsFdCqSE3cwZ4OdQfRaV6fe9s9g@mail.gmail.com> (sfid-20140319_093423_255961_AA92DC3C)
Subject: Re: [RFC 07/21] mac80211: improve find_chanctx() for reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 March 2014 17:42, Eliad Peller <eliad@wizery.com> wrote:
> On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Relax ieee80211_find_chanctx(). If chanctx
>> reservation chandef is compatible with
>> current-future assigned interfaces chandef then
>> allow it to be used by new interfaces.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
> [...]
>
>> +static const struct cfg80211_chan_def *
>> +ieee80211_chanctx_reserved_chandef(struct ieee80211_local *local,
>> +                                  struct ieee80211_chanctx *ctx,
>> +                                  const struct cfg80211_chan_def *compat)
>> +{
>> +       struct ieee80211_sub_if_data *sdata;
>> +
>> +       lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +       list_for_each_entry(sdata, &ctx->reserved_vifs,
>> +                           reserved_chanctx_list) {
>> +               if (!compat)
>> +                       compat = &sdata->reserved_chandef;
> this check is redundant.

It isn't. The function can be called with compat == NULL. You don't
want to call cfg80211_chandef_compatible() with a NULL chandef.


Michał
