Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.polito.it ([130.192.182.65]:24460 "EHLO mx.polito.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab2FTJvU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:51:20 -0400
Message-ID: <1340184209.2915.2.camel@MacGyver> (sfid-20120620_115124_226055_94A1A9EF)
Subject: Re: [PATCH 1/3] wl1251: fix TSF calculation
From: Guido Gavilanes <gavilanes@ismb.it>
Reply-To: gavilanes@ismb.it
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 11:23:29 +0200
In-Reply-To: <1339874808-9991-2-git-send-email-notasas@gmail.com>
References: <1339874808-9991-1-git-send-email-notasas@gmail.com>
	 <1339874808-9991-2-git-send-email-notasas@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

Regarding the TSF, is there a way to read from an outside program the
TSF to help stations or programs have a "synchronization" low level
reference time?

Any ideas would be appreciated!
Thank you!
Guido

On Sat, 2012-06-16 at 22:26 +0300, Grazvydas Ignotas wrote:
> Cast MSB part of current TSF to u64 to prevent loss of most
> significant bits. MSB should also be shifted by 32.
> 
> Patch based on old maemo patch by:
> Yuri Kululin <ext-yuri.kululin@nokia.com>
> Yuri Ershov <ext-yuri.ershov@nokia.com>
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
>  drivers/net/wireless/ti/wl1251/acx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wl1251/acx.c b/drivers/net/wireless/ti/wl1251/acx.c
> index ad87a1a..db6430c 100644
> --- a/drivers/net/wireless/ti/wl1251/acx.c
> +++ b/drivers/net/wireless/ti/wl1251/acx.c
> @@ -869,7 +869,7 @@ int wl1251_acx_tsf_info(struct wl1251 *wl, u64 *mactime)
>  	}
>  
>  	*mactime = tsf_info->current_tsf_lsb |
> -		(tsf_info->current_tsf_msb << 31);
> +		((u64)tsf_info->current_tsf_msb << 32);
>  
>  out:
>  	kfree(tsf_info);



