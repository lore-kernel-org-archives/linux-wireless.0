Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:42086 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3KTHRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 02:17:45 -0500
Received: by mail-vc0-f181.google.com with SMTP id ks9so2927603vcb.40
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 23:17:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384870413-5569-1-git-send-email-yeohchunyeow@gmail.com>
References: <1384870413-5569-1-git-send-email-yeohchunyeow@gmail.com>
Date: Wed, 20 Nov 2013 07:17:45 +0000
Message-ID: <CAFSJ42ZLhh5ns-aaO8G38TH1em37iHnYKvgF7BjSK-ZhA7jNcA@mail.gmail.com> (sfid-20131120_081749_114620_F3329382)
Subject: Re: [PATCH] wcn36xx: set self sta entry as HT capable
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why would the function that is setting default HT params will also set
default rates? There is no connection between HT params and default
rates.

But the idea to set HT by default in AP mode is something that we
definitely need.

On Tue, Nov 19, 2013 at 2:13 PM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Set the HT capable for self STA entry for bss configuration. Otherwise,
> only legacy rate will be used for transmitting, especially for mesh
> mode.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 19f43de..5160b04 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -115,6 +115,13 @@ static void wcn36xx_smd_set_sta_ht_params(struct ieee80211_sta *sta,
>         }
>  }
>
> +static void wcn36xx_smd_set_sta_default_ht_params(
> +               struct wcn36xx_hal_config_sta_params *sta_params)
> +{
> +       wcn36xx_set_default_rates(&sta_params->supported_rates);
> +       sta_params->ht_capable = 1;
> +}
> +
>  static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
>                 struct ieee80211_vif *vif,
>                 struct ieee80211_sta *sta,
> @@ -171,7 +178,7 @@ static void wcn36xx_smd_set_sta_params(struct wcn36xx *wcn,
>                 memcpy(&sta_params->supported_rates, &priv_sta->supported_rates,
>                         sizeof(priv_sta->supported_rates));
>         } else {
> -               wcn36xx_set_default_rates(&sta_params->supported_rates);
> +               wcn36xx_smd_set_sta_default_ht_params(sta_params);
>         }
>  }
>
> --
> 1.7.9.5
>



-- 
Best regards,
Eugene
