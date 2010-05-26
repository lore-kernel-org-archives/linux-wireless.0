Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62310 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab0EZMur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 08:50:47 -0400
Subject: Re: [RFC PATCHv2] mac80211: Add support for hardware ARP query
 filtering
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274874739.3658.5.camel@jlt3.sipsolutions.net>
References: <1274873379-12944-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274874739.3658.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 15:51:12 +0300
Message-ID: <1274878272.5277.1890.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 13:52 +0200, ext Johannes Berg wrote:
> On Wed, 2010-05-26 at 14:29 +0300, Juuso Oikarinen wrote:
> 
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -858,6 +858,10 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
> >  	ieee80211_recalc_smps(local, sdata);
> >  	mutex_unlock(&local->iflist_mtx);
> >  
> > +	rtnl_lock();
> > +	ieee80211_set_arp_filter(sdata);
> > +	rtnl_unlock();
> > +
> 
> Please analyse locking in more detail and enable lockdep :)
> 
> This will cause deadlocks.

I have lockdep permanently enabled in my development kernel. It has
given me no complaints in testing with the corresponding wl1271 driver
patch.

But I will look into those locks further if I can figure out any
deadlock scenarios.

-Juuso


> johannes
> 


