Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:46410 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab2BBQH2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 11:07:28 -0500
Received: by werm10 with SMTP id m10so1977485wer.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 08:07:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F27814A.9060906@sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-7-git-send-email-victorg@ti.com>
	<4F27814A.9060906@sipsolutions.net>
Date: Thu, 2 Feb 2012 18:07:25 +0200
Message-ID: <CAK80WHZw9PRr_wjazJiPUo1vrCpjgyrSx9ydHwLGoJEp3qNwDA@mail.gmail.com> (sfid-20120202_170731_577878_7DC20538)
Subject: Re: [RFC 6/9] mac80211: add ap channel switch command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 7:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
>>
>> New ieee80211_ap_process_chanswitch(), to handle a channel switch
>> request for AP/GO.
>>
>> New 'post_switch_block_tx' parameter in 'ieee80211_channel_switch'
>> structure, which indicates whether transmission must be blocked after
>> the scheduled channel switch, it should be set if the target channel
>> is DFS channel.
>>
>> New ieee80211_ap_ch_switch_complete_notify() which notifies upper
>> layers about channel switch complete event.
>
>
> Shouldn't mac80211 have some non-offload implementation for this?
>
>

What do you mean by "non-offload"?

>> @@ -841,12 +841,16 @@ struct ieee80211_conf {
>>   *    the driver passed into mac80211.
>>   * @block_tx: Indicates whether transmission must be blocked before the
>>   *    scheduled channel switch, as indicated by the AP.
>> + * @post_switch_block_tx: Indicates whether transmission must be blocked
>> after
>> + *     the scheduled channel switch, this should be set if the target
>> channel
>> + *     is DFS channel.
>
>
> Hmmm. This channel switch stuff here was really intended for client-side
> channel switching initially ... and it should quite possibly be a different
> mechanism?
>

The mechanism is different from the client-side channel switch, but
the "ieee80211_channel_switch" struct is almost the same (new
post_switch_block_tx). Do you prefer to create a new
"ieee80211_ap_channel_switch" struct + new driver callback ? something
like drv_ap_channel_switch ?

>> +static int ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
>> +                                          struct net_device *dev,
>> +                                          u32 count, bool block_tx,
>> +                                          bool post_switch_block_tx,
>> +                                          u32 new_freq)
>> +{
>> +       struct ieee80211_sub_if_data *sdata =
>> IEEE80211_DEV_TO_SUB_IF(dev);
>> +       struct ieee80211_local *local = sdata->local;
>> +       struct ieee80211_channel *new_ch;
>> +       struct ieee80211_channel_switch ch_switch;
>> +
>> +       new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
>> +       if (!new_ch || new_ch->flags&  IEEE80211_CHAN_DISABLED) {
>>
>> +               wiphy_debug(local->hw.wiphy,
>> +                           "failed channel switch on freq: %d\n",
>> new_freq);
>> +               return -EINVAL;
>> +       }
>
>
> That code should obviously be in cfg80211.
>

Why ? and where exactly ?

>
>> @@ -2793,4 +2826,5 @@ struct cfg80211_ops mac80211_config_ops = {
>>        .set_noack_map = ieee80211_set_noack_map,
>>        .dfs_start_radar_detection = ieee80211_dfs_start_radar_detection,
>>        .dfs_en_tx = ieee80211_dfs_en_tx,
>> +       .ap_channel_switch = ieee80211_ap_process_chanswitch,
>
>
> why deviate from the ieee80211_ + callback_name scheme?
>

Wanted to be aligned with ieee80211_sta_process_chanswitch(), will rename it.


-- 
Thanks,
Victor.
