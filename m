Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1JGHui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 03:50:38 -0400
Subject: Re: [PATCH] mac80211: Fix regression that allowed mpaths between
 non-peers.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1317938062-1226-1-git-send-email-javier@cozybit.com> (sfid-20111006_235503_003519_EC0F43DC)
References: <1317938062-1226-1-git-send-email-javier@cozybit.com>
	 (sfid-20111006_235503_003519_EC0F43DC)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 09:50:29 +0200
Message-ID: <1317973829.3988.8.camel@jlt3.sipsolutions.net> (sfid-20111007_095041_787969_9215137F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-06 at 14:54 -0700, Javier Cardona wrote:
> Mesh paths should only exist over established peer links.
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  net/mac80211/mesh_hwmp.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 6df7913..174040a 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -789,11 +789,20 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
>  	struct ieee802_11_elems elems;
>  	size_t baselen;
>  	u32 last_hop_metric;
> +	struct sta_info *sta;
>  
>  	/* need action_code */
>  	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
>  		return;
>  
> +	rcu_read_lock();
> +	sta = sta_info_get(sdata, mgmt->sa);
> +	if (!sta || sta->plink_state != NL80211_PLINK_ESTAB) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +	rcu_read_unlock();
> +

No real objections to this patch as I'm sure this is how it works, but I
do wonder ... if a mesh path (mesh_path_add right?) can only exist with
a nexthop peer, how is all this correct when their lifetime isn't tied
together? Yes, mesh_path is flushed when sta_info dies, but there can be
mesh_path w/o a next_hop. How can that be correct?

Or put another way: what guarantees that the sta you find above will be
assigned next_hop for the path? Couldn't it have been deleted by that
time since you don't hang on to the pointer here?

Or am I completely misunderstanding this?

johannes

