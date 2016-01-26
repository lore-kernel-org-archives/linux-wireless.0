Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41963 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbcAZUxo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 15:53:44 -0500
Message-ID: <1453841613.2759.77.camel@sipsolutions.net> (sfid-20160126_215347_730838_16AF0582)
Subject: Re: [PATCH 1/2] mac80211: Remove connected MPP table entries with
 MPath
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Henning Rogge <hrogge@gmail.com>, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Date: Tue, 26 Jan 2016 21:53:33 +0100
In-Reply-To: <20160126183628.GA30183@localhost> (sfid-20160126_193634_459896_87BDC3FE)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1453808485.2759.32.camel@sipsolutions.net>
	 <20160126183628.GA30183@localhost> (sfid-20160126_193634_459896_87BDC3FE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-26 at 13:36 -0500, Bob Copeland wrote:
> On Tue, Jan 26, 2016 at 12:41:25PM +0100, Johannes Berg wrote:
> > > +		mpp = node->mpath;
> > > +		if (ether_addr_equal(mpp->mpp, proxy)) {
> > > +			spin_lock(&tbl->hashwlock[i]);
> > > +			__mesh_path_del(tbl, node);
> > > +			spin_unlock(&tbl->hashwlock[i]);
> > 
> > It also doesn't seem like for_each_mesh_entry() can deal with
> > "node"
> > getting deleted from underneath it? It accesses it through
> > hlist_next_rcu() after the deletion, so you have a use-after-free
> > here
> > afaict.
> 
> But __mesh_path_del() doesn't free it immediately: it does:
> 
>         hlist_del_rcu(&node->list);
>         call_rcu(&node->rcu, mesh_path_node_reclaim);
> 
> ...so this should be ok if in an rcu read-side critical section,
> right?

Oh. Interesting. Yeah, I guess that should be OK then.

It's not *nice*, since that's pretty much unexpected, and you then do
need the rcu_read_lock() ... hmm.

johannes
