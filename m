Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3746 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbYEVD2r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 23:28:47 -0400
Date: Wed, 21 May 2008 23:10:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5/5] mac80211: move TX info into skb->cb
Message-ID: <20080522031021.GB10561@tuxdriver.com> (sfid-20080522_052859_563987_70E49069)
References: <20080515105524.359863000@sipsolutions.net> <20080515105948.820956000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080515105948.820956000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 15, 2008 at 12:55:29PM +0200, Johannes Berg wrote:

> --- everything.orig/net/mac80211/tx.c	2008-05-15 12:09:40.000000000 +0200
> +++ everything/net/mac80211/tx.c	2008-05-15 12:09:59.000000000 +0200

> @@ -1325,9 +1324,10 @@ int ieee80211_master_start_xmit(struct s
>  		dev_kfree_skb(skb);
>  		return 0;
>  	}
> +
>  	osdata = IEEE80211_DEV_TO_SUB_IF(odev);
>  
> -	encrypt = !(pkt_data->flags & IEEE80211_TXPD_DO_NOT_ENCRYPT);
> +	encrypt = !(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT);
>  
>  	headroom = osdata->local->tx_headroom;
>  	if (encrypt)

This hunk didn't apply, please review the merge results.

John
-- 
John W. Linville
linville@tuxdriver.com
