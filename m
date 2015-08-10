Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62124 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106AbbHJSbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 14:31:06 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: report per-chain RSSI
In-Reply-To: <20150729121942.9c8c2ec02dfc0469163aa7aa@ubnt.com> (Dmitry
	Ivanov's message of "Wed, 29 Jul 2015 12:19:42 +0300")
References: <20150729121942.9c8c2ec02dfc0469163aa7aa@ubnt.com>
Date: Mon, 10 Aug 2015 21:30:56 +0300
Message-ID: <874mk7uhb3.fsf@kamboji.qca.qualcomm.com> (sfid-20150810_203115_094472_1325CE17)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com> writes:

> ath10k: report per-chain RSSI.
>
> Signed-off-by: Dmitry Ivanov <dima@ubnt.com>

Please write a proper commit log. And CC ath10k mailing list when
submitting ath10k patches:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/sources#submitting_patches

> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -832,6 +832,20 @@ static void ath10k_htt_rx_h_signal(struct ath10k *ar,
>  				   struct ieee80211_rx_status *status,
>  				   struct htt_rx_desc *rxd)
>  {
> +	{

The extra block is not needed and can be remove, right?

> +		/* Linux array has size IEEE80211_MAX_CHAINS, FW array has size 4 */
> +		BUILD_BUG_ON(IEEE80211_MAX_CHAINS != 4);

This is a bit evil, is this really necessary? Can't we just add a define
for FW array size and use that?

> +		u32 i = IEEE80211_MAX_CHAINS;

Why u32? Wouldn't int be enough?

> +		u8 signal_per_chain;
> +		do {
> +			i--;
> +			signal_per_chain = rxd->ppdu_start.rssi_chains[i].pri20_mhz;
> +			if (signal_per_chain != 0x80) {

What's the magic number 0x80? Is there an existing define you could use
or do we need to add a new one?

> +				status->chains |= BIT(i);
> +				status->chain_signal[i] = ATH10K_DEFAULT_NOISE_FLOOR + signal_per_chain;
> +			}
> +		} while (i);
> +	}

Wouldn't a normal for loop be simpler?

for (i = 0; i < IEEE80211_MAX_CHAINS; i++)

-- 
Kalle Valo
