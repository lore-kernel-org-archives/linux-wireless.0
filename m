Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3FCO5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 10:57:05 -0400
Message-ID: <1370271421.8227.14.camel@jlt4.sipsolutions.net> (sfid-20130603_165709_487024_D4744368)
Subject: Re: [PATCH] cfg80211: fix deadlock in cfg80211_leave_mesh()
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: thomas@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Mon, 03 Jun 2013 16:57:01 +0200
In-Reply-To: <20130601131916.GA2484@localhost> (sfid-20130601_152018_273852_3FE32A57)
References: <20130601131916.GA2484@localhost>
	 (sfid-20130601_152018_273852_3FE32A57)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-06-01 at 09:19 -0400, Bob Copeland wrote:
> As of "cfg80211/mac80211: use cfg80211 wdev mutex in mac80211",
> mac80211 expects to be able to take the wdev mutex around sdata
> accesses.  This causes a recursive deadlock since
> __cfg80211_leave_mesh() already holds the wdev mutex.  Removing
> the sdata_lock() calls in ieee80211_stop_mesh() alone won't fix
> this, as the cancel_work_sync() in mesh runs the iface work,
> and various work items also want to take the wdev lock (not
> just in mesh, see e.g.  ieee80211_sta_rx_queued_mgmt().)

Ouch. My mistake, clearly.

> diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
> index 5dfb289..6344a81 100644
> --- a/net/wireless/mesh.c
> +++ b/net/wireless/mesh.c
> @@ -250,7 +250,9 @@ static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
>  	if (!wdev->mesh_id_len)
>  		return -ENOTCONN;
>  
> +	wdev_unlock(wdev);
>  	err = rdev_leave_mesh(rdev, dev);
> +	wdev_lock(wdev);

I'm not really happy much with this, like you said, and it's also
incomplete because the same can happen in an error path in mac80211 in
rdev_join_mesh().

I also don't really want to think about races with mesh_id_len,
particularly in the join.

However, I think that in mac80211 we can instead just remove the locking
and the cancel_work_sync() since the latter will happen whenever the
interface goes down, in a different code path outside of this. Just need
to make sure the work can cope with running while the interface is not
joined to a mesh, but I guess that's not going to be a big problem.

johannes

