Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40337 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0JJV0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 17:26:25 -0400
Message-ID: <4CB22F79.60806@openwrt.org>
Date: Sun, 10 Oct 2010 23:26:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath9k: built-in rate control A-MPDU fix
References: <alpine.DEB.2.00.1010102245220.31264@bigbill>
In-Reply-To: <alpine.DEB.2.00.1010102245220.31264@bigbill>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-10 10:51 PM, Björn Smedman wrote:
> This patch attempts to ensure that ath9k's built-in rate control algorithm 
> does not rely on the value of the ampdu_len and ampdu_ack_len tx status 
> fields unless the IEEE80211_TX_STAT_AMPDU flag is set.
> 
> This patch has not been tested.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
> ---
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index ce1cd6d..13f9e88 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -1375,6 +1375,12 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
>  	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
>  		return;
>  
> +	if (!(tx_info->flags & IEEE80211_TX_STAT_AMPDU)) {
> +		tx_info->status.ampdu_ack_len =
> +			(tx_info->flags & IEEE80211_TX_STAT_ACK ? 1 : 0);
> +		tx_info->status.ampdu_len = 1;
> +	}
> +
Shouldn't mac80211 do this instead?

- Felix
