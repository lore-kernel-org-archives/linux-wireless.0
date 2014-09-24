Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41026 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaIXFt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 01:49:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21538.23427.487888.806826@gargle.gargle.HOWL> (sfid-20140924_074929_062180_3F11E719)
Date: Wed, 24 Sep 2014 11:19:55 +0530
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: Re: [RFC 3/4] ath9k: Fix force_channel usage for offchannel frames
In-Reply-To: <1411533452-22921-4-git-send-email-sujith@msujith.org>
References: <1411533452-22921-1-git-send-email-sujith@msujith.org>
	<1411533452-22921-4-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Since RoC is done before frames marked with
> IEEE80211_TX_CTL_TX_OFFCHAN are received by the driver,
> setting force_channel is useless. We will be in
> the required offchannel, so incoming frames can
> be transmitted immediately.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 00931b6..4d00f59 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -2211,9 +2211,6 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
>  	if (vif)
>  		avp = (void *)vif->drv_priv;
>  
> -	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
> -		txctl->force_channel = true;
> -
>  	ret = ath_tx_prepare(hw, skb, txctl);
>  	if (ret)
>  	    return ret;

This breaks things, so this patch can be dropped.

Sujith
