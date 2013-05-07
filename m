Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33676 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab3EGOJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 10:09:50 -0400
Received: by mail-ie0-f172.google.com with SMTP id 16so1018733iea.31
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 07:09:50 -0700 (PDT)
Date: Tue, 7 May 2013 10:08:35 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: Re: [RFC 01/12] mac80211: track and share mesh BSSes among
 interfaces
Message-ID: <20130507140835.GD1438@localhost> (sfid-20130507_161020_368947_519B436B)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
 <1367548442-8229-2-git-send-email-thomas@cozybit.com>
 <1367933862.8328.18.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1367933862.8328.18.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 07, 2013 at 03:37:42PM +0200, Johannes Berg wrote:
> Ok this is big ... Let me tackle it patch by patch I guess :-)
> 
> > +struct mesh_local_bss {
> 
> > +	bool can_share;
> 
> Does that even make sense? I mean, wouldn't you simply not link/create
> such an entry if the given vif can't share?

We could do that, but as written mpath table now wants an mbss pointer
in either case.  Seemed more straight-forward to just always require
it even though the structures are kind of pointless for unshared vifs.

> > @@ -818,6 +986,10 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
> >  	local->fif_other_bss--;
> >  	atomic_dec(&local->iff_allmultis);
> >  	ieee80211_configure_filter(local);
> > +
> > +	netif_tx_stop_all_queues(sdata->dev);
> 
> how is that related to this patch?

Intent was to be sure pending queue doesn't run while we're taking
out this interface (since another interface may be queueing frames
here), but that can't actually happen until a later patch.  So
maybe it should be split out or moved later.

The stop path should be revisited anyway, there's some duplication
in what ieee80211_do_stop() does and this, which is really about when
stop_mesh() gets called and when mbss gets freed.

-- 
Bob Copeland %% www.bobcopeland.com
