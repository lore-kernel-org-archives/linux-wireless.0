Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34440 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaCXI4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 04:56:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/8] ath10k: setup rx channel per ppdu
References: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
	<1395394341-3958-5-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 24 Mar 2014 10:56:14 +0200
In-Reply-To: <1395394341-3958-5-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 21 Mar 2014 10:32:17 +0100")
Message-ID: <87vbv46klt.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_095623_521403_ADC0CD37)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Setup band and frequency in ieee80211_rx_status
> only once - for ppdu.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

[...]

> @@ -775,23 +794,7 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
>  	if (info->amsdu_more)
>  		status->flag |= RX_FLAG_AMSDU_MORE;
>  
> -	status->signal = info->signal;

What about the signal, how is it set now? I don't see that anywhere in
this patch.

-- 
Kalle Valo
