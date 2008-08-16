Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:46840 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbYHPAet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 20:34:49 -0400
Message-ID: <48A6209E.1020904@lwfinger.net> (sfid-20080816_023456_303837_B60D431A)
Date: Fri, 15 Aug 2008 19:34:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808082038.48840.chunkeey@web.de> <489EF8DE.5030801@lwfinger.net> <200808152034.46346.chunkeey@web.de>
In-Reply-To: <200808152034.46346.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> Hmm, or there's something else can't count?!??
> 
> Anyway, the firmware will always assign (as in overwrite) the
> sequence number for every transmitted frame... unfortunatly
> there isn't a uniform way to disable this behaviour. 
> 
> So, rather than doing the sequence number (ac-)couting in the
> driver, we can stick to the one the firmware has already generated...
> 
> Larry, does this patch fixes the "every two hour disconnect" problem as well, or not at all?
> ---
> diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> --- a/drivers/net/wireless/p54/p54common.c	2008-08-13 20:50:03.000000000 +0200
> +++ b/drivers/net/wireless/p54/p54common.c	2008-08-15 20:06:12.000000000 +0200
> @@ -428,6 +428,12 @@ static void p54_rx_frame_sent(struct iee
>  			info->status.retry_count = payload->retries - 1;
>  			info->status.ack_signal = le16_to_cpu(payload->ack_rssi);
>  			skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
> +			if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> +				struct ieee80211_hdr *ieee80211hdr =
> +					(struct ieee80211_hdr *) entry->data;
> +
> +				ieee80211hdr->seq_ctrl |= payload->seq;
> +			}
>  			ieee80211_tx_status_irqsafe(dev, entry);
>  			break;
>  		} else
> @@ -553,7 +559,6 @@ static int p54_tx(struct ieee80211_hw *d
>  	struct ieee80211_tx_queue_stats *current_queue;
>  	struct p54_common *priv = dev->priv;
>  	struct p54_control_hdr *hdr;
> -	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
>  	struct p54_tx_control_allocdata *txhdr;
>  	size_t padding, len;
>  	u8 rate, cts_rate = 0x20;
> @@ -604,19 +609,6 @@ static int p54_tx(struct ieee80211_hw *d
>  	if (padding)
>  		txhdr->align[0] = padding;
>  
> -	/* FIXME: The sequence that follows is needed for this driver to
> -	 * work with mac80211 since "mac80211: fix TX sequence numbers".
> -	 * As with the temporary code in rt2x00, changes will be needed
> -	 * to get proper sequence numbers on beacons. In addition, this
> -	 * patch places the sequence number in the hardware state, which
> -	 * limits us to a single virtual state.
> -	 */
> -	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> -		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> -			priv->seqno += 0x10;
> -		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> -		ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
> -	}
>  	/* modifies skb->cb and with it info, so must be last! */
>  	p54_assign_address(dev, skb, hdr, skb->len);
>  
> diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
> --- a/drivers/net/wireless/p54/p54.h	2008-08-13 20:50:30.000000000 +0200
> +++ b/drivers/net/wireless/p54/p54.h	2008-08-15 19:38:10.000000000 +0200
> @@ -52,7 +52,6 @@ struct p54_common {
>  	int (*open)(struct ieee80211_hw *dev);
>  	void (*stop)(struct ieee80211_hw *dev);
>  	int mode;
> -	u16 seqno;
>  	struct mutex conf_mutex;
>  	u8 mac_addr[ETH_ALEN];
>  	u8 bssid[ETH_ALEN];
> 
> 

This one lasted for 4 hours. What was worse is that it crashed my 
computer with a 1 Hz blink of the Caps Lock light when it failed. I 
hadn't seen that before.

Larry
