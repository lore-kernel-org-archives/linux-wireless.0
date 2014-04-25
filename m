Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:47312 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaDYTPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 15:15:46 -0400
Received: by mail-qg0-f50.google.com with SMTP id 63so4435836qgz.37
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 12:15:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140425225334.646d5bb22f458e0054b965c3@lnv.dyndns-server.com>
References: <20140425225334.646d5bb22f458e0054b965c3@lnv.dyndns-server.com>
Date: Fri, 25 Apr 2014 20:15:45 +0100
Message-ID: <CAFtRNNyvGcUH0JqhvmNw46b5YFeKKfLmTwfitwapLKBNpgjW7A@mail.gmail.com> (sfid-20140425_211554_747301_0F26F2B4)
Subject: Re: [PATCH] ath5k: Fix AR5K_PHY_TXPOWER_RATE_MAX register value setting.
From: Nick Kossifidis <mickflemm@gmail.com>
To: Nickolay Ledovskikh <nledovskikh@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Reyk Floeter <reyk@openbsd.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-04-25 19:53 GMT+01:00 Nickolay Ledovskikh <nledovskikh@gmail.com>:
> I was reading ath5k power setting code and
> noticed typing error in ath5k_hw_txpower function.
> Invalid value was written to AR5K_PHY_TXPOWER_RATE_MAX
> register.
>
> Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 1a2973b..f383b25 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -3709,8 +3709,8 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>                         AR5K_REG_MS(AR5K_TUNE_MAX_TXPOWER, AR5K_TPC_CHIRP),
>                         AR5K_TPC);
>         } else {
> -               ath5k_hw_reg_write(ah, AR5K_PHY_TXPOWER_RATE_MAX |
> -                       AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
> +               ath5k_hw_reg_write(ah, AR5K_TUNE_MAX_TXPOWER,
> +                       AR5K_PHY_TXPOWER_RATE_MAX);
>         }
>
>         return 0;
> --
> Best regards, Nikolay Ledovskikh.

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
