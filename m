Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3CRTZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:25:18 -0400
Message-ID: <1363634710.8260.15.camel@jlt4.sipsolutions.net> (sfid-20130318_202523_235949_D892F595)
Subject: Re: [RFC 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Mon, 18 Mar 2013 20:25:10 +0100
In-Reply-To: <1363552234-6752-2-git-send-email-karl.beldan@gmail.com> (sfid-20130317_213108_773844_D27BC62E)
References: <1363552234-6752-1-git-send-email-karl.beldan@gmail.com>
	 <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130317_213108_773844_D27BC62E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-03-17 at 21:30 +0100, Karl Beldan wrote:

> +	if (conf->chandef.chan)

> +	else
> +		wiphy_debug(hw->wiphy,
> +			    "%s (freq=0/%s idle=%d ps=%d smps=%s)\n",

I don't think the else should be allowed to happen.

> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -805,8 +805,7 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
>  					IEEE80211_CHANCTX_EXCLUSIVE);
>  		}
>  	} else if (local->open_count == local->monitors) {
> -		local->_oper_channel = chandef->chan;
> -		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
> +		memcpy(&local->oper_chandef, chandef, sizeof(local->oper_chandef));

Somehow I'd prefer an assignment:

local->oper_chandef = *chandef;

I know it'll just be a memcpy() again, but ... reads nicer, imho.

> +			memcpy(chandef, &local->oper_chandef, sizeof(chandef));

ditto

> @@ -22,7 +22,9 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
>  	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
>  
>  	if (!local->use_chanctx) {
> -		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
> +		local->oper_chandef.width = chandef->width;
> +		local->oper_chandef.center_freq1 = chandef->center_freq1;
> +		local->oper_chandef.center_freq2 = chandef->center_freq2;

Why not assign all here as well? Is the channel pointer itself special?

> -	/* For backward compatibility only -- do not use */
> -	struct ieee80211_channel *_oper_channel;
> -	enum nl80211_channel_type _oper_channel_type;
> +	struct cfg80211_chan_def oper_chandef;

You shouldn't remove the comment, and I think you should also keep the
leading underscore -- this is still for backward compatibility with
non-chanctx drivers only, and mac80211 internally must use chanctxes all
the way except in SW scan and SW roc code.
 
> +static int ieee80211_chandef_cmp(const struct cfg80211_chan_def *def1,
> +				 const struct cfg80211_chan_def *def2)

indentation

However this already exists in cfg80211.h --
cfg80211_chandef_identical().

>  static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
>  {
>  	struct ieee80211_sub_if_data *sdata;
> +	struct cfg80211_chan_def chandef;

better initialize this: struct ... chandef = {};

> +	if (offchannel_flag ||
> +	    ieee80211_chandef_cmp(&local->hw.conf.chandef,
> +				  &local->oper_chandef)) {

indentation

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -994,18 +994,18 @@ static void ieee80211_chswitch_work(struct work_struct *work)
>  	if (!ifmgd->associated)
>  		goto out;
>  
> -	sdata->local->_oper_channel = sdata->local->csa_channel;
> +	sdata->local->oper_chandef.chan = sdata->local->csa_channel;
>  	if (!sdata->local->ops->channel_switch) {
>  		/* call "hw_config" only if doing sw channel switch */
>  		ieee80211_hw_config(sdata->local,
>  			IEEE80211_CONF_CHANGE_CHANNEL);
>  	} else {
>  		/* update the device channel directly */
> -		sdata->local->hw.conf.channel = sdata->local->_oper_channel;
> +		sdata->local->hw.conf.chandef.chan = sdata->local->oper_chandef.chan;
>  	}

All of this is now even more obviously wrong. If it's an HT40 channel,
it previously would try to switch to the same HT40 channel, but now it'd
result in an invalid chandef, the center_freq1 would now be wrong.

> --- a/net/mac80211/trace.h
> +++ b/net/mac80211/trace.h
> @@ -269,7 +269,6 @@ DEFINE_EVENT(local_sdata_addr_evt, drv_remove_interface,
>  		 struct ieee80211_sub_if_data *sdata),
>  	TP_ARGS(local, sdata)
>  );
> -
>  TRACE_EVENT(drv_config,

please don't remove that line :)

> @@ -287,7 +286,7 @@ TRACE_EVENT(drv_config,
>  		__field(u8, long_frame_max_tx_count)
>  		__field(u8, short_frame_max_tx_count)
>  		__field(int, center_freq)
> -		__field(int, channel_type)
> +		__field(int, channel_width)

I think you should add center_freq1/2 ... there are also macros for
chandef tracing, so you could use those.

johannes

