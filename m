Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19038 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0IPE5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 00:57:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 21:57:05 -0700
Date: Thu, 16 Sep 2010 10:26:48 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH] ath9k: make ath_ant_div_conf_fast_divbias static
Message-ID: <20100916045648.GB30871@vasanth-laptop>
References: <1284578773-18629-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1284578773-18629-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 12:56:13AM +0530, John W. Linville wrote:
>   CHECK   drivers/net/wireless/ath/ath9k/recv.c
> drivers/net/wireless/ath/ath9k/recv.c:1341:6: warning: symbol 'ath_ant_div_conf_fast_divbias' was not declared. Should it be static?
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 6fb3b45..aa9a14d 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1338,7 +1338,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
>  	}
>  }
>  
> -void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf)
> +static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf)
>  {
>  	/* Adjust the fast_div_bias based on main and alt lna conf */
>  	switch ((ant_conf->main_lna_conf << 4) | ant_conf->alt_lna_conf) {

thanks for fixing this. btw, a patch fixing this one was already
part of my 3 patch series, probably the commit log was not good
or something?

Thanks,

Vasanth
