Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3BRTCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:02:00 -0500
Message-ID: <1361214105.8555.39.camel@jlt4.sipsolutions.net> (sfid-20130218_200205_709366_9C0A55A3)
Subject: Re: [PATCH] mac80211: fix the problem of unicast forwarding from DS
 to DS in Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	cedric.voncken@acksys.fr
Date: Mon, 18 Feb 2013 20:01:45 +0100
In-Reply-To: <1361186207-1390-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130218_124724_975470_FED20EF3)
References: <1361186207-1390-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130218_124724_975470_FED20EF3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 19:16 +0800, Chun-Yeow Yeoh wrote:
> Unicast frame with unknown forwarding information always trigger
> the path discovery assuming destination is always located inside the
> MBSS. This patch allows the forwarding to look for mesh gate if path
> discovery inside the MBSS has failed.
> 
> Reported-by: Cedric Voncken <cedric.voncken@acksys.fr>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  net/mac80211/tx.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 5b9602b..dce3af3 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1844,9 +1844,18 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  		}
>  
>  		if (!is_multicast_ether_addr(skb->data)) {
> -			mpath = mesh_path_lookup(sdata, skb->data);
> -			if (!mpath)
> -				mppath = mpp_path_lookup(sdata, skb->data);
> +			struct sta_info *next_hop;
> +
> +			mpath = mesh_path_lookup(skb->data, sdata);

as Thomas said, please rebase on mac80211-next.

> +			if (mpath)
> +				next_hop = rcu_dereference(mpath->next_hop);
> +
> +			if (!mpath || (mpath && (!next_hop ||
> +					!(mpath->flags & MESH_PATH_ACTIVE))))

indentation here is also wrong.

johannes


