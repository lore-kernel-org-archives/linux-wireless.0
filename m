Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:56527 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755173AbdKAUh4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 16:37:56 -0400
Subject: Re: [PATCH] ath10k: fix recent bandwidth conversion bug
To: Christian Lamparter <chunkeey@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
References: <20171101200157.27096-1-chunkeey@gmail.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <224e2890-3775-967b-d4ce-4297574c0642@dd-wrt.com> (sfid-20171101_213759_185668_7EE4BEB8)
Date: Wed, 1 Nov 2017 21:37:53 +0100
MIME-Version: 1.0
In-Reply-To: <20171101200157.27096-1-chunkeey@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

a additional array bounds check would be good

Am 01.11.2017 um 21:01 schrieb Christian Lamparter:
> The commit "cfg80211: make RATE_INFO_BW_20 the default" changed
> the index of RATE_INFO_BW_20, but the updates to ath10k missed
> the special bandwidth calculation case in
> ath10k_update_per_peer_tx_stats().
>
> Fixes: 842be75c77cb ("cfg80211: make RATE_INFO_BW_20 the default")
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
>   drivers/net/wireless/ath/ath10k/htt_rx.c | 23 +++++------------------
>   1 file changed, 5 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index a3f5dc78353f..26b0d201a698 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -592,6 +592,9 @@ struct amsdu_subframe_hdr {
>   
>   #define GROUP_ID_IS_SU_MIMO(x) ((x) == 0 || (x) == 63)
>   
> +static const u8 ath10k_bw_to_mac80211[] = { RATE_INFO_BW_20, RATE_INFO_BW_40,
> +	RATE_INFO_BW_80, RATE_INFO_BW_160 };
> +
>   static void ath10k_htt_rx_h_rates(struct ath10k *ar,
>   				  struct ieee80211_rx_status *status,
>   				  struct htt_rx_desc *rxd)
> @@ -694,23 +697,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
>   		if (sgi)
>   			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
>   
> -		switch (bw) {
> -		/* 20MHZ */
> -		case 0:
> -			break;
> -		/* 40MHZ */
> -		case 1:
> -			status->bw = RATE_INFO_BW_40;
> -			break;
> -		/* 80MHZ */
> -		case 2:
> -			status->bw = RATE_INFO_BW_80;
> -			break;
> -		case 3:
> -			status->bw = RATE_INFO_BW_160;
> -			break;
> -		}
> -
> +		status->bw = ath10k_bw_to_mac80211[bw];
>   		status->encoding = RX_ENC_VHT;
>   		break;
>   	default:
> @@ -2297,7 +2284,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
>   		arsta->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
>   
>   	arsta->txrate.nss = txrate.nss;
> -	arsta->txrate.bw = txrate.bw + RATE_INFO_BW_20;
> +	arsta->txrate.bw = ath10k_bw_to_mac80211[txrate.bw];
>   }
>   
>   static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
