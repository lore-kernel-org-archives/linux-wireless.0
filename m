Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65510 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaCXJip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 05:38:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 8/8] ath10k: finally kill htt_rx_info
References: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
	<1395394341-3958-9-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 24 Mar 2014 11:38:40 +0200
In-Reply-To: <1395394341-3958-9-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 21 Mar 2014 10:32:21 +0100")
Message-ID: <87r45s6in3.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_103849_651545_50B0B1B3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Struct htt_rx_info is not needed anymore while
> we will use ieee80211_rx_status structure as
> as template.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

[...]

> -static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
> +static void ath10k_process_rx(struct ath10k *ar,
> +			      struct ieee80211_rx_status *rx_status,
> +			      struct sk_buff *skb)
>  {
>  	struct ieee80211_rx_status *status;
>  
> -	status = IEEE80211_SKB_RXCB(info->skb);
> -	memcpy(status, &info->rx_status, sizeof(*status));
> +	status = IEEE80211_SKB_RXCB(skb);
> +	memcpy(status, rx_status, sizeof(*status));

I guess you saw this suggestion from the buildbot:

>> drivers/net/wireless/ath/ath10k/htt_rx.c:803:1-7: Replace memcpy with struct assignment

-- 
Kalle Valo
