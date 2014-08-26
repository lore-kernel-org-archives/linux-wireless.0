Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24244 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbaHZHBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 03:01:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: improve logging to include dev id
References: <1408961378-1390-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 26 Aug 2014 10:01:45 +0300
In-Reply-To: <1408961378-1390-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 25 Aug 2014 12:09:38 +0200")
Message-ID: <87vbpf3fae.fsf@kamboji.qca.qualcomm.com> (sfid-20140826_090155_318910_440133B0)
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

A comment for the future, no need to change anything in this patch:

> -int ath10k_info(const char *fmt, ...)
> +int ath10k_info(struct ath10k *ar, const char *fmt, ...)
>  {
>  	struct va_format vaf = {
>  		.fmt = fmt,
> @@ -134,7 +116,7 @@ int ath10k_info(const char *fmt, ...)
>  
>  	va_start(args, fmt);
>  	vaf.va = &args;
> -	ret = ath10k_printk(KERN_INFO, "%pV", &vaf);
> +	ret = dev_info(ar->dev, "%pV", &vaf);
>  	trace_ath10k_log_info(&vaf);
>  	va_end(args);
>  

So how should we handle tracing? We would want to provide same
information through logging trace events, right?

One idea I had is that we modify the tracing logging macros to take
struct ath10k (or struct device) and use dev_driver_string() &
dev_name() to provide the same info via trace events.

-- 
Kalle Valo
