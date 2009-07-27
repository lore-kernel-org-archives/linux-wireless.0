Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2959 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZG0Pes (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:34:48 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248683249.19945.29.camel@johannes.local>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 11:34:46 -0400
Message-Id: <1248708886.2688.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 10:27 +0200, Johannes Berg wrote:
> Thanks Pavel,
> 
> > >  		while (!skb_queue_empty(&local->pending[i])) {
> > >  			struct sk_buff *skb = __skb_dequeue(&local->pending[i]);
> > > +			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> > > +			struct ieee80211_sub_if_data *sdata;
> > > +
> > > +			sdata = vif_to_sdata(info->control.vif);
> > > +			dev_hold(sdata->dev);
> > 
> > I'm getting a panic at this point if I run hostapd on ath9k and a
> > Windows client tries to authenticate with a wrong WPA key.
> > 
> > Debugging shows that sdata->dev is NULL.
> 
> I suspect 'sdata' is already pointing to something bogus, since it's the
> result of a container_of().
> 
> Can you try with the sanity checking patch I'm about to send?

If you mean "verify info->control.vif is not NULL", it makes no
difference for me.  No BUG is triggered.  info->control.vif is never
NULL in ieee80211_tx_pending(), but sdata->dev is NULL the second time
ieee80211_tx_pending() is called.  Just skipping that case doesn't help,
I still get a panic in that function after about 10 calls.

-- 
Regards,
Pavel Roskin
