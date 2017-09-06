Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51896 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754568AbdIFN1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 09:27:16 -0400
Date: Wed, 6 Sep 2017 15:27:09 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Matteo Croce <mcroce@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hung task in mac80211
Message-ID: <20170906152709.673f230d@elisabeth> (sfid-20170906_152746_934606_C0B4C5F7)
In-Reply-To: <1504704060.13457.20.camel@sipsolutions.net>
References: <CAGnkfhwi9MmtLneeU23iWEGLj9cb1ODb3KzzOqTDvA6nNVsugg@mail.gmail.com>
        <20170906144019.1c98a636@elisabeth>
        <1504702115.13457.16.camel@sipsolutions.net>
        <20170906151922.4a320b1d@elisabeth>
        <1504704060.13457.20.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 06 Sep 2017 15:21:00 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2017-09-06 at 15:19 +0200, Stefano Brivio wrote:
> > On Wed, 06 Sep 2017 14:48:35 +0200
> > Johannes Berg <johannes@sipsolutions.net> wrote:
> >   
> > > I'll look in a bit - but
> > >   
> > > > +			mutex_unlock(&sta->ampdu_mlme.mtx);
> > > >  			___ieee80211_stop_rx_ba_session(
> > > >  				sta, tid, WLAN_BACK_RECIPIENT,
> > > >  				WLAN_REASON_QSTA_TIMEOUT,
> > > > true);    
> > > 
> > > This already has three underscores so shouldn't drop.  
> > 
> > Right, of course.
> >   
> > > [...]  
> > > > +			mutex_unlock(&sta->ampdu_mlme.mtx);
> > > >  			__ieee80211_start_rx_ba_session(sta, 0,
> > > > 0,
> > > > 0, 1, tid,    
> > > 
> > > maybe this one needs a ___ version then?  
> > 
> > Either that, or as it's a single call, perhaps just the following?
> > Matter of taste I guess...  
> 
> I don't think it's a matter of taste - for me, in principle, dropping
> locks for small sections of code where the larger section holds it is a
> bug waiting to happen. It may (may, I don't even know) be OK here, but
> in general it's something to avoid.

Yes, that was based on the assumption that the initial part of
__ieee80211_start_rx_ba_session() can't really affect the AMPDU
state-machine in any way.

But sure, one small change there in the future and the assumption
doesn't hold anymore.


--
Stefano
