Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33172 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2GEOwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 10:52:21 -0400
Date: Mon, 2 Jul 2012 14:17:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: always set in_reconfig=false on wakeup
Message-ID: <20120702181747.GA2010@tuxdriver.com> (sfid-20120705_165225_838850_C26D22D3)
References: <1341230905-8929-1-git-send-email-eliad@wizery.com>
 <1341231541.19642.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341231541.19642.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 02, 2012 at 02:19:01PM +0200, Johannes Berg wrote:
> On Mon, 2012-07-02 at 15:08 +0300, Eliad Peller wrote:
> > If the interfaces were removed just before a restart
> > work was started, open_count will be 0, and most of
> > the reconfig work will be skipped, including the
> > resetting of local->in_reconfig to false.
> > 
> > Leaving local->inconfig = true will result in
> > dropping any incoming packet.
> > 
> > Fix it by always setting local->in_reconfig = false
> > (even if there are no active interfaces).
> > 
> > Signed-off-by: Eliad Peller <eliad@wizery.com>
> > ---
> > this should go to 3.5
> 
> Also looks good, thanks
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> John, could you also pick this up?
> 
> johannes
> 
> 
> >  net/mac80211/util.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > index 242ecde..e1b7c63 100644
> > --- a/net/mac80211/util.c
> > +++ b/net/mac80211/util.c
> > @@ -1411,10 +1411,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
> >  		if (ieee80211_sdata_running(sdata))
> >  			ieee80211_enable_keys(sdata);
> >  
> > + wake_up:
> >  	local->in_reconfig = false;
> >  	barrier();
> >  
> > - wake_up:
> >  	/*
> >  	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
> >  	 * sessions can be established after a resume.

This doesn't apply to 3.5 -- the "local->in_reconfig = false" bit isn't there.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
