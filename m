Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:39845 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756854Ab2DDQQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 12:16:24 -0400
Message-ID: <1333556182.16978.9.camel@joe2Laptop> (sfid-20120404_181627_510288_FFF87D5A)
Subject: Re: [PATCH v2] ath9k:  Gather and report IRQ sync_cause errors.
From: Joe Perches <joe@perches.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Date: Wed, 04 Apr 2012 09:16:22 -0700
In-Reply-To: <1333513250-30478-1-git-send-email-greearb@candelatech.com>
References: <1333513250-30478-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 21:20 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Report all defined sync_cause errors in debugfs
> to aid with debugging.

just trivia:

> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
[]
> @@ -385,63 +385,130 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
>  				   size_t count, loff_t *ppos)
>  {
>  	struct ath_softc *sc = file->private_data;
[]
>  	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
[]
> +		len += snprintf(buf + len, mxlen - len,
> +			"%21s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);

Alignment is overrated.

I wouldn't change any of the original block
though perhaps changing the sc pointer to an
istats pointer so these dereferences become
similar to istats->rxlp;

[]

> +	len += snprintf(buf + len, mxlen - len,
> +			"SYNC_CAUSE stats:\n");

But _might_ add the %21s here for the new entries.

> +	len += snprintf(buf + len, mxlen - len,
> +			"%21s: %10u\n", "Sync-All",
> +			sc->debug.stats.istats.sync_cause_all);

[]

> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
[]
> @@ -82,6 +84,53 @@ static void ath9k_hw_ani_cache_ini_regs(struct ath_hw *ah)
>  /* Helper Functions */
>  /********************/
>  
> +#ifdef CONFIG_ATH9K_DEBUGFS
> +
> +void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause)
> +{
> +	struct ath_softc *sc = common->priv;
> +	if (sync_cause)
> +		sc->debug.stats.istats.sync_cause_all++;
> +	if (sync_cause & AR_INTR_SYNC_RTC_IRQ)
> +		sc->debug.stats.istats.sync_rtc_irq++;

And nicer here to use a pointer to istats too.

		istats->sync_rtc_irq++;

> +	if (sync_cause & AR_INTR_SYNC_MAC_IRQ)
> +		sc->debug.stats.istats.sync_mac_irq++;

		istats->sync_mac_irq++;

etc.

