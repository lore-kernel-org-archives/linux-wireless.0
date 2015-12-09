Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35684 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbbLIRNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 12:13:20 -0500
Received: by qgec40 with SMTP id c40so88942161qge.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2015 09:13:19 -0800 (PST)
Date: Wed, 9 Dec 2015 12:13:14 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] iwlegacy: mark il_adjust_beacon_interval as noinline
In-Reply-To: <36263581.L8412YxJjp@wuerfel>
Message-ID: <alpine.LFD.2.20.1512091209130.26920@knanqh.ubzr> (sfid-20151209_181339_380758_48F5166B)
References: <36263581.L8412YxJjp@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 9 Dec 2015, Arnd Bergmann wrote:

> With the new optimized do_div() code, some versions of gcc
> produce obviously incorrect code that leads to a link error
> in iwlegacy/common.o:
> 
> drivers/built-in.o: In function `il_send_rxon_timing':
> :(.text+0xa6b4d4): undefined reference to `____ilog2_NaN'
> :(.text+0xa6b4f0): undefined reference to `__aeabi_uldivmod'
> 
> In a few thousand randconfig builds, I have seen this problem
> a couple of times in this file, but never anywhere else in the
> kernel, so we can try to work around this in the only file
> that shows the behavior, by marking the il_adjust_beacon_interval
> function as noinline, which convinces gcc to use the unoptimized
> do_div() all the time.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Nicolas Pitre <nico@linaro.org>

> 
> diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
> index 887114582583..6308bb217454 100644
> --- a/drivers/net/wireless/intel/iwlegacy/common.c
> +++ b/drivers/net/wireless/intel/iwlegacy/common.c
> @@ -3602,7 +3602,7 @@ il_is_ht40_tx_allowed(struct il_priv *il, struct ieee80211_sta_ht_cap *ht_cap)
>  }
>  EXPORT_SYMBOL(il_is_ht40_tx_allowed);
>  
> -static u16
> +static u16 noinline
>  il_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
>  {
>  	u16 new_val;
> 
> 
