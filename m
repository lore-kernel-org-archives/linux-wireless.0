Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:57444 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab3CSAMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 20:12:32 -0400
Received: by mail-wi0-f177.google.com with SMTP id hm14so3255040wib.10
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 17:12:30 -0700 (PDT)
Date: Tue, 19 Mar 2013 01:12:24 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [RFC 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
Message-ID: <20130319001224.GB25758@gobelin> (sfid-20130319_011239_416675_AC6C04D2)
References: <1363552234-6752-1-git-send-email-karl.beldan@gmail.com>
 <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363552234-6752-2-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My own input to highlight the changes in V2.

On Sun, Mar 17, 2013 at 09:30:33PM +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Drivers that don't use chanctxes cannot perform VHT association because
> they still use a "backward compatibility" pair of {ieee80211_channel,
> nl80211_channel_type} in ieee80211_conf and ieee80211_local.
> (FIXME: this only changes mac80211_hwsim for the RFC)
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |   45 +++++++++++++++++++---------
>  include/net/mac80211.h                |   15 +++++----
>  net/mac80211/cfg.c                    |    7 +---
>  net/mac80211/chan.c                   |   10 +++---
>  net/mac80211/ieee80211_i.h            |    4 +--
>  net/mac80211/main.c                   |   52 +++++++++++++++++++++------------
>  net/mac80211/mlme.c                   |    6 ++--
>  net/mac80211/scan.c                   |    6 ++--
>  net/mac80211/trace.h                  |    9 ++---
>  net/mac80211/tx.c                     |    4 +-
>  net/mac80211/util.c                   |    3 +-
>  11 files changed, 92 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 7490c4f..71cb109 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -1056,11 +1056,13 @@ out:
>  	return HRTIMER_NORESTART;
>  }
>  
> -static const char *hwsim_chantypes[] = {
> -	[NL80211_CHAN_NO_HT] = "noht",
> -	[NL80211_CHAN_HT20] = "ht20",
> -	[NL80211_CHAN_HT40MINUS] = "ht40-",
> -	[NL80211_CHAN_HT40PLUS] = "ht40+",
> +static const char *hwsim_chanwidth[] = {
> +	[NL80211_CHAN_WIDTH_20_NOHT] = "noht",
> +	[NL80211_CHAN_WIDTH_20] = "ht20",
> +	[NL80211_CHAN_WIDTH_40] = "ht40",
> +	[NL80211_CHAN_WIDTH_80] = "ht80",
> +	[NL80211_CHAN_WIDTH_80P80] = "ht80p80",
> +	[NL80211_CHAN_WIDTH_160] = "ht160",
>  };
>  
>  static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
> @@ -1074,18 +1076,31 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
>  		[IEEE80211_SMPS_DYNAMIC] = "dynamic",
>  	};
>  
> -	wiphy_debug(hw->wiphy,
> -		    "%s (freq=%d/%s idle=%d ps=%d smps=%s)\n",
> -		    __func__,
> -		    conf->channel ? conf->channel->center_freq : 0,
> -		    hwsim_chantypes[conf->channel_type],
> -		    !!(conf->flags & IEEE80211_CONF_IDLE),
> -		    !!(conf->flags & IEEE80211_CONF_PS),
> -		    smps_modes[conf->smps_mode]);
> +	if (conf->chandef.chan)
> +		wiphy_debug(hw->wiphy,
> +			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
> +			    __func__,
> +			    conf->chandef.chan->center_freq,
> +			    conf->chandef.width > NL80211_CHAN_WIDTH_20 ?
> +			    conf->chandef.center_freq1 : 0,
> +			    conf->chandef.width > NL80211_CHAN_WIDTH_40 ?
> +			    conf->chandef.center_freq2 : 0,
> +			    hwsim_chanwidth[conf->chandef.width],
> +			    !!(conf->flags & IEEE80211_CONF_IDLE),
> +			    !!(conf->flags & IEEE80211_CONF_PS),
> +			    smps_modes[conf->smps_mode]);
> +	else
> +		wiphy_debug(hw->wiphy,
> +			    "%s (freq=0/%s idle=%d ps=%d smps=%s)\n",
> +			    __func__,
> +			    hwsim_chanwidth[conf->chandef.width],
No chan, so I'll drop the channel width.

> +			    !!(conf->flags & IEEE80211_CONF_IDLE),
> +			    !!(conf->flags & IEEE80211_CONF_PS),
> +			    smps_modes[conf->smps_mode]);
>  
>  	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
>  
> -	data->channel = conf->channel;
> +	data->channel = conf->chandef.chan;
>  
>  	WARN_ON(data->channel && channels > 1);
>  
> @@ -1271,7 +1286,7 @@ static int mac80211_hwsim_get_survey(
>  		return -ENOENT;
>  
>  	/* Current channel */
> -	survey->channel = conf->channel;
> +	survey->channel = conf->chandef.chan;
>  
>  	/*
>  	 * Magically conjured noise level --- this is only ok for simulated hardware.
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 8c0ca11..2eb3de9 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1001,8 +1001,7 @@ struct ieee80211_conf {
>  
>  	u8 long_frame_max_tx_count, short_frame_max_tx_count;
>  
> -	struct ieee80211_channel *channel;
> -	enum nl80211_channel_type channel_type;
> +	struct cfg80211_chan_def chandef;
>  	bool radar_enabled;
>  	enum ieee80211_smps_mode smps_mode;
>  };
> @@ -4204,31 +4203,33 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
>  static inline bool
>  conf_is_ht20(struct ieee80211_conf *conf)
>  {
> -	return conf->channel_type == NL80211_CHAN_HT20;
> +	return conf->chandef.width == NL80211_CHAN_WIDTH_20;
>  }
>  
>  static inline bool
>  conf_is_ht40_minus(struct ieee80211_conf *conf)
>  {
> -	return conf->channel_type == NL80211_CHAN_HT40MINUS;
> +	return conf->chandef.width == NL80211_CHAN_WIDTH_40 &&
> +	       conf->chandef.center_freq1 < conf->chandef.chan->center_freq;
>  }
>  
>  static inline bool
>  conf_is_ht40_plus(struct ieee80211_conf *conf)
>  {
> -	return conf->channel_type == NL80211_CHAN_HT40PLUS;
> +	return conf->chandef.width == NL80211_CHAN_WIDTH_40 &&
> +	       conf->chandef.center_freq1 > conf->chandef.chan->center_freq;
>  }
>  
>  static inline bool
>  conf_is_ht40(struct ieee80211_conf *conf)
>  {
> -	return conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf);
> +	return conf->chandef.width == NL80211_CHAN_WIDTH_40;
>  }
>  
>  static inline bool
>  conf_is_ht(struct ieee80211_conf *conf)
>  {
> -	return conf->channel_type != NL80211_CHAN_NO_HT;
> +	return conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT;
>  }
>  
>  static inline enum nl80211_iftype
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index e5c1441..d7924b0 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -805,8 +805,7 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
>  					IEEE80211_CHANCTX_EXCLUSIVE);
>  		}
>  	} else if (local->open_count == local->monitors) {
> -		local->_oper_channel = chandef->chan;
> -		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
> +		memcpy(&local->oper_chandef, chandef, sizeof(local->oper_chandef));
>  		ieee80211_hw_config(local, 0);
>  	}
>  
> @@ -3360,9 +3359,7 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
>  		if (local->use_chanctx)
>  			*chandef = local->monitor_chandef;
>  		else
> -			cfg80211_chandef_create(chandef,
> -						local->_oper_channel,
> -						local->_oper_channel_type);
> +			memcpy(chandef, &local->oper_chandef, sizeof(chandef));
>  		ret = 0;
>  	}
>  	rcu_read_unlock();
> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index 78c0d90..8b7f47a 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -22,7 +22,9 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
>  	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
>  
>  	if (!local->use_chanctx) {
> -		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
> +		local->oper_chandef.width = chandef->width;
> +		local->oper_chandef.center_freq1 = chandef->center_freq1;
> +		local->oper_chandef.center_freq2 = chandef->center_freq2;
>  		ieee80211_hw_config(local, 0);
>  	}
>  }
> @@ -77,9 +79,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
>  	ctx->mode = mode;
>  
>  	if (!local->use_chanctx) {
> -		local->_oper_channel_type =
> -			cfg80211_get_chandef_type(chandef);
> -		local->_oper_channel = chandef->chan;
> +		memcpy(&local->oper_chandef, chandef, sizeof(local->oper_chandef));
>  		ieee80211_hw_config(local, 0);
>  	} else {
>  		err = drv_add_chanctx(local, ctx);
> @@ -106,7 +106,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
>  	WARN_ON_ONCE(ctx->refcount != 0);
>  
>  	if (!local->use_chanctx) {
> -		local->_oper_channel_type = NL80211_CHAN_NO_HT;
> +		local->oper_chandef.width = NL80211_CHAN_NO_HT;
>  		ieee80211_hw_config(local, 0);
>  	} else {
>  		drv_remove_chanctx(local, ctx);
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 95beb18..b72a1d1 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -1021,9 +1021,7 @@ struct ieee80211_local {
>  	struct delayed_work scan_work;
>  	struct ieee80211_sub_if_data __rcu *scan_sdata;
>  	struct ieee80211_channel *csa_channel;
> -	/* For backward compatibility only -- do not use */
> -	struct ieee80211_channel *_oper_channel;
> -	enum nl80211_channel_type _oper_channel_type;
> +	struct cfg80211_chan_def oper_chandef;
>  
>  	/* Temporary remain-on-channel for off-channel operations */
>  	struct ieee80211_channel *tmp_channel;
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index eee1768..25db628 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -92,47 +92,61 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
>  	ieee80211_configure_filter(local);
>  }
>  
> +static int ieee80211_chandef_cmp(const struct cfg80211_chan_def *def1,
> +				 const struct cfg80211_chan_def *def2)
> +{
> +	if (def1->chan != def2->chan || def1->width != def2->width)
> +		return 1;
> +	if (def1->width < NL80211_CHAN_WIDTH_40)
> +		return 0;
> +	if (def1->width != NL80211_CHAN_WIDTH_80P80)
> +		return def1->center_freq1 != def2->center_freq1 ||
> +		       def1->center_freq2 != def2->center_freq2;
> +	return def1->center_freq1 != def2->center_freq1;
> +}
> +
>  static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
>  {
>  	struct ieee80211_sub_if_data *sdata;
> +	struct cfg80211_chan_def chandef;
>  	struct ieee80211_channel *chan;
>  	u32 changed = 0;
>  	int power;
> -	enum nl80211_channel_type channel_type;
>  	u32 offchannel_flag;
>  
>  	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
> +
>  	if (local->scan_channel) {
> -		chan = local->scan_channel;
> +		chandef.chan = local->scan_channel;
>  		/* If scanning on oper channel, use whatever channel-type
>  		 * is currently in use.
>  		 */
> -		if (chan == local->_oper_channel)
> -			channel_type = local->_oper_channel_type;
> +		if (chandef.chan == local->oper_chandef.chan)
> +			memcpy(&chandef, &local->oper_chandef, sizeof(chandef));
>  		else
> -			channel_type = NL80211_CHAN_NO_HT;
> +			chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
>  	} else if (local->tmp_channel) {
> -		chan = local->tmp_channel;
> -		channel_type = NL80211_CHAN_NO_HT;
> +		chandef.chan = local->tmp_channel;
> +		chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
>  	} else {
> -		chan = local->_oper_channel;
> -		channel_type = local->_oper_channel_type;
> +		memcpy(&chandef, &local->oper_chandef, sizeof(chandef));
>  	}
>  
> -	if (chan != local->_oper_channel ||
> -	    channel_type != local->_oper_channel_type)
> +	if (ieee80211_chandef_cmp(&chandef, &local->oper_chandef))
>  		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
>  	else
>  		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
>  
>  	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
>  
> -	if (offchannel_flag || chan != local->hw.conf.channel ||
> -	    channel_type != local->hw.conf.channel_type) {
> -		local->hw.conf.channel = chan;
> -		local->hw.conf.channel_type = channel_type;
> +	if (offchannel_flag ||
> +	    ieee80211_chandef_cmp(&local->hw.conf.chandef,
> +				  &local->oper_chandef)) {
> +		memcpy(&local->hw.conf.chandef, &chandef,
> +		       sizeof(local->hw.conf.chandef));
>  		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
>  	}
> +	chan = chandef.chan;
>  
drop chan, it is only used once afterwards for txpower

>  	if (!conf_is_ht(&local->hw.conf)) {
>  		/*
> @@ -738,11 +752,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		sband = local->hw.wiphy->bands[band];
>  		if (!sband)
>  			continue;
> -		if (!local->use_chanctx && !local->_oper_channel) {
> +		if (!local->use_chanctx && !local->oper_chandef.chan) {
>  			/* init channel we're on */
> -			local->hw.conf.channel =
> -			local->_oper_channel = &sband->channels[0];
> -			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
> +			local->hw.conf.chandef.chan =
> +			local->oper_chandef.chan = &sband->channels[0];
> +			local->hw.conf.chandef.width = NL80211_CHAN_NO_HT;
s/NL80211_CHAN_NO_HT/NL80211_CHAN_WIDTH_20_NOHT

>  		}
>  		cfg80211_chandef_create(&local->monitor_chandef,
>  					&sband->channels[0],
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index fdc06e3..3a98660 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -994,18 +994,18 @@ static void ieee80211_chswitch_work(struct work_struct *work)
>  	if (!ifmgd->associated)
>  		goto out;
>  
> -	sdata->local->_oper_channel = sdata->local->csa_channel;
> +	sdata->local->oper_chandef.chan = sdata->local->csa_channel;
Here I'll adjust oper_chandef.center_freq{1,2} with 
csa_channel->center_freq - _oper_chandef.chan->center_freq

>  	if (!sdata->local->ops->channel_switch) {
>  		/* call "hw_config" only if doing sw channel switch */
>  		ieee80211_hw_config(sdata->local,
>  			IEEE80211_CONF_CHANGE_CHANNEL);
>  	} else {
>  		/* update the device channel directly */
> -		sdata->local->hw.conf.channel = sdata->local->_oper_channel;
> +		sdata->local->hw.conf.chandef.chan = sdata->local->oper_chandef.chan;
And here I'll assign the chandef instead of the chan
 
Karl
