Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3FKMHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:07:24 -0400
Message-ID: <1370952437.8356.26.camel@jlt4.sipsolutions.net> (sfid-20130611_140727_416579_3997AD53)
Subject: Re: [PATCHv4 1/4] mac80211: make mgmt_tx accept a NULL channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Tue, 11 Jun 2013 14:07:17 +0200
In-Reply-To: <20130611115722.GD1466@ritirata.org>
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
	 <1370951718.8356.22.camel@jlt4.sipsolutions.net>
	 <1370951887.8356.23.camel@jlt4.sipsolutions.net>
	 <20130611115722.GD1466@ritirata.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-11 at 13:57 +0200, Antonio Quartulli wrote:
> On Tue, Jun 11, 2013 at 01:58:07PM +0200, Johannes Berg wrote:
> > On Tue, 2013-06-11 at 13:55 +0200, Johannes Berg wrote:
> > > On Wed, 2013-06-05 at 17:09 +0200, Antonio Quartulli wrote:
> > > 
> > > > +	if (need_offchan && !chan)
> > > > +		return -EINVAL;
> > > 
> > > > @@ -2847,10 +2853,14 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
> > > >  		rcu_read_lock();
> > > >  		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> > > >  
> > > > -		if (chanctx_conf)
> > > > -			need_offchan = chan != chanctx_conf->def.chan;
> > > > -		else
> > > > +		if (chanctx_conf) {
> > > > +			need_offchan = chan && (chan != chanctx_conf->def.chan);
> > > > +		} else if (!chan) {
> > > > +			ret = -EINVAL;
> > > > +			goto out_unlock;
> > > > +		} else {
> > > >  			need_offchan = true;
> > > > +		}
> > > >  		rcu_read_unlock();
> > > 
> > > It seems this would be clearer?
> > > http://p.sipsolutions.net/b8a03c85f0e8b89f.txt
> > 
> > Actually, no, I like your version better.
> 
> uhm, having one else less looks better..why did you change your mind?
> Maybe you version is not entirely equivalent?

It's not, but that wouldn't matter, it's different I think only if you
have input from cfg80211 as "!chan && offchan".

It just seems to me that your version is clearer, first you check if you
need offchan, and if you do but don't have a channel you abort. Then you
check if you might need offchan for another reason, etc.

johannes

