Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47237
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbXHAWPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 18:15:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow transmission rate decreases
Date: Thu, 2 Aug 2007 00:14:14 +0200
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net>
In-Reply-To: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708020014.15072.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 01 August 2007 22:56:07 Larry Finger wrote:
> Michael,
> 
> I think I took care of your comments in the previous version.
> 
> Larry
> ---
> 
> In bcm43xx-mac80211, the mechanism for decreasing the transmit rate cannot
> be triggered. This may be shown by walking away from the AP with a laptop.
> At some distance, communications will be lost and never recovered because
> the rate decreasing mechanism of rc80211_simple needs to see excessive_retries
> set in the ieee80211_tx_status struct. With this patch, the transmit rate
> will decrease until communications restart.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
> @@ -1311,6 +1311,16 @@ void bcm43xx_dma_handle_txstatus(struct 
>  			 */
>  			if (status->acked)
>  				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
> +			else
> +				if (dev->short_preamble) {

Short preamble is something different.
The thing I was talking about is
mac_ctl |= BCM43xx_TX4_MAC_LONGFRAME;
which we do in xmit.c:338.
We currently do it for frames sent with CTS or RTS.

Though, I have no idea how we can easily track the information for each
packet if it was sent with LONGFRAME bit or without.
It needs to be a per-frame-attribute.
I think the txstatus doesn't tell us (but I'm not sure).

> +					if (status->frame_count >=
> +					    dev->short_retry_limit)
> +						meta->txstat.excessive_retries = 1;
> +				} else {
> +					if (status->frame_count >=
> +					    dev->long_retry_limit)
> +						meta->txstat.excessive_retries = 1;
> +				}
>  			meta->txstat.retry_count = status->frame_count - 1;
>  			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb, &(meta->txstat));
>  			/* skb is freed by ieee80211_tx_status_irqsafe() */
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
> @@ -707,6 +707,8 @@ struct bcm43xx_wldev {
>  	bool short_preamble;		/* TRUE, if short preamble is enabled. */
>  	bool short_slot;		/* TRUE, if short slot timing is enabled. */
>  	bool radio_hw_enable;		/* saved state of radio hardware enabled state */
> +	u8 short_retry_limit;
> +	u8 long_retry_limit;
>  
>  	/* PHY/Radio device. */
>  	struct bcm43xx_phy phy;
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
> @@ -3333,10 +3333,12 @@ static int bcm43xx_wireless_core_init(st
>  	tmp = limit_value(modparam_short_retry, 0, 0xF);
>  	bcm43xx_shm_write16(dev, BCM43xx_SHM_SCRATCH,
>  			    BCM43xx_SHM_SC_SRLIMIT, tmp);
> +	dev->short_retry_limit = tmp;
>  	tmp = limit_value(modparam_long_retry, 0, 0xF);
>  	bcm43xx_shm_write16(dev, BCM43xx_SHM_SCRATCH,
>  			    BCM43xx_SHM_SC_LRLIMIT, tmp);
>  
> +	dev->long_retry_limit = tmp;
>  	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
>  			    BCM43xx_SHM_SH_SFFBLIM, 3);
>  	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
> 
> 



-- 
Greetings Michael.
