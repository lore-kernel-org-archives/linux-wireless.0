Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:14196 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbYBZAUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 19:20:42 -0500
Received: by wr-out-0506.google.com with SMTP id c48so2829445wra.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 16:20:41 -0800 (PST)
Subject: Re: [PATCH 06/10] mac80211: RCU-ify STA info structure access
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080225153007.340533000@sipsolutions.net>
References: <20080225152740.360393000@sipsolutions.net>
	 <20080225153007.340533000@sipsolutions.net>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 16:22:17 -0800
Message-Id: <1203985337.6929.120.camel@localhost> (sfid-20080226_002100_340741_8B525267)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-25 at 16:27 +0100, Johannes Berg wrote:
> @@ -303,8 +300,8 @@ static void mesh_path_node_reclaim(struc
>  	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
>  	struct ieee80211_sub_if_data *sdata =
>  		IEEE80211_DEV_TO_SUB_IF(node->mpath->dev);
> -	if (node->mpath->next_hop)
> -		sta_info_put(node->mpath->next_hop);
> +
> +	rcu_assign_pointer(node->mpath->next_hop, NULL);

Is that necessary? If we are here nobody else should have access to this
path and we should just free it, right?

Also since now we can force deletion, the mesh path timer might be
running and we need a del_timer_sync() somewhere. After adding that, we
may as well always force the path deletion.


-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


