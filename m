Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60366 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2AYMw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 07:52:26 -0500
Received: by ghrr11 with SMTP id r11so1332905ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2012 04:52:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327435292-25050-1-git-send-email-linville@tuxdriver.com>
References: <1327435292-25050-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 25 Jan 2012 14:52:25 +0200
Message-ID: <CAFtRNNzWM=Dg4-qjkoU0YiNaA2LwHw6U93xCKo2AQxPdm8tn=A@mail.gmail.com> (sfid-20120125_135229_850833_69371486)
Subject: Re: [PATCH] ath5k: use bool type for no_hw_rfkill_switch module parameter
From: Nick Kossifidis <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/1/24 John W. Linville <linville@tuxdriver.com>:
> Avoids this:
>
>  CC [M]  drivers/net/wireless/ath/ath5k/base.o
> drivers/net/wireless/ath/ath5k/base.c: In function ‘__check_no_hw_rfkill_switch’:
> drivers/net/wireless/ath/ath5k/base.c:85:1: warning: return from incompatible pointer type
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 4ab835f..a339693 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -80,7 +80,7 @@ static bool modparam_fastchanswitch;
>  module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
>  MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
>
> -static int ath5k_modparam_no_hw_rfkill_switch;
> +static bool ath5k_modparam_no_hw_rfkill_switch;
>  module_param_named(no_hw_rfkill_switch, ath5k_modparam_no_hw_rfkill_switch,
>                                                                bool, S_IRUGO);
>  MODULE_PARM_DESC(no_hw_rfkill_switch, "Ignore the GPIO RFKill switch state");
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks John !

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
