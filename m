Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59074 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbcFUUmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 16:42:50 -0400
Message-ID: <1466536150.18972.1.camel@sipsolutions.net> (sfid-20160621_224254_132949_A4A17EA4)
Subject: Re: [PATCH] mac80211: Fix mesh estab_plinks counting in STA removal
 case
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Jun 2016 21:09:10 +0200
In-Reply-To: <20160619205102.GA28350@w1.fi> (sfid-20160619_225105_265465_B90726F0)
References: <20160619205102.GA28350@w1.fi>
	 (sfid-20160619_225105_265465_B90726F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  	 */
> -	changed = mesh_accept_plinks_update(sdata);
> +	if (sdata->u.mesh.user_mpm &&
> +	    sta->mesh->plink_state == NL80211_PLINK_ESTAB)
> +		changed |= mesh_plink_dec_estab_count(sdata);
> +	changed |= mesh_accept_plinks_update(sdata);
>  	if (!sdata->u.mesh.user_mpm) {
>  		changed |= mesh_plink_deactivate(sta);
>  		del_timer_sync(&sta->mesh->plink_timer);
> 

Does it have to be done before the mesh_accept_plinks_update()?

If not, you should put it with the existing u.mesh.user_mpm check. If
yes, then the code is further buggy since only mesh_plink_deactivate()
will call it when the kernel MPM is used.

johannes
