Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33590 "EHLO
	mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbcFUWaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 18:30:13 -0400
Received: by mail-it0-f67.google.com with SMTP id y93so3334477ita.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2016 15:29:55 -0700 (PDT)
Date: Tue, 21 Jun 2016 18:29:53 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix mesh estab_plinks counting in STA removal
 case
Message-ID: <20160621222953.GB7271@localhost> (sfid-20160622_003043_190487_6941DC35)
References: <20160619205102.GA28350@w1.fi>
 <1466536150.18972.1.camel@sipsolutions.net>
 <20160621222602.GA7271@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160621222602.GA7271@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2016 at 06:26:02PM -0400, Bob Copeland wrote:
> Looks further buggy, so perhaps this untested patch would work, i.e.
                                       ^^^^^^^^ (still)

> @@ -370,13 +372,19 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
>  
>  	spin_lock_bh(&sta->mesh->plink_lock);
>  	changed = __mesh_plink_deactivate(sta);
> -	sta->mesh->reason = WLAN_REASON_MESH_PEER_CANCELED;
> -	mesh_plink_frame_tx(sdata, sta, WLAN_SP_MESH_PEERING_CLOSE,
> -			    sta->sta.addr, sta->mesh->llid, sta->mesh->plid,
> -			    sta->mesh->reason);
> +
> +	if (sdata->u.mesh.user_mpm) {

should be !sdata->u.mesh.user_mpm :)

> +		sta->mesh->reason = WLAN_REASON_MESH_PEER_CANCELED;
> +		mesh_plink_frame_tx(sdata, sta, WLAN_SP_MESH_PEERING_CLOSE,
> +				    sta->sta.addr, sta->mesh->llid, sta->mesh->plid,
> +				    sta->mesh->reason);
> +	}
>  	spin_unlock_bh(&sta->mesh->plink_lock);
>  	mesh_path_flush_by_nexthop(sta);
>  
> +	/* make sure no readers can access nexthop sta from here on */
> +	synchronize_net();
> +
>  	return changed;
>  }
>  
> -- 
> 2.9.0
> 

-- 
Bob Copeland %% http://bobcopeland.com/
