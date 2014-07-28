Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38440 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaG1Gg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 02:36:56 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so9213191pdj.8
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2014 23:36:55 -0700 (PDT)
Message-ID: <53D5EF33.1080208@gmail.com> (sfid-20140728_083659_110997_A73A8F17)
Date: Mon, 28 Jul 2014 12:05:31 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: extend debug code for RX path
References: <1406528765-4669-1-git-send-email-janusz.dziedzic@tieto.com>
In-Reply-To: <1406528765-4669-1-git-send-email-janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2014 11:56 AM, Janusz Dziedzic wrote:
> Print sequence number, AMSDU_MORE flag and AC when additional
> debug enabled in RX path. This is usefull for debugging purpose.
>
> Signed-off-by: Janusz Dziedzic<janusz.dziedzic@tieto.com>
> ---
>   drivers/net/wireless/ath/ath10k/htt_rx.c |   41 ++++++++++++++++++++++++++++--
>   1 file changed, 39 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index d80fcda..f7c8021 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -818,19 +818,55 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
>   	return true;
>   }
>   
> +static const char * const tid_to_ac[] = {

No space required '*' and const.

static const char *const tid_to_ac[] = {


> +	"BE",
> +	"BK",
> +	"BK",
> +	"BE",
> +	"VI",
> +	"VI",
> +	"VO",
> +	"VO",
> +};
> +
> +static char *ath10k_get_tid(struct ieee80211_hdr *hdr, char *out, size_t size)
> +{
> +	u8 *qc;
> +	int tid;
> +
> +	if (!ieee80211_is_data_qos(hdr->frame_control))
> +		return "";

return NULL would be more readable...?

> +
> +	qc = ieee80211_get_qos_ctl(hdr);
> +	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
> +	if (tid < 8)
> +		snprintf(out, size, "tid %d (%s)", tid, tid_to_ac[tid]);
> +	else
> +		snprintf(out, size, "tid %d", tid);
> +
> +	return out;
> +}
> +
>   static void ath10k_process_rx(struct ath10k *ar,
>   			      struct ieee80211_rx_status *rx_status,
>   			      struct sk_buff *skb)
>   {
>   	struct ieee80211_rx_status *status;
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +	char tid[32];
>   
>   	status = IEEE80211_SKB_RXCB(skb);
>   	*status = *rx_status;
>   
>   	ath10k_dbg(ATH10K_DBG_DATA,
> -		   "rx skb %p len %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %imic-err %i\n",
> +		   "rx skb %p len %u peer %pM %s %s sn %u %s%s%s%s%s %srate_idx %u vht_nss %u freq %u band %u flag 0x%x fcs-err %i mic-err %i amsdu-more %i\n",
>   		   skb,
>   		   skb->len,
> +		   ieee80211_get_SA(hdr),
> +		   ath10k_get_tid(hdr, tid, sizeof(tid)),
> +		   is_multicast_ether_addr(ieee80211_get_DA(hdr)) ?
> +							"mcast" : "ucast",

should match open paranthesis...

is_multicast_ether_addr(ieee80211_get_DA(hdr)) ?
			"mcast" : "ucast",

> +		   (__le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4,
>   		   status->flag == 0 ? "legacy" : "",
>   		   status->flag & RX_FLAG_HT ? "ht" : "",
>   		   status->flag & RX_FLAG_VHT ? "vht" : "",
> @@ -842,7 +878,8 @@ static void ath10k_process_rx(struct ath10k *ar,
>   		   status->freq,
>   		   status->band, status->flag,
>   		   !!(status->flag & RX_FLAG_FAILED_FCS_CRC),
> -		   !!(status->flag & RX_FLAG_MMIC_ERROR));
> +		   !!(status->flag & RX_FLAG_MMIC_ERROR),
> +		   !!(status->flag & RX_FLAG_AMSDU_MORE));
>   	ath10k_dbg_dump(ATH10K_DBG_HTT_DUMP, NULL, "rx skb: ",
>   			skb->data, skb->len);
>   


-- 
Regards,
Varka Bhadram.

