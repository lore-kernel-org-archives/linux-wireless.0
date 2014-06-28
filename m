Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:60883 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaF1UyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 16:54:17 -0400
Received: by mail-ig0-f169.google.com with SMTP id c1so3043291igq.2
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 13:54:16 -0700 (PDT)
Date: Sat, 28 Jun 2014 16:54:14 -0400
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: mesh_plink: handle confirm frames with new
 plid
Message-ID: <20140628205414.GA17825@localhost> (sfid-20140628_225421_142433_942363C2)
References: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[oops, +linux-wireless]
On Sat, Jun 28, 2014 at 04:35:25PM -0400, Bob Copeland wrote:
> The 802.11 standard says when processing a plink confirm
> frame:
> 
> "If the peerLinkID in the mesh peering instance has not been
> set, the Local Link ID field of the Mesh Peering Confirm
> request shall be copied into the peerLinkID in the mesh
> peering instance."
> 
> We were only doing this when receiving an open peering frame,
> but it could happen that the open frame gets lost and so we
> should handle this case rather than rejecting the confirm and
> failing the whole peering process.
> 
> Reported-by: Yu Niiro <yu.niiro@gmail.com>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  net/mac80211/mesh_plink.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index 63b8741..c47194d 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -959,7 +959,8 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
>  		if (!matches_local)
>  			event = CNF_RJCT;
>  		if (!mesh_plink_free_count(sdata) ||
> -		    (sta->llid != llid || sta->plid != plid))
> +		    sta->llid != llid ||
> +		    (sta->plid && sta->plid != plid))
>  			event = CNF_IGNR;
>  		else
>  			event = CNF_ACPT;
> @@ -1080,6 +1081,10 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
>  		goto unlock_rcu;
>  	}
>  
> +	/* 802.11-2012 13.3.7.2 - update plid on CNF if not set */
> +	if (!sta->plid && event == CNF_ACPT)
> +		sta->plid = plid;
> +
>  	changed |= mesh_plink_fsm(sdata, sta, event);
>  
>  unlock_rcu:
> -- 
> 2.0.0.rc2
> 

-- 
Bob Copeland %% www.bobcopeland.com
