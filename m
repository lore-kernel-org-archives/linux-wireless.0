Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:35883 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755206Ab2DCVDB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 17:03:01 -0400
Message-ID: <1333486979.2695.8.camel@joe2Laptop> (sfid-20120403_230319_040383_BF1D5EA4)
Subject: Re: [PATCH] ath9k:  Gather and report bus-timeout errors.
From: Joe Perches <joe@perches.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Date: Tue, 03 Apr 2012 14:02:59 -0700
In-Reply-To: <1333484545-14273-1-git-send-email-greearb@candelatech.com>
References: <1333484545-14273-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 13:22 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Seems like a useful stat to report (when debugfs
> is enabled).
[]
> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
[]
> @@ -385,57 +385,61 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
>  				   size_t count, loff_t *ppos)
>  {
>  	struct ath_softc *sc = file->private_data;
> -	char buf[512];
> +	char buf[800];

800 seems excessive.
Maybe it's better to kmalloc this.

>  	unsigned int len = 0;
>  
>  	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
>  		len += snprintf(buf + len, sizeof(buf) - len,
> -			"%8s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
> +			"%11s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);

why change the size from 8 to 11?

>  		len += snprintf(buf + len, sizeof(buf) - len,
> -			"%8s: %10u\n", "RXHP", sc->debug.stats.istats.rxhp);
> +			"%11s: %10u\n", "RXHP", sc->debug.stats.istats.rxhp);
>  		len += snprintf(buf + len, sizeof(buf) - len,
> -			"%8s: %10u\n", "WATCHDOG",
> +			"%11s: %10u\n", "WATCHDOG",
>  			sc->debug.stats.istats.bb_watchdog);

[]

> diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
[]
> @@ -85,8 +86,15 @@ struct ath_interrupt_stats {
>  	u32 dtim;
>  	u32 bb_watchdog;
>  	u32 tsfoor;
> +	u32 sync_local_timeout;
>  };
>  
> +#define ATH_INCR_IRQ_STAT_COMMON(c, s)					\
> +	do {								\
> +		struct ath_softc *sc = (struct ath_softc *) (c)->priv;	\

Isn't priv void *?
I think you don't need the cast.

> +		sc->debug.stats.istats.s++;				\
> +	} while (0);

sb: "while (0)" without the ;


