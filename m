Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51695 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab0JDQgH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 12:36:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 09:35:59 -0700
Date: Mon, 4 Oct 2010 09:36:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH v2 2/3] mac80211: wait until completely disassociated
 before new association
Message-ID: <20101004163605.GC2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1285965233-11097-3-git-send-email-lrodriguez@atheros.com>
 <1286198080.3620.34.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286198080.3620.34.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 06:14:40AM -0700, Johannes Berg wrote:
> On Fri, 2010-10-01 at 16:33 -0400, Luis R. Rodriguez wrote:
> 
> > @@ -936,7 +936,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
> >  
> >  	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
> >  
> > -	ifmgd->associated = NULL;
> >  	memset(ifmgd->bssid, 0, ETH_ALEN);
> >  
> >  	/*
> 
> You need to read this comment and the one below it :-)

Missed that.. thanks.

> > @@ -513,6 +513,19 @@ ieee80211_associate(struct ieee80211_work *wk)
> >  {
> >  	struct ieee80211_sub_if_data *sdata = wk->sdata;
> >  	struct ieee80211_local *local = sdata->local;
> > +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> > +	bool associated;
> > +
> > +	mutex_lock(&ifmgd->mtx);
> > +	associated = !!ifmgd->associated;
> > +	mutex_unlock(&ifmgd->mtx);
> > +
> > +	if (associated) {
> > +		printk(KERN_DEBUG "%s: delaying association with %pM as "
> > +		       "we are still associated",
> > +		       sdata->name, wk->filter_ta);
> > +		goto wait;
> > +	}
> >  
> >  	wk->assoc.tries++;
> >  	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
> > @@ -534,6 +547,7 @@ ieee80211_associate(struct ieee80211_work *wk)
> >  	       sdata->name, wk->filter_ta, wk->assoc.tries);
> >  	ieee80211_send_assoc(sdata, wk);
> >  
> > +wait:
> >  	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
> >  	run_again(local, wk->timeout);
> 
> But you'll be staying off-channel for the wait period, so what does this
> really help?

I totally missed this what locks us offchannel here, I though we just re-arm
the timer, and come back offchannel at a later time. What is it that locks
us offchannel until the timer runs again?

  Luis
