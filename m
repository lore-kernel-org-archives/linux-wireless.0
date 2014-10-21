Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57207 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553AbaJUNR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 09:17:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21574.23847.838683.198020@gargle.gargle.HOWL> (sfid-20141021_151733_827129_44A9FAC6)
Date: Tue, 21 Oct 2014 18:48:31 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
In-Reply-To: <1413873729.1998.2.camel@jlt4.sipsolutions.net>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
	<CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com>
	<21568.29077.518022.812356@gargle.gargle.HOWL>
	<1413797588.10246.3.camel@jlt4.sipsolutions.net>
	<21572.55536.308167.684155@gargle.gargle.HOWL>
	<1413798712.10246.14.camel@jlt4.sipsolutions.net>
	<21572.58249.490532.207564@gargle.gargle.HOWL>
	<1413801423.10246.16.camel@jlt4.sipsolutions.net>
	<21572.60015.349942.74265@gargle.gargle.HOWL>
	<1413806542.10246.21.camel@jlt4.sipsolutions.net>
	<1413809136.24269.0.camel@jlt4.sipsolutions.net>
	<21573.55666.43231.68176@gargle.gargle.HOWL>
	<1413873729.1998.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Yeah you're right.
> 
> However, when the interface is deleted, the driver must still also
> remove the scan and definitely schedule the work, so most drivers will
> really always do so in cancel_hw_scan()? We could change the API and
> require that to be synchronous, like in the interface removal case, but
> maybe we don't want to.
> 
> How about this then?
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index e469b3390f2a..6f1b90eb568c 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -766,10 +766,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  	int i, flushed;
>  	struct ps_data *ps;
>  	struct cfg80211_chan_def chandef;
> +	bool cancel_scan;
>  
>  	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
>  
> -	if (rcu_access_pointer(local->scan_sdata) == sdata)
> +	cancel_scan = rcu_access_pointer(local->scan_sdata) == sdata;
> +	if (cancel_scan)
>  		ieee80211_scan_cancel(local);
>  
>  	/*
> @@ -993,6 +995,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  
>  	ieee80211_recalc_ps(local, -1);
>  
> +	if (cancel_scan)
> +		flush_delayed_work(&local->scan_work);
> +
>  	if (local->open_count == 0) {
>  		ieee80211_stop_device(local);

Yep, this fixes the issue. Thanks !

Sujith
