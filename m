Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34767 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbbJPMwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 08:52:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] ath10k: add copy engine fast path support
References: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Fri, 16 Oct 2015 15:51:44 +0300
In-Reply-To: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 12 Oct 2015 18:26:59 +0530")
Message-ID: <87pp0fgen3.fsf@kamboji.qca.qualcomm.com> (sfid-20151016_145220_665490_1DCA8F8A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Below patchset adds fast path support for uplink traffic by bypassing
> HTC layer processing. This is enabled by making use of unused copy
> engine 5 to receive HTT messages directly from HIF layer. From initial
> validation in VHT80/5G mode TCP UL is improved to 900Mbps from ~840Mbps
> in conducted test.
>
> -Rajkumar
>
> v2:
>  * fix invalid dma memory access (ATH10K_SKB_RXCB is used instead of
>    ATH10K_SKB_CB in htt_tx_cb)
>  * register either send_cb or recv_cb callback not both for
>    appropriate CE.
>  * Process CE 4 send completion first before processing rx
>  
> Rajkumar Manoharan (7):
>   ath10k: export htc tx rx handlers
>   ath10k: register per copy engine send completion callbacks
>   ath10k: register per copy engine receive callbacks
>   ath10k: export htt tx rx handlers
>   ath10k: Configure copy engine 5 for HTT messages
>   ath10k: remove unused dl_is_polled
>   ath10k: remove htc polling for tx completion

All 7 applied, thanks. I wasn't able to reproduce the warning anymore,
tested with both qca988x and qca99x0.

-- 
Kalle Valo
