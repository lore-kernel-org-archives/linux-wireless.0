Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0086.outbound.protection.outlook.com ([104.47.1.86]:30592
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752081AbdFMRj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 13:39:58 -0400
Subject: Re: [RFC v2 06/10] ath10k: htt: High latency RX support
To: Erik Stromdahl <erik.stromdahl@gmail.com>, kvalo@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
 <1497279791-9598-7-git-send-email-erik.stromdahl@gmail.com>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <97b65176-7def-54b1-c204-e41bcbe1935f@bowerswilkins.com> (sfid-20170613_194003_759191_0D98EA32)
Date: Tue, 13 Jun 2017 10:39:46 -0700
MIME-Version: 1.0
In-Reply-To: <1497279791-9598-7-git-send-email-erik.stromdahl@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 06/12/2017 08:03 AM, Erik Stromdahl wrote:
> Special HTT RX handling for high latency interfaces.
>
> Since no DMA physical addresses are used in the RX ring
> config message (this is not supported by the high latency
> devices), no RX ring is allocated.
> All RX skb's are allocated by the driver and passed directly
> to mac80211 in the HTT RX indication handler.
>
> A nice side effect of this is that no huge buffer will be
> allocated with dma_alloc_coherent. On embedded systems with
> limited memory resources, the allocation of the RX ring is
> prone to fail.
>
> Some tweaks made to "make it work":
>
> Removal of protected bit in 802.11 header frame control field.
> The chipset seems to do hw decryption but the frame_control
> protected bit is still set.
>
> This is necessary for mac80211 not to drop the frame.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>
> +static void ath10k_htt_rx_proc_rx_ind_ll(struct ath10k_htt *htt,
> +					 struct htt_rx_indication *rx)
>   {
>   	struct ath10k *ar = htt->ar;
>   	struct htt_rx_indication_mpdu_range *mpdu_ranges;
> @@ -2356,7 +2442,12 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
>   		break;
>   	}
>   	case HTT_T2H_MSG_TYPE_RX_IND:
> -		ath10k_htt_rx_proc_rx_ind(htt, &resp->rx_ind);
> +		if (ar->is_high_latency)
Can we use function pointers at initial time to avoid condition check at 
hot path?
I'm afraid adding more lines on hot path.
> +			return ath10k_htt_rx_proc_rx_ind_hl(htt,
> +							    &resp->rx_ind_hl,
> +							    skb);
> +		else
> +			ath10k_htt_rx_proc_rx_ind_ll(htt, &resp->rx_ind);
>   		break;
>   	case HTT_T2H_MSG_TYPE_PEER_MAP: {
>   		struct htt_peer_map_event ev = {
>
