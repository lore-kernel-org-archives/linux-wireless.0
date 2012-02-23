Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53857 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2BWOxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 09:53:49 -0500
Received: by iacb35 with SMTP id b35so1636833iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 06:53:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330004364.3448.8.camel@jlt3.sipsolutions.net>
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
	<20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
	<1330004364.3448.8.camel@jlt3.sipsolutions.net>
Date: Thu, 23 Feb 2012 06:53:48 -0800
Message-ID: <CA+yqC4bcLz5xBTqOV_C4cjm4MDwEaifbJNi9dCSh7CTbjPiXBg@mail.gmail.com> (sfid-20120223_155356_327000_2A223FA1)
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
From: Sam Leffler <sleffler@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Stewart <pstew@chromium.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2012 at 5:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-02-20 at 21:25 -0800, Paul Stewart wrote:
>> When regulatory information changes our HT behavior (e.g,
>> when we get a country code from the AP we have just associated
>> with), we should use this information to change the power with
>> which we transmit, and what channels we transmit.  Sometimes
>> the channel parameters we derive from regulatory information
>> contradicts the parameters we used in association.  For example,
>> we could have associated specifying HT40, but the regulatory
>> rules we apply may forbid HT40 operation.
>>
>> In the situation above, we should reconfigure ourselves to
>> transmit in HT20 only, however it makes no sense for us to
>> disable receive in HT40, since if we associated with these
>> parameters, the AP has every reason to expect we can and
>> will receive packets this way.  The code in mac80211 does
>> not have the capability of sending the appropriate action
>> frames to signal a change in HT behaviour so the AP has
>> no clue we can no longer receive frames encoded this way.
>> In some broken AP implementations, this can leave us
>> effectively deaf if the AP never retries in lower HT rates.
>>
>> This change breaks up the channel_type parameter in the
>> ieee80211_enable_ht function into a separate receive and
>> transmit part.  It honors the channel flags set by regulatory
>> in order to configure the rate control algorithm, but uses
>> the capability flags to configure the channel on the radio,
>> since these were used in association to set the AP's transmit
>> rate.
>
> Quite the stupid APs, obviously ...

Actually the AP is operating correctly (modulo the question of whether
HT40 may be used in kr).

>
>> +/*
>> + * ieee80211_get_xmit_channel_type returns the channel type we should
>> + * use for packet transmission, given the channel capability and
>> + * whatever regulatory flags we have been given.
>> + */
>> +enum nl80211_channel_type ieee80211_get_xmit_channel_type(
>> +                             struct ieee80211_local *local,
>> +                             enum nl80211_channel_type channel_type) {
>
> code style, please put the brace on the next line
>
>> +     switch (channel_type) {
>> +     case NL80211_CHAN_HT40PLUS:
>> +             if ((local->hw.conf.channel->flags &
>> +                 IEEE80211_CHAN_NO_HT40PLUS))
>
> those extra parentheses seem useless, and maybe indent the IEEE80211_...
> another two tabs or so to make it stand out as the continuation of the
> statement rather than the if
>
> (see the recent thread about code style here on this list ...)
>
>> @@ -188,6 +188,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
>>       bool enable_ht = true;
>>       enum nl80211_channel_type prev_chantype;
>>       enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
>> +     enum nl80211_channel_type xmit_channel_type;
>
> Maybe you should rename "channel_type" to "rx_channel_type" then, or
> "config_channel_type"?
>
>>       sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
>>
>> @@ -228,19 +229,18 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
>>                   (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
>>                       switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
>>                       case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
>> -                             if (!(local->hw.conf.channel->flags &
>> -                                 IEEE80211_CHAN_NO_HT40PLUS))
>> -                                     channel_type = NL80211_CHAN_HT40PLUS;
>> +                             channel_type = NL80211_CHAN_HT40PLUS;
>>                               break;
>>                       case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
>> -                             if (!(local->hw.conf.channel->flags &
>> -                                 IEEE80211_CHAN_NO_HT40MINUS))
>> -                                     channel_type = NL80211_CHAN_HT40MINUS;
>> +                             channel_type = NL80211_CHAN_HT40MINUS;
>>                               break;
>>                       }
>>               }
>>       }
>>
>> +     xmit_channel_type =
>> +             ieee80211_get_xmit_channel_type(local, channel_type);
>> +
>>       if (local->tmp_channel)
>>               local->tmp_channel_type = channel_type;
>>
>> @@ -268,13 +268,13 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
>>       /* channel_type change automatically detected */
>>       ieee80211_hw_config(local, 0);
>>
>> -     if (prev_chantype != channel_type) {
>> +     if (prev_chantype != xmit_channel_type) {
>>               rcu_read_lock();
>>               sta = sta_info_get(sdata, bssid);
>>               if (sta)
>>                       rate_control_rate_update(local, sband, sta,
>>                                                IEEE80211_RC_HT_CHANGED,
>> -                                              channel_type);
>> +                                              xmit_channel_type);
>>               rcu_read_unlock();
>
>
> Otherwise looks fine to me.

I believe the root cause is the local sta overriding the AP based on
local regulatory. In general sta's need to honor settings from an AP.

-Sam
