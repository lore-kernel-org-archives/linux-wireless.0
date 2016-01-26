Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34975 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbcAZVW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 16:22:27 -0500
Received: by mail-qk0-f196.google.com with SMTP id s5so6291424qkd.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 13:22:27 -0800 (PST)
Date: Tue, 26 Jan 2016 16:22:21 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Henning Rogge <hrogge@gmail.com>, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH 1/2] mac80211: Remove connected MPP table entries with
 MPath
Message-ID: <20160126212221.GA5710@localhost> (sfid-20160126_222236_746998_589D6E87)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453808485.2759.32.camel@sipsolutions.net>
 <20160126183628.GA30183@localhost>
 <1453841613.2759.77.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453841613.2759.77.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2016 at 09:53:33PM +0100, Johannes Berg wrote:
> Oh. Interesting. Yeah, I guess that should be OK then.
> 
> It's not *nice*, since that's pretty much unexpected, and you then do
> need the rcu_read_lock() ... hmm.

Yeah, I puzzled over that a bit last week as well -- I rewrote it like
this in the series I haven't posted yet:

void mesh_path_flush_by_nexthop(struct sta_info *sta)
{
    [...]
	rhashtable_walk_start(&iter);
	while ((mpath = rhashtable_walk_next(&iter))) {
		if (IS_ERR(mpath) && PTR_ERR(mpath) == -EAGAIN)
			continue;
		if (IS_ERR(mpath))
			break;

		if (rcu_access_pointer(mpath->next_hop) == sta)
			__mesh_path_del(tbl, mpath);
	}
	rhashtable_walk_stop(&iter);
    [...]
}

...this still relies on the rcu read lock inside _walk_start and _walk_stop,
though.

-- 
Bob Copeland %% http://bobcopeland.com/
