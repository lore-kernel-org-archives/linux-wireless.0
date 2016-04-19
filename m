Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:33385 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750969AbcDSIoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 04:44:46 -0400
Message-ID: <1461055475.1917.17.camel@perches.com> (sfid-20160419_104511_887333_DA429D9B)
Subject: Re: [PATCH v3 06/18] wcn36xx: Add helper macros to cast sta to priv
From: Joe Perches <joe@perches.com>
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
	Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2016 01:44:35 -0700
In-Reply-To: <1461042056-10607-7-git-send-email-bjorn.andersson@linaro.org>
References: <1461042056-10607-1-git-send-email-bjorn.andersson@linaro.org>
	 <1461042056-10607-7-git-send-email-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-18 at 22:00 -0700, Bjorn Andersson wrote:
> From: Pontus Fuchs <pontus.fuchs@gmail.com>
> 
> While poking at this I also change two related things. I rename one
> variable to make the names consistent. I also move one assignment of
> priv_sta to the declaration to save a few lines.

trivia:

The commit subject is a bit misleading as this adds
the preferred static
inline not a macro.

> diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
[]
> @@ -275,4 +275,10 @@ struct ieee80211_vif *wcn36xx_priv_to_vif(struct wcn36xx_vif *vif_priv)
>  	return container_of((void *) vif_priv, struct ieee80211_vif, drv_priv);
>  }
>  
> +static inline
> +struct wcn36xx_sta *wcn36xx_sta_to_priv(struct ieee80211_sta *sta)
> +{
> +	return (struct wcn36xx_sta *)sta->drv_priv;
> +}
> +
>  #endif	/* _WCN36XX_H_ */

And this could be const struct ieee8021_sta *sta
