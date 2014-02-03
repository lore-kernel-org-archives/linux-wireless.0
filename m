Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:59620 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaBCNC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 08:02:26 -0500
Received: by mail-qc0-f178.google.com with SMTP id m20so10876879qcx.37
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 05:02:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391175318.4141.8.camel@jlt4.sipsolutions.net>
References: <1386252334-26696-1-git-send-email-marek.kwaczynski@tieto.com>
	<1391175318.4141.8.camel@jlt4.sipsolutions.net>
Date: Mon, 3 Feb 2014 14:02:25 +0100
Message-ID: <CALDuf6jq7UnfkYub_MaRP8J4g5ANv3o1U2kdzssEPjiEvUtuYg@mail.gmail.com> (sfid-20140203_140229_804621_95D86000)
Subject: Re: [PATCH V6] mac80211: Update opmode during adding new station
From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 January 2014 14:35, Johannes Berg <johannes@sipsolutions.net> wrote:
> Sorry, I had somehow lost this patch before.
>
>> +     if (params->opmode_notif_used) {
>> +             enum ieee80211_band band =
>> +                             ieee80211_get_sdata_band(sdata);
>> +             ieee80211_vht_recalc_handle_opmode(sdata, sta,
>> +                                                params->opmode_notif,
>> +                                                band, 0);
>> +     }
>
> That last argument should be 'false', it seems. You're also ignoring the
> return value, which seems wrong at first look? Maybe it's right, but
> then you should probably add a comment?

Yes, you are right I will change it.
>
>> +u32 ieee80211_vht_recalc_handle_opmode(struct ieee80211_sub_if_data *sdata,
>> +                                    struct sta_info *sta, u8 opmode,
>> +                                    enum ieee80211_band band, bool nss_only);
>>  void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
>>                                struct sta_info *sta, u8 opmode,
>>                                enum ieee80211_band band, bool nss_only);
>
> It's not clear to me what those function name distinction means, maybe
> it would be better to not call this 'recalc' but just give it two
> underscores in the function name or so, since it's really the same but
> without calling the RC upate?

Yes, it was my intention, set only nss and bandwidth in station
without calling the RC update.
I will add two underscores in the function.
>
>> -     struct ieee80211_local *local = sdata->local;
>> -     struct ieee80211_supported_band *sband;
>>       enum ieee80211_sta_rx_bandwidth new_bw;
>> -     u32 changed = 0;
>>       u8 nss;
>> -
>> -     sband = local->hw.wiphy->bands[band];
>> +     u32 changed = 0;
>
> Why change the order of nss/changed? If you leave as is the diff might
> be simpler? Not that it matters, I was just wondering for a bit here
> what was really changed on the 'changed' line.

I'm sorry, it was my mistake. Of course that change wasn't needed.
>
>
>>               sta->sta.bandwidth = new_bw;
>>               changed |= IEEE80211_RC_BW_CHANGED;
>>       }
>> +     return changed;
>
> Would prefer a blank line after the }
Ok, no problem
>
>> +void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
>> +                              struct sta_info *sta, u8 opmode,
>> +                              enum ieee80211_band band, bool nss_only)
>> +{
>> +     struct ieee80211_local *local = sdata->local;
>> +     struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
>> +     u32 changed = ieee80211_vht_recalc_handle_opmode(sdata, sta, opmode,
>> +                                                      band, nss_only);
>> +     if (changed > 0)
>
> And after the variable declarations, i.e. before the if
>
> Sorry for the delay, not sure why I missed your patch!
>
> johannes
>
>

I will send a new version of the patch.

Marek Kwaczynski
