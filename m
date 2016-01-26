Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42122 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbcAZVbe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 16:31:34 -0500
Message-ID: <1453843889.2759.78.camel@sipsolutions.net> (sfid-20160126_223138_180246_395DC461)
Subject: Re: [PATCH 1/2] mac80211: Remove connected MPP table entries with
 MPath
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Henning Rogge <hrogge@gmail.com>, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Date: Tue, 26 Jan 2016 22:31:29 +0100
In-Reply-To: <20160126212221.GA5710@localhost> (sfid-20160126_222227_889414_A397F9B9)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1453808485.2759.32.camel@sipsolutions.net>
	 <20160126183628.GA30183@localhost>
	 <1453841613.2759.77.camel@sipsolutions.net>
	 <20160126212221.GA5710@localhost> (sfid-20160126_222227_889414_A397F9B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-26 at 16:22 -0500, Bob Copeland wrote:
> 
> void mesh_path_flush_by_nexthop(struct sta_info *sta)
> {
>     [...]
> 	rhashtable_walk_start(&iter);

It seems you need to check the return value here?

> 	while ((mpath = rhashtable_walk_next(&iter))) {
> 		if (IS_ERR(mpath) && PTR_ERR(mpath) == -EAGAIN)
> 			continue;
> 		if (IS_ERR(mpath))
> 			break;
> 
> 		if (rcu_access_pointer(mpath->next_hop) == sta)
> 			__mesh_path_del(tbl, mpath);
> 	}
> 	rhashtable_walk_stop(&iter);
>     [...]
> }
> 
> ...this still relies on the rcu read lock inside _walk_start and
> _walk_stop, though.

At least that's kinda hidden in walk_start/stop though ;-)

johannes
