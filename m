Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52892 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYCFRQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 12:16:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Date: Thu, 6 Mar 2008 18:15:30 +0100
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	root <root@localhost.localdomain>
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
In-Reply-To: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803061815.31398.mb@bu3sch.de> (sfid-20080306_171710_461687_7242C021)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 March 2008 17:51:47 Ron Rindjunsky wrote:
> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
> index 3dfb28a..416a43e 100644
> --- a/drivers/net/wireless/b43/dma.c
> +++ b/drivers/net/wireless/b43/dma.c
> @@ -1294,7 +1294,12 @@ int b43_dma_tx(struct b43_wldev *dev,
>  		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
>  	} else {
>  		/* Decide by priority where to put this frame. */
> -		ring = priority_to_txring(dev, ctl->queue);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +		ring = priority_to_txring(dev, skb->queue_mapping);
> +#else
> +		/* XXX: b43 qos needs a lot of work */
> +		ring = 1;
> +#endif
>  	}

ehm, this won't compile.
And did you see the patches I recently submitted?

> diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
> index e87b427..c8eeb27 100644
> --- a/drivers/net/wireless/b43legacy/dma.c
> +++ b/drivers/net/wireless/b43legacy/dma.c
> @@ -1323,7 +1323,11 @@ int b43legacy_dma_tx(struct b43legacy_wldev *dev,
>  	int err = 0;
>  	unsigned long flags;
>  
> -	ring = priority_to_txring(dev, ctl->queue);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +	ring = priority_to_txring(dev, skb->queue_mapping);
> +#else
> +	ring = 1;
> +#endif

Won't compile.


-- 
Greetings Michael.
