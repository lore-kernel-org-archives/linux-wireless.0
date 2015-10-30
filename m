Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57544 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784AbbJ3J7w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 05:59:52 -0400
Message-ID: <1446199181.3261.21.camel@sipsolutions.net> (sfid-20151030_105956_008238_28983B17)
Subject: Re: [PATCH 1/2] mac80211: add support to set_coalesce
From: Johannes Berg <johannes@sipsolutions.net>
To: Olav Haugan <ohaugan@codeaurora.org>,
	linux-wireless@vger.kernel.org
Cc: davem@davemloft.net, kvalo@codeaurora.org,
	ath9k-devel@qca.qualcomm.com
Date: Fri, 30 Oct 2015 10:59:41 +0100
In-Reply-To: <1445712652-19327-1-git-send-email-ohaugan@codeaurora.org>
References: <1445712652-19327-1-git-send-email-ohaugan@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/net/mac80211/driver-ops.h
> @@ -1355,4 +1355,16 @@ static inline void drv_wake_tx_queue(struct 
> ieee80211_local *local,
>  	local->ops->wake_tx_queue(&local->hw, &txq->txq);
>  }
>  
> +static inline int drv_set_coalesce(struct ieee80211_local *local,
> +				   struct cfg80211_coalesce 
> *coalesce)
> +{
> +	u32 ret = 0;
> 
This doesn't seem right - now you're accepting any call even if it's
not really done by the driver?

johannes

