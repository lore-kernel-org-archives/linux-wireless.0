Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56385 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaCKKAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 06:00:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 05/14] ath10k: introduce ieee80211_rx_status to htt_rx_info
References: <1393937548-7482-1-git-send-email-janusz.dziedzic@tieto.com>
	<1393937548-7482-6-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 11 Mar 2014 11:59:55 +0200
In-Reply-To: <1393937548-7482-6-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Tue, 4 Mar 2014 13:52:18 +0100")
Message-ID: <87eh29hx7o.fsf@kamboji.qca.qualcomm.com> (sfid-20140311_110051_959375_B2AEBABF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Will be used as a template, and final storage for
> rx_status.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

I think this patch is too small. It's good to have small atomic commits
but I think goes overboard.

> @@ -1174,6 +1175,7 @@ struct htt_peer_unmap_event {
>  
>  struct htt_rx_info {
>  	struct sk_buff *skb;
> +	struct ieee80211_rx_status rx_status;
>  	enum htt_rx_mpdu_status status;
>  	enum htt_rx_mpdu_encrypt_type encrypt_type;
>  	s8 signal;
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 3008a1d..2fca1fa 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -756,7 +756,7 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)info->skb->data;
>  
>  	status = IEEE80211_SKB_RXCB(info->skb);
> -	memset(status, 0, sizeof(*status));
> +	memcpy(status, &info->rx_status, sizeof(*status));

So you are idea with the status template is that instead clearing
status, you copy it from the previous frame and reuse it? Why do you
want to do it? Performance reasons?

I didn't fully understand your idea here, but I assume patch 9 is
related as I see that you change the CRC flag handling from this:

-	if (info->fcs_err)
-		status->flag |= RX_FLAG_FAILED_FCS_CRC;

to this:

+			fcs_err = ath10k_htt_rx_has_fcs_err(msdu_head);
+			if (fcs_err)
+				info.rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+			else
+				info.rx_status.flag &= ~RX_FLAG_FAILED_FCS_CRC;

I don't really like that clearing the flag part. Can you describe what
is your plan behind this template?

-- 
Kalle Valo
