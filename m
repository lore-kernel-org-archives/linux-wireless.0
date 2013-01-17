Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3AQFeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 00:34:37 -0500
Date: Wed, 16 Jan 2013 23:34:34 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] mac80211: Add flushes to ensure off-channel PS is
 enabled during sw scans
Message-ID: <20130117053434.GC31449@thinkpad-t410> (sfid-20130117_063440_248007_3DED9D52)
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
 <1357668645-5101-2-git-send-email-seth.forshee@canonical.com>
 <1358379254.15012.70.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358379254.15012.70.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 17, 2013 at 12:34:14AM +0100, Johannes Berg wrote:
> On Tue, 2013-01-08 at 12:10 -0600, Seth Forshee wrote:
> 
> > +++ b/net/mac80211/offchannel.c
> > @@ -136,8 +136,23 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
> >  			netif_tx_stop_all_queues(sdata->dev);
> >  			if (offchannel_ps_enable &&
> >  			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
> > -			    sdata->u.mgd.associated)
> > +			    sdata->u.mgd.associated) {
> > +				/*
> > +				 * Need to flush frames in driver queues
> > +				 * before sending nullfunc. Otherwise
> > +				 * devices which support QoS may send the
> > +				 * nullfunc before these queued frames, and
> > +				 * those frames may not have PM set.
> > +				 *
> > +				 * XXX: Would be nice to not flush for each
> > +				 * vif, however I don't see that there's any
> > +				 * protection to prevent frames being handed
> > +				 * to the driver before stopping the netdev
> > +				 * queue.
> > +				 */
> > +				drv_flush(local, false);
> >  				ieee80211_offchannel_ps_enable(sdata);
> 
> Could we split the loop, and send the frames in a second loop, to
> combine the flushes into a single one?

I started thinking about just that earlier today. Seems like it ought to
be possible.

Seth
