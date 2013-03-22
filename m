Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab3CVKzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 06:55:50 -0400
Message-ID: <1363949737.8238.22.camel@jlt4.sipsolutions.net> (sfid-20130322_115554_435743_9926FC6D)
Subject: Re: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Fri, 22 Mar 2013 11:55:37 +0100
In-Reply-To: <1363652600-23223-2-git-send-email-karl.beldan@gmail.com> (sfid-20130319_012354_327811_9F02E91B)
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
	 <1363652600-23223-2-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130319_012354_327811_9F02E91B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 01:23 +0100, Karl Beldan wrote:

> @@ -106,7 +104,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
>  	WARN_ON_ONCE(ctx->refcount != 0);
>  
>  	if (!local->use_chanctx) {
> -		local->_oper_channel_type = NL80211_CHAN_NO_HT;
> +		local->_oper_chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
>  		ieee80211_hw_config(local, 0);

You also have to reset center_freq1/2 here to make it a valid chandef in
all cases, otherwise you can end up with e.g. "2412 noht20 2422 0" which
makes no sense.

I think it'd be worth sticking a

WARN_ON(!cfg80211_chandef_valid(...))

into ieee80211_hw_conf_chan().

> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -92,45 +92,54 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
>  	ieee80211_configure_filter(local);
>  }
>  
> +static int ieee80211_chandef_cmp(const struct cfg80211_chan_def *def1,
> +				 const struct cfg80211_chan_def *def2)

Shouldn't be needed?

> -			local->hw.conf.channel =
> -			local->_oper_channel = &sband->channels[0];
> -			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
> +			local->hw.conf.chandef.chan =
> +			local->_oper_chandef.chan = &sband->channels[0];
> +			local->hw.conf.chandef.width = NL80211_CHAN_NO_HT;

wrong constant

> +++ b/net/mac80211/mlme.c
> @@ -985,7 +985,9 @@ static void ieee80211_chswitch_work(struct work_struct *work)
>  {
>  	struct ieee80211_sub_if_data *sdata =
>  		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
> +	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +	int cfreq_off;
>  
>  	if (!ieee80211_sdata_running(sdata))
>  		return;
> @@ -994,21 +996,25 @@ static void ieee80211_chswitch_work(struct work_struct *work)
>  	if (!ifmgd->associated)
>  		goto out;
>  
> -	sdata->local->_oper_channel = sdata->local->csa_channel;
> -	if (!sdata->local->ops->channel_switch) {
> +	cfreq_off = local->csa_channel->center_freq -
> +		local->_oper_chandef.chan->center_freq;
> +
> +	local->_oper_chandef.center_freq1 += cfreq_off;
> +	local->_oper_chandef.center_freq2 += cfreq_off;

Adjusting the center_freq1 is quite clearly wrong. :-)

Besides, it might not even be supported by the driver.

Since we really don't handle anything but 20 MHz channel switches
correctly, maybe we should just disconnect in that case, like we do in
the chanctx case today. I'd prefer that as a separate patch (coming
before this one) though.

Of course, patches to make it handle it correctly would also be welcome
-- I started playing with it here:

http://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/commit/?h=wip&id=cb0308430993e96c79b3449cf0b3c744ef62b50e

(and the parent commit)

> +++ b/net/mac80211/trace.h
> @@ -269,7 +269,6 @@ DEFINE_EVENT(local_sdata_addr_evt, drv_remove_interface,
>  		 struct ieee80211_sub_if_data *sdata),
>  	TP_ARGS(local, sdata)
>  );
> -
>  TRACE_EVENT(drv_config,

please keep that :-)

>  	TP_PROTO(struct ieee80211_local *local,
>  		 u32 changed),
> @@ -286,8 +285,10 @@ TRACE_EVENT(drv_config,
>  		__field(u16, listen_interval)
>  		__field(u8, long_frame_max_tx_count)
>  		__field(u8, short_frame_max_tx_count)
> -		__field(int, center_freq)
> -		__field(int, channel_type)
> +		__field(int, control_freq)
> +		__field(int, center_freq1)
> +		__field(int, center_freq2)
> +		__field(int, chan_width)

There should be ready macros for chandef tracing -- can you use them?

> +		LOCAL_PR_FMT " ch:%#x" CHANDEF_PR_FMT,
> +		LOCAL_PR_ARG, __entry->changed, CHANDEF_PR_ARG

Hm so you used some? Why not all?

johannes

