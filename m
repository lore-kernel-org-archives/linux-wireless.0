Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58276 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3KNIY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 03:24:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21124.34726.610542.341502@gargle.gargle.HOWL> (sfid-20131114_092433_981893_4B5417A5)
Date: Thu, 14 Nov 2013 13:49:50 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/3] ath9k: optimize ath_drain_all_txq
In-Reply-To: <1384205015-68622-2-git-send-email-nbd@openwrt.org>
References: <1384205015-68622-1-git-send-email-nbd@openwrt.org>
	<1384205015-68622-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> If the software has processed all packets, checking the hardware queue
> is unnecessary.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 09cdbcd..babb513 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1786,6 +1786,9 @@ bool ath_drain_all_txq(struct ath_softc *sc)
>  		if (!ATH_TXQ_SETUP(sc, i))
>  			continue;
>  
> +		if (!sc->tx.txq[i].axq_depth)
> +			continue;
> +

Shouldn't the TX queue lock be taken here ?

Sujith
