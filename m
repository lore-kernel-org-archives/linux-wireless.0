Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:33471 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932149Ab3JNUYO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 16:24:14 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 3.12] ath5k: fix regression in tx status processing
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1381778328-7684-1-git-send-email-nbd@openwrt.org>
Date: Mon, 14 Oct 2013 22:16:41 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bvahl@net.t-labs.tu-berlin.de, ben@gowasabi.net
Message-Id: <301C8A59-A435-4A5A-8BEB-7C3E726342ED@net.t-labs.tu-berlin.de> (sfid-20131014_222421_600569_0916ED6F)
References: <1381778328-7684-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 14.10.2013, at 21:18, Felix Fietkau <nbd@openwrt.org> wrote:

> The regression was introduced in the following commit:
> 
> 0967e01e8e713ed2982fb4eba8ba13794e9a6e89
> "ath5k: make use of the new rate control API"
> 
> ath5k_tx_frame_completed saves the intended per-rate retry counts before
> they are cleared by ieee80211_tx_info_clear_status, however at this
> point the information in info->status.rates is incomplete.
> 
> This causes significant throughput degradation and excessive packet loss
> on links where high bit rates don't work properly.
> 
> Move the copy from bf->rates a few lines up to ensure that the saved
> retry counts are updated, and that they are really cleared in
> info->status.rates after the call to ieee80211_tx_info_clear_status.
> 
> Cc: stable@vger.kernel.org # 3.10+
> Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> Cc: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
> Reported-by: Ben West <ben@gowasabi.net>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Good catch !

Acked-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>


> ---
> drivers/net/wireless/ath/ath5k/base.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 48161ed..69f58b0 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1663,15 +1663,15 @@ ath5k_tx_frame_completed(struct ath5k_hw *ah, struct sk_buff *skb,
> 	ah->stats.tx_bytes_count += skb->len;
> 	info = IEEE80211_SKB_CB(skb);
> 
> +	size = min_t(int, sizeof(info->status.rates), sizeof(bf->rates));
> +	memcpy(info->status.rates, bf->rates, size);
> +
> 	tries[0] = info->status.rates[0].count;
> 	tries[1] = info->status.rates[1].count;
> 	tries[2] = info->status.rates[2].count;
> 
> 	ieee80211_tx_info_clear_status(info);
> 
> -	size = min_t(int, sizeof(info->status.rates), sizeof(bf->rates));
> -	memcpy(info->status.rates, bf->rates, size);
> -
> 	for (i = 0; i < ts->ts_final_idx; i++) {
> 		struct ieee80211_tx_rate *r =
> 			&info->status.rates[i];
> -- 
> 1.8.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

