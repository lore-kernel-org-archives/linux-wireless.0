Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45137 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaHYJS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 05:18:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath10k: improve logging to include dev id
References: <1408952456-3121-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 25 Aug 2014 12:18:51 +0300
In-Reply-To: <1408952456-3121-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 25 Aug 2014 09:40:56 +0200")
Message-ID: <87tx5153lw.fsf@kamboji.qca.qualcomm.com> (sfid-20140825_111901_613195_324021DD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes it a lot easier to log and debug
> messages if there's more than 1 ath10k device on a
> system.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Did only a quick review and test but looks good to me except one problem
in pci.c, see below. But there are some conflicts now, can you rebase
please? I hope it's not too much work to fix them.

I'll also summarise the "meat" of the changes so that it's easier for
others to review:

> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index df1abe7..57995b9 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -24,25 +24,7 @@
>  /* ms */
>  #define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
>  
> -static int ath10k_printk(const char *level, const char *fmt, ...)
> -{
> -	struct va_format vaf;
> -	va_list args;
> -	int rtn;
> -
> -	va_start(args, fmt);
> -
> -	vaf.fmt = fmt;
> -	vaf.va = &args;
> -
> -	rtn = printk("%sath10k: %pV", level, &vaf);
> -
> -	va_end(args);
> -
> -	return rtn;
> -}
> -
> -int ath10k_info(const char *fmt, ...)
> +int ath10k_info(struct ath10k *ar, const char *fmt, ...)
>  {
>  	struct va_format vaf = {
>  		.fmt = fmt,
> @@ -52,7 +34,7 @@ int ath10k_info(const char *fmt, ...)
>  
>  	va_start(args, fmt);
>  	vaf.va = &args;
> -	ret = ath10k_printk(KERN_INFO, "%pV", &vaf);
> +	ret = dev_info(ar->dev, "%pV", &vaf);
>  	trace_ath10k_log_info(&vaf);
>  	va_end(args);
>  
> @@ -60,7 +42,7 @@ int ath10k_info(const char *fmt, ...)
>  }
>  EXPORT_SYMBOL(ath10k_info);
>  
> -int ath10k_err(const char *fmt, ...)
> +int ath10k_err(struct ath10k *ar, const char *fmt, ...)
>  {
>  	struct va_format vaf = {
>  		.fmt = fmt,
> @@ -70,7 +52,7 @@ int ath10k_err(const char *fmt, ...)
>  
>  	va_start(args, fmt);
>  	vaf.va = &args;
> -	ret = ath10k_printk(KERN_ERR, "%pV", &vaf);
> +	ret = dev_err(ar->dev, "%pV", &vaf);
>  	trace_ath10k_log_err(&vaf);
>  	va_end(args);
>  
> @@ -78,7 +60,7 @@ int ath10k_err(const char *fmt, ...)
>  }
>  EXPORT_SYMBOL(ath10k_err);
>  
> -int ath10k_warn(const char *fmt, ...)
> +int ath10k_warn(struct ath10k *ar, const char *fmt, ...)
>  {
>  	struct va_format vaf = {
>  		.fmt = fmt,
> @@ -88,10 +70,7 @@ int ath10k_warn(const char *fmt, ...)
>  
>  	va_start(args, fmt);
>  	vaf.va = &args;
> -
> -	if (net_ratelimit())
> -		ret = ath10k_printk(KERN_WARNING, "%pV", &vaf);
> -
> +	dev_warn_ratelimited(ar->dev, "%pV", &vaf);
>  	trace_ath10k_log_warn(&vaf);
>  
>  	va_end(args);

[...]

> @@ -979,7 +959,8 @@ void ath10k_debug_destroy(struct ath10k *ar)
>  #endif /* CONFIG_ATH10K_DEBUGFS */
>  
>  #ifdef CONFIG_ATH10K_DEBUG
> -void ath10k_dbg(enum ath10k_debug_mask mask, const char *fmt, ...)
> +void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
> +		const char *fmt, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> @@ -990,7 +971,7 @@ void ath10k_dbg(enum ath10k_debug_mask mask, const char *fmt, ...)
>  	vaf.va = &args;
>  
>  	if (ath10k_debug_mask & mask)
> -		ath10k_printk(KERN_DEBUG, "%pV", &vaf);
> +		dev_printk(KERN_DEBUG, ar->dev, "%pV", &vaf);
>  
>  	trace_ath10k_log_dbg(mask, &vaf);
>  
> @@ -998,13 +979,14 @@ void ath10k_dbg(enum ath10k_debug_mask mask, const char *fmt, ...)
>  }
>  EXPORT_SYMBOL(ath10k_dbg);
>  
> -void ath10k_dbg_dump(enum ath10k_debug_mask mask,
> +void ath10k_dbg_dump(struct ath10k *ar,
> +		     enum ath10k_debug_mask mask,
>  		     const char *msg, const char *prefix,
>  		     const void *buf, size_t len)
>  {
>  	if (ath10k_debug_mask & mask) {
>  		if (msg)
> -			ath10k_dbg(mask, "%s\n", msg);
> +			ath10k_dbg(ar, mask, "%s\n", msg);
>  
>  		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
>  	}
> diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
> index a582499..f5a01d5 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -39,9 +39,9 @@ enum ath10k_debug_mask {
>  
>  extern unsigned int ath10k_debug_mask;
>  
> -__printf(1, 2) int ath10k_info(const char *fmt, ...);
> -__printf(1, 2) int ath10k_err(const char *fmt, ...);
> -__printf(1, 2) int ath10k_warn(const char *fmt, ...);
> +__printf(2, 3) int ath10k_info(struct ath10k *ar, const char *fmt, ...);
> +__printf(2, 3) int ath10k_err(struct ath10k *ar, const char *fmt, ...);
> +__printf(2, 3) int ath10k_warn(struct ath10k *ar, const char *fmt, ...);
>  
>  #ifdef CONFIG_ATH10K_DEBUGFS
>  int ath10k_debug_start(struct ath10k *ar);
> @@ -91,20 +91,24 @@ static inline void ath10k_debug_read_target_stats(struct ath10k *ar,
>  #endif /* CONFIG_ATH10K_DEBUGFS */
>  
>  #ifdef CONFIG_ATH10K_DEBUG
> -__printf(2, 3) void ath10k_dbg(enum ath10k_debug_mask mask,
> +__printf(3, 4) void ath10k_dbg(struct ath10k *ar,
> +			       enum ath10k_debug_mask mask,
>  			       const char *fmt, ...);
> -void ath10k_dbg_dump(enum ath10k_debug_mask mask,
> +void ath10k_dbg_dump(struct ath10k *ar,
> +		     enum ath10k_debug_mask mask,
>  		     const char *msg, const char *prefix,
>  		     const void *buf, size_t len);
>  #else /* CONFIG_ATH10K_DEBUG */
>  
> -static inline int ath10k_dbg(enum ath10k_debug_mask dbg_mask,
> +static inline int ath10k_dbg(struct ath10k *ar,
> +			     enum ath10k_debug_mask dbg_mask,
>  			     const char *fmt, ...)
>  {
>  	return 0;
>  }
>  
> -static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
> +static inline void ath10k_dbg_dump(struct ath10k *ar,
> +				   enum ath10k_debug_mask mask,
>  				   const char *msg, const char *prefix,
>  				   const void *buf, size_t len)
>  {

[...]

> @@ -2566,12 +2576,12 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>  	struct ath10k_pci *ar_pci;
>  	u32 chip_id;
>  
> -	ath10k_dbg(ATH10K_DBG_PCI, "pci probe\n");
> +	dev_printk(KERN_DEBUG, &pdev->dev, "pci probe\n");

But this doesn't look right. A leftover from testing, perhaps?

-- 
Kalle Valo
