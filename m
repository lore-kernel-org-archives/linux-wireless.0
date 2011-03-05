Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1CEOBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 09:01:46 -0500
Subject: Re: [PATCH 4/4 v2] mac80211: Let userspace create stations when
 mesh security is enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Javier Cardona <javier@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1299288252-28314-5-git-send-email-thomas@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
	 <1299288252-28314-5-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 15:01:40 +0100
Message-ID: <1299333700.3826.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 17:24 -0800, Thomas Pedersen wrote:

> +++ b/net/mac80211/mesh_plink.c
> @@ -105,7 +105,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
>  	if (!sta)
>  		return NULL;
>  
> -	sta->flags = WLAN_STA_AUTHORIZED;
> +	sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH;
>  	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
>  	rate_control_rate_init(sta);

This is just for consistency now, right? The AUTH flag isn't tested, but
stations from userspace will have it set, afaiu?

johannes

