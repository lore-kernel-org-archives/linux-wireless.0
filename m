Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40552 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbcEaKNl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 06:13:41 -0400
Message-ID: <1464689616.3076.10.camel@sipsolutions.net> (sfid-20160531_121344_359720_9DBC1007)
Subject: Re: [PATCH v2] mac80211: mesh: flush mesh paths unconditionally
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, fred.veldini@gmail.com,
	nbd@nbd.name, stable@vger.kernel.org
Date: Tue, 31 May 2016 12:13:36 +0200
In-Reply-To: <1463332756-31423-1-git-send-email-me@bobcopeland.com> (sfid-20160515_191932_658002_65A3F8B9)
References: <1463332756-31423-1-git-send-email-me@bobcopeland.com>
	 (sfid-20160515_191932_658002_65A3F8B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-05-15 at 13:19 -0400, Bob Copeland wrote:
> Currently, the mesh paths associated with a nexthop station are
> cleaned
> up in the following code path:
> 
>     __sta_info_destroy_part1
>     synchronize_net()
>     __sta_info_destroy_part2
>      -> cleanup_single_sta
>        -> mesh_sta_cleanup
>          -> mesh_plink_deactivate
>            -> mesh_path_flush_by_nexthop
> 
> However, there are a couple of problems here:
> 
> 1) the paths aren't flushed at all if the MPM is running in userspace
>    (e.g. when using wpa_supplicant or authsae)
> 
> 2) there is no synchronize_rcu between removing the path and readers
>    accessing the nexthop, which means the following race is possible:
> 
> CPU0                            CPU1
> ~~~~                            ~~~~
>                                 sta_info_destroy_part1()
>                                 synchronize_net()
> rcu_read_lock()
> mesh_nexthop_resolve()
>   mpath = mesh_path_lookup()
>                                 [...] -> mesh_path_flush_by_nexthop()
>   sta = rcu_dereference(
>     mpath->next_hop)
>                                 kfree(sta)
>   access sta <-- CRASH
> 
> Fix both of these by unconditionally flushing paths before destroying
> the sta, and by adding a synchronize_net() after path flush to ensure
> no active readers can still dereference the sta.
> 
[...]

Applied, thanks for the fix and the detailed description!

johannes
