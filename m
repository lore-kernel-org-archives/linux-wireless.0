Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:58176 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZGJSDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 14:03:20 -0400
Received: by qyk31 with SMTP id 31so918025qyk.33
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 11:03:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090709211221.GA4854@steven676.net>
References: <20090709211221.GA4854@steven676.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Jul 2009 11:02:58 -0700
Message-ID: <43e72e890907101102i29352c6bq9e511663e2c3a986@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix enabling OFDM weak signal
	detection
To: Steven Luo <steven@steven676.net>,
	Bennyam Malavazi <Bennyam.Malavazi@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 9, 2009 at 2:12 PM, Steven Luo<steven@steven676.net> wrote:
> From: Steven Luo <steven@steven676.net>
>
> It seems that OFDM weak signal detection should be enabled after an ANI
> state reset, as indicated by the initial setting of ofdmWeakSigDetectOff
> and what the open Atheros HAL does.  Unfortunately, the reversed sense
> of ofdmWeakSigDetectOff (true if weak signal detection is NOT enabled)
> seems to have resulted in a mixup here, causing weak signal detection to
> be disabled.
>
> This patch significantly improves reception and throughput from distant
> stations for my AR5416-based AP running compat-wireless 2009-06-25.
>
> Signed-off-by: Steven Luo <steven@steven676.net>
> Cc: stable@kernel.org
> ---

NACK for now, please give us a chance to review this -- this may
actually be correct.

  Luis

> --- a/drivers/net/wireless/ath/ath9k/ani.c      2009-06-24 21:14:00.000000000 -0700
> +++ b/drivers/net/wireless/ath/ath9k/ani.c      2009-07-06 02:45:57.000000000 -0700
> @@ -482,7 +482,7 @@ void ath9k_ani_reset(struct ath_hw *ah)
>                ath9k_hw_ani_control(ah, ATH9K_ANI_SPUR_IMMUNITY_LEVEL, 0);
>                ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL, 0);
>                ath9k_hw_ani_control(ah, ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
> -                                    !ATH9K_ANI_USE_OFDM_WEAK_SIG);
> +                                    ATH9K_ANI_USE_OFDM_WEAK_SIG);
>                ath9k_hw_ani_control(ah, ATH9K_ANI_CCK_WEAK_SIGNAL_THR,
>                                     ATH9K_ANI_CCK_WEAK_SIG_THR);
>
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
