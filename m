Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2970 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1AETkL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 14:40:11 -0500
Subject: Re: [PATCH 1/3] ath5k: move nohwcrypt to ath_common structure
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	ath9k-devel@venema.h4ckr.net
In-Reply-To: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
References: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 11:40:09 -0800
Message-ID: <1294256409.12561.8.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-05 at 14:22 -0500, John W. Linville wrote:

> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
[]
> +	bool nohwcrypt;

> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> -int modparam_nohwcrypt;
> +static int modparam_nohwcrypt;
>  module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);

bool/int matching?

Perhaps the modparam_nohwcrypts should be
bool and S_IRUGO

> diff --git a/drivers/net/wireless/ath/ath9k/init.c 
[]
> -int modparam_nohwcrypt;
> +static int modparam_nohwcrypt;
>  module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);

> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c 
[]
> -int htc_modparam_nohwcrypt;
> -module_param_named(nohwcrypt, htc_modparam_nohwcrypt, int, 0444);
> +static int modparam_nohwcrypt;
> +module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);


