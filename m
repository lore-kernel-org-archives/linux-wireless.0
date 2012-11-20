Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57312 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab2KTIdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:33:10 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5673896oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 00:33:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfeUxiSPu58mYEaS-gJbT1L1-sWrH9R8mkXBVyaUaS09fw@mail.gmail.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-6-git-send-email-eliad@wizery.com>
	<CA+XVXfeUxiSPu58mYEaS-gJbT1L1-sWrH9R8mkXBVyaUaS09fw@mail.gmail.com>
Date: Tue, 20 Nov 2012 10:33:09 +0200
Message-ID: <CAB3XZEeqTS2N==W=6Ym__RioaswaCkYeP7z2-65YX7EGUBYZUQ@mail.gmail.com> (sfid-20121120_093317_057100_07B8C974)
Subject: Re: [PATCH 05/15] wlcore: implement .remain_on_channel() callback
From: Eliad Peller <eliad@wizery.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 11:13 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Mon, Nov 19, 2012 at 6:39 PM, Eliad Peller <eliad@wizery.com> wrote:
>> implement the reamin_on_channel() callback by starting
>> a dev role (already associated with the current vif)
>> on the requested channel/band.
>>
>> This channel is usually different from the channel
>> of the sta role, so pass it to wl12xx_roc() as well,
>> and notify mac80211 (async) when the fw is ready
>> on the new channel.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
> [...]
>> @@ -1608,7 +1610,7 @@ static int wl12xx_cmd_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>>         }
>>
>>         cmd->role_id = role_id;
>> -       cmd->channel = wlvif->channel;
>> +       cmd->channel = channel;
>>         switch (wlvif->band) {
>>         case IEEE80211_BAND_2GHZ:
>>                 cmd->band = WLCORE_BAND_2_4GHZ;
>
> This seems wrong... What happens if the roc is on another band from
> the one the vif is connected on?
>
> The dev role is started on the correct band, but the roc will be on
> the band of the wlvif..
>
good catch. i'll fix it.


>> +static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
>> +                                      struct ieee80211_vif *vif,
>> +                                      struct ieee80211_channel *chan,
>> +                                      enum nl80211_channel_type channel_type,
>> +                                      int duration)
>> +{
>> +       struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
>> +       struct wl1271 *wl = hw->priv;
>> +       int channel, ret = 0;
>> +
>> +       channel = ieee80211_frequency_to_channel(chan->center_freq);
>> +
>> +       wl1271_debug(DEBUG_MAC80211, "mac80211 roc %d (%d)",
>> +                    channel, wlvif->role_id);
>> +
>> +       mutex_lock(&wl->mutex);
>> +
>> +       if (unlikely(wl->state != WLCORE_STATE_ON))
>> +               goto out;
>> +
>> +       /* return EBUSY if we can't ROC right now */
>> +       if (WARN_ON(wl->roc_vif ||
>> +                   find_first_bit(wl->roc_map,
>> +                                  WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES)) {
>> +               ret = -EBUSY;
>> +               goto out;
>> +       }
>> +
>> +       /*
>> +        * make sure the vif has dev role.
>> +        * TODO: enable dev role dynamically instead of pre-allocating it.
>> +        */
>
> Not sure what you mean here. Seems pretty dynamic to me..
>
yeah... i referred to the lazy-enable of dev role, but forgot that we
already upstreamed it :)
so i'll just drop this check (as we can start dev role along with any
other role).

>> @@ -5245,6 +5368,8 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
>>         wl->hw->wiphy->max_sched_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
>>                 sizeof(struct ieee80211_header);
>>
>> +       wl->hw->wiphy->max_remain_on_channel_duration = 5000;
>
> Isn't this the default?
>
only for drivers that don't implement .remain_on_channel (i.e.
implemented by mac80211).

Eliad.
