Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out21.sjc.mx.trendmicro.com ([216.99.131.78]:51403 "EHLO
	out21.sjc.mx.trendmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756721Ab1DLHEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 03:04:32 -0400
Received: from relay02.sjc.mx.trendmicro.com (unknown [10.30.239.9])
	by out21.sjc.mx.trendmicro.com (Postfix) with ESMTP id F0F8F980448
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 07:04:31 +0000 (UTC)
Received: from thinktube.com (unknown [111.68.225.247])
	by relay02.sjc.mx.trendmicro.com (Postfix) with ESMTP id 86D8F9583C
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 07:04:30 +0000 (UTC)
Message-ID: <4DA3F986.3070800@thinktube.com>
Date: Tue, 12 Apr 2011 16:04:38 +0900
From: =?UTF-8?B?5rW36Je75pWs5LmL?= <tkaiso@thinktube.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 5/7] ath5k: remove ts_retry from	ath5k_tx_status
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>	<1302453139-11437-2-git-send-email-nbd@openwrt.org>	<1302453139-11437-3-git-send-email-nbd@openwrt.org>	<1302453139-11437-4-git-send-email-nbd@openwrt.org> <1302453139-11437-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302453139-11437-5-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Isn't there any chance in which info->status.rates[x].count has
  different retry-count value from the one which the firmware actually did.

  For example, driver requests invalid value of retry count and firmware rejects it (take other value).

  no such chance  ?

Thanks
Takayuki Kaiso
> Reusing the configured retry counts from the skb cb is more efficient than
> reloading the data from uncached memory.
> Replace ts_longretry (unused) with ts_final_retry which contains the retry
> count for the final rate only
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> ---
>   drivers/net/wireless/ath/ath5k/ath5k.h |    3 +-
>   drivers/net/wireless/ath/ath5k/base.c  |   11 ++++++++-
>   drivers/net/wireless/ath/ath5k/desc.c  |   34 ++-----------------------------
>   3 files changed, 13 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
> index aa588a0..fcaf4ed 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k.h
> @@ -452,11 +452,10 @@ struct ath5k_tx_status {
>   	u16	ts_seqnum;
>   	u16	ts_tstamp;
>   	u8	ts_status;
> -	u8	ts_retry[4];
>   	u8	ts_final_idx;
> +	u8	ts_final_retry;
>   	s8	ts_rssi;
>   	u8	ts_shortretry;
> -	u8	ts_longretry;
>   	u8	ts_virtcol;
>   	u8	ts_antenna;
>   };
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 753662f..1a561b8 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1573,20 +1573,27 @@ ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
>   			 struct ath5k_txq *txq, struct ath5k_tx_status *ts)
>   {
>   	struct ieee80211_tx_info *info;
> +	u8 tries[3];
>   	int i;
>
>   	sc->stats.tx_all_count++;
>   	sc->stats.tx_bytes_count += skb->len;
>   	info = IEEE80211_SKB_CB(skb);
>
> +	tries[0] = info->status.rates[0].count;
> +	tries[1] = info->status.rates[1].count;
> +	tries[2] = info->status.rates[2].count;
> +
>   	ieee80211_tx_info_clear_status(info);
> -	for (i = 0; i<= ts->ts_final_idx; i++) {
> +
> +	for (i = 0; i<  ts->ts_final_idx; i++) {
>   		struct ieee80211_tx_rate *r =
>   			&info->status.rates[i];
>
> -		r->count = ts->ts_retry[i];
> +		r->count = tries[i];
>   	}
>
> +	info->status.rates[ts->ts_final_idx].count = ts->ts_final_retry;
>   	info->status.rates[ts->ts_final_idx + 1].idx = -1;
>
>   	if (unlikely(ts->ts_status)) {
> diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
> index e366d30..0391813 100644
> --- a/drivers/net/wireless/ath/ath5k/desc.c
> +++ b/drivers/net/wireless/ath/ath5k/desc.c
> @@ -366,7 +366,7 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
>   		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
>   	ts->ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
>   		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
> -	ts->ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
> +	ts->ts_final_retry = AR5K_REG_MS(tx_status->tx_status_0,
>   		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
>   	/*TODO: ts->ts_virtcol + test*/
>   	ts->ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
> @@ -375,7 +375,6 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
>   		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
>   	ts->ts_antenna = 1;
>   	ts->ts_status = 0;
> -	ts->ts_retry[0] = ts->ts_longretry;
>   	ts->ts_final_idx = 0;
>
>   	if (!(tx_status->tx_status_0&  AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK)) {
> @@ -401,7 +400,7 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
>   {
>   	struct ath5k_hw_4w_tx_ctl *tx_ctl;
>   	struct ath5k_hw_tx_status *tx_status;
> -	u32 txstat0, txstat1, txctl2;
> +	u32 txstat0, txstat1;
>
>   	tx_ctl =&desc->ud.ds_tx5212.tx_ctl;
>   	tx_status =&desc->ud.ds_tx5212.tx_stat;
> @@ -413,7 +412,6 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
>   		return -EINPROGRESS;
>
>   	txstat0 = ACCESS_ONCE(tx_status->tx_status_0);
> -	txctl2 = ACCESS_ONCE(tx_ctl->tx_control_2);
>
>   	/*
>   	 * Get descriptor status
> @@ -422,7 +420,7 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
>   		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
>   	ts->ts_shortretry = AR5K_REG_MS(txstat0,
>   		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
> -	ts->ts_longretry = AR5K_REG_MS(txstat0,
> +	ts->ts_final_retry = AR5K_REG_MS(txstat0,
>   		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
>   	ts->ts_seqnum = AR5K_REG_MS(txstat1,
>   		AR5K_DESC_TX_STATUS1_SEQ_NUM);
> @@ -435,32 +433,6 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
>   	ts->ts_final_idx = AR5K_REG_MS(txstat1,
>   			AR5K_DESC_TX_STATUS1_FINAL_TS_IX_5212);
>
> -	/* The longretry counter has the number of un-acked retries
> -	 * for the final rate. To get the total number of retries
> -	 * we have to add the retry counters for the other rates
> -	 * as well
> -	 */
> -	ts->ts_retry[ts->ts_final_idx] = ts->ts_longretry;
> -	switch (ts->ts_final_idx) {
> -	case 3:
> -		ts->ts_retry[2] = AR5K_REG_MS(txctl2,
> -			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2);
> -		ts->ts_longretry += ts->ts_retry[2];
> -		/* fall through */
> -	case 2:
> -		ts->ts_retry[1] = AR5K_REG_MS(txctl2,
> -			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
> -		ts->ts_longretry += ts->ts_retry[1];
> -		/* fall through */
> -	case 1:
> -		ts->ts_retry[0] = AR5K_REG_MS(txctl2,
> -			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
> -		ts->ts_longretry += ts->ts_retry[0];
> -		/* fall through */
> -	case 0:
> -		break;
> -	}
> -
>   	/* TX error */
>   	if (!(txstat0&  AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK)) {
>   		if (txstat0&  AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)


