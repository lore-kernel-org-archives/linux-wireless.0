Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:65392 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3AZXgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 18:36:46 -0500
Received: by mail-we0-f174.google.com with SMTP id r6so804677wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2013 15:36:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359241463.9086.4.camel@jlt4.sipsolutions.net>
References: <1359232645-10563-1-git-send-email-thomas@cozybit.com> <1359241463.9086.4.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Sat, 26 Jan 2013 15:36:24 -0800
Message-ID: <CAG6hwVNFbuQLGhLECpjoFVevf+SunUY62RNAxmJSum34XGH+gw@mail.gmail.com> (sfid-20130127_003653_343905_DFD483B2)
Subject: Re: [PATCH v2] mac80211: dynamic short slot time for MBSSs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 26, 2013 at 3:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +     sband = local->hw.wiphy->bands[band];
>> +     bitrates = sband->bitrates;
>
> It might be interesting to loop once here and build a bitmap (in an
> unsigned long) of rates marked ERP_G. Something like
>
> erp_rates = 0;
> for (i = 0; i < sband->n_bitrates; i++)
>         if (bitrates[i].flags & ...)
>                 erp_rates |= BIT(i);
>
>
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(sta, &local->sta_list, list) {
>> +             if (sdata != sta->sdata ||
>> +                 sta->plink_state != NL80211_PLINK_ESTAB)
>> +                     continue;
>> +
>> +             short_slot = false;
>> +             rates = sta->sta.supp_rates[band];
>> +             for_each_set_bit(i, (unsigned long *)&rates,
>> +                              sizeof(rates) * BITS_PER_BYTE) {
>> +                     if (bitrates[i].flags & IEEE80211_RATE_ERP_G) {
>> +                             short_slot = true;
>> +                             break;
>> +                     }
>> +             }
>> +
>> +             if (!short_slot)
>> +                     break;
>
> Then the inner bitrate loop here becomes just
>
>                 if (!(rates & erp_rates)) {
>                         short_slot = false;
>                         break;
>                 }

Huh, that's actually pretty nice. I don't really get why the
for_each_set_bit() is broken on big endian 64-bit systems, but hey
this approach takes care of that concern :)

> which assumes "short_slot = true" as a precondition to going into the
> sta loop.
>
> (although that does change the overall logic to enable short slot when
> NO stations are present)

Sure. We'll disable it when not locally supported anyway.

Thanks.

-- 
Thomas
