Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:34966 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab0ETMyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 08:54:24 -0400
Received: by ewy8 with SMTP id 8so3004257ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 05:54:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100519013214.22206.43556.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
	 <20100519013214.22206.43556.stgit@tt-desk>
Date: Thu, 20 May 2010 15:54:22 +0300
Message-ID: <AANLkTilswnY6oFifj4_iWRqrWTw7U1rtlQmSgrHbbtKT@mail.gmail.com>
Subject: Re: [PATCH v2 18/20] ath5k: update AR5K_PHY_RESTART_DIV_GC values to
	match masks
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/19 Bruno Randolf <br1@einfach.org>:
> #define AR5K_PHY_RESTART_DIV_GC               0x001c0000
> is 3 bit wide.
>
> The previous values of 0xc and 0x8 are 4bit wide and bigger than the mask.
>
> Writing 0 and 1 to AR5K_PHY_RESTART_DIV_GC is consistent with the comments and
> initvals we have in the HAL.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index d9506e7..2136930 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1768,13 +1768,13 @@ ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
>
>        if (enable) {
>                AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RESTART,
> -                               AR5K_PHY_RESTART_DIV_GC, 0xc);
> +                               AR5K_PHY_RESTART_DIV_GC, 1);
>
>                AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_FAST_ANT_DIV,
>                                        AR5K_PHY_FAST_ANT_DIV_EN);
>        } else {
>                AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RESTART,
> -                               AR5K_PHY_RESTART_DIV_GC, 0x8);
> +                               AR5K_PHY_RESTART_DIV_GC, 0);
>
>                AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_FAST_ANT_DIV,
>                                        AR5K_PHY_FAST_ANT_DIV_EN);
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
