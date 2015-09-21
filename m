Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36157 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbbIUHdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 03:33:43 -0400
Received: by wicgb1 with SMTP id gb1so101815996wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 00:33:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1442362098-24859-1-git-send-email-greearb@candelatech.com>
References: <1442362098-24859-1-git-send-email-greearb@candelatech.com>
Date: Mon, 21 Sep 2015 09:33:42 +0200
Message-ID: <CA+BoTQkXma5KXpGa3XnnFw=13GRVoTEth0_=K-YNEKru1CpaOA@mail.gmail.com> (sfid-20150921_093346_625594_78C2F7AA)
Subject: Re: [PATCH] ath10k: Fix CCK rate definitions.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 September 2015 at 02:08,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> The old values did NOT match what is found in 10.1.467
> firmware.  I figure it is likely it is wrong for the others
> as well.

Does this fix anything at all?


> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/hw.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 4c5eee4..710ca32 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -202,13 +202,13 @@ enum ath10k_hw_rate_ofdm {
>  };
>
>  enum ath10k_hw_rate_cck {
> -       ATH10K_HW_RATE_CCK_LP_11M = 0,
> -       ATH10K_HW_RATE_CCK_LP_5_5M,
> -       ATH10K_HW_RATE_CCK_LP_2M,
> -       ATH10K_HW_RATE_CCK_LP_1M,
> -       ATH10K_HW_RATE_CCK_SP_11M,
> -       ATH10K_HW_RATE_CCK_SP_5_5M,
> -       ATH10K_HW_RATE_CCK_SP_2M,
> +       ATH10K_HW_RATE_CCK_LP_11M = 0x40,
> +       ATH10K_HW_RATE_CCK_LP_5_5M = 0x41,
> +       ATH10K_HW_RATE_CCK_LP_2M = 0x42,
> +       ATH10K_HW_RATE_CCK_LP_1M = 0x43,
> +       ATH10K_HW_RATE_CCK_SP_11M = ATH10K_HW_RATE_CCK_LP_11M | 0x4,
> +       ATH10K_HW_RATE_CCK_SP_5_5M = ATH10K_HW_RATE_CCK_LP_5_5M | 0x4,
> +       ATH10K_HW_RATE_CCK_SP_2M = ATH10K_HW_RATE_CCK_LP_2M | 0x4,
>  };

This breaks Rx CCK rate decoding/reporting. See code associated with
ath10k_mac_hw_rate_to_idx().


Michał
