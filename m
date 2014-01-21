Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaAUPak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 10:30:40 -0500
Message-ID: <1390318236.6199.45.camel@jlt4.sipsolutions.net> (sfid-20140121_163043_960624_470B5A2C)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, Luca Coelho <luca@coelho.fi>
Date: Tue, 21 Jan 2014 16:30:36 +0100
In-Reply-To: <1390228033-19162-3-git-send-email-michal.kazior@tieto.com> (sfid-20140120_153204_422278_760034F0)
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	 <1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140120_153204_422278_760034F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 15:27 +0100, Michal Kazior wrote:

> This implements a fairly simple multi-interface
> CSA. It doesn't support multiple channel
> contexts so it doesn't support multi-channel.

For not implementing chanctx support, I think it changes an awful lot in
the implementation there...

> A new worker is introduced: csa_complete_work
> which is used to account per-interface countdowns
> and issue the actual channel switch after last
> interface completes its CSA.

Not sure I understand this part, don't they all have the same countdown,
and should finish at the same time?
 
>  	/* abort any running channel switch */
>  	mutex_lock(&local->mtx);
> -	sdata->vif.csa_active = false;
> -	kfree(sdata->u.ap.next_beacon);
> -	sdata->u.ap.next_beacon = NULL;
> +	ieee80211_csa_clear(sdata);
> +	ieee80211_csa_free(sdata);
>  	mutex_unlock(&local->mtx);

Maybe that kind of refactoring would be better in a separate patch?
 
> +static int ieee80211_ap_beacon_presp_backup(struct ieee80211_sub_if_data *sdata)

I'm beginning to think it's time to create a new file
net/mac80211/ap.c :-)

What's the backup/restore used for anyway?

> -int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
> -				 u32 *changed)
> +const struct cfg80211_chan_def *
> +ieee80211_get_csa_chandef(struct ieee80211_local *local)
>  {
> -	struct ieee80211_local *local = sdata->local;
> -	struct ieee80211_chanctx_conf *conf;
> -	struct ieee80211_chanctx *ctx;
> -	const struct cfg80211_chan_def *chandef = &sdata->csa_chandef;
> -	int ret;
> -	u32 chanctx_changed = 0;
> +	struct ieee80211_sub_if_data *sdata;
> +	const struct cfg80211_chan_def *chandef = NULL;
>  
>  	lockdep_assert_held(&local->mtx);
> +	lockdep_assert_held(&local->chanctx_mtx);
>  
> -	/* should never be called if not performing a channel switch. */
> -	if (WARN_ON(!sdata->vif.csa_active))
> -		return -EINVAL;
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {

_rcu doesn't seem right.

But then again this whole function, iterating interfaces rather than
channel contexts etc. is terrible IMHO. This seems to pretty much turn
chanctx support upside down, making the channel context structures not
be the first-class citizens I think we want them to be.

I'd say Luca's approach has more future, as it makes channel context
support native. With this, I don't even see how you *could* later add
real channel context support. A function like this, that essentially
assumes exactly a single chanctx that might be doing CSA and similar
seems to make that rather difficult.

> +struct ieee80211_chanctx *
> +ieee80211_get_csa_chanctx(struct ieee80211_local *local)
> +{
> +	struct ieee80211_chanctx *chanctx = NULL, *ctx;
> +	int num_chanctx = 0;
> +
> +	lockdep_assert_held(&local->chanctx_mtx);
> +
> +	list_for_each_entry(ctx, &local->chanctx_list, list) {
> +		chanctx = ctx;
> +		num_chanctx++;
>  	}
>  
> -	sdata->vif.bss_conf.chandef = *chandef;
> -	ctx->conf.def = *chandef;
> +	/* multi-channel is not supported, multi-vif is */
> +	if (num_chanctx > 1)
> +		return NULL;

This is essentially the same thing, but written as a chanctx function?

> +	if (!chandef) {
> +		rcu_read_unlock();
> +		return -EINVAL;
> +	}
> +
> +	if (!cfg80211_chandef_usable(local->hw.wiphy, chandef,
> +				     IEEE80211_CHAN_DISABLED)) {
> +		rcu_read_unlock();
> +		return -EINVAL;
> +	}
> +
> +	ieee80211_use_csa_chandef(local);
> +	rcu_read_unlock();

A function that changes something but is under rcu_read_lock()? can't
this call into the driver, which is likely not allowed?


> +++ b/net/mac80211/tx.c
> @@ -2427,13 +2427,16 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
>  	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
>  		return;
>  
> -	/* Warn if the driver did not check for/react to csa
> -	 * completeness.  A beacon with CSA counter set to 0 should
> -	 * never occur, because a counter of 1 means switch just
> -	 * before the next beacon.
> -	 */
> -	if (WARN_ON(beacon_data[counter_offset_beacon] == 1))
> +	if (beacon_data[counter_offset_beacon] == 1) {
> +		/* Warn if the driver did not check for/react to csa
> +		 * completeness. A beacon with CSA counter set to 0 should
> +		 * never occur, because a counter of 1 means switch just before
> +		 * the next beacon. Multi-interface CSA may need to wait for
> +		 * other interfaces to complete their counter so don't warn
> +		 * unless driver actually didn't notify us. */

Err, that doesn't seem right either ... multi-interface CSA should all
be switching at the same time, so you *still* shouldn't be running into
this and transmitting beacons with CSA count==1. If you do, your driver
is likely not behaving as it should.


In any case, unless I'm missing some bigger picture this seems like a
really hacky way to add things, basically ignoring all the channel
context work. Since I care more about channel contexts, maybe we should
merge support for channel context CSA before we try to do the multi
thing.

johannes

