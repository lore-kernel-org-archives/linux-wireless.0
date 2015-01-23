Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58787 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbbAWQ7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 11:59:17 -0500
Received: by mail-wg0-f52.google.com with SMTP id y19so8552129wgg.11
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 08:59:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421694555-20795-1-git-send-email-linville@tuxdriver.com>
References: <1421694555-20795-1-git-send-email-linville@tuxdriver.com>
Date: Fri, 23 Jan 2015 18:59:15 +0200
Message-ID: <CAFtRNNz7r+O1bdg+c+TZOdK1LpXM6-v8R1rFx8ksGC-kXd4eeQ@mail.gmail.com> (sfid-20150123_175920_616064_1B79DA83)
Subject: Re: [PATCH] ath5k: document a fall-through case in ath5k_hw_set_opmode
From: Nick Kossifidis <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's AR5210 related, we haven't worked much on that chip but I think that's ok.
AR5K_STA_ID1_NO_PSPOLL is set in every case on AR5210 so this
fall-through makes sure it gets set on station and monitor mode too.

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

2015-01-19 21:09 GMT+02:00 John W. Linville <linville@tuxdriver.com>:
> Coverity: CID 114932
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> I'm guessing this is OK, since it seems to work?
>
>  drivers/net/wireless/ath/ath5k/pcu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
> index c60d36aa13e2..bf29da5e90da 100644
> --- a/drivers/net/wireless/ath/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath/ath5k/pcu.c
> @@ -912,6 +912,7 @@ ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
>                 pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
>                         | (ah->ah_version == AR5K_AR5210 ?
>                                 AR5K_STA_ID1_PWR_SV : 0);
> +               /* fall through */
>         case NL80211_IFTYPE_MONITOR:
>                 pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
>                         | (ah->ah_version == AR5K_AR5210 ?
> --
> 2.1.0
>



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
