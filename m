Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53254 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754567AbdIFNVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 09:21:03 -0400
Message-ID: <1504704060.13457.20.camel@sipsolutions.net> (sfid-20170906_152849_977581_96D4C526)
Subject: Re: hung task in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Matteo Croce <mcroce@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 06 Sep 2017 15:21:00 +0200
In-Reply-To: <20170906151922.4a320b1d@elisabeth>
References: <CAGnkfhwi9MmtLneeU23iWEGLj9cb1ODb3KzzOqTDvA6nNVsugg@mail.gmail.com>
         <20170906144019.1c98a636@elisabeth>
         <1504702115.13457.16.camel@sipsolutions.net>
         <20170906151922.4a320b1d@elisabeth>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-09-06 at 15:19 +0200, Stefano Brivio wrote:
> On Wed, 06 Sep 2017 14:48:35 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > I'll look in a bit - but
> > 
> > > +			mutex_unlock(&sta->ampdu_mlme.mtx);
> > >  			___ieee80211_stop_rx_ba_session(
> > >  				sta, tid, WLAN_BACK_RECIPIENT,
> > >  				WLAN_REASON_QSTA_TIMEOUT,
> > > true);  
> > 
> > This already has three underscores so shouldn't drop.
> 
> Right, of course.
> 
> > [...]
> > > +			mutex_unlock(&sta->ampdu_mlme.mtx);
> > >  			__ieee80211_start_rx_ba_session(sta, 0,
> > > 0,
> > > 0, 1, tid,  
> > 
> > maybe this one needs a ___ version then?
> 
> Either that, or as it's a single call, perhaps just the following?
> Matter of taste I guess...

I don't think it's a matter of taste - for me, in principle, dropping
locks for small sections of code where the larger section holds it is a
bug waiting to happen. It may (may, I don't even know) be OK here, but
in general it's something to avoid.

johannes
