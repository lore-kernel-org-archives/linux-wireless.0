Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34081 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbcAZSge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 13:36:34 -0500
Received: by mail-qk0-f193.google.com with SMTP id u128so6162122qkh.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 10:36:33 -0800 (PST)
Date: Tue, 26 Jan 2016 13:36:28 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Henning Rogge <hrogge@gmail.com>, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH 1/2] mac80211: Remove connected MPP table entries with
 MPath
Message-ID: <20160126183628.GA30183@localhost> (sfid-20160126_193637_803971_F90EF398)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453808485.2759.32.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453808485.2759.32.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2016 at 12:41:25PM +0100, Johannes Berg wrote:
> > +		mpp = node->mpath;
> > +		if (ether_addr_equal(mpp->mpp, proxy)) {
> > +			spin_lock(&tbl->hashwlock[i]);
> > +			__mesh_path_del(tbl, node);
> > +			spin_unlock(&tbl->hashwlock[i]);
> 
> It also doesn't seem like for_each_mesh_entry() can deal with "node"
> getting deleted from underneath it? It accesses it through
> hlist_next_rcu() after the deletion, so you have a use-after-free here
> afaict.

But __mesh_path_del() doesn't free it immediately: it does:

        hlist_del_rcu(&node->list);
        call_rcu(&node->rcu, mesh_path_node_reclaim);

...so this should be ok if in an rcu read-side critical section, right?

-- 
Bob Copeland %% http://bobcopeland.com/
