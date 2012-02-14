Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44815 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2BNJHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 04:07:01 -0500
Received: by vcge1 with SMTP id e1so3722196vcg.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 01:07:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20282.7600.287048.11418@gargle.gargle.HOWL>
References: <20282.7600.287048.11418@gargle.gargle.HOWL>
Date: Tue, 14 Feb 2012 14:37:01 +0530
Message-ID: <CAD2nsn3sVaAea1iBRAgp7-j733BznjrB6sU_i5V1SZ0_kpC1fA@mail.gmail.com> (sfid-20120214_100712_779918_B988C028)
Subject: Re: [PATCH 3/4] ath9k: Modify CCK spur mitigation for AR9462
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Tue, Feb 14, 2012 at 2:09 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> This improves sensitivity for CCK at specific channels.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> index 70e27d2..941b915 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> @@ -171,6 +171,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
>                                            struct ath9k_channel *chan)
>  {
>        static const u32 spur_freq[4] = { 2420, 2440, 2464, 2480 };
> +       static const u32 spur_freq_AR9462[2] = { 2440, 2464 };
>        int cur_bb_spur, negative = 0, cck_spur_freq;
>        int i;
>        int range, max_spur_cnts, synth_freq;
> @@ -198,8 +199,12 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
>                        range = 10;
>                        synth_freq = chan->channel;
>                }
> +       } else if (AR_SREV_9462(ah)) {
> +               range = 5;
> +               max_spur_cnts = 2;
> +               synth_freq = chan->channel;
>        } else {
> -               range = AR_SREV_9462(ah) ? 5 : 10;
> +               range = 10;
>                max_spur_cnts = 4;
>                synth_freq = chan->channel;
>        }
> @@ -211,6 +216,8 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
>                if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah))
>                        cur_bb_spur = FBIN2FREQ(spur_fbin_ptr[i],
>                                        IS_CHAN_2GHZ(chan)) - synth_freq;
> +               else if (AR_SREV_9462(ah))
> +                       cur_bb_spur = spur_freq_AR9462[i] - synth_freq;
>                else
>                        cur_bb_spur = spur_freq[i] - synth_freq;

i saw this some time back ,the check will not take care of this logic

if (AR_SREV_9462(ah) && (i == 0 || i == 3))
			continue;

please let me know if i had missed something

>
> --
> 1.7.9
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
shafi
