Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64330 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3IZOYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 10:24:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: replenish HTT RX buffers in a tasklet
References: <1380010716-27151-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 26 Sep 2013 17:24:01 +0300
In-Reply-To: <1380010716-27151-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 24 Sep 2013 10:18:36 +0200")
Message-ID: <8761tnpsou.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_162418_025462_9D51CE66)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This starves FW RX ring buffer in case of
> excessive RX. This prevents from CPU being
> overwhelmed by RX indications/completions by
> naturally forbiddin FW to submit more RX.
>
> This fixes RX starvation on slow machines when
> under heavy RX traffic.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied. I did a cosmetic change:

> +/* Refill a bunch of RX buffers for each refill round so that FW/HW can handle
> + * aggregated traffic more nicely. */
> +#define ATH10K_HTT_MAX_NUM_REFILL 16
> +
> +

I removed the extra newline here.

-- 
Kalle Valo
