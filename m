Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:50802 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755679Ab2JCNx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 09:53:58 -0400
Received: by oagh16 with SMTP id h16so7401777oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 06:53:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347276227.4272.17.camel@jlt4.sipsolutions.net>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-6-git-send-email-victorg@ti.com>
	<1347276227.4272.17.camel@jlt4.sipsolutions.net>
Date: Wed, 3 Oct 2012 15:53:56 +0200
Message-ID: <CAK80WHarUE=6tne+BD=cvMHVT7Yyq+kK2ce=cHvfuapxqyo35w@mail.gmail.com> (sfid-20121003_155459_077674_832A09F5)
Subject: Re: [PATCH v3 5/7] nl80211/cfg80211: add ap channel switch command
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 10, 2012 at 2:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> + * @NL80211_CMD_AP_CH_SWITCH: Perform a channel switch in the driver (for
>> + *   AP/GO).
>> + *   %NL80211_ATTR_WIPHY_FREQ: new channel frequency.
>> + *   %NL80211_ATTR_CH_SWITCH_BLOCK_TX: block tx on the current channel.
>> + *   %NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: block tx on the target channel.
>> + *   %NL80211_FREQ_ATTR_CH_SWITCH_COUNT: number of TBTT's until the channel
>> + *   switch event.
>
> Needs more documentation.

I'll elaborate a bit..

>
>> @@ -720,6 +728,8 @@ enum nl80211_commands {
>>
>>       NL80211_CMD_CH_SWITCH_NOTIFY,
>>
>> +     NL80211_CMD_AP_CH_SWITCH,
>> +
>>       NL80211_CMD_RADAR_DETECT,
>>
>>       NL80211_CMD_DFS_ENABLE_TX,
>
> Ahem.
>

just thought to put the channel switch stuff together.
don't might to move it down.

>> @@ -1267,6 +1277,14 @@ enum nl80211_commands {
>>   *   was used to provide the hint. For the different types of
>>   *   allowed user regulatory hints see nl80211_user_reg_hint_type.
>>   *
>> + * @NL80211_ATTR_CH_SWITCH_COUNT: the number of TBTT's until the channel
>> + *   switch event
>> + * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: block tx on the current channel before the
>> + *   channel switch operation.
>> + * @NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: block tx on the target channel after
>> + *   the channel switch operation, should be set if the target channel is
>> + *   DFS channel.
>
> Need to document the types.

np.

>
>>   * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
>> + * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.
>
> I have a nagging feeling I keep asking this, but what's the point of
> radar detection without channel switch? Or is it the other way around
> that's interesting? Maybe should verify that if you have DFS you also
> have chanswitch?

one might support a channel switch without DFS, but the one who sets
the "NL80211_FEATURE_DFS" must support channel switch.
I don't might to check both these flags, but then I think it would be
cleaner (more readable) to leave the "dfs_supported" flag.
something like:
bool dfs_supported = ((local->hw.wiphy->features & NL80211_FEATURE_DFS) &&
(local->hw.wiphy->features & NL80211_FEATURE_AP_CH_SWITCH));


>
>>  /**
>> + * struct ieee80211_ap_ch_switch - holds the ap channel switch data
>> + *
>> + * The information provided in this structure is required for the ap channel
>> + * switch operation.
>> + *
>> + * @timestamp: value in microseconds of the 64-bit Time Synchronization
>> + *   Function (TSF) timer when the frame containing the channel switch
>> + *   announcement was received. This is simply the rx.mactime parameter
>> + *   the driver passed into mac80211.
>> + * @block_tx: Indicates whether transmission must be blocked before the
>> + *   scheduled channel switch, as indicated by the AP.
>> + * @post_switch_block_tx: Indicates whether transmission must be blocked after
>> + *   the scheduled channel switch, this should be set if the target channel
>> + *   is DFS channel.
>> + * @channel: the new channel to switch to
>> + * @channel_type: the type of the new channel
>> + * @count: the number of TBTT's until the channel switch event
>> + */
>
> Bogus documentation.

can you please elaborate on this one.
note that it's almost identical to "ieee80211_channel_switch" struct,
the two new parameters here are "post_switch_block_tx" and
"channel_type".

-- 
Thanks,
Victor.
