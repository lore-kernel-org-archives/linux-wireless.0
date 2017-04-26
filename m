Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43192 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1953677AbdDZGuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 02:50:44 -0400
Message-ID: <1493189440.2464.0.camel@sipsolutions.net> (sfid-20170426_085121_017210_356B76E8)
Subject: Re: [PATCH V3 1/9] nl80211: allow multiple active scheduled scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 26 Apr 2017 08:50:40 +0200
In-Reply-To: <1493149747.15192.0.camel@sipsolutions.net> (sfid-20170425_214921_195781_DA50B80E)
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
         <1492776308-15120-2-git-send-email-arend.vanspriel@broadcom.com>
         <1493149747.15192.0.camel@sipsolutions.net>
         (sfid-20170425_214921_195781_DA50B80E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-04-25 at 21:49 +0200, Johannes Berg wrote:
> >  		if (schedule_destroy_work) {
> > -			struct cfg80211_iface_destroy *destroy;
> > +			struct cfg80211_nlport_release *destroy;
> >  
> >  			destroy = kzalloc(sizeof(*destroy),
> > GFP_ATOMIC);
> 
> I was never really happy with this allocation and really want to get
> rid of it ...

Done :)

> > +		if (schedule_sched_stop_work) {
> > +			struct cfg80211_nlport_release *destroy;
> > +
> > +			destroy = kzalloc(sizeof(*destroy),
> > GFP_ATOMIC);
> > +			if (destroy) {
> > +				destroy->nlportid = notify-
> > >portid;
> > +				spin_lock(&rdev-
> > > sched_stop_list_lock);
> > 
> > +				list_add(&destroy->list, &rdev-
> > > sched_stop_list);
> > 
> > +				spin_unlock(&rdev-
> > > sched_stop_list_lock);
> > 
> > +				schedule_work(&rdev-
> > > sched_scan_stop_wk);
> > 
> > +			}
> > +		}
> 
> Can't we set some kind of flag in the struct
> cfg80211_sched_scan_request and iterate through them later again,
> checking which need to be destroyed?

Easy enough - I'll also do that.

johannes
