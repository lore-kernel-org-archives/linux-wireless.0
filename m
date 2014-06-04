Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:54793 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaFDLzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 07:55:37 -0400
Received: by mail-we0-f180.google.com with SMTP id q58so8268562wes.25
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 04:55:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401824416.4157.32.camel@jlt4.sipsolutions.net>
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
	<1401345535-22991-2-git-send-email-michal.kazior@tieto.com>
	<1401824416.4157.32.camel@jlt4.sipsolutions.net>
Date: Wed, 4 Jun 2014 13:55:36 +0200
Message-ID: <CA+BoTQ=gRHgiRG7NpUzEdeKXPzBbob=snYMMG-agMQeoiXwDTw@mail.gmail.com> (sfid-20140604_135541_190331_3BF2EC40)
Subject: Re: [PATCH v2 1/2] mac80211: move csa counters from sdata to beacon/presp
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 June 2014 21:40, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-29 at 08:38 +0200, Michal Kazior wrote:
>
>
>> +               memcpy(new->csa_counter_offsets,
>> csa->counter_offsets_beacon,
>> +                      csa->n_counter_offsets_beacon *
>> +                      sizeof(*new->csa_counter_offsets));
>
> Given that it's used like an array, maybe
> sizeof(new->csa_counter_offsets[0]) would be more readable? (this is in
> a few places)

I can update that.


>> +++ b/net/mac80211/ibss.c
>> @@ -143,7 +143,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
>>               *pos++ = csa_settings->block_tx ? 1 : 0;
>>               *pos++ = ieee80211_frequency_to_channel(
>>                               csa_settings->chandef.chan->center_freq);
>> -             sdata->csa_counter_offset_beacon[0] = (pos - presp->head);
>> +             presp->csa_counter_offsets[0] = (pos - presp->head);
>
> This seems slightly odd, but maybe it's a bugfix? Or are presp/beacon
> actually identical?

It seems presp is used when building beacon for ibss. See
__ieee80211_beacon_get().


Michał
