Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39013 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958AbcAZLl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 06:41:28 -0500
Message-ID: <1453808485.2759.32.camel@sipsolutions.net> (sfid-20160126_124131_646854_7E24AE63)
Subject: Re: [PATCH 1/2] mac80211: Remove connected MPP table entries with
 MPath
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>, linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Date: Tue, 26 Jan 2016 12:41:25 +0100
In-Reply-To: <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20160119_090458_613391_4030F52E)
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1453190672-9748-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 (sfid-20160119_090458_613391_4030F52E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-19 at 09:04 +0100, Henning Rogge wrote:
> 
> +static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
> +			       const u8 *proxy)
> +{
> +	struct mesh_table *tbl;
> +	struct mesh_path *mpp;
> +	struct mpath_node *node;
> +	int i;
> +
> +	rcu_read_lock();
> +	read_lock_bh(&pathtbl_resize_lock);
> +	tbl = resize_dereference_mpp_paths();
> +	for_each_mesh_entry(tbl, node, i) {

It does not seem to me that the rcu_read_lock() above is necessary or
correct, though it's probably not hurting it should be removed to avoid
having misleading code.

> +		mpp = node->mpath;
> +		if (ether_addr_equal(mpp->mpp, proxy)) {
> +			spin_lock(&tbl->hashwlock[i]);
> +			__mesh_path_del(tbl, node);
> +			spin_unlock(&tbl->hashwlock[i]);

It also doesn't seem like for_each_mesh_entry() can deal with "node"
getting deleted from underneath it? It accesses it through
hlist_next_rcu() after the deletion, so you have a use-after-free here
afaict.

johannes

