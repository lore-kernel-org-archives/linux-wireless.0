Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sacred.ru ([62.205.161.221]:58331 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbYEPLK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 07:10:26 -0400
Message-ID: <482D6A80.6030804@openvz.org> (sfid-20080516_131031_293994_541829E4)
Date: Fri, 16 May 2008 15:05:36 +0400
From: Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/7][MAC8021]: Fix one more call to synchronize_rcu in
 atomic context.
References: <4821CE54.9000401@openvz.org>
In-Reply-To: <4821CE54.9000401@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, John. 

Sorry for bothering you, I guess that you're very busy now, 
but what are you plans about this set?

After I saw my first set included in some wireless git update,
I thought this one would be in some of the next ones (since
this set fixes some bugs in mesh tables), and started waiting.

Here's a new wireless git update and this set is still not in.
Shall I resubmit one?

Thanks,
Pavel

> (This set applies OK without the previous one of 4 patches,
>  but with some fuzz in the 7th one)
> 
> 
> The mesh_path_node_free() does so under hashwlock.
> 
> But, this one is called
> 1. from mesh_path_add() after an old hash is hidden and
>    synchronize_rcu() is calld
> 2. mesh_pathtbl_unregister(), when the module is being
>    unloaded and no devices exist to mess with this hash.
> 
> So, it seems to me, that simply removing the call is OK.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
>  net/mac80211/mesh_pathtbl.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 7097ef9..0b6c4bf 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -458,7 +458,6 @@ static void mesh_path_node_free(struct hlist_node *p, bool free_leafs)
>  	struct mpath_node *node = hlist_entry(p, struct mpath_node, list);
>  	mpath = node->mpath;
>  	hlist_del_rcu(p);
> -	synchronize_rcu();
>  	if (free_leafs)
>  		kfree(mpath);
>  	kfree(node);

