Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0080.outbound.protection.outlook.com ([104.47.2.80]:2227
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752033AbdFMRil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 13:38:41 -0400
Subject: Re: [RFC v2 05/10] ath10k: htt: High latency TX support
To: Erik Stromdahl <erik.stromdahl@gmail.com>, kvalo@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
 <1497279791-9598-6-git-send-email-erik.stromdahl@gmail.com>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <f446d226-ca60-7dcb-f62d-00de6ead4cd4@bowerswilkins.com> (sfid-20170613_193846_963591_C5E93870)
Date: Tue, 13 Jun 2017 10:38:28 -0700
MIME-Version: 1.0
In-Reply-To: <1497279791-9598-6-git-send-email-erik.stromdahl@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/2017 08:03 AM, Erik Stromdahl wrote:
> Add HTT TX function for HL interfaces.
> Intended for SDIO and USB.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 48418f9..c5fd803 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -3572,7 +3572,10 @@ static int ath10k_mac_tx_submit(struct ath10k *ar,
>   
>   	switch (txpath) {
>   	case ATH10K_MAC_TX_HTT:
> -		ret = ath10k_htt_tx(htt, txmode, skb);
> +		if (ar->is_high_latency)
Can we use function pointers at initial time to avoid condition check at 
hot path?
I'm afraid adding more lines on hot path.
> +			ret = ath10k_htt_tx_hl(htt, txmode, skb);
> +		else
> +			ret = ath10k_htt_tx_ll(htt, txmode, skb);
>   		break;
>   	case ATH10K_MAC_TX_HTT_MGMT:
>   		ret = ath10k_htt_mgmt_tx(htt, skb);
