Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54302 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab1HVPC0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 11:02:26 -0400
Message-ID: <4E526F78.1030302@openwrt.org> (sfid-20110822_170229_921545_66CAB83E)
Date: Mon, 22 Aug 2011 17:02:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Send legacy rated frames as unaggregated
References: <1314016632-1742-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1314016632-1742-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-22 2:37 PM, Rajkumar Manoharan wrote:
> Currently the aggregation is formed till the aggregation limit
> is reached and the rate lookup is done for the first frame alone.
> But there can be a legacy rated frames in tid queue. This patch
> limits the subframe addition based on last MRR's rate and sends
> the legacy rated frames as unaggregated one.
>
> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/xmit.c |   23 ++++++++++++++++++++++-
>   1 files changed, 22 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 2062672..41d9184 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -571,6 +571,26 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>   		ath_reset(sc, false);
>   }
>
> +static bool ath_lookup_lecacy(struct ath_buf *bf)
> +{
> +	struct sk_buff *skb;
> +	struct ieee80211_tx_info *tx_info;
> +	struct ieee80211_tx_rate *rates;
> +
> +	skb = bf->bf_mpdu;
> +	tx_info = IEEE80211_SKB_CB(skb);
> +	rates = tx_info->control.rates;
> +
> +	/*
> +	 * Checking the last MRR's flag is sufficient to
> +	 * determine legacy or not
> +	 */
No it isn't. Maybe with ath9k_rate_control, but things may change with 
other rate control modules.

- Felix
