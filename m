Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50051 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755308AbcJLOiT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 10:38:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH] rsi: update in boot parameters
References: <1475660148-14087-1-git-send-email-prameela.j04cs@gmail.com>
Date: Wed, 12 Oct 2016 17:37:57 +0300
In-Reply-To: <1475660148-14087-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Wed, 5 Oct 2016 15:05:48
        +0530")
Message-ID: <87fuo1eipm.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_163850_359825_63A27D83)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> Added more clock switch fields in boot parameters configured to device
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Why? How does this help?

>  			.tapll_info_g = {
> -				.pll_reg_1 = cpu_to_le16((TA_PLL_N_VAL_20 << 8)|
> -					      (TA_PLL_M_VAL_20)),
> -				.pll_reg_2 = cpu_to_le16(TA_PLL_P_VAL_20),
> +				.pll_reg_1 = cpu_to_le16((TAPLL_N_VAL_20 << 8) |
> +							 (TAPLL_M_VAL_20)),
> +				.pll_reg_2 = cpu_to_le16(TAPLL_P_VAL_20),

Doing changes from TA_PLL_N_VAL_20 to TAPLL_N_VAL_20 makes this hard to
review. Only one logical change per patch, please. And make style
changes separately from functional changes.

>  			},
>  			.pll960_info_g = {
> -				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8)|
> +				.pll_reg_1 = cpu_to_le16((PLL960_P_VAL_20 << 8) |

Again unnecessary style change.

> -#define TA_PLL_M_VAL_20                  8
> -#define TA_PLL_N_VAL_20                  1
> -#define TA_PLL_P_VAL_20                  4
> +#define TAPLL_M_VAL_20			8
> +#define TAPLL_N_VAL_20			1
> +#define TAPLL_P_VAL_20			4

I don't really see the point with the rename. Changing the spaces to
tabs I understand, though.

But now that you are just starting don't waste time doing code style
changes, instead focus on fixing functionality or adding new features.
The style changes can be done later when you are more familiar with
everything.

I stopped now, please resend without the style changes so that it's
easier to review.

-- 
Kalle Valo
