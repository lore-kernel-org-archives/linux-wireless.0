Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1H2Ntw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 09:49:52 -0400
Subject: Re: [PATCH v2 7/8] mac80211: Don't take the mesh path resize lock
 when deleting an mpath
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1314404294-4233-8-git-send-email-javier@cozybit.com> (sfid-20110827_021915_070022_ADF6088F)
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
	 <1314404294-4233-1-git-send-email-javier@cozybit.com>
	 <1314404294-4233-8-git-send-email-javier@cozybit.com>
	 (sfid-20110827_021915_070022_ADF6088F)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Aug 2011 15:49:48 +0200
Message-ID: <1314625788.8959.10.camel@jlt3.sipsolutions.net> (sfid-20110829_154957_497858_05186B12)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-08-26 at 17:18 -0700, Javier Cardona wrote:
> The mesh path resize lock is only needed to protect addition or removal
> of buckets on the hash table, not nodes on those buckets.
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  net/mac80211/mesh_pathtbl.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 3c03be9..216bd2f 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -905,8 +905,8 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
>  	int hash_idx;
>  	int err = 0;
>  
> -	read_lock_bh(&pathtbl_resize_lock);
> -	tbl = resize_dereference_mesh_paths();
> +	rcu_read_lock();
> +	tbl = rcu_dereference(mesh_paths);
>  	hash_idx = mesh_table_hash(addr, sdata, tbl);
>  	bucket = &tbl->hash_buckets[hash_idx];

Doesn't that pose a similar question to the one I just had on the other
patch?

johannes

