Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34258 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbcHIHOd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 03:14:33 -0400
From: Stephan Mueller <smueller@chronox.de>
To: miaoqing@codeaurora.org
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, linux-crypto@vger.kernel.org,
	jason@lakedaemon.net, pouyans@qti.qualcomm.com
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 09 Aug 2016 09:14:30 +0200
Message-ID: <4627645.oz3l49ICL3@tauon.atsec.com> (sfid-20160809_091436_985166_3862DE96)
In-Reply-To: <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <1470726147-30095-2-git-send-email-miaoqing@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 9. August 2016, 15:02:27 CEST schrieb miaoqing@codeaurora.org:

Hi Miaoqing,

> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> ath9k RNG will dominates all the noise sources from the real HW
> RNG, disable it by default. But we strongly recommand to enable
> it if the system without HW RNG, especially on embedded systems.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

As a short term solution:

Acked-by: Stephan Mueller <smueller@chronox.de>

But as Jason outlined, there should be nothing that prevents using this code 
with the HW Random framework. This framework also has logic to limit the rate 
of injection and allows the setting of the entropy threshold at runtime.

> ---
>  drivers/net/wireless/ath/ath9k/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
> b/drivers/net/wireless/ath/ath9k/Kconfig index f68cb00..8f231c6 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -180,7 +180,7 @@ config ATH9K_HTC_DEBUGFS
>  config ATH9K_HWRNG
>  	bool "Random number generator support"
>  	depends on ATH9K && (HW_RANDOM = y || HW_RANDOM = ATH9K)
> -	default y
> +	default n
>  	---help---
>  	  This option incorporates the ADC register output as a source of
>  	  randomness into Linux entropy pool (/dev/urandom and /dev/random)



Ciao
Stephan
