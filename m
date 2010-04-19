Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0DSF5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 01:57:37 -0400
Subject: Re: [RFC PATCH] mac80211: Prevent running sta_cleanup timer
 unnecessarily
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1271652964.6205.4211.camel@wimaxnb.nmp.nokia.com>
References: <1271403308-23416-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271403308-23416-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1271449060.4184.1.camel@jlt3.sipsolutions.net>
	 <1271652964.6205.4211.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 07:57:24 +0200
Message-ID: <1271656644.3873.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-19 at 07:56 +0300, Juuso Oikarinen wrote:

> > > --- a/net/mac80211/tx.c
> > > +++ b/net/mac80211/tx.c
> > > @@ -429,6 +429,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
> > >  	struct sta_info *sta = tx->sta;
> > >  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
> > >  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
> > > +	struct ieee80211_local *local = tx->local;
> > >  	u32 staflags;
> > >  
> > >  	if (unlikely(!sta ||
> > > @@ -476,6 +477,12 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
> > >  		info->control.vif = &tx->sdata->vif;
> > >  		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
> > >  		skb_queue_tail(&sta->ps_tx_buf, tx->skb);
> > > +
> > > +		if (!timer_pending(&local->sta_cleanup))
> > > +			mod_timer(&local->sta_cleanup,
> > > +				  round_jiffies(jiffies +
> > > +						STA_INFO_CLEANUP_INTERVAL));
> > > +
> > 
> > Why bother to check !timer_pending?
> > 
> 
> Otherwise, if we have some periodic TX going on with an interval less
> than STA_INFO_CLEANUP_INTERVAL, the sta_cleanup could be delayed
> considerably.

Ok, makes sense, I didn't check the context there.

johannes

