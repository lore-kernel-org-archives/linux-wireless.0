Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46361 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267AbaH0Ijz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 04:39:55 -0400
Message-ID: <53FD9958.90806@openwrt.org> (sfid-20140827_103959_471229_841F138F)
Date: Wed, 27 Aug 2014 10:39:52 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 2/4] ath9k: Disable fastcc for channel context mode
References: <1409121445-11484-1-git-send-email-sujith@msujith.org> <1409121445-11484-3-git-send-email-sujith@msujith.org>
In-Reply-To: <1409121445-11484-3-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-08-27 08:37, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 2fcafa6..b823b5a 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -303,6 +303,9 @@ int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
>  	if (!ath_prepare_reset(sc))
>  		fastcc = false;
>  
> +	if (ath9k_is_chanctx_enabled())
> +		fastcc = false;
> +
Why?

- Felix
