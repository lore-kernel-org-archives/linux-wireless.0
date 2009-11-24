Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:44684 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbZKXRTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:19:30 -0500
Received: by ewy7 with SMTP id 7so78501ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 09:19:34 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2 8/8] rt2x00: Properly request tx headroom for alignment operations.
Date: Tue, 24 Nov 2009 18:19:29 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com> <1259012694-14869-8-git-send-email-gwingerde@gmail.com> <1259012694-14869-9-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259012694-14869-9-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911241819.29685.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009, Gertjan van Wingerde wrote:
> Current rt2x00 drivers may result in a "ieee80211_tx_status: headroom too
> small" error message when a frame needs to be properly aligned before
> transmitting it.
> This is because the space needed to ensure proper alignment isn't
> requested from mac80211.
> Fix this by adding sufficient amount of alignment space to the amount
> of headroom requested for TX frames.
> 
> Reported-by: David Ellingsworth <david@identd.dyndns.org>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
>  drivers/net/wireless/rt2x00/rt2x00dev.c |   12 +++++++++++-
>  2 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 4d841c0..dcfc8c2 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -113,6 +113,12 @@
>  	(  ((unsigned long)((__skb)->data + (__header))) & 3 )
>  
>  /*
> + * Constants for extra TX headroom for alignment purposes.
> + */
> +#define RT2X00_ALIGN_SIZE	4 /* Only whole frame needs alignment */
> +#define RT2X00_L2PAD_SIZE	8 /* Both header & payload need alignment */

Now that I think of it, why do we need 8 byte for L2 padding?
Shouldn't we need the same size for regular alignment, L2 padding only indicates
the padding occurs between header and payload rather then before the header only.
So unless I am mistaken about how I coded the header & payload moving in rt2x00lib,
you always need at most 4 bytes.

> +/*
>   * Standard timing and size defines.
>   * These values should follow the ieee80211 specifications.
>   */
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 06c43ca..265e66d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -686,7 +686,17 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize extra TX headroom required.
>  	 */
> -	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
> +	rt2x00dev->hw->extra_tx_headroom =
> +		max_t(unsigned int, IEEE80211_TX_STATUS_HEADROOM,
> +		      rt2x00dev->ops->extra_tx_headroom);
> +
> +	/*
> +	 * Take TX headroom required for alignment into account.
> +	 */
> +	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
> +		rt2x00dev->hw->extra_tx_headroom += RT2X00_L2PAD_SIZE;
> +	else if (test_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags))
> +		rt2x00dev->hw->extra_tx_headroom += RT2X00_ALIGN_SIZE;
>  
>  	/*
>  	 * Register HW.


