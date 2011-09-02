Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933366Ab1IBKyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 06:54:50 -0400
Subject: Re: [PATCH] mac80211: Stop forwarding mesh traffic when tx queues
 are full
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1314907533-27486-1-git-send-email-javier@cozybit.com> (sfid-20110901_220614_208133_761E3776)
References: <1314907533-27486-1-git-send-email-javier@cozybit.com>
	 (sfid-20110901_220614_208133_761E3776)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 12:54:43 +0200
Message-ID: <1314960883.3927.3.camel@jlt3.sipsolutions.net> (sfid-20110902_125453_957757_96AC8284)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-01 at 13:05 -0700, Javier Cardona wrote:

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1847,6 +1847,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
>  		/* illegal frame */
>  		return RX_DROP_MONITOR;
>  
> +	if (local->queue_stop_reasons[skb_get_queue_mapping(skb)]) {
> +		IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
> +						dropped_frames_congestion);
> +		return RX_DROP_MONITOR;
> +	}

It's probably not terribly important, but shouldn't the
queue_stop_reasons access be locked?

johannes

