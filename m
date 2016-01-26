Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39046 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003AbcAZLoo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 06:44:44 -0500
Message-ID: <1453808681.2759.35.camel@sipsolutions.net> (sfid-20160126_124447_582981_495C7DF5)
Subject: Re: [PATCH 2/2] mac80211: let unused MPP table entries timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>, linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Date: Tue, 26 Jan 2016 12:44:41 +0100
In-Reply-To: <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160119_090459_536071_3CC17F87)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 (sfid-20160119_090459_536071_3CC17F87)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-19 at 09:04 +0100, Henning Rogge wrote:

> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -929,12 +929,55 @@ int mesh_path_del(struct ieee80211_sub_if_data
> *sdata, const u8 *addr)
>  		if (mpath->sdata == sdata &&
>  		    ether_addr_equal(addr, mpath->dst)) {
>  			__mesh_path_del(tbl, node);
> -			goto enddel;
> +			goto enddelpath;

C labels are scoped, why rename it?

>  		}
>  	}
>  
>  	err = -ENXIO;
> -enddel:
> +enddelpath:
> +	mesh_paths_generation++;
> +	spin_unlock(&tbl->hashwlock[hash_idx]);
> +	read_unlock_bh(&pathtbl_resize_lock);
> +	return err;
> +}
> +
> +/**
> + * mpp_path_del - delete a mesh proxy path from the table
> + *
> + * @addr: addr address (ETH_ALEN length)
> + * @sdata: local subif
> + *
> + * Returns: 0 if successful
> + */
> +static int mpp_path_del(struct ieee80211_sub_if_data *sdata, const
> u8 *addr)
> +{
> +	struct mesh_table *tbl;
> +	struct mesh_path *mpath;
> +	struct mpath_node *node;
> +	struct hlist_head *bucket;
> +	int hash_idx;
> +	int err = 0;
> +
> +	/* flush relevant mpp entries first */
> +	mpp_flush_by_proxy(sdata, addr);
> +
> +	read_lock_bh(&pathtbl_resize_lock);
> +	tbl = resize_dereference_mpp_paths();
> +	hash_idx = mesh_table_hash(addr, sdata, tbl);
> +	bucket = &tbl->hash_buckets[hash_idx];
> +
> +	spin_lock(&tbl->hashwlock[hash_idx]);
> +	hlist_for_each_entry(node, bucket, list) {
> +		mpath = node->mpath;
> +		if (mpath->sdata == sdata &&
> +		    ether_addr_equal(addr, mpath->dst)) {
> +			__mesh_path_del(tbl, node);
> +			goto enddelmpp;

This has the same use-after-free, I'd say?
And another instance later in this file.


> +					spin_lock_bh(&mppath-
> >state_lock);
> +					mppath->exp_time = jiffies;

That locking seems fairly pointless? You only write to this value here,
and it's an unsigned long, so in itself it's atomic and there's no
synchronisation against anything else needed.

johannes
