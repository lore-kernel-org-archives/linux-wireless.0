Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45767 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab1AGBFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 20:05:24 -0500
Received: by fxm20 with SMTP id 20so16554858fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 17:05:23 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: greearb@candelatech.com
Subject: Re: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
Date: Fri, 7 Jan 2011 02:04:59 +0100
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Eric Dumazet <eric.dumazet@gmail.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201101070205.00886.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 January 2011 01:46:03 greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Patch is from Eric Dumazet, as described here:
> https://patchwork.kernel.org/patch/104271/
> 
> Reported-by: Michael Guntsche <mike@it-loops.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> NOTE:  This needs review by ath9k and/or other informed
> people.

Does the hardware support vector-i/o for rx (like for instance iwlagn)?
Else, this change would break A-MSDU rx - which is a mandatory feature
(although, not very popular) of 802.11n - 

See for example 802.11n-2009 9.7c:

"Support for the reception of an A-MSDU, where [...], is mandatory for
an HT STA"

And 7.1.2 "The maximum frame body size is determined by the maximum
MSDU size (2304 octets) OR the maximum A-MSDU (3839 or 7935 octets,
depending upon the STA's capability), plus any overhead from security
encapsulation.

> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index b2497b8..270661d 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -230,11 +230,11 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
>  	int error = 0, i;
>  	u32 size;
>  
> -
> -	common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN +
> -				     ah->caps.rx_status_len,
> -				     min(common->cachelsz, (u16)64));
> -
> +	size = roundup(IEEE80211_MAX_MPDU_LEN + ah->caps.rx_status_len,
> +		       min(common->cachelsz, (u16)64));
> +	common->rx_bufsize = max_t(u32, size,
> +				   SKB_MAX_ORDER(NET_SKB_PAD
> +						 + common->cachelsz, 0));
>  	ath9k_hw_set_rx_bufsize(ah, common->rx_bufsize -
>  				    ah->caps.rx_status_len);
>  
> 
