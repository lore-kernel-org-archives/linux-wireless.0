Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56572 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab2DCNQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 09:16:24 -0400
Message-ID: <4F7AF81F.30903@openwrt.org> (sfid-20120403_151629_630812_BF9F67F3)
Date: Tue, 03 Apr 2012 15:16:15 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k:  Don't delete key from hw if using sw-crypt.
References: <1333399292-23231-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1333399292-23231-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-02 10:41 PM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This spams logs if we are using large numbers of stations,
> for instance:
> 
> ath: wiphy0: keyreset: keycache entry 228 out of range
> ath: wiphy0: keyreset: keycache entry 228 out of range
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 917032a... 65e7281... M	drivers/net/wireless/ath/ath9k/main.c
>  drivers/net/wireless/ath/ath9k/main.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 917032a..65e7281 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1771,6 +1771,9 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
>  	if (!an->ps_key)
>  	    return;
>  
> +	if (ath9k_modparam_nohwcrypt)
> +		return;
> +
This looks wrong to me. ps_key is used for better powersave handling of
both unencrypted and encrypted stations (using the keycache only for tx
filtering on unencrypted stations).

- Felix
