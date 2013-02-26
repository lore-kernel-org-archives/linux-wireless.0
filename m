Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725Ab3BZUoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 15:44:06 -0500
Message-ID: <1361911440.8440.12.camel@jlt4.sipsolutions.net> (sfid-20130226_214410_532178_751917D2)
Subject: Re: [PATCH 2/6] mac80211: sync suspend and stop interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 26 Feb 2013 21:44:00 +0100
In-Reply-To: <1361793008-2857-2-git-send-email-sgruszka@redhat.com>
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
	 <1361793008-2857-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 12:50 +0100, Stanislaw Gruszka wrote:
> Is possible that we close interface while we are suspended, that
> results in warning like below (and some others similar):
> 
> WARNING: at net/mac80211/driver-ops.h:12 ieee80211_do_stop+0x62e/0x670 [mac80211]()
> wlan0:  Failed check-sdata-in-driver check, flags: 0x4

> @@ -834,16 +835,18 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  
>  		skb_queue_purge(&sdata->skb_queue);
>  
> -		/*
> -		 * Free all remaining keys, there shouldn't be any,
> -		 * except maybe group keys in AP more or WDS?
> -		 */
> -		ieee80211_free_keys(sdata);
> -
>  		drv_remove_interface_debugfs(local, sdata);
>  
> -		if (going_down)
> -			drv_remove_interface(local, sdata);
> +		if (!local->suspended) {
> +			/*
> +			 * There shouldn't be any kays, sice we disconnected
> +			 * before suspend.
> +			 */
> +			WARN_ON(!list_empty(&sdata->key_list));

This is wrong -- you're now leaking the keys after a warning; freeing
the keys had nothing to do with suspend originally. You shouldn't change
this, in fact you should just move the comment & code I think.

More generally, does this really make much sense? There are other things
here, e.g. ieee80211_configure_filter(), ieee80211_recalc_ps(),
ieee80211_hw_config() and probably more that can be executed in this
function -- I don't think protecting these two calls is really
sufficient?

I think it'd be smarter to delay the down until resumed, or so.

johannes

