Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60404 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2E3QJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 12:09:21 -0400
Message-ID: <1338394153.4511.27.camel@jlt3.sipsolutions.net> (sfid-20120530_180942_507760_CAC20AEC)
Subject: Re: [PATCH] mac80211:  Limit number of pending skbs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Wed, 30 May 2012 18:09:13 +0200
In-Reply-To: <4FC644F8.8020606@candelatech.com>
References: <1338332576-26427-1-git-send-email-greearb@candelatech.com>
	  <4FC55A83.6030602@openwrt.org> <4FC55BE7.7010807@candelatech.com>
	  (sfid-20120530_012950_634296_DA1EEA8E) <1338361388.4511.3.camel@jlt3.sipsolutions.net>
	 <4FC644F8.8020606@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 09:04 -0700, Ben Greear wrote:

> > There used to be bugs in this area in mac80211 and/or pktgen, and I
> > remember crashing my machine very trivially. I don't think that this is
> > still a problem though, but I haven't tried in a long time. FWIW, the
> > time-frame of this must've been ~2-3 years ago.
> 
> I think it's still broken..I've been carrying this patch for a year or two:
> 
>  From 5ad8e96ace28d798214ba6e203d143e6380e0605 Mon Sep 17 00:00:00 2001
> From: Ben Greear <greearb@candelatech.com>
> Date: Tue, 14 Jun 2011 11:01:50 -0700
> Subject: [PATCH 016/102] mac80211: Set up tx-queue-mapping in subif_start_xmit.
> 
> Otherwise, ath9k gets confused about which queue to use
> and spews a warning like this when driving traffic with
> pktgen.


> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index e05667c..1f026b5 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -2072,6 +2072,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>   	} else
>   		memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
> 
> +	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));

Looks like pktgen then doesn't care about the select_queue() call which
should be called before start_xmit

johannes

