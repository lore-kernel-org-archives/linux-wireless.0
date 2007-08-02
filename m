Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59037
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbXHBWHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 18:07:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx-mac80211: Provide information to allow transmission rate decreases
Date: Fri, 3 Aug 2007 00:06:34 +0200
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46b24304.DLuGdus4YPRFspUn%Larry.Finger@lwfinger.net>
In-Reply-To: <46b24304.DLuGdus4YPRFspUn%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708030006.35112.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, I fixed that and queued it up ;)
http://bu3sch.de/patches/wireless-dev/20070803-1186092135/patches/bcm43xx-mac80211-provide-information-to-allow-transmission-rate-decreases.patch

On Thursday 02 August 2007, Larry Finger wrote:
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
> John and Michael,
> 
> This is based on the wireless-dev tree.
> 
> Larry
> 
>  bcm43xx_dma.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
> @@ -1311,6 +1311,9 @@ void bcm43xx_dma_handle_txstatus(struct 
>  			 */
>  			if (status->acked)
>  				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
> +			else
> +				if (!(meta->txstat.flags & IEEE80211_TXCTL_NO_ACK))
> +					meta->txstat.excessive_retries = 1;
>  			meta->txstat.retry_count = status->frame_count - 1;
>  			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb, &(meta->txstat));
>  			/* skb is freed by ieee80211_tx_status_irqsafe() */
> 
> 


