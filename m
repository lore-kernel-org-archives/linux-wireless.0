Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1BBNN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 08:13:27 -0500
Subject: Re: [PATCH v8] mac80211: Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296597556-17431-1-git-send-email-greearb@candelatech.com>
References: <1296597556-17431-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 14:13:23 +0100
Message-ID: <1296652403.5671.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Are you asleep now? Good thing I didn't even look at v7 ;-)

I'm kinda afraid of this patch. It's big, but I guess there's nothing we
can do about that.

> @@ -1147,8 +1144,14 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
>  			  struct ieee80211_bss *bss);
>  
>  /* off-channel helpers */
> -void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local);
> -void ieee80211_offchannel_stop_station(struct ieee80211_local *local);
> +/**
> + * Returns true if we are logically configured to be on
> + * the operating channel AND the hardware-conf is currently
> + * configured on the operating channel.  Compares channel-type
> + * as well.
> + */

Please don't use /** unless you add real kernel-doc (which I don't think
is necessary or even makes sense here)
 
> +/* Return true if we are logically configured to be on
> + * the operating channel AND the hardware-conf is currently
> + * configured on the operating channel.
> + */

Err, I prefer not to have this duplicated -- one or the other will be
missed when changing ... Maybe just add it here and remove from the
header since it's internal API.

>  int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>  {
>  	struct ieee80211_channel *chan, *scan_chan;
> @@ -110,21 +143,27 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>  
>  	scan_chan = local->scan_channel;
>  
> +	/* If this off-channel logic ever changes,  ieee80211_on_oper_channel
> +	 * may need to change as well.
> +	 */

Would it make sense to roll this thing into one?

Like "ieee80211_get_desired_channel(local, &chan, &chantype)"

and then this code and on_oper_channel would use that?

>  	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
>  	if (scan_chan) {
>  		chan = scan_chan;
>  		channel_type = NL80211_CHAN_NO_HT;
> -		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
> -	} else if (local->tmp_channel &&
> -		   local->oper_channel != local->tmp_channel) {
> +	} else if (local->tmp_channel) {
>  		chan = scan_chan = local->tmp_channel;
>  		channel_type = local->tmp_channel_type;
> -		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
>  	} else {
>  		chan = local->oper_channel;
>  		channel_type = local->_oper_channel_type;
> -		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
>  	}

Basically rolling up this piece of code?

> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index f246d8a..b48ce0d 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -212,6 +212,13 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
>  	if (bss)
>  		ieee80211_rx_bss_put(sdata->local, bss);
>  
> +	/* If we are scanning on-channel, pass the pkt on up the stack so that
> +	 * mlme can make use of it
> +	 */
> +	if (ieee80211_cfg_on_oper_channel(sdata->local)
> +	    && (channel == sdata->local->oper_channel))
> +		return RX_CONTINUE;

Ah, neat trick, no need to duplicate the packet :-)
But didn't you say this wasn't necessary since timers were stopped
anyway during scan? So maybe the comment shouldn't refer to scanning,
but other work?

>  	dev_kfree_skb(skb);
>  	return RX_QUEUED;
>  }
> @@ -293,15 +300,28 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>  					      bool was_hw_scan)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> +	bool ooc;

That might be nicer if it was a bit more verbose. Same with ooc2 I
think. I suppose it's understandable though, so if it really gets messy
with long lines maybe we shouldn't worry about it.

> -	if (local->scan_channel) {
> +	next_chan = local->scan_req->channels[local->scan_channel_idx];
> +
> +	if (ieee80211_cfg_on_oper_channel(local)) {
> +		/* We're currently on operating channel. */
> +		if ((next_chan == local->oper_channel) &&
> +		    (local->_oper_channel_type == NL80211_CHAN_NO_HT))
> +			/* We don't need to move off of operating channel. */
> +			local->next_scan_state = SCAN_SET_CHANNEL;
> +		else
> +			/*
> +			 * We do need to leave operating channel, as next
> +			 * scan is somewhere else.
> +			 */

Hmm, is that really "leave"? You aren't sorting (yet) so might this not
go back onto the operating channel then?

> +++ b/net/mac80211/tx.c
> @@ -257,7 +257,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
>  	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
>  		return TX_CONTINUE;
>  
> -	if (unlikely(test_bit(SCAN_OFF_CHANNEL, &tx->local->scanning)) &&
> +	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
> +	    test_bit(SDATA_STATE_OFFCHANNEL, &tx->sdata->state) &&

Shouldn't that be || ? Or only the off-channel check I think?

>  	    !ieee80211_is_probe_req(hdr->frame_control) &&
>  	    !ieee80211_is_nullfunc(hdr->frame_control))
>  		/*
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 36305e0..3c8ece9 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -924,18 +924,39 @@ static void ieee80211_work_work(struct work_struct *work)
>  		}
>  
>  		if (!started && !local->tmp_channel) {
> -			/*
> -			 * TODO: could optimize this by leaving the
> -			 *	 station vifs in awake mode if they
> -			 *	 happen to be on the same channel as
> -			 *	 the requested channel
> -			 */
> -			ieee80211_offchannel_stop_beaconing(local);
> -			ieee80211_offchannel_stop_station(local);
> +			bool ooc = ieee80211_cfg_on_oper_channel(local);
> +			bool tmp_chan_changed = false;
> +			bool ooc2;
> +			if (local->tmp_channel)
> +				if ((local->tmp_channel != wk->chan) ||
> +				    (local->tmp_channel_type != wk->chan_type))
> +					tmp_chan_changed = true;
>  
>  			local->tmp_channel = wk->chan;
>  			local->tmp_channel_type = wk->chan_type;
> -			ieee80211_hw_config(local, 0);
> +			/*
> +			 * Leave the station vifs in awake mode if they
> +			 * happen to be on the same channel as
> +			 * the requested channel.
> +			 */
> +			ooc2 = ieee80211_cfg_on_oper_channel(local);
> +			if (ooc != ooc2) {
> +				if (ooc2) {
> +					/* went off operating channel */
> +					ieee80211_offchannel_stop_vifs(local);

"went" is a little misleading, I think it needs to be "will go"? It
shouldn't be "went" since we need to stop first and then switch
channels.

johannes

