Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1H3DTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 23:19:40 -0400
Subject: Re: [PATCH v3 2/7] mac80211: Remove mesh paths when an interface
 is removed
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1314649389-7115-3-git-send-email-javier@cozybit.com> (sfid-20110829_222353_670430_99789D22)
References: <1314649389-7115-1-git-send-email-javier@cozybit.com>
	 <1314649389-7115-3-git-send-email-javier@cozybit.com>
	 (sfid-20110829_222353_670430_99789D22)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 05:19:33 +0200
Message-ID: <1314674373.4011.0.camel@jlt3.sipsolutions.net> (sfid-20110830_051943_508795_3FC735FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 13:23 -0700, Javier Cardona wrote:

> +static void mpp_path_flush(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct mesh_table *tbl;
> +	struct mesh_path *mpath;
> +	struct mpath_node *node;
> +	struct hlist_node *p;
> +	int i;
> +
> +	read_lock_bh(&pathtbl_resize_lock);
> +	tbl = rcu_dereference_protected(mpp_paths,
> +					lockdep_is_held(pathtbl_resize_lock));
> +	for_each_mesh_entry(tbl, p, node, i) {
> +		mpath = node->mpath;
> +		if (mpath->sdata != sdata)
> +			continue;
> +		spin_lock_bh(&tbl->hashwlock[i]);
> +		spin_lock_bh(&mpath->state_lock);
> +		call_rcu(&node->rcu, mesh_path_node_reclaim);

Why is read_lock sufficient? Why is this even a r/w lock?

johannes

