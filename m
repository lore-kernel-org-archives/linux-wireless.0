Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:3447 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYI2QaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 12:30:02 -0400
Received: by yw-out-2324.google.com with SMTP id 9so327583ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 09:30:01 -0700 (PDT)
Message-ID: <40f31dec0809290930t350ac275j42e53fac60829fa@mail.gmail.com> (sfid-20080929_183007_825508_E4490ED2)
Date: Mon, 29 Sep 2008 19:30:01 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: write beacon control register twice when resetting tsf
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080928160943.GA30901@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080928160943.GA30901@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/28 Bob Copeland <me@bobcopeland.com>:
> According to the newly-released Atheros HAL code, asserting the
> TSF reset bit will toggle a hardware internal state, resulting in a
> spurious reset on the next chip reset.  Whenever we force a TSF bit,
> write the bit twice to clear the internal signal.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>
> This was the only major difference I found between code we're currently
> using in pcu.c and its equivalents in the HAL.  See comment in
> ar5212ResetTsf.  This is only compile-tested.
>
> (There are other differences but they are in the key setup code or
> beacon setup code that we are not using right now.)
>
>  drivers/net/wireless/ath5k/pcu.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
> index c77cee2..c8f9170 100644
> --- a/drivers/net/wireless/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath5k/pcu.c
> @@ -633,8 +633,20 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
>  */
>  void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
>  {
> +       u32 val;
> +
>        ATH5K_TRACE(ah->ah_sc);
> -       AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
> +
> +       val = ath5k_hw_reg_read(ah, AR5K_BEACON) | AR5K_BEACON_RESET_TSF;
> +
> +       /*
> +        * Each write to the RESET_TSF bit toggles a hardware internal
> +        * signal to reset TSF, but if left high it will cause a TSF reset
> +        * on the next chip reset as well.  Thus we always write the value
> +        * twice to clear the signal.
> +        */
> +       ath5k_hw_reg_write(ah, val, AR5K_BEACON);
> +       ath5k_hw_reg_write(ah, val, AR5K_BEACON);
>  }
>
>  /*
> --
> 1.5.4.2.182.gb3092
>
> --
> Bob Copeland %% www.bobcopeland.com
>
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
