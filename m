Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36645 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932206AbdEKJjt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 05:39:49 -0400
Received: by mail-wm0-f48.google.com with SMTP id u65so33045570wmu.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 02:39:49 -0700 (PDT)
Subject: Re: [PATCH] ath10k: Fix reported HT MCS rates with NSS > 1
To: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ath10k@lists.infradead.org
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com>
Cc: linux-wireless@vger.kernel.org, akolli@qti.qualcomm.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6e066fe4-35e0-981a-a86e-d9dcaf6ec3b1@broadcom.com> (sfid-20170511_113956_745480_46C037D6)
Date: Thu, 11 May 2017 11:39:46 +0200
MIME-Version: 1.0
In-Reply-To: <20170511090930.18205-1-sven.eckelmann@openmesh.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-5-2017 11:09, Sven Eckelmann wrote:
> The QCA4019 firmware 10.4-3.2.1-00050 reports only HT MCS rates between
> 0-9. But 802.11n MCS rates can be larger than that. For example a 2x2
> device can send with up to MCS 15.
> 
> The firmware encodes the higher MCS rates using the NSS field. The actual
> calculation is not documented by QCA but it seems like the NSS field can be
> mapped for HT rates to following MCS offsets:
> 
>  * NSS 1: 0
>  * NSS 2: 8
>  * NSS 3: 16
>  * NSS 4: 24
> 
> This offset therefore has to be added for HT rates before they are stored
> in the rate_info struct.
> 
> Fixes: cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 84b6067ff6e7..6c0a821fe79d 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2229,9 +2229,15 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
>  	txrate.mcs = ATH10K_HW_MCS_RATE(peer_stats->ratecode);
>  	sgi = ATH10K_HW_GI(peer_stats->flags);
>  
> -	if (((txrate.flags == WMI_RATE_PREAMBLE_HT) ||
> -	     (txrate.flags == WMI_RATE_PREAMBLE_VHT)) && txrate.mcs > 9) {
> -		ath10k_warn(ar, "Invalid mcs %hhd peer stats", txrate.mcs);
> +	if (txrate.flags == WMI_RATE_PREAMBLE_VHT && txrate.mcs > 9) {
> +		ath10k_warn(ar, "Invalid VHT mcs %hhd peer stats",  txrate.mcs);
> +		return;
> +	}

So you leave VHT as is. Did you check with 11ac device? I am wondering
if it needs the same change.

Regards,
Arend
