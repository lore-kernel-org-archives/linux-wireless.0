Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:53522 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1FVH0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 03:26:47 -0400
Date: Wed, 22 Jun 2011 12:47:46 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <20110622071743.GA4087@hertz.marvell.com> (sfid-20110622_092652_155529_DDF63036)
References: <1308331485.7329.2.camel@Nokia-N900-51-1>
 <20110620143051.GA31035@hertz.marvell.com>
 <1308583799.4322.9.camel@jlt3.sipsolutions.net>
 <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
 <20110621130305.GB32464@hertz.marvell.com>
 <1308663814.4276.3.camel@jlt3.sipsolutions.net>
 <20110621141017.GC32464@hertz.marvell.com>
 <1308667215.4276.7.camel@jlt3.sipsolutions.net>
 <20110621163351.GD32464@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110621163351.GD32464@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > @@ -498,8 +541,12 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
> > >  
> > >  	mutex_lock(&sdata->local->key_mtx);
> > >  
> > > -	list_for_each_entry(key, &sdata->key_list, list)
> > > +	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
> > > +
> > 
> > That doesn't seem right either -- only if you have a single sdata that
> > will work, I think?
> Right. For multiple sdata count will be over written to 0.
> 
> I think, following should fix this
> 
> Thanks
> Yogesh
> 
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index edf9f40..0bf450d 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -541,8 +541,6 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
>  
>  	mutex_lock(&sdata->local->key_mtx);
>  
> -	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
> -
>  	list_for_each_entry(key, &sdata->key_list, list) {
>  		increment_tailroom_need_count(sdata->local);
>  		ieee80211_key_enable_hw_accel(key);
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 05e3fb8..bef3bdd 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1271,6 +1271,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  		mutex_unlock(&local->sta_mtx);
>  	}
>  
> +	/* Reset tailroom skip count */
> +	local->crypto_tx_tailroom_needed_cnt = 0;
> +
>  	/* add back keys */
>  	list_for_each_entry(sdata, &local->interfaces, list)
>  		if (ieee80211_sdata_running(sdata))
> 
> 
Above logic will not work if one the sdatas fails to enable keys may be
because of sdata not running.

Will work on some other logic.

Thanks
Yogesh
