Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:17403 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbdK1DmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 22:42:03 -0500
Date: Mon, 27 Nov 2017 19:35:16 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Matthias Schiffer <mschiffer@universe-factory.net>
Cc: kvalo@qca.qualcomm.com, ath9k-devel@qca.qualcomm.com,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH 1/3] ath9k: remove stray backslash in Makefile
Message-ID: <20171127193516.682827ea@cakuba.netronome.com> (sfid-20171128_044207_552764_E5CB9DFB)
In-Reply-To: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
References: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 27 Nov 2017 18:56:21 +0100, Matthias Schiffer wrote:
> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
> ---
>  drivers/net/wireless/ath/ath9k/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
> index 36a40ffdce15..90e4a341076c 100644
> --- a/drivers/net/wireless/ath/ath9k/Makefile
> +++ b/drivers/net/wireless/ath/ath9k/Makefile
> @@ -59,7 +59,7 @@ obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
>  obj-$(CONFIG_ATH9K_COMMON) += ath9k_common.o
>  ath9k_common-y:=	common.o \
>  			common-init.o \
> -			common-beacon.o \
> +			common-beacon.o
>  

It's not necessarily stray, there is nothing on the next line so it's
OK, and if you add \ at the end of all lines, you don't have to touch
the last line every time you add/remove something.  Sort of like
putting a , after last enum value.

Just my $.02, not that I mind either way :)

>  ath9k_common-$(CONFIG_ATH9K_COMMON_DEBUG) += common-debug.o \
>  					     common-spectral.o
