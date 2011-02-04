Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1BDI2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 03:28:53 -0500
Received: by iwn9 with SMTP id 9so1919903iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 00:28:53 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19787.47298.50879.401166@gargle.gargle.HOWL>
Date: Fri, 4 Feb 2011 13:58:50 +0530
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
In-Reply-To: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
> In a highly noisy environment, a data frame which is queued before
> a nullfunc frame on a different hw queue may be sent over the air
> after the tx completion of nullfunc frame. This causes the station
> to enter power save and the AP to see the station as awake and
> continues to send the data traffic. Fix this by draining all tx
> queues before we send the null function frame with PM bit set.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 68a1c76..0cb6017 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1710,7 +1710,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
>  			    bf->bf_buf_addr,
>  			    txq->axq_qnum);
>  
> -
>  	return bf;
>  }
>  
> @@ -1813,6 +1812,15 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
>  	if (unlikely(!bf))
>  		return -ENOMEM;
>  
> +	if (ieee80211_is_nullfunc(hdr->frame_control) &&
> +	    ieee80211_has_pm(hdr->frame_control)) {
> +		/* Drain all the pending frames before we send a nullfunc frame
> +		 * to avoid any power save state mismatch between the station
> +		 * and the AP.
> +		 */
> +		ath_drain_all_txq(sc, false);
> +	}
> +

There is a comment about the caller waking queues up properly in ath_drain_all_txq(),
I don't think that requirement is handled properly.

Also, mac80211's flush() callback exists precisely for this purpose.
I think it would be better to use that rather than adding a check for every packet.

Sujith
