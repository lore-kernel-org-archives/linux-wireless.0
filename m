Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50952 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbeD0LcZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 07:32:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] rsi: fix a bug in rsi_hal_key_config()
References: <20180427112130.GA27655@mwanda>
Date: Fri, 27 Apr 2018 14:32:20 +0300
In-Reply-To: <20180427112130.GA27655@mwanda> (Dan Carpenter's message of "Fri,
        27 Apr 2018 14:21:30 +0300")
Message-ID: <87o9i46g1n.fsf@kamboji.qca.qualcomm.com> (sfid-20180427_133229_580041_8814038E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Smatch complains that the end of this function is dead code.  I'm pretty
> sure that this return needs to be changed to only return on error.
>
> Fixes: 4fd6c4762f37 ("rsi: roaming enhancements")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> index 766d874cc6e2..80e7f4f4f188 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> @@ -911,14 +911,14 @@ static int rsi_hal_key_config(struct ieee80211_hw *hw,
>  		}
>  	}
>  
> -	return rsi_hal_load_key(adapter->priv,
> -				key->key,
> -				key->keylen,
> -				key_type,
> -				key->keyidx,
> -				key->cipher,
> -				sta_id,
> -				vif);
> +	status = rsi_hal_load_key(adapter->priv,
> +				  key->key,
> +				  key->keylen,
> +				  key_type,
> +				  key->keyidx,
> +				  key->cipher,
> +				  sta_id,
> +				  vif);

Gustavo submitted an identical patch also for this one :)

https://patchwork.kernel.org/patch/10365997/

-- 
Kalle Valo
