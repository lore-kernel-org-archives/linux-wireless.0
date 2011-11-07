Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1KGPn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 10:43:28 -0500
Subject: Re: [PATCH v2] mac80211: disassociate when direct probe timed out
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Lukasz Jagiello <jagiello.lukasz@gmail.com>
In-Reply-To: <1320680552.3993.46.camel@jlt3.sipsolutions.net> (sfid-20111107_164241_816840_392AC13F)
References: <20111107142620.GA5852@redhat.com>
	 <20111107152859.GA5990@redhat.com>  <20111107153410.GB5990@redhat.com>
	 <1320680552.3993.46.camel@jlt3.sipsolutions.net>
	 (sfid-20111107_164241_816840_392AC13F)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 16:43:22 +0100
Message-ID: <1320680602.3993.47.camel@jlt3.sipsolutions.net> (sfid-20111107_164332_126559_2F44D08E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 16:42 +0100, Johannes Berg wrote:
> On Mon, 2011-11-07 at 16:34 +0100, Stanislaw Gruszka wrote:
> 
> > +++ b/net/mac80211/mlme.c
> > @@ -2379,8 +2379,14 @@ ieee80211_probe_auth_done(struct ieee80211_work *wk,
> >  			  struct sk_buff *skb)
> >  {
> >  	struct ieee80211_local *local = wk->sdata->local;
> > +	struct ieee80211_if_managed *ifmgd = &wk->sdata->u.mgd;
> >  
> >  	if (!skb) {
> > +		mutex_lock(&ifmgd->mtx);
> > +		if (ifmgd->associated)
> > +			ieee80211_set_disassoc(wk->sdata, true, false);
> > +		mutex_unlock(&ifmgd->mtx);
> > +
> >  		cfg80211_send_auth_timeout(wk->sdata->dev, wk->filter_ta);
> >  		goto destroy;
> >  	}
> 
> This doesn't seem right -- we can authenticate with a new AP while
> connected to an old one, but if the connection to the new one fails why
> should we tear down the connection to the *old* one?

Also, we should never be able to get into a situation where the new AP
is the same as the old AP as cfg80211 won't let you authenticate with a
BSS that you're connected to (I believe).

johannes

