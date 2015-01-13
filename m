Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:60314 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbAMPDr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 10:03:47 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
Date: Tue, 13 Jan 2015 17:03:37 +0200
In-Reply-To: <1420432796-10765-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 5 Jan 2015 10:09:56 +0530")
Message-ID: <87r3uy4t9y.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_160350_352034_59CA8CF4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> The HTT RX ring is replenished with a maximum of 16 buffers,
> but this might be insufficient when RX traffic is high.
> Not having enough RX buffers throttles the FW, resulting
> in low throughput.
>
> This patch adds a module parameter to adjust the fill size
> based on the platform/usage.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -33,14 +33,17 @@
>  unsigned int ath10k_debug_mask;
>  static bool uart_print;
>  static bool skip_otp;
> +int htt_fill_size = ATH10K_HTT_MAX_NUM_REFILL;
>  
>  module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
>  module_param(uart_print, bool, 0644);
>  module_param(skip_otp, bool, 0644);
> +module_param(htt_fill_size, int, 0644);
>  
>  MODULE_PARM_DESC(debug_mask, "Debugging mask");
>  MODULE_PARM_DESC(uart_print, "Uart target debugging");
>  MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");
> +MODULE_PARM_DESC(htt_fill_size, "HTT RX ring fill size");

I'm not sure if I really like this path of having interfaces to
configure driver internals. I suspect that if we add this, we will have
even more later. It's a lot more documenting for us and more work to the
users to understand what parameters they should use. Also this means
that testing will be more challenging as people will use different
values and results won't be comparable.

Isn't there any other way to solve the problem? Like automatically
changing the value somehow (no idea how) or some other means?

Or if nothing else helps, a crazy idea is to have some sort of platform
profile parameter:

0 = auto
1 = slow
2 = fast
3 = superfast (x86)

And then we would have preset values (not just htt_fill_size) within
ath10k and they get chosen based on the profile configured.

-- 
Kalle Valo
