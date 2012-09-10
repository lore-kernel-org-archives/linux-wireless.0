Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2IJLXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 07:23:11 -0400
Message-ID: <1347276227.4272.17.camel@jlt4.sipsolutions.net> (sfid-20120910_132315_444084_B48A08F0)
Subject: Re: [PATCH v3 5/7] nl80211/cfg80211: add ap channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 10 Sep 2012 13:23:47 +0200
In-Reply-To: <1344426823-1795-6-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-6-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @NL80211_CMD_AP_CH_SWITCH: Perform a channel switch in the driver (for
> + *	AP/GO).
> + *	%NL80211_ATTR_WIPHY_FREQ: new channel frequency.
> + *	%NL80211_ATTR_CH_SWITCH_BLOCK_TX: block tx on the current channel.
> + *	%NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: block tx on the target channel.
> + *	%NL80211_FREQ_ATTR_CH_SWITCH_COUNT: number of TBTT's until the channel
> + *	switch event.

Needs more documentation.

> @@ -720,6 +728,8 @@ enum nl80211_commands {
>  
>  	NL80211_CMD_CH_SWITCH_NOTIFY,
>  
> +	NL80211_CMD_AP_CH_SWITCH,
> +
>  	NL80211_CMD_RADAR_DETECT,
>  
>  	NL80211_CMD_DFS_ENABLE_TX,

Ahem.

> @@ -1267,6 +1277,14 @@ enum nl80211_commands {
>   *	was used to provide the hint. For the different types of
>   *	allowed user regulatory hints see nl80211_user_reg_hint_type.
>   *
> + * @NL80211_ATTR_CH_SWITCH_COUNT: the number of TBTT's until the channel
> + *	switch event
> + * @NL80211_ATTR_CH_SWITCH_BLOCK_TX: block tx on the current channel before the
> + *	channel switch operation.
> + * @NL80211_ATTR_CH_SWITCH_POST_BLOCK_TX: block tx on the target channel after
> + *	the channel switch operation, should be set if the target channel is
> + *	DFS channel.

Need to document the types.

>   * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
> + * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.

I have a nagging feeling I keep asking this, but what's the point of
radar detection without channel switch? Or is it the other way around
that's interesting? Maybe should verify that if you have DFS you also
have chanswitch?

>  /**
> + * struct ieee80211_ap_ch_switch - holds the ap channel switch data
> + *
> + * The information provided in this structure is required for the ap channel
> + * switch operation.
> + *
> + * @timestamp: value in microseconds of the 64-bit Time Synchronization
> + *	Function (TSF) timer when the frame containing the channel switch
> + *	announcement was received. This is simply the rx.mactime parameter
> + *	the driver passed into mac80211.
> + * @block_tx: Indicates whether transmission must be blocked before the
> + *	scheduled channel switch, as indicated by the AP.
> + * @post_switch_block_tx: Indicates whether transmission must be blocked after
> + *	the scheduled channel switch, this should be set if the target channel
> + *	is DFS channel.
> + * @channel: the new channel to switch to
> + * @channel_type: the type of the new channel
> + * @count: the number of TBTT's until the channel switch event
> + */

Bogus documentation.

johannes

