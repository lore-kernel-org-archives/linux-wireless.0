Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366Ab1IBK7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 06:59:53 -0400
Subject: Re: [PATCH v2] mac80211: Defer tranmission of mesh path errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1314896685-2932-2-git-send-email-javier@cozybit.com> (sfid-20110901_190545_523637_8C19C6AA)
References: <1314767494.4161.2.camel@jlt3.sipsolutions.net>
	 <1314896685-2932-1-git-send-email-javier@cozybit.com>
	 <1314896685-2932-2-git-send-email-javier@cozybit.com>
	 (sfid-20110901_190545_523637_8C19C6AA)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 12:59:50 +0200
Message-ID: <1314961190.3927.6.camel@jlt3.sipsolutions.net> (sfid-20110902_125956_753899_323B2B9B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-01 at 10:04 -0700, Javier Cardona wrote:
> Under failure conditions, the mesh stack sends PERR messages to the
> previous sender of the failed frame.  This happens in the tx feedback
> path, in which the transmission queue lock may be taken.  Avoid a
> deadlock by sending the path error via the pending queue.
> 
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> v2: - Helper to prepare skb for deferred transmission (Johannes)
>     - Reword comment (Johannes)
> 
>  net/mac80211/mesh_hwmp.c |   30 ++++++++++++++++++++++++++++--
>  1 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index fd4f76a..cda4818 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/slab.h>
> +#include "wme.h"
>  #include "mesh.h"
>  
>  #ifdef CONFIG_MAC80211_VERBOSE_MHWMP_DEBUG
> @@ -202,6 +203,25 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
>  	return 0;
>  }
>  
> +
> +static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
> +		struct sk_buff *skb)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +
> +	skb_set_mac_header(skb, 0);
> +	skb_set_network_header(skb, 0);
> +	skb_set_transport_header(skb, 0);
> +
> +	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
> +	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
> +	skb->priority = 7;
> +
> +	info->control.vif = &sdata->vif;
> +	ieee80211_set_qos_hdr(local, skb);
> +}

Maybe add a note that if the frame might be encrypted enough headroom
needs to be there?

johannes

